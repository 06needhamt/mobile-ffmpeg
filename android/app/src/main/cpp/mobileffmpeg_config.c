/*
 * Copyright (c) 2018 Taner Sener
 *
 * This file is part of MobileFFmpeg.
 *
 * MobileFFmpeg is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * MobileFFmpeg is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with MobileFFmpeg.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <pthread.h>

#include "fftools_ffmpeg.h"
#include "mobileffmpeg.h"

/** Log data structure */
struct CallbackData {
  int type;                 // 1 (log callback) or 2 (stats callback)

  int logLevel;             // log level
  char *logData;            // log data

  int statsFrameNumber;     // stats frame number
  float statsFps;           // stats fps
  float statsQuality;       // stats quality
  int64_t statsSize;        // stats size
  int statsTime;            // stats time
  double statsBitrate;      // stats bitrate
  double statsSpeed;        // stats speed

  struct CallbackData *next;
};

/** Log redirection variables */
pthread_mutex_t lockMutex;
pthread_mutex_t monitorMutex;
pthread_cond_t monitorCondition;

pthread_t callbackThread;
int redirectionEnabled;

struct CallbackData *callbackDataHead;
struct CallbackData *callbackDataTail;

/** Global reference to the virtual machine running */
static JavaVM *globalVm;

/** Global reference of Config class in Java */
static jclass configClass;

/** Global reference of log redirection method in Java */
static jmethodID logMethod;

/** Global reference of stats redirection method in Java */
static jmethodID statsMethod;

/** Full name of the Config class */
const char *configClassName = "com/arthenica/mobileffmpeg/Config";

/** Prototypes of native functions defined by Config class. */
JNINativeMethod configMethods[] = {
    {"enableNativeRedirection", "()V", (void*) Java_com_arthenica_mobileffmpeg_Config_enableNativeRedirection},
    {"disableNativeRedirection", "()V", (void*) Java_com_arthenica_mobileffmpeg_Config_disableNativeRedirection},
    {"setNativeLogLevel", "(I)V", (void*) Java_com_arthenica_mobileffmpeg_Config_setNativeLogLevel},
    {"getNativeLogLevel", "()I", (void*) Java_com_arthenica_mobileffmpeg_Config_getNativeLogLevel}
};

void mutexInit() {
    pthread_mutexattr_t attributes;
    pthread_mutexattr_init(&attributes);
    pthread_mutexattr_settype(&attributes, PTHREAD_MUTEX_RECURSIVE_NP);

    pthread_mutex_init(&lockMutex, &attributes);
    pthread_mutexattr_destroy(&attributes);
}

void monitorInit() {
    pthread_mutexattr_t attributes;
    pthread_mutexattr_init(&attributes);
    pthread_mutexattr_settype(&attributes, PTHREAD_MUTEX_RECURSIVE_NP);

    pthread_condattr_t cattributes;
    pthread_condattr_init(&cattributes);
    pthread_condattr_setpshared(&cattributes, PTHREAD_PROCESS_PRIVATE);

    pthread_mutex_init(&monitorMutex, &attributes);
    pthread_mutexattr_destroy(&attributes);

    pthread_cond_init(&monitorCondition, &cattributes);
    pthread_condattr_destroy(&cattributes);
}

void mutexUnInit() {
    pthread_mutex_destroy(&lockMutex);
}

void monitorUnInit() {
    pthread_mutex_destroy(&monitorMutex);
    pthread_cond_destroy(&monitorCondition);
}

void mutexLock() {
    pthread_mutex_lock(&lockMutex);
}

void mutexUnlock() {
    pthread_mutex_unlock(&lockMutex);
}

void monitorWait(int milliSeconds) {
    struct timeval tp;
    struct timespec ts;
    int rc;

    rc = gettimeofday(&tp, NULL);
    if (rc) {
        return;
    }

    ts.tv_sec  = tp.tv_sec;
    ts.tv_nsec = tp.tv_usec * 1000;
    ts.tv_sec += milliSeconds / 1000;
    ts.tv_nsec += (milliSeconds % 1000)*1000000;

    pthread_mutex_lock(&monitorMutex);
    pthread_cond_timedwait(&monitorCondition, &monitorMutex, &ts);
    pthread_mutex_unlock(&monitorMutex);
}

void monitorNotify() {
    pthread_mutex_lock(&monitorMutex);
    pthread_cond_signal(&monitorCondition);
    pthread_mutex_unlock(&monitorMutex);
}

/**
 * Adds log data to the end of callback data list.
 */
