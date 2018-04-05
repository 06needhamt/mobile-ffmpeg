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
set_toolchain_clang_paths

# PREPARING FLAGS
TARGET_HOST=$(get_target_host)
COMMON_CFLAGS=$(get_cflags "gnutls")
COMMON_CXXFLAGS=$(get_cxxflags "gnutls")
COMMON_LDFLAGS=$(get_ldflags "gnutls")

export CFLAGS="${COMMON_CFLAGS} -I${ANDROID_NDK_ROOT}/prebuilt/android-$(get_target_build ${ARCH})/libiconv/include -I${ANDROID_NDK_ROOT}/prebuilt/android-$(get_target_build ${ARCH})/gmp/include"
export CXXFLAGS="${COMMON_CXXFLAGS}"
export LDFLAGS="${COMMON_LDFLAGS} -L${ANDROID_NDK_ROOT}/prebuilt/android-$(get_target_build ${ARCH})/libiconv/lib -L${ANDROID_NDK_ROOT}/prebuilt/android-$(get_target_build ${ARCH})/gmp/lib"
export PKG_CONFIG_PATH="${INSTALL_PKG_CONFIG_DIR}"

cd ${BASEDIR}/src/gnutls || exit 1

make distclean 2>/dev/null 1>/dev/null

./configure \
    --prefix=${ANDROID_NDK_ROOT}/prebuilt/android-$(get_target_build ${ARCH})/gnutls \
    --with-pic \
    --with-sysroot=${ANDROID_NDK_ROOT}/toolchains/mobile-ffmpeg-${TOOLCHAIN}/sysroot \
    --with-included-libtasn1 \
    --with-included-unistring \
    --without-idn \
    --without-libidn2 \
    --without-p11-kit \
    --enable-openssl-compatibility \
    --enable-static \
    --disable-shared \
    --disable-fast-install \
    --disable-code-coverage \
    --disable-doc \
    --disable-manpages \
    --disable-tests \
    --disable-tools \
    --host=${TARGET_HOST} || exit 1

make -j$(get_cpu_count) || exit 1

# CREATE PACKAGE CONFIG MANUALLY
create_gnutls_package_config "3.5.18"

make install || exit 1
