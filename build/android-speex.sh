#!/bin/bash

if [[ -z $1 ]]; then
    echo "usage: $0 <mobile ffmpeg base directory>"
    exit 1
fi

if [[ -z $ANDROID_NDK ]]; then
    echo "ANDROID_NDK not defined"
    exit 1
fi

if [[ -z $ARCH ]]; then
    echo "ARCH not defined"
    exit 1
fi

if [[ -z $API ]]; then
    echo "API not defined"
    exit 1
fi

# ENABLE COMMON FUNCTIONS
. $1/build/common.sh

# PREPARING PATHS
android_prepare_toolchain_paths $ARCH

TARGET_HOST=$(android_get_target_host $ARCH)
COMMON_CPPFLAGS=$(android_get_common_cppflags $ARCH)
COMMON_CXXFLAGS=$(android_get_common_cxxflags $ARCH)
COMMON_LDFLAGS=$(android_get_common_ldflags $ARCH)
CPPFLAGS="$COMMON_CPPFLAGS -I$ANDROID_NDK/prebuilt/android-$ARCH/libiconv/include"
CXXFLAGS="$COMMON_CXXFLAGS"
LDFLAGS="$COMMON_LDFLAGS -L$ANDROID_NDK/prebuilt/android-$ARCH/libiconv/lib"

OPTIONAL_CPU_SUPPORT=""
if [ $ARCH == "x86" ] || [ $ARCH == "x86_64" ]; then
    OPTIONAL_CPU_SUPPORT="--enable-sse"
fi

cd $1/src/speex || exit 1

make clean

CPFLAGS=$CPPFLAGS \
CXXFLAGS=$CXXFLAGS \
LDFLAGS=$LDFLAGS \
./configure \
    --prefix=$ANDROID_NDK/prebuilt/android-$ARCH/speex \
    --with-pic \
    --with-sysroot=$ANDROID_NDK/toolchains/mobile-ffmpeg-$ARCH/sysroot \
    --enable-static \
    $OPTIONAL_CPU_SUPPORT \
    --disable-shared \
    --disable-binaries \
    --disable-fast-install \
    --host=$TARGET_HOST || exit 1

CPFLAGS=$CPPFLAGS \
CXXFLAGS=$CXXFLAGS \
LDFLAGS=$LDFLAGS \
make -j$(nproc) || exit 1

CPFLAGS=$CPPFLAGS \
CXXFLAGS=$CXXFLAGS \
LDFLAGS=$LDFLAGS \
make install || exit 1
