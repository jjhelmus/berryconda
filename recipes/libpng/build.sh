#!/bin/bash

export CFLAGS="$CFLAGS -I$PREFIX/include -L$PREFIX/lib"
export CPPFLAGS="$CPPFLAGS -I$PREFIX/include"

./configure --prefix=$PREFIX \
            --with-zlib-prefix=$PREFIX

make
make check
make install
