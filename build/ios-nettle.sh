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
set_toolchain_clang_paths

# PREPARING FLAGS
TARGET_HOST=$(get_target_host)
export CFLAGS=$(get_cflags "nettle")
export CXXFLAGS=$(get_cxxflags "nettle")
export LDFLAGS=$(get_ldflags "nettle")
export PKG_CONFIG_PATH="${INSTALL_PKG_CONFIG_DIR}"

OPTIONAL_CPU_SUPPORT=""
case ${ARCH} in
    armv7 | armv7s | arm64)
        OPTIONAL_CPU_SUPPORT="--enable-arm-neon"
    ;;
    i386 | x86-64)
        OPTIONAL_CPU_SUPPORT="--enable-x86-aesni"
    ;;
esac

cd ${BASEDIR}/src/nettle || exit 1

make distclean 2>/dev/null 1>/dev/null

# RECONFIGURING IF REQUESTED
if [[ ${RECONF_nettle} -eq 1 ]]; then
    autoreconf --force --install
fi

./configure \
    --prefix=${BASEDIR}/prebuilt/ios-$(get_target_host)/nettle \
    --enable-pic \
    --enable-static \
    --with-include-path=${BASEDIR}/prebuilt/ios-$(get_target_host)/gmp/include \
    --with-lib-path=${BASEDIR}/prebuilt/ios-$(get_target_host)/gmp/lib \
    --disable-shared \
    --disable-mini-gmp \
    --disable-assembler \
    --disable-openssl \
    --disable-gcov \
    --disable-documentation \
    ${OPTIONAL_CPU_SUPPORT} \
    --host=${TARGET_HOST} || exit 1

make -j$(get_cpu_count) || exit 1

# MANUALLY COPY PKG-CONFIG FILES
cp ./*.pc ${INSTALL_PKG_CONFIG_DIR}

make install || exit 1
