#!/bin/bash

create_libiconv_package_config() {
    local LIB_ICONV_VERSION="$1"

    cat > "${INSTALL_PKG_CONFIG_DIR}/libiconv.pc" << EOF
prefix=${ANDROID_NDK_ROOT}/prebuilt/android-${ARCH//-/_}/libiconv
exec_prefix=\${prefix}
libdir=\${exec_prefix}/lib
includedir=\${prefix}/include

Name: libiconv
Description: Character set conversion library
Version: ${LIB_ICONV_VERSION}

Requires:
Libs: -L\${libdir} -liconv -lcharset
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

if [[ -z ${ARCH//-/_} ]]; then
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
export CFLAGS=$(android_get_cflags "libiconv")
export CXXFLAGS=$(android_get_cxxflags "libiconv")
export LDFLAGS=$(android_get_ldflags "libiconv")

cd $1/src/libiconv || exit 1

make distclean

./configure \
    --prefix=${ANDROID_NDK_ROOT}/prebuilt/android-${ARCH//-/_}/libiconv \
    --with-pic \
    --with-sysroot=${ANDROID_NDK_ROOT}/toolchains/mobile-ffmpeg-${ARCH//-/_}/sysroot \
    --enable-static \
    --disable-shared \
    --disable-fast-install \
    --disable-rpath \
    --host=${TARGET_HOST} || exit 1

make -j$(nproc) || exit 1

# CREATE PACKAGE CONFIG MANUALLY
create_libiconv_package_config "1.15"

make install || exit 1
