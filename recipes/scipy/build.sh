#!/bin/bash

export OPENBLAS_NUM_THREADS=1
export LIBRARY_PATH="${PREFIX}/lib"
export C_INCLUDE_PATH="${PREFIX}/include"
export CPLUS_INCLUDE_PATH="${PREFIX}/include"

#DYLIB_EXT=so
unset LDFLAGS

# If OpenBLAS is being used, we should be able to find the libraries.
# As OpenBLAS now will have all symbols that BLAS or LAPACK have,
# create libraries with the standard names that are linked back to
# OpenBLAS. This will make it easy for NumPy to find it.
#test -f "${PREFIX}/lib/libopenblas.${DYLIB_EXT}" && ln -fs "${PREFIX}/lib/libopenblas.${DYLIB_EXT}" "${PREFIX}/lib/libblas.${DYLIB_EXT}"
#test -f "${PREFIX}/lib/libopenblas.${DYLIB_EXT}" && ln -fs "${PREFIX}/lib/libopenblas.${DYLIB_EXT}" "${PREFIX}/lib/liblapack.${DYLIB_EXT}"

$PYTHON setup.py install --single-version-externally-managed --record=record.txt

# Need to clean these up as we don't want them as part of the NumPy package.
# If these are part of a BLAS (e.g. ATLAS), this won't cause us any problems
# as those would have been existing packages and `conda-build` would have
# ignored packaging those files anyways.
#rm -f "${PREFIX}/lib/libblas.${DYLIB_EXT}"
#rm -f "${PREFIX}/lib/liblapack.${DYLIB_EXT}"
