#!/bin/bash

export LIBRARY_SEARCH_VAR=LD_LIBRARY_PATH

#./autogen.sh
./configure \
	    --prefix="${PREFIX}" \
	    --with-libsodium="${PREFIX}" \
	    --without-documentation
make -j ${CPU_COUNT}
#eval ${LIBRARY_SEARCH_VAR}="${PREFIX}/lib" make check
make install
