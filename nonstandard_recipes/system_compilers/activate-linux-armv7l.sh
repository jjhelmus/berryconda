#!/bin/bash

# target the Raspberry Pi 2 or 3(+)
# Pi 2 : Cortex-A7
# Pi 2 ver 1.2 : Cortex-A53
# Pi 3/3+ : Cortex A53
ARCH_FLAGS="-march=armv7-a -mfpu=neon-vfpv4 -mfloat-abi=hard"

export CC=gcc
export CXX=g++
export FC=gfortran
export F77=gfortran
export F90=gfortran

export CPPFLAGS="${CPPFLAGS} -O2"
export CFLAGS="${CFLAGS} -I${PREFIX}/include ${ARCH_FLAGS} -fPIC -O2 -pipe"
export CXXFLAGS="${CXXFLAGS} -I${PREFIX}/include ${ARCH_FLAGS} -fPIC -O2 -pipe"
export FFLAGS="${FFLAGS} ${ARCH_FLAGS} -I${PREFIX} -fPIC -O2 -pipe"
export LDFLAGS="${LDFLAGS} -Wl,-rpath,$PREFIX/lib -L${PREFIX}/lib"
export LINKFLAGS="${LDFLAGS}"
