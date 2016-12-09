#!/bin/sh

export CFLAGS="-I$PREFIX/include"
export LDFLAGS="-L$PREFIX/lib"
export PYTHON="/usr/bin/python"
./configure --prefix=$PREFIX   \
            --with-internal-glib

make
make install
