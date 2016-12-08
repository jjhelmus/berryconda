#!/bin/bash

make -f Makefile-libbz2_so
make install PREFIX=$PREFIX

rm -rf $PREFIX/bin $PREFIX/man
