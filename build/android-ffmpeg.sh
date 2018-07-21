#!/bin/bash

if [[ -z ${ANDROID_NDK_ROOT} ]]; then
    echo -e "(*) ANDROID_NDK_ROOT not defined\n"
    exit 1
fi

if [[ -z ${ARCH} ]]; then
    echo -e "(*) ARCH not defined\n"
    exit 1
fi

if [[ -z ${API} ]]; then
    echo -e "(*) API not defined\n"
    exit 1
fi

if [[ -z ${BASEDIR} ]]; then
    echo -e "(*) BASEDIR not defined\n"
    exit 1
fi

HOST_PKG_CONFIG_PATH=`command -v pkg-config`
if [ -z ${HOST_PKG_CONFIG_PATH} ]; then
    echo -e "(*) pkg-config command not found\n"
    exit 1
fi

# ENABLE COMMON FUNCTIONS
. ${BASEDIR}/build/android-common.sh

# PREPARING PATHS & DEFINING ${INSTALL_PKG_CONFIG_DIR}
LIB_NAME="ffmpeg"
set_toolchain_clang_paths ${LIB_NAME}

# PREPARING FLAGS
TARGET_HOST=$(get_target_host)
CFLAGS=$(get_cflags ${LIB_NAME})
CXXFLAGS=$(get_cxxflags ${LIB_NAME})
LDFLAGS=$(get_ldflags ${LIB_NAME})
export PKG_CONFIG_LIBDIR="${INSTALL_PKG_CONFIG_DIR}"

TARGET_CPU=""
TARGET_ARCH=""
ASM_FLAGS=""
case ${ARCH} in
    arm-v7a)
        TARGET_CPU="armv7-a"
        TARGET_ARCH="armv7-a"
        ASM_FLAGS="	--disable-neon --enable-asm --enable-inline-asm"
    ;;
    arm-v7a-neon)
        TARGET_CPU="armv7-a"
        TARGET_ARCH="armv7-a"
        ASM_FLAGS="	--enable-neon --enable-asm --enable-inline-asm"
    ;;
    arm64-v8a)
        TARGET_CPU="armv8-a"
        TARGET_ARCH="aarch64"
        ASM_FLAGS="	--enable-neon --enable-asm --enable-inline-asm"
    ;;
    x86)
        TARGET_CPU="i686"
        TARGET_ARCH="i686"

        # asm disabled due to this ticker https://trac.ffmpeg.org/ticket/4928
        ASM_FLAGS="	--disable-neon --disable-asm --disable-inline-asm"
    ;;
    x86-64)
        TARGET_CPU="x86_64"
        TARGET_ARCH="x86_64"
        ASM_FLAGS="	--disable-neon --enable-asm --enable-inline-asm"
    ;;
esac

CONFIGURE_POSTFIX=""

