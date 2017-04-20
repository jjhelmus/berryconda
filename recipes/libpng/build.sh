#!/bin/bash

export CFLAGS="$CFLAGS -I$PREFIX/include -L$PREFIX/lib"
export CPPFLAGS="$CPPFLAGS -I$PREFIX/include"

./configure --prefix=$PREFIX \
            --with-zlib-prefix=$PREFIX

make -j ${CPU_COUNT}
make check
make install
