#!/bin/bash

$PYTHON -m pip install . --no-deps --ignore-installed --no-cache-dir -vvv

rm -rf $PREFIX/man
rm -rf $SP_DIR/man
rm -rf $SP_DIR/nose-*.egg/man
rm -f $PREFIX/bin/nosetests-*
