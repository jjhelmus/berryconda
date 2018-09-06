#!/bin/bash
PERL=${BUILD_PREFIX}/bin/perl
# Configure OpenSSL manually to prevent it from building for armv7-a
# "./config -t" can be used to see the automatically determine configuration
./Configure linux-armv4 shared --prefix=${PREFIX} -march=armv6 -mfpu=vfp -mfloat-abi=hard -Wa,--noexecstack
make -j$CPU_COUNT
make test
make install
