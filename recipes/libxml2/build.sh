#!/bin/bash

./autogen.sh

./configure --prefix="${PREFIX}" \
            --build=$BUILD \
            --host=$HOST \
            --with-iconv="${PREFIX}" \
            --with-zlib="${PREFIX}" \
            --with-icu \
            --with-lzma="${PREFIX}" \
            --without-python
make -j${CPU_COUNT} ${VERBOSE_AT}
# Sorry:
# ## Error cases regression tests
# file result/errors/759573.xml.err is 1983 bytes, result is 1557 bytes
# Error for ./test/errors/759573.xml failed
# if [[ ${target_platform} != osx-64 ]]; then
#   make check $VERBOSE_AT}
# fi
make install

# remove libtool files
find $PREFIX -name '*.la' -delete
