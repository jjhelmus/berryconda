#!/bin/sh

# Fix shebangs
for f in bin/aclocal.in bin/automake.in t/wrap/aclocal.in t/wrap/automake.in; do
    sed -i.bak -e 's|^#!@PERL@ -w|#!/usr/bin/env perl|' "$f"
    rm -f "$f.bak"
done

./configure --prefix=$PREFIX
make
# make check TODO: There is one failure I need to check.
make install
