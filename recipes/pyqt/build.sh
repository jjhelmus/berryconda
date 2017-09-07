#!/bin/bash

set -e # Abort on error.

$PYTHON configure.py \
        --verbose \
        --confirm-license \
        --assume-shared
        #-q $PREFIX/bin/qmake

make -j$CPU_COUNT
make check 
make install
