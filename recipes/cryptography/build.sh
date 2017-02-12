#!/bin/bash

export CFLAGS="-I${PREFIX}/include"

$PYTHON setup.py install --single-version-externally-managed --record=record.txt

rm $PREFIX/bin/easy_install-*
