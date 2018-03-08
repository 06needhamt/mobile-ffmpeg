#!/bin/bash

if [[ -z $1 ]]; then
    echo "usage: $0 <enabled libraries>"
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
. ${BASEDIR}/build/common.sh

echo -e "\nBuilding for $ARCH on API level $API\n"
INSTALL_BASE="${ANDROID_NDK_ROOT}/prebuilt/android-${ARCH}"

# CLEANING EXISTING PACKAGE CONFIG DIRECTORY
PKG_CONFIG_DIRECTORY="${INSTALL_BASE}/pkgconfig"
if [ -d ${PKG_CONFIG_DIRECTORY} ]; then
    cd ${PKG_CONFIG_DIRECTORY} || exit 1
    rm -f *.pc || exit 1
else
    mkdir -p ${PKG_CONFIG_DIRECTORY} || exit 1
fi

enabled_library_list=()
for library in {1..24}
do
    if [[ ${!library} -eq 1 ]]; then
        ENABLED_LIBRARY=$(get_library_name $((library - 1)))
        enabled_library_list+=(${ENABLED_LIBRARY})
    fi
done

let completed=0
while [ ${#enabled_library_list[@]} -gt $completed ]; do
    for library in "${enabled_library_list[@]}"
    do
        let run=0
        case $library in
            fontconfig)
                if [ ! -z $OK_libuuid ] && [ ! -z $OK_libxml2 ] && [ ! -z $OK_libiconv ] && [ ! -z $OK_freetype ]; then
                    run 1
                fi
            ;;
            gnutls)
                if [ ! -z $OK_nettle ] && [ ! -z $OK_gmp ] && [ ! -z $OK_libiconv ]; then
                    run 1
                fi
            ;;
            lame)
                if [ ! -z $OK_libiconv ]; then
                    run 1
                fi
            ;;
            libass)
                if [ ! -z $OK_libuuid ] && [ ! -z $OK_libxml2 ] && [ ! -z $OK_libiconv ] && [ ! -z $OK_freetype ] && [ ! -z $OK_fribidi ] && [ ! -z $OK_fontconfig ]; then
                    run 1
                fi
            ;;
            libtheora)
                if [ ! -z $OK_libvorbis ] && [ ! -z $OK_libogg ]; then
                    run 1
                fi
            ;;
            libvorbis)
                if [ ! -z $OK_libogg ]; then
                    run 1
                fi
            ;;
            libwebp)
                if [ ! -z $OK_giflib ] && [ ! -z $OK_jpeg ] && [ ! -z $OK_libpng ] && [ ! -z $OK_tiff ]; then
                    run 1
                fi
            ;;
            libxml2)
                if [ ! -z $OK_libiconv ]; then
                    run 1
                fi
            ;;
            *)
                run=1
            ;;
        esac

        if [[ $run -eq 1 ]]; then
            ENABLED_LIBRARY_PATH="${INSTALL_BASE}/${library}"

            echo -n "${library}:"

            if [ -d ${ENABLED_LIBRARY_PATH} ]; then
                rm -rf ${INSTALL_BASE}/${library} || exit 1
            fi

            SCRIPT_PATH="$BASEDIR/build/android-${library}.sh"

            # BUILD EACH LIBRARY ALONE FIRST
            SCRIPT_PATH ${BASEDIR} 1>>build.log 2>>build.log

            if [ $? -eq 0 ]; then
                $((completed++))
                declare "OK_$library=1"
                echo " ok"
            else
                echo " failed"
                exit 1
            fi
        fi
    done
done
