#!/bin/bash

./configure $B --prefix=$PREFIX CFLAGS=-fPIC
make
make install

rm -rf $PREFIX/share
