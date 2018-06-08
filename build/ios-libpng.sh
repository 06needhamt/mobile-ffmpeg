#!/bin/bash

if [[ -z ${ARCH} ]]; then
    echo "ARCH not defined"
    exit 1
fi

if [[ -z ${IOS_MIN_VERSION} ]]; then
    echo "IOS_MIN_VERSION not defined"
    exit 1
fi

if [[ -z ${TARGET_SDK} ]]; then
    echo "TARGET_SDK not defined"
    exit 1
fi

if [[ -z ${SDK_PATH} ]]; then
    echo "SDK_PATH not defined"
    exit 1
fi

if [[ -z ${BASEDIR} ]]; then
    echo "BASEDIR not defined"
    exit 1
fi

# ENABLE COMMON FUNCTIONS
. ${BASEDIR}/build/ios-common.sh

# PREPARING PATHS & DEFINING ${INSTALL_PKG_CONFIG_DIR}
LIB_NAME="libpng"
set_toolchain_clang_paths ${LIB_NAME}

# PREPARING FLAGS
TARGET_HOST=$(get_target_host)
export CFLAGS=$(get_cflags ${LIB_NAME})
export CXXFLAGS=$(get_cxxflags ${LIB_NAME})
export LDFLAGS=$(get_ldflags ${LIB_NAME})
export PKG_CONFIG_PATH="${INSTALL_PKG_CONFIG_DIR}"

CPU_SPECIFIC_OPTIONS="--enable-hardware-optimizations"
case ${ARCH} in
    x86 | x86-64)
        CPU_SPECIFIC_OPTIONS+=" --enable-sse"
    ;;
    armv7 | armv7s | arm64)
        CPU_SPECIFIC_OPTIONS+=" --enable-arm-neon"
    ;;
esac

cd ${BASEDIR}/src/${LIB_NAME} || exit 1

make distclean 2>/dev/null 1>/dev/null

# RECONFIGURING IF REQUESTED
if [[ ${RECONF_libpng} -eq 1 ]]; then
    autoreconf_library ${LIB_NAME}
fi

./configure \
    --prefix=${BASEDIR}/prebuilt/ios-$(get_target_host)/${LIB_NAME} \
    --with-pic \
    --with-sysroot=${SDK_PATH} \
    --enable-static \
    --disable-shared \
    --disable-fast-install \
    --disable-unversioned-libpng-pc \
    --disable-unversioned-libpng-config \
    ${CPU_SPECIFIC_OPTIONS} \
    --host=${TARGET_HOST} || exit 1

make -j$(get_cpu_count) || exit 1

# CREATE PACKAGE CONFIG MANUALLY
create_libpng_package_config "1.6.34"

make install || exit 1
