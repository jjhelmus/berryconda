#!/bin/bash

export BZIP2_DIR=$PREFIX
export HDF5_DIR=$PREFIX
export LZO_DIR=$PREFIX

$PYTHON -m pip install --no-deps --ignore-installed .
