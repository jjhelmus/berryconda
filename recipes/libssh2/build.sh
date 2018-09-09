#!/bin/bash

# We use a repackaged cmake from elsewhere to break a build cycle.
export PATH=${PREFIX}/cmake-bin/bin:${PATH}

mkdir build && cd build

cmake -D CMAKE_INSTALL_PREFIX=$PREFIX \
      -D BUILD_SHARED_LIBS=OFF \
      -D CRYPTO_BACKEND=OpenSSL \
      -D CMAKE_INSTALL_LIBDIR=lib \
      -D ENABLE_ZLIB_COMPRESSION=ON \
      $SRC_DIR

make -j${CPU_COUNT}
# ctest  # fails on the docker image
make install

cmake -D CMAKE_INSTALL_PREFIX=$PREFIX \
      -D BUILD_SHARED_LIBS=ON \
      -D CRYPTO_BACKEND=OpenSSL \
      -D CMAKE_INSTALL_LIBDIR=lib \
      -D ENABLE_ZLIB_COMPRESSION=ON \
      -D CMAKE_INSTALL_RPATH=$PREFIX/lib \
      $SRC_DIR

make -j${CPU_COUNT}
# ctest  # fails on the docker image
make install
