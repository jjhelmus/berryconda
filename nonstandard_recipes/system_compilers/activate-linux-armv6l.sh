#!/bin/bash

# match the compiler flags used by Raspbian for linux-armv6l conda packages
ARCH_FLAGS="-march=armv6 -mfpu=vfp -mfloat-abi=hard"

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
