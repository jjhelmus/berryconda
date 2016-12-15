#!/bin/bash

pushd $PREFIX/lib
ln -s libtcl8.6.so libtcl.so
ln -s libtk8.6.so libtk.so
popd

cat <<EOF > setup.cfg
[directories]
basedirlist = $PREFIX

[packages]
tests = False
toolkit_tests = False
sample_data = False

EOF

cat setup.cfg
sed -i.bak "s|/usr/local|$PREFIX|" setupext.py


$PYTHON setup.py install
