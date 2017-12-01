#!/bin/bash

mkdir -vp ${PREFIX}/bin

chmod +x configure
./configure \
        --enable-pic \
        --enable-shared \
        --enable-static \
        --prefix=${PREFIX}
make
make install
