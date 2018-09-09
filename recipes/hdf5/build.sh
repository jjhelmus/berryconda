#!/bin/bash

if [ "$(uname)" == "Darwin" ]; then
    export CXX="${CXX} -stdlib=libc++"
    export LDFLAGS="${LDFLAGS} -Wl,-rpath,$PREFIX/lib"
fi

export LIBRARY_PATH="${PREFIX}/lib"

./configure --prefix="${PREFIX}" \
            --with-pic \
            --enable-linux-lfs \
            --with-zlib="${PREFIX}" \
            --with-pthread=yes  \
            --enable-cxx \
            --enable-fortran \
            --enable-fortran2003 \
            --with-default-plugindir="${PREFIX}/lib/hdf5/plugin" \
            --enable-threadsafe \
            --enable-shared \
            --enable-build-mode=production \
            --enable-unsupported \
            --with-ssl

make -j "${CPU_COUNT}"
make check
make install

rm -rf $PREFIX/share/hdf5_examples

# We can remove this when we start using the new conda-build.
find $PREFIX -name '*.la' -delete
