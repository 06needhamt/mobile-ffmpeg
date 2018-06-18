# MobileFFmpeg
Source code and scripts to build FFmpeg for Android and IOS platform; prebuilt libraries for both platforms

### 1. Features
- Builds both Android and IOS
- Supports 21 external libraries, 2 GPL libraries and 10 architectures in total
- Exposes FFmpeg capabilities both directly from FFmpeg libraries and through MobileFFmpeg wrapper library
- Creates shared libraries (.so for Android, .dylib for IOS)
- Includes cross-compile instructions for 32 open-source libraries including FFmpeg
- Licensed under LGPL 3.0, can be customized to support GPL v3.0
#### 1.1 Android
- Creates Android archive with .aar extension
#### 1.2 IOS
- Creates IOS dynamic universal (fat) library
- Creates IOS dynamic framework for IOS 8 or later

### 2. Architectures
#### 2.1 Android
- arm-v7a
- arm-v7a-neon
- arm64-v8a
- x86
- x86_64
#### 2.2 IOS
- armv7
- armv7s
- arm64
- i386
- x86_64

### 3. FFmpeg Support
This repository branch contains FFmpeg version 3.4.2 with support for the following external libraries. 
Cross-compile instructions for all of them can be found under scripts inside `build` folder.
- fontconfig
- freetype
- fribidi
- gmp
- gnutls
- kvazaar
- lame
- libass
- libiconv
- libilbc
- libtheora
- libvorbis
- libvpx
- libwebp
- libxml2
- opencore-amr
- opus
- shine
- snappy
- speex
- wavpack
- x264
- xvidcore

External libraries and their dependencies are explained in the [External Libraries](https://github.com/tanersener/mobile-ffmpeg/wiki/External-Libraries) page.

### 4. Using
#### 4.1 Android
Import `mobile-ffmpeg-1.1.aar` into your project and use the following source code.
```
    import com.arthenica.mobileffmpeg.FFmpeg;

    int rc = FFmpeg.execute("-i", "file1.mp4", "-c:v", "libxvid", "file1.avi");
    Log.i(Log.TAG, String.format("Command execution %s.", (rc == 0?"completed successfully":"failed with rc=" + rc));
```
#### 4.2 IOS
Use MobileFFmpeg in your project by adding all IOS frameworks from `prebuilt/ios-framework` path or 
by adding all `ffmpeg` and `mobile-ffmpeg` dylibs with headers from folders inside `prebuilt/ios-universal`.

Then run the following Objective-C source code.
```
    #import <mobileffmpeg/mobileffmpeg.h>

    NSString* command = @"-i file1.mp4 -c:v libxvid file1.avi";
    NSArray* commandArray = [command componentsSeparatedByString:@" "];
    char **arguments = (char **)malloc(sizeof(char*) * ([commandArray count]));
    for (int i=0; i < [commandArray count]; i++) {
        NSString *argument = [commandArray objectAtIndex:i];
        arguments[i] = (char *) [argument UTF8String];
    }

    int result = mobileffmpeg_execute((int) [commandArray count], arguments);

    NSLog(@"Process exited with rc %d\n", result);
    
    free(arguments);
```
#### 4.3 Test Application
You can see how MobileFFmpeg is used inside an application by running test applications in this repository.
There is an Android test application under the `android/test-app` folder and an IOS test application under the 
`ios/test-app` folder. 

### 5. Building
#### 5.1 Prerequisites
1. Use your package manager (apt, yum, dnf, brew, etc.) to install the following packages.
```
autoconf automake libtool pkg-config curl cmake gcc gperf texinfo yasm nasm
```
Some of these packages are not mandatory for the default build.
Please visit [Android Prerequisites](https://github.com/tanersener/mobile-ffmpeg/wiki/Android-Prerequisites) and
[IOS Prerequisites](https://github.com/tanersener/mobile-ffmpeg/wiki/IOS-Prerequisites) for the details.

2. Android builds require these additional packages.
- **Android SDK 5.0 Lollipop (API Level 21)** or later
- **Android NDK r16b** or later with LLDB and CMake
- **gradle 4.4** or later

3. IOS builds need these extra packages and tools.
- **IOS SDK 7.0.x** or later
- **Xcode 8.x** or later
- **Command Line Tools**
- **lipo** utility

#### 5.2 Build Scripts
Use `android.sh` and `ios.sh` to build MobileFFmpeg for each platform.
After a successful build, compiled FFmpeg and MobileFFmpeg libraries can be found under `prebuilt` directory.

Both `android.sh` and `ios.sh` can be customized to override default settings,
[android.sh](https://github.com/tanersener/mobile-ffmpeg/wiki/android.sh) and
[ios.sh](https://github.com/tanersener/mobile-ffmpeg/wiki/ios.sh) wiki pages include all available build options.
##### 5.2.1 Android
```
export ANDROID_NDK_ROOT=<Android NDK Path>
./android.sh
```
##### 5.2.2 IOS
```
./ios.sh
```
#### 5.3 GPL Support
From `v1.1` onwards it is possible to enable to GPL libraries `x264` and `xvidcore` from top level build scripts.
Their source code is not included in the repository and downloaded when enabled.

### 6. Documentation

A more detailed documentation is available at [Wiki](https://github.com/tanersener/mobile-ffmpeg/wiki).

### 7. License

This project is licensed under the LGPL v3.0. However, if source code is built using optional `--enable-gpl` flag or 
prebuilt binaries with `-gpl` postfix are used then MobileFFmpeg is subject to the GPL v3.0 license.

Source code of FFmpeg and external libraries is included in compliance with their individual licenses.

Digital assets used in test applications are published in the public domain.

Please visit [License](https://github.com/tanersener/mobile-ffmpeg/wiki/License) page for the details.

### 8. Contributing

This project is stable but far from complete. If you have any recommendations or ideas to improve it, please feel free to submit issues or pull requests. Any help is appreciated.

### 9. See Also

- [libav gas-preprocessor](https://github.com/libav/gas-preprocessor/raw/master/gas-preprocessor.pl)
- [FFmpeg API Documentation](https://ffmpeg.org/doxygen/3.4/index.html)
- [FFmpeg License and Legal Considerations](https://ffmpeg.org/legal.html)
