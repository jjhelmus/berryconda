#!/bin/bash

export C_INCLUDE_PATH="${PREFIX}/include"

./configure \
    --disable-ldap \
    --prefix=${PREFIX} \
    --with-ca-bundle=${PREFIX}/ssl/cacert.pem \
    --with-ssl=${PREFIX} \
    --with-zlib=${PREFIX} \
|| cat config.log

make
make test
make install

# Includes man pages and other miscellaneous.
rm -rf "${PREFIX}/share"
