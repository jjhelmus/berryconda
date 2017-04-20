#!/bin/bash

export LDFLAGS="-L$PREFIX/lib $LDFLAGS"
export CPPFLAGS="-I$PREFIX/include $CPPFLAGS"

./configure --prefix=$PREFIX \
            --with-zlib=yes \
            --with-png=yes \
            --without-harfbuzz \
            --with-bzip2=no \

make -j ${CPU_COUNT}
make check
make install