for library in {1..39}
do
    if [[ ${!library} -eq 1 ]]; then
        ENABLED_LIBRARY=$(get_library_name $((library - 1)))

        echo -e "INFO: Enabling library ${ENABLED_LIBRARY}" >> ${BASEDIR}/build.log

        case $ENABLED_LIBRARY in
            chromaprint)
                CFLAGS+=" $(pkg-config --cflags libchromaprint)"
                LDFLAGS+=" $(pkg-config --libs --static libchromaprint)"
                CONFIGURE_POSTFIX+=" --enable-chromaprint"
            ;;
            fontconfig)
                CFLAGS+=" $(pkg-config --cflags fontconfig)"
                LDFLAGS+=" $(pkg-config --libs --static fontconfig)"
                CONFIGURE_POSTFIX+=" --enable-libfontconfig"
            ;;
            freetype)
                CFLAGS+=" $(pkg-config --cflags freetype2)"
                LDFLAGS+=" $(pkg-config --libs --static freetype2)"
                CONFIGURE_POSTFIX+=" --enable-libfreetype"
            ;;
            frei0r)
                CFLAGS+=" $(pkg-config --cflags frei0r)"
                LDFLAGS+=" $(pkg-config --libs --static frei0r)"
                CONFIGURE_POSTFIX+=" --enable-frei0r --enable-gpl"
            ;;
            fribidi)
                CFLAGS+=" $(pkg-config --cflags fribidi)"
                LDFLAGS+=" $(pkg-config --libs --static fribidi)"
                CONFIGURE_POSTFIX+=" --enable-libfribidi"
            ;;
            gmp)
                CFLAGS+=" $(pkg-config --cflags gmp)"
                LDFLAGS+=" $(pkg-config --libs --static gmp)"
                CONFIGURE_POSTFIX+=" --enable-gmp"
            ;;
            gnutls)
                CFLAGS+=" $(pkg-config --cflags gnutls)"
                LDFLAGS+=" $(pkg-config --libs --static gnutls)"
                CONFIGURE_POSTFIX+=" --enable-gnutls"
            ;;
            kvazaar)
                CFLAGS+=" $(pkg-config --cflags kvazaar)"
                LDFLAGS+=" $(pkg-config --libs --static kvazaar)"
                CONFIGURE_POSTFIX+=" --enable-libkvazaar"
            ;;
            lame)
                CFLAGS+=" $(pkg-config --cflags libmp3lame)"
                LDFLAGS+=" $(pkg-config --libs --static libmp3lame)"
                CONFIGURE_POSTFIX+=" --enable-libmp3lame"
            ;;
            libaom)
                CFLAGS+=" $(pkg-config --cflags aom)"
                LDFLAGS+=" $(pkg-config --libs --static aom)"
                CONFIGURE_POSTFIX+=" --enable-libaom"
            ;;
            libass)
                CFLAGS+=" $(pkg-config --cflags libass)"
                LDFLAGS+=" $(pkg-config --libs --static libass)"
                CONFIGURE_POSTFIX+=" --enable-libass"
            ;;
            libiconv)
                CFLAGS+=" $(pkg-config --cflags libiconv)"
                LDFLAGS+=" $(pkg-config --libs --static libiconv)"
                CONFIGURE_POSTFIX+=" --enable-iconv"
            ;;
            libilbc)
                CFLAGS+=" $(pkg-config --cflags libilbc)"
                LDFLAGS+=" $(pkg-config --libs --static libilbc)"
                CONFIGURE_POSTFIX+=" --enable-libilbc"
            ;;
            libtheora)
                CFLAGS+=" $(pkg-config --cflags theora)"
                LDFLAGS+=" $(pkg-config --libs --static theora)"
                CONFIGURE_POSTFIX+=" --enable-libtheora"
            ;;
            libvidstab)
                CFLAGS+=" $(pkg-config --cflags vidstab)"
                LDFLAGS+=" $(pkg-config --libs --static vidstab)"
                CONFIGURE_POSTFIX+=" --enable-libvidstab --enable-gpl"
            ;;
            libvorbis)
                CFLAGS+=" $(pkg-config --cflags vorbis)"
                LDFLAGS+=" $(pkg-config --libs --static vorbis)"
                CONFIGURE_POSTFIX+=" --enable-libvorbis"
            ;;
            libvpx)
                CFLAGS+=" $(pkg-config --cflags vpx)"
                LDFLAGS+=" $(pkg-config --libs vpx)"
                LDFLAGS+=" $(pkg-config --libs --static cpufeatures)"
                CONFIGURE_POSTFIX+=" --enable-libvpx"
            ;;
            libwebp)
                CFLAGS+=" $(pkg-config --cflags libwebp)"
                LDFLAGS+=" $(pkg-config --libs --static libwebp)"
                CONFIGURE_POSTFIX+=" --enable-libwebp"
            ;;
            libxml2)
                CFLAGS+=" $(pkg-config --cflags libxml-2.0)"
                LDFLAGS+=" $(pkg-config --libs --static libxml-2.0)"
                CONFIGURE_POSTFIX+=" --enable-libxml2"
            ;;
            opencore-amr)
                CFLAGS+=" $(pkg-config --cflags opencore-amrnb)"
                CFLAGS+=" $(pkg-config --cflags opencore-amrwb)"
                LDFLAGS+=" $(pkg-config --libs --static opencore-amrnb)"
                LDFLAGS+=" $(pkg-config --libs --static opencore-amrwb)"
                CONFIGURE_POSTFIX+=" --enable-libopencore-amrnb"
                CONFIGURE_POSTFIX+=" --enable-libopencore-amrwb"
            ;;
            opus)
                CFLAGS+=" $(pkg-config --cflags opus)"
                LDFLAGS+=" $(pkg-config --libs --static opus)"
                CONFIGURE_POSTFIX+=" --enable-libopus"
            ;;
            shine)
                CFLAGS+=" $(pkg-config --cflags shine)"
                LDFLAGS+=" $(pkg-config --libs --static shine)"
                CONFIGURE_POSTFIX+=" --enable-libshine"
            ;;
            snappy)
                CFLAGS+=" $(pkg-config --cflags snappy)"
                LDFLAGS+=" $(pkg-config --libs --static snappy)"
                CONFIGURE_POSTFIX+=" --enable-libsnappy"
            ;;
            soxr)
                CFLAGS+=" $(pkg-config --cflags soxr)"
                LDFLAGS+=" $(pkg-config --libs --static soxr)"
                CONFIGURE_POSTFIX+=" --enable-libsoxr"
            ;;
            speex)
                CFLAGS+=" $(pkg-config --cflags speex)"
                LDFLAGS+=" $(pkg-config --libs --static speex)"
                CONFIGURE_POSTFIX+=" --enable-libspeex"
            ;;
            wavpack)
                CFLAGS+=" $(pkg-config --cflags wavpack)"
                LDFLAGS+=" $(pkg-config --libs --static wavpack)"
                CONFIGURE_POSTFIX+=" --enable-libwavpack"
            ;;
            x264)
                CFLAGS+=" $(pkg-config --cflags x264)"
                LDFLAGS+=" $(pkg-config --libs --static x264)"
                CONFIGURE_POSTFIX+=" --enable-libx264 --enable-gpl"
            ;;
            x265)
                CFLAGS+=" $(pkg-config --cflags x265)"
                LDFLAGS+=" $(pkg-config --libs --static x265)"
                CONFIGURE_POSTFIX+=" --enable-x265 --enable-gpl"
            ;;
            xvidcore)
                CFLAGS+=" $(pkg-config --cflags xvidcore)"
                LDFLAGS+=" $(pkg-config --libs --static xvidcore)"
                CONFIGURE_POSTFIX+=" --enable-libxvid --enable-gpl"
            ;;
            expat)
                CFLAGS+=" $(pkg-config --cflags expat)"
                LDFLAGS+=" $(pkg-config --libs --static expat)"
            ;;
            libogg)
                CFLAGS+=" $(pkg-config --cflags ogg)"
                LDFLAGS+=" $(pkg-config --libs --static ogg)"
            ;;
            libpng)
                CFLAGS+=" $(pkg-config --cflags libpng)"
                LDFLAGS+=" $(pkg-config --libs --static libpng)"
            ;;
            libuuid)
                CFLAGS+=" $(pkg-config --cflags uuid)"
                LDFLAGS+=" $(pkg-config --libs --static uuid)"
            ;;
            nettle)
                CFLAGS+=" $(pkg-config --cflags nettle)"
                LDFLAGS+=" $(pkg-config --libs --static nettle)"
                CFLAGS+=" $(pkg-config --cflags hogweed)"
                LDFLAGS+=" $(pkg-config --libs --static hogweed)"
            ;;
            android-zlib)
                CFLAGS+=" $(pkg-config --cflags zlib)"
                LDFLAGS+=" $(pkg-config --libs --static zlib)"
                CONFIGURE_POSTFIX+=" --enable-zlib"
            ;;
            android-media-codec)
                CONFIGURE_POSTFIX+=" --enable-mediacodec"
            ;;
        esac
    else

        # THE FOLLOWING LIBRARIES SHOULD BE EXPLICITLY DISABLED TO PREVENT AUTODETECT
        if [[ ${library} -eq 38 ]]; then
            CONFIGURE_POSTFIX+=" --disable-zlib"
        fi
    fi
