#!/bin/bash

./configure --prefix=$PREFIX
make -j2
make check
make install
