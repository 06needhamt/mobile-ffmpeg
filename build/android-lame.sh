#!/bin/bash

create_libmp3lame_package_config() {
    local LAME_VERSION="$1"

    cat > "${INSTALL_PKG_CONFIG_DIR}/libmp3lame.pc" << EOF
prefix=${ANDROID_NDK_ROOT}/prebuilt/android-${ARCH}/lame
exec_prefix=\${prefix}
libdir=\${exec_prefix}/lib
includedir=\${prefix}/include

Name: libmp3lame
Description: lame mp3 encoder library
Version: ${LAME_VERSION}

Requires:
Libs: -L\${libdir} -lmp3lame
Cflags: -I\${includedir}
EOF
}

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

# PREPARING PATHS & DEFINING ${INSTALL_PKG_CONFIG_DIR}
android_prepare_toolchain_paths

# PREPARING FLAGS
TARGET_HOST=$(android_get_target_host)
export CFLAGS=$(android_get_cflags "lame")
export CXXFLAGS=$(android_get_cxxflags "lame")
export LDFLAGS=$(android_get_ldflags "lame")

cd $1/src/lame || exit 1

make clean

./configure \
    --prefix=${ANDROID_NDK_ROOT}/prebuilt/android-${ARCH}/lame \
    --with-pic \
    --with-sysroot=${ANDROID_NDK_ROOT}/toolchains/mobile-ffmpeg-${ARCH}/sysroot \
    --with-libiconv-prefix=${ANDROID_NDK_ROOT}/prebuilt/android-${ARCH}/libiconv \
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
