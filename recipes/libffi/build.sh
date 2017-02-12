#!/usr/bin/env bash

if [[ $(uname) == "Linux" ]]; then
  # this changes the install dir from ${PREFIX}/lib64 to ${PREFIX}/lib
  sed -i 's:@toolexeclibdir@:$(libdir):g' Makefile.in */Makefile.in
  sed -i 's:@toolexeclibdir@:${libdir}:g' libffi.pc.in
fi

./configure --disable-debug --disable-dependency-tracking \
            --prefix="${PREFIX}" --includedir="${PREFIX}/include" \
  || { cat config.log; exit 1;}

make
make check
make install
