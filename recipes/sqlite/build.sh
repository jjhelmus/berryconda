#!/bin/bash

if [ `uname -m` == ppc64le ]; then
    B="--build=ppc64le-linux"
fi
if [ `uname -m` == armv7l ]; then
    B="--build=armv7l-linux"
fi

./configure $B --enable-threadsafe \
            --enable-tempstore \
            --enable-shared=yes \
            --disable-tcl \
            --disable-readline \
            --prefix=$PREFIX
make
make check
make install

rm -rf  $PREFIX/share
