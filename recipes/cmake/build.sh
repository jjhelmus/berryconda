#!/bin/sh
set -ex

# Filter out -I${PREFIX}/include from CXXFLAGS as it causes issues with bad header
# *and* macro name hygiene around libuv (queue.h / QUEUE etc, urgh).
re="(.*[[:space:]])\-I${PREFIX}/include[^[:space:]]*(.*)"
if [[ "${CXXFLAGS}" =~ $re ]]; then
  export CXXFLAGS="${BASH_REMATCH[1]}${BASH_REMATCH[2]}"
fi
if [[ "${CFLAGS}" =~ $re ]]; then
  export CFLAGS="${BASH_REMATCH[1]}${BASH_REMATCH[2]}"
fi

./bootstrap \
             --verbose \
             --prefix="${PREFIX}" \
             --system-libs \
             --no-qt-gui \
             --no-system-libuv \
             --no-system-libarchive \
             --no-system-jsoncpp \
             --parallel=${CPU_COUNT} \
             -- \
             -DCMAKE_FIND_ROOT_PATH="${PREFIX}" \
             -DCMAKE_INSTALL_RPATH="${PREFIX}/lib" \
             -DCMAKE_BUILD_TYPE:STRING=Release \
             -DCURSES_INCLUDE_PATH="${PREFIX}/include" \
             -DBUILD_CursesDialog=ON
make install -j${CPU_COUNT}
