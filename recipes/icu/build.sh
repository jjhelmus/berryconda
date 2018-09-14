#!/bin/bash

cd source

chmod +x configure install-sh

EXTRA_OPTS=""
if [ "$(uname)" == "Darwin" ]; then
  EXTRA_OPTS="--enable-rpath"
  export CXX="${CXX} -stdlib=libc++"
fi

./configure --prefix="$PREFIX" \
            --disable-samples \
            --disable-extras \
            --disable-layout \
            --disable-tests \
            --enable-static \
            "${EXTRA_OPTS}"

make -j$CPU_COUNT
make check
make install

rm -rf $PREFIX/sbin
