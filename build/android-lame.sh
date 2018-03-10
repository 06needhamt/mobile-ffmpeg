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

if [[ -z ${BASEDIR} ]]; then
    echo "BASEDIR not defined"
    exit 1
fi

# ENABLE COMMON FUNCTIONS
. ${BASEDIR}/build/android-common.sh

# PREPARING PATHS & DEFINING ${INSTALL_PKG_CONFIG_DIR}
prepare_toolchain_paths

# PREPARING FLAGS
TARGET_HOST=$(get_target_host)
export CFLAGS=$(get_cflags "lame")
export CXXFLAGS=$(get_cxxflags "lame")
export LDFLAGS=$(get_ldflags "lame")

cd ${BASEDIR}/src/lame || exit 1

make distclean 2>/dev/null 1>/dev/null

./configure \
    --prefix=${ANDROID_NDK_ROOT}/prebuilt/android-${ARCH//-/_}/lame \
    --with-pic \
    --with-sysroot=${ANDROID_NDK_ROOT}/toolchains/mobile-ffmpeg-${TOOLCHAIN}/sysroot \
    --with-libiconv-prefix=${ANDROID_NDK_ROOT}/prebuilt/android-${ARCH//-/_}/libiconv \
    --enable-static \
    --disable-shared \
    --disable-fast-install \
    --disable-maintainer-mode \
    --disable-frontend \
    --disable-efence \
    --disable-gtktest \
    --host=${TARGET_HOST} || exit 1

make -j$(nproc) || exit 1

# CREATE PACKAGE CONFIG MANUALLY
create_libmp3lame_package_config "3.100"

make install || exit 1