void logCallbackDataAdd(const int level, const char *data) {

    // CREATE DATA STRUCT FIRST
    struct CallbackData *newData = (struct CallbackData*)malloc(sizeof(struct CallbackData));
    newData->type = 1;
    newData->logLevel = level;
    size_t dataSize = strlen(data) + 1;
    newData->logData = (char*)malloc(dataSize);
    memcpy(newData->logData, data, dataSize);
    newData->next = NULL;

    mutexLock();

    // INSERT IT TO THE END OF QUEUE
    if (callbackDataTail == NULL) {
        callbackDataTail = newData;

        if (callbackDataHead != NULL) {
            LOGE("Dangling callback data head detected. This can cause memory leak.");
        } else {
            callbackDataHead = newData;
        }
    } else {
        struct CallbackData *oldTail = callbackDataTail;
        oldTail->next = newData;

        callbackDataTail = newData;
    }

    mutexUnlock();

    monitorNotify();
}

/**
 * Adds stats data to the end of callback data list.
 */
void statsCallbackDataAdd(int frameNumber, float fps, float quality, int64_t size, int time, double bitrate, double speed) {

    // CREATE DATA STRUCT FIRST
    struct CallbackData *newData = (struct CallbackData*)malloc(sizeof(struct CallbackData));
    newData->type = 2;
    newData->statsFrameNumber = frameNumber;
    newData->statsFps = fps;
    newData->statsQuality = quality;
    newData->statsSize = size;
    newData->statsTime = time;
    newData->statsBitrate = bitrate;
    newData->statsSpeed = speed;

    newData->next = NULL;

    mutexLock();

    // INSERT IT TO THE END OF QUEUE
    if (callbackDataTail == NULL) {
        callbackDataTail = newData;

        if (callbackDataHead != NULL) {
            LOGE("Dangling callback data head detected. This can cause memory leak.");
        } else {
            callbackDataHead = newData;
        }
    } else {
        struct CallbackData *oldTail = callbackDataTail;
        oldTail->next = newData;

        callbackDataTail = newData;
    }

    mutexUnlock();

    monitorNotify();
}

/**
 * Removes head of callback data list.
 */
struct CallbackData *callbackDataRemove() {
    struct CallbackData *currentData;

    mutexLock();

    if (callbackDataHead == NULL) {
        currentData = NULL;
    } else {
        currentData = callbackDataHead;

        struct CallbackData *nextHead = currentData->next;
        if (nextHead == NULL) {
            if (callbackDataHead != callbackDataTail) {
                LOGE("Head and tail callback data pointers do not match for single callback data element. This can cause memory leak.");
            } else {
                callbackDataTail = NULL;
            }
            callbackDataHead = NULL;

        } else {
            callbackDataHead = nextHead;
        }
    }

    mutexUnlock();

    return currentData;
}

/**
 * Callback function for ffmpeg logs.
 *
 * \param pointer to AVClass struct
 * \param level
 * \param format
 * \param arguments
 */
void mobileffmpeg_log_callback_function(void *ptr, int level, const char* format, va_list vargs) {
    char line[2];

    int logSize = vsnprintf(line, 1, format, vargs);

    if (logSize > 0) {
        int bufferSize = logSize + 1;
        char* buffer = (char*)malloc(bufferSize);

        vsnprintf(buffer, bufferSize, format, vargs);
        logCallbackDataAdd(level, buffer);

        free(buffer);
    }
}

/**
 * Callback function for ffmpeg stats.
 *
 * \param frameNumber last processed frame number
 * \param fps frames processed per second
 * \param quality quality of the output stream (video only)
 * \param size size in bytes
 * \param time processed output duration
 * \param bitrate output bit rate in kbits/s
 * \param speed processing speed = processed duration / operation duration
 */
void mobileffmpeg_stats_callback_function(int frameNumber, float fps, float quality, int64_t size, int time, double bitrate, double speed) {
    statsCallbackDataAdd(frameNumber, fps, quality, size, time, bitrate, speed);
}

/**
 * Forwards callback messages to Java classes.
 */
void *callbackThreadFunction() {
    JNIEnv *env;
    jint getEnvRc = (*globalVm)->GetEnv(globalVm, (void**) &env, JNI_VERSION_1_6);
    if (getEnvRc != JNI_OK) {
        if (getEnvRc != JNI_EDETACHED) {
            LOGE("Callback thread failed to GetEnv for class %s with rc %d.\n", configClassName, getEnvRc);
            return NULL;
        }

        if ((*globalVm)->AttachCurrentThread(globalVm, &env, NULL) != 0) {
            LOGE("Callback thread failed to AttachCurrentThread for class %s.\n", configClassName);
            return NULL;
        }
    }

    LOGD("Callback thread started.\n");

    while(redirectionEnabled) {

        struct CallbackData *callbackData = callbackDataRemove();
        if (callbackData != NULL) {
            if (callbackData->type == 1) {

                // LOG CALLBACK

                size_t size = strlen(callbackData->logData);

                jbyteArray byteArray = (jbyteArray) (*env)->NewByteArray(env, size);
                (*env)->SetByteArrayRegion(env, byteArray, 0, size, (jbyte *)callbackData->logData);
                (*env)->CallStaticVoidMethod(env, configClass, logMethod, callbackData->logLevel, byteArray);
                (*env)->DeleteLocalRef(env, byteArray);

                // CLEAN LOG DATA
                free(callbackData->logData);

            } else {

                // STATS CALLBACK

                (*env)->CallStaticVoidMethod(env, configClass, statsMethod,
                    callbackData->statsFrameNumber, callbackData->statsFps,
                    callbackData->statsQuality, callbackData->statsSize,
                    callbackData->statsTime, callbackData->statsBitrate,
                    callbackData->statsSpeed);

            }

            // CLEAN STRUCT
            callbackData->next = NULL;
            free(callbackData);

        } else {
            monitorWait(100);
        }
    }

    (*globalVm)->DetachCurrentThread(globalVm);

    LOGD("Callback thread stopped.\n");

    return NULL;
}

