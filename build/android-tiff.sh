#!/bin/bash

if [[ -z $1 ]]; then
    echo "usage: $0 <mobile ffmpeg base directory>"
    exit 1
fi

if [[ -z ${ANDROID_NDK_ROOT} ]]; then
    echo "ANDROID_NDK_ROOT not defined"
    exit 1
fi

if [[ -z ${ARCH} ]]; then
    echo "ARCH not defined"
    exit 1
fi

if [[ -z ${API} ]]; then
    echo "API not defined"
    exit 1
fi

# ENABLE COMMON FUNCTIONS
. $1/build/common.sh

# PREPARING FLAGS
TARGET_HOST=$(android_get_target_host)
export CFLAGS=$(android_get_cflags "tiff")
export CXXFLAGS=$(android_get_cxxflags "tiff")
export LDFLAGS=$(android_get_ldflags "tiff")

# MANUALLY PREPARING PATHS AND TOOLS
export PATH=$PATH:${ANDROID_NDK_ROOT}/toolchains/mobile-ffmpeg-${ARCH}/bin
export AR=${TARGET_HOST}-ar
export AS=${TARGET_HOST}-clang
export CC=${TARGET_HOST}-clang
export CXX=${TARGET_HOST}-clang++
export LD=${TARGET_HOST}-ld
export RANLIB=${TARGET_HOST}-ranlib
export STRIP=${TARGET_HOST}-strip
export INSTALL_PKG_CONFIG_DIR="${ANDROID_NDK_ROOT}/prebuilt/android-${ARCH}/pkgconfig"

cd $1/src/tiff || exit 1

make clean

./configure \
    --prefix=${ANDROID_NDK_ROOT}/prebuilt/android-${ARCH}/tiff \
    --with-pic \
    --with-sysroot=${ANDROID_NDK_ROOT}/toolchains/mobile-ffmpeg-${ARCH}/sysroot \
    --with-jpeg-include-dir=${ANDROID_NDK_ROOT}/prebuilt/android-${ARCH}/jpeg/include \
    --with-jpeg-lib-dir=${ANDROID_NDK_ROOT}/prebuilt/android-${ARCH}/jpeg/lib \
    --enable-static \
    --disable-shared \
    --disable-fast-install \
    --disable-maintainer-mode \
    --host=${TARGET_HOST} || exit 1

make -j$(nproc) || exit 1

# MANUALLY COPY PKG-CONFIG FILES
cp ./*.pc ${INSTALL_PKG_CONFIG_DIR}

make install || exit 1
