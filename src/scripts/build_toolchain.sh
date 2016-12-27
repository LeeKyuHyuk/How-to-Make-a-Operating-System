#!/bin/bash
set -o nounset
set -o errexit

export TARGET="x86_64-pc-linux"
export WORKSPACE_DIR=$(pwd)
export PACKAGES_DIR=${WORKSPACE_DIR}/packages
export TOOLS_DIR=${WORKSPACE_DIR}/out/tools
export BUILD_DIR=${WORKSPACE_DIR}/out/build
export PATH="${TOOLS_DIR}/bin:${PATH}"

function step() {
	echo -e "\e[7m\e[1m>>> $1\e[0m"
}

function timer {
    if [[ $# -eq 0 ]]; then
        echo $(date '+%s')
    else
        local stime=$1
        etime=$(date '+%s')
        if [[ -z "$stime" ]]; then stime=$etime; fi
        dt=$((etime - stime))
        ds=$((dt % 60))
        dm=$(((dt / 60) % 60))
        dh=$((dt / 3600))
        printf '%02d:%02d:%02d' $dh $dm $ds
    fi
}

CPU_NUM=`cat /proc/cpuinfo | grep cores | wc -l `
let PARALLEL_JOBS=$CPU_NUM+$(printf %.0f `echo "$CPU_NUM*0.2"|bc`)
total_time=$(timer)

rm -rf ${TOOLS_DIR} ${BUILD_DIR}
mkdir -p ${TOOLS_DIR} ${BUILD_DIR}

#----------------------------#
#        binutils 2.27       #
#----------------------------#
step "binutils 2.27 Extracting"
mkdir -p ${BUILD_DIR}/binutils-2.27
bzcat ${PACKAGES_DIR}/binutils/binutils-2.27.tar.bz2 | tar --strip-components=1 -C ${BUILD_DIR}/binutils-2.27 -xf -
step "binutils 2.27 Configuring"
( cd ${BUILD_DIR}/binutils-2.27/ && ./configure --target=${TARGET} --prefix=${TOOLS_DIR} --disable-nls --disable-shared --enable-64-bit-bfd )
step "binutils 2.27 Building"
make -j${PARALLEL_JOBS} configure-host -C ${BUILD_DIR}/binutils-2.27/
make -j${PARALLEL_JOBS} LDFLAGS="-all-static" -C ${BUILD_DIR}/binutils-2.27/
make -j${PARALLEL_JOBS} install -C ${BUILD_DIR}/binutils-2.27/
rm -rf ${BUILD_DIR}/binutils-2.27

#----------------------------#
#          GCC 6.3.0         #
#----------------------------#
step "GCC 6.3.0 Extracting"
cat ${PACKAGES_DIR}/gcc/gcc-6.3.0.part* > ${BUILD_DIR}/gcc-6.3.0.tar.bz2
mkdir -p ${BUILD_DIR}/gcc-6.3.0
bzcat ${BUILD_DIR}/gcc-6.3.0.tar.bz2 | tar --strip-components=1 -C ${BUILD_DIR}/gcc-6.3.0 -xf -
rm ${BUILD_DIR}/gcc-6.3.0.tar.bz2
step "GMP 6.1.2 Extracting"
mkdir -p ${BUILD_DIR}/gcc-6.3.0/gmp
xzcat ${PACKAGES_DIR}/gmp/gmp-6.1.2.tar.xz | tar --strip-components=1 -C ${BUILD_DIR}/gcc-6.3.0/gmp -xf -
step "MPC 1.0.3 Extracting"
mkdir -p ${BUILD_DIR}/gcc-6.3.0/mpc
gzip -d -c ${PACKAGES_DIR}/mpc/mpc-1.0.3.tar.gz | tar --strip-components=1 -C ${BUILD_DIR}/gcc-6.3.0/mpc -xf -
step "MPFR 3.1.5 Extracting"
mkdir -p ${BUILD_DIR}/gcc-6.3.0/mpfr
xzcat ${PACKAGES_DIR}/mpfr/mpfr-3.1.5.tar.xz | tar --strip-components=1 -C ${BUILD_DIR}/gcc-6.3.0/mpfr -xf -
step "GCC 6.3.0 Configuring"
( cd ${BUILD_DIR}/gcc-6.3.0/ && ./configure --target=${TARGET} --prefix=${TOOLS_DIR} --disable-nls --disable-shared --enable-languages=c --enable-multilib --without-headers )
step "GCC 6.3.07 Building"
make -j${PARALLEL_JOBS} configure-host -C ${BUILD_DIR}/gcc-6.3.0/
make -j${PARALLEL_JOBS} all-gcc -C ${BUILD_DIR}/gcc-6.3.0/
make -j${PARALLEL_JOBS} install-gcc -C ${BUILD_DIR}/gcc-6.3.0/
rm -rf ${BUILD_DIR}/gcc-6.3.0

echo -e "\e[7m\e[1m"
printf '>>> Total toolchain build time: %s\n' $(timer $total_time)
echo -e "\e[0m"