/**
 * Called when 'mobileffmpeg-config' native library is loaded.
 *
 * \param vm pointer to the running virtual machine
 * \param reserved reserved
 * \return JNI version needed by 'mobileffmpeg' library
 */
jint JNI_OnLoad(JavaVM *vm, void *reserved) {
    JNIEnv *env;
    if ((*vm)->GetEnv(vm, (void**)(&env), JNI_VERSION_1_6) != JNI_OK) {
        LOGE("OnLoad failed to GetEnv for class %s.\n", configClassName);
        return JNI_FALSE;
    }

    jclass localConfigClass = (*env)->FindClass(env, configClassName);
    if (localConfigClass == NULL) {
        LOGE("OnLoad failed to FindClass %s.\n", configClassName);
        return JNI_FALSE;
    }

    if ((*env)->RegisterNatives(env, localConfigClass, configMethods, 4) < 0) {
        LOGE("OnLoad failed to RegisterNatives for class %s.\n", configClassName);
        return JNI_FALSE;
    }

    (*env)->GetJavaVM(env, &globalVm);

    logMethod = (*env)->GetStaticMethodID(env, localConfigClass, "log", "(I[B)V");
    if (logMethod == NULL) {
        LOGE("OnLoad thread failed to GetMethodID for %s.\n", "log");
        (*globalVm)->DetachCurrentThread(globalVm);
        return JNI_FALSE;
    }

    statsMethod = (*env)->GetStaticMethodID(env, localConfigClass, "stats", "(IFFJIDD)V");
    if (logMethod == NULL) {
        LOGE("OnLoad thread failed to GetMethodID for %s.\n", "stats");
        (*globalVm)->DetachCurrentThread(globalVm);
        return JNI_FALSE;
    }

    configClass = (jclass) ((*env)->NewGlobalRef(env, localConfigClass));

    redirectionEnabled = 0;

    callbackDataHead = NULL;
    callbackDataTail = NULL;

    mutexInit();
    monitorInit();

    return JNI_VERSION_1_6;
}

/**
 * Sets log level.
 *
 * \param env pointer to native method interface
 * \param reference to the class on which this method is invoked
 * \param log level
 */
JNIEXPORT void JNICALL Java_com_arthenica_mobileffmpeg_Config_setNativeLogLevel(JNIEnv *env, jclass object, jint level) {
    av_log_set_level(level);
}

/**
 * Returns current log level.
 *
 * \param env pointer to native method interface
 * \param reference to the class on which this method is invoked
 */
JNIEXPORT jint JNICALL Java_com_arthenica_mobileffmpeg_Config_getNativeLogLevel(JNIEnv *env, jclass object) {
    return av_log_get_level();
}

/**
 * Enables log and stats redirection.
 *
 * \param env pointer to native method interface
 * \param reference to the class on which this method is invoked
 */
JNIEXPORT void JNICALL Java_com_arthenica_mobileffmpeg_Config_enableNativeRedirection(JNIEnv *env, jclass object) {
    mutexLock();

    if (redirectionEnabled != 0) {
        mutexUnlock();
        return;
    }
    redirectionEnabled = 1;

    mutexUnlock();

    int rc = pthread_create(&callbackThread, 0, callbackThreadFunction, 0);
    if (rc != 0) {
        LOGE("Failed to create callback thread (rc=%d).\n", rc);
        return;
    }

    av_log_set_callback(mobileffmpeg_log_callback_function);
    set_report_callback(mobileffmpeg_stats_callback_function);
}

/**
 * Disables log and stats redirection.
 *
 * \param env pointer to native method interface
 * \param reference to the class on which this method is invoked
 */
JNIEXPORT void JNICALL Java_com_arthenica_mobileffmpeg_Config_disableNativeRedirection(JNIEnv *env, jclass object) {

    mutexLock();

    if (redirectionEnabled != 1) {
        mutexUnlock();
        return;
    }
    redirectionEnabled = 0;

    mutexUnlock();

    av_log_set_callback(av_log_default_callback);
    set_report_callback(NULL);

    monitorNotify();
}
