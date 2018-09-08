#!/bin/bash

./configure --prefix=$PREFIX \
            --build=${BUILD}\
            --host=${HOST} \
            --enable-shared=yes \
            --enable-static=yes

make -j${CPU_COUNT} ${VERBOSE_AT}
make check
make install

# We can remove this when we start using the new conda-build.
find $PREFIX -name '*.la' -delete
