#!/bin/bash

python ${RECIPE_DIR}/brand_python.py

# Remove test data and ensurepip stubs to save space
rm -rf Lib/test Lib/*/test
rm -rf Lib/ensurepip

./configure --enable-shared --enable-ipv6 --with-ensurepip=no \
    --prefix=$PREFIX \
    --with-tcltk-includes="-I$PREFIX/include" \
    --with-tcltk-libs="-L$PREFIX/lib -ltcl8.6 -ltk8.6" \
    CPPFLAGS="-I$PREFIX/include" \
    LDFLAGS="-L$PREFIX/lib -Wl,-rpath=$PREFIX/lib,--no-as-needed"

make -j4
make install
ln -s $PREFIX/bin/python3.5 $PREFIX/bin/python
ln -s $PREFIX/bin/pydoc3.5 $PREFIX/bin/pydoc