done

LDFLAGS+=" -L${ANDROID_NDK_ROOT}/platforms/android-${API}/arch-${TOOLCHAIN_ARCH}/usr/lib"

cd ${BASEDIR}/src/${LIB_NAME} || exit 1

echo -n -e "\n${LIB_NAME}: "

make distclean 2>/dev/null 1>/dev/null

./configure \
    --cross-prefix="${TARGET_HOST}-" \
    --sysroot="${ANDROID_NDK_ROOT}/toolchains/mobile-ffmpeg-${TOOLCHAIN}/sysroot" \
    --prefix="${BASEDIR}/prebuilt/android-$(get_target_build)/${LIB_NAME}" \
    --pkg-config="${HOST_PKG_CONFIG_PATH}" \
    --extra-cflags="${CFLAGS}" \
    --extra-cxxflags="${CXXFLAGS}" \
    --extra-ldflags="${LDFLAGS}" \
    --enable-version3 \
    --arch="${TARGET_ARCH}" \
    --cpu="${TARGET_CPU}" \
    --target-os=android \
    ${ASM_FLAGS} \
    --enable-cross-compile \
    --enable-pic \
    --enable-jni \
    --enable-optimizations \
    --enable-small  \
    --enable-swscale \
    --enable-shared \
    --disable-openssl \
    --disable-xmm-clobber-test \
    --disable-debug \
    --disable-neon-clobber-test \
    --disable-programs \
    --disable-postproc \
    --disable-doc \
    --disable-htmlpages \
    --disable-manpages \
    --disable-podpages \
    --disable-txtpages \
    --disable-static \
    --disable-sndio \
    --disable-schannel \
    --disable-sdl2 \
    --disable-securetransport \
    --disable-xlib \
    --disable-cuda \
    --disable-cuvid \
    --disable-nvenc \
    --disable-vaapi \
    --disable-vdpau \
    --disable-videotoolbox \
    --disable-appkit \
    --disable-alsa \
    --disable-cuda \
    --disable-cuvid \
    --disable-nvenc \
    --disable-vaapi \
    --disable-vdpau \
    --disable-videotoolbox \
    ${CONFIGURE_POSTFIX} 1>>${BASEDIR}/build.log 2>>${BASEDIR}/build.log

if [ $? -ne 0 ]; then
    echo "failed"
    exit 1
fi

make -j$(get_cpu_count) 1>>${BASEDIR}/build.log 2>>${BASEDIR}/build.log

if [ $? -ne 0 ]; then
    echo "failed"
    exit 1
fi

make install 1>>${BASEDIR}/build.log 2>>${BASEDIR}/build.log

if [ $? -ne 0 ]; then
    echo "failed"
    exit 1
fi

# MANUALLY ADD CONFIG HEADER
cp -f ${BASEDIR}/src/ffmpeg/config.h ${BASEDIR}/prebuilt/android-$(get_target_build)/ffmpeg/include

if [ $? -eq 0 ]; then
    echo "ok"
else
    echo "failed"
    exit 1
fi
