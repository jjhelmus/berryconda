#!/bin/bash

./configure --prefix=${PREFIX}  \
            --host=${HOST}      \
            --build=${BUILD}
make -j${CPU_COUNT} ${VERBOSE_AT}
make tests
make install
