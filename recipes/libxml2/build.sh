#!/bin/bash

export LIBRARY_SEARCH_VAR=LD_LIBRARY_PATH

./autogen.sh

./configure --prefix="${PREFIX}" \
            --with-zlib="${PREFIX}" \
            --with-lzma="${PREFIX}" \
            --without-python
make
eval ${LIBRARY_SEARCH_VAR}=$PREFIX/lib make check
make install
