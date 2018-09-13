#!/bin/bash

# declare -a CMAKE_PLATFORM_FLAGS
# if [[ ${HOST} =~ .*darwin.* ]]; then
#   CMAKE_PLATFORM_FLAGS+=(-DCMAKE_OSX_SYSROOT="${CONDA_BUILD_SYSROOT}")
#   # We have a problem with over-stripping of dylibs in the test programs:
#   # nm ${PREFIX}/lib/libdf.dylib | grep error_top
#   #   000000000006197c S _error_top
#   # Then, despite this being linked to explicitly when creating the test programs:
#   # ./hdf4_test_tst_chunk_hdf4
#   # dyld: Symbol not found: _error_top
#   #   Referenced from: ${PREFIX}/lib/libmfhdf.0.dylib
#   #   Expected in: flat namespace
#   #  in ${PREFIX}/lib/libmfhdf.0.dylib
#   # Abort trap: 56
#   # Now clearly libmfhdf should autoload libdf but it does not and that is not going to change:
#   # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=556439
#   # .. so we must remove our unused stripping instead :-(
#   # (it may be possible to arrange this symbol to be in the 'D'ata section instead of 'S'
#   #  (symbol in a section other than those above according to man nm), instead though
#   #  or to fix ld64 so that it checks for symbols being used in this section).
#   export LDFLAGS=$(echo "${LDFLAGS}" | sed "s/-Wl,-dead_strip_dylibs//g")
# else
#   CMAKE_PLATFORM_FLAGS+=(-DCMAKE_TOOLCHAIN_FILE="${RECIPE_DIR}/cross-linux.cmake")
# fi

if [[ ${DEBUG_C} == yes ]]; then
  CMAKE_BUILD_TYPE=Debug
else
  CMAKE_BUILD_TYPE=Release
fi

# Build static.
cmake -DCMAKE_INSTALL_PREFIX=${PREFIX} \
      -DCMAKE_INSTALL_LIBDIR:PATH=${PREFIX}/lib \
      -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} \
      -DENABLE_DAP=ON \
      -DENABLE_HDF4=ON \
      -DENABLE_NETCDF_4=ON \
      -DBUILD_SHARED_LIBS=OFF \
      -DENABLE_TESTS=ON \
      -DBUILD_UTILITIES=ON \
      -DENABLE_DOXYGEN=OFF \
      -DENABLE_LOGGING=ON \
      -DCMAKE_C_FLAGS_RELEASE=${CFLAGS} \
      -DCMAKE_C_FLAGS_DEBUG=${CFLAGS} \
      -DCURL_INCLUDE_DIR=${PREFIX}/include \
      -DCURL_LIBRARY=${PREFIX}/lib/libcurl${SHLIB_EXT} \
      -DENABLE_CDF5=ON \
      ${CMAKE_PLATFORM_FLAGS[@]} \
      ${SRC_DIR}
make -j${CPU_COUNT} ${VERBOSE_CM}
# ctest  # Run only for the shared lib build to save time.
make install -j${CPU_COUNT}
make clean

# Build shared.
cmake -DCMAKE_INSTALL_PREFIX=${PREFIX} \
      -DCMAKE_INSTALL_LIBDIR:PATH=${PREFIX}/lib \
      -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} \
      -DENABLE_DAP=ON \
      -DENABLE_HDF4=ON \
      -DENABLE_NETCDF_4=ON \
      -DBUILD_SHARED_LIBS=ON \
      -DENABLE_TESTS=ON \
      -DBUILD_UTILITIES=ON \
      -DENABLE_DOXYGEN=OFF \
      -DENABLE_LOGGING=ON \
      -DCMAKE_C_FLAGS_RELEASE=${CFLAGS} \
      -DCMAKE_C_FLAGS_DEBUG=${CFLAGS} \
      -DCURL_INCLUDE_DIR=${PREFIX}/include \
      -DCURL_LIBRARY=${PREFIX}/lib/libcurl${SHLIB_EXT} \
      -DENABLE_CDF5=ON \
      ${CMAKE_PLATFORM_FLAGS[@]} \
      ${SRC_DIR}
make -j${CPU_COUNT} ${VERBOSE_CM}
make install -j${CPU_COUNT}
ctest -VV

# Leave this test where it is. ATM, conda-build deletes host prefixes by the time it runs the
# package tests which makes investigating problems very tricky. Pinging @msarahan about that.
ncdump/ncdump -h http://geoport-dev.whoi.edu/thredds/dodsC/estofs/atlantic || exit $?
