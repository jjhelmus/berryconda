#!/bin/bash

case `uname -m` in
  'aarch64' )
    TARGET=ARMV8
    ;;
  'armv7l' )
    TARGET=ARMV7
    ;;
  'armv6l' )
    TARGET=ARMV6
    ;;
  * )
    TARGET=NEHALEM
    ;;
esac

OPTS="USE_THREAD=1 NO_LAPACK=0 TARGET=$TARGET NO_STATIC=1"

make FC=gfortran $OPTS -j$CPU_COUNT
OPENBLAS_NUM_THREADS=$CPU_COUNT make test
make PREFIX=$PREFIX $OPTS install
