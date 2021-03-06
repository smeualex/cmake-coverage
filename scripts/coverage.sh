#!/bin/bash
# get architecture - i386/x86_64/etc
ARCH=`lscpu | grep -e "Architecture" | awk '{print $2}'`
CONFIG=Debug
GENERATOR="Unix Makefiles"
BUILD_DIR=${HOME}/build/cmake-coverage/Linux-${ARCH}/${CONFIG}

gcc_8_present=false

# project directory
SOURCE_DIR=''

function copy_dir {
    src=$1
    dstDir=$2

    log Copy ${src} to ${dstDir}

    # create the destination directory if it doesn't exist
    [ ! -d "${dstDir}" ] && mkdir -p ${dstDir}
    cp -R ${src} ${dstDir}
}

function main {
    log "============================================================================="
    # GCC ver > 8.3.0 is required
    check_gcc_version
    # add /usr/local/lib64 to lib path to be sure
    export LD_LIBRARY_PATH=/usr/local/lib64:$LD_LIBRARY_PATH
    # get the script's location
    get_source_dir

    log " >> Building cmake-coverage - ${CONFIG}-${ARCH}"
    log " >> directory = ${SOURCE_DIR}"

    log " >> CMake configure..."
    cmake -S ${SOURCE_DIR} -B "${BUILD_DIR}" -G "${GENERATOR}" -DCMAKE_BUILD_TYPE=${CONFIG} -DBUILD_TESTS=ON -DLOG_CMAKE_VARIABLES=ON -DCODE_COVERAGE=ON
    err=$?
    check_error $err "ERROR - CMake configure; err=${err}"

    log " >> CMake Build..."
    cmake --build ${BUILD_DIR} --config ${CONFIG} $1
    err=$?
    check_error $err "ERROR - CMake build; err=${err}"

    pushd ${BUILD_DIR}
        #log " >> CMake CTest..."
        #ctest --build-config ${CONFIG}
        log " >> Running coverage..."
        make ccov-all
        err=$?
        check_error $err "ERROR - CMake CTest; err=${err}"

        log " >> Copy ccov report to host..."
        copy_dir ./ccov /vagrant/build/Linux-${ARCH}/${CONFIG}
    popd

    log " >> DONE"
    log "============================================================================="
}

function log {
    echo "[$(date --rfc-3339=seconds)]: $*"
}

function check_error {
    errCode=$1
    errMsg=$2

    if [ "${errCode}" -ne "0" ]; then
        log ${errMsg}
        exit 1
    fi
}

function check_gcc_version {
    currentver="$(gcc -dumpversion)"
    requiredver="8"

    log "   >> Checking for GCC version."
    log "   >> Required version: ${requiredver}"
    log "   >> Found    version: ${currentver}"

    if [ "$(printf '%s\n' "$requiredver" "$currentver" | sort -V | head -n1)" = "$requiredver" ]; then 
        log "   >> GCC 9 Found"
        gcc_8_present=true
    else
        log "   >> GCC 9 not found - PLEASE UPDATE GCC!!!"
        gcc_8_present=false
        exit
    fi
}

# set SCRIPT_DIR with the script's location
# this is where the CMakeLists.txt file is present
function get_source_dir {
    SOURCE="${BASH_SOURCE[0]}"
    # resolve $SOURCE until the file is no longer a symlink
    while [ -h "$SOURCE" ]; do
        SCRIPT_DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
        SOURCE="$(readlink "$SOURCE")"
        # if $SOURCE was a relative symlink, we need to resolve it 
        # relative to the path where the symlink file was located
        [[ $SOURCE != /* ]] && SOURCE="$SCRIPT_DIR/$SOURCE"
    done
    SCRIPT_DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
    SOURCE_DIR=${SCRIPT_DIR}/..
}

main $1