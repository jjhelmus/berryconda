#!/bin/bash

# unset the SUBDIR variable since it changes the behavior of make here
unset SUBDIR

./configure \
        --prefix="${PREFIX}" \
        --disable-doc \
        --enable-shared \
        --enable-static \
        --extra-libs="`pkg-config --libs zlib`" \
        --enable-pic \
        --enable-gpl \
        --enable-version3 \
        --enable-hardcoded-tables \
        --enable-avresample \
        --enable-libx264

make -j ${CPU_COUNT}
make install
