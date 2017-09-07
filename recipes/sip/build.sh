#!/bin/bash

python configure.py --sysroot=$PREFIX

make
make install
