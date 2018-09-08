#!/bin/bash
set -euo pipefail

if [[ `uname` == Darwin ]]; then
  export LDFLAGS="-Wl,-rpath,$PREFIX/lib $LDFLAGS"
fi


if [[ `uname` == Darwin ]]; then
./autogen.sh
fi

./configure --prefix="$PREFIX" --with-libsodium
make -j${CPU_COUNT}
make check
make install

# Generate CMake files, so downstream packages can use `find_package(ZeroMQ)`,
# which is normally only available when libzmq is itself installed with CMake

CMAKE_DIR="$PREFIX/lib/cmake/ZeroMQ"
mkdir -p "$CMAKE_DIR"

cat << EOF > "$CMAKE_DIR/ZeroMQConfig.cmake"
set(PN ZeroMQ)
set(_CONDA_PREFIX "$PREFIX")
set(\${PN}_INCLUDE_DIR "\${_CONDA_PREFIX}/include")
set(\${PN}_LIBRARY "\${_CONDA_PREFIX}/lib/libzmq${SHLIB_EXT}")
set(\${PN}_STATIC_LIBRARY "\${_CONDA_PREFIX}/lib/libzmq.a")
unset(_CONDA_PREFIX)

set(\${PN}_FOUND TRUE)

# add libzmq-4.2.3 cmake targets

# only define targets once
# this file can be loaded multiple times
if (TARGET libzmq)
  return()
endif()

add_library(libzmq SHARED IMPORTED)
set_property(TARGET libzmq PROPERTY INTERFACE_INCLUDE_DIRECTORIES "\${\${PN}_INCLUDE_DIR}")
set_property(TARGET libzmq PROPERTY IMPORTED_LOCATION "\${\${PN}_LIBRARY}")

add_library(libzmq-static STATIC IMPORTED "\${\${PN}_INCLUDE_DIR}")
set_property(TARGET libzmq-static PROPERTY INTERFACE_INCLUDE_DIRECTORIES "\${\${PN}_INCLUDE_DIR}")
set_property(TARGET libzmq-static PROPERTY IMPORTED_LOCATION "\${\${PN}_STATIC_LIBRARY}")

EOF

cat << EOF > "$CMAKE_DIR/ZeroMQConfigVersion.cmake"
set(PACKAGE_VERSION "$PKG_VERSION")

# Check whether the requested PACKAGE_FIND_VERSION is compatible
if("\${PACKAGE_VERSION}" VERSION_LESS "\${PACKAGE_FIND_VERSION}")
  set(PACKAGE_VERSION_COMPATIBLE FALSE)
else()
  set(PACKAGE_VERSION_COMPATIBLE TRUE)
  if ("\${PACKAGE_VERSION}" VERSION_EQUAL "\${PACKAGE_FIND_VERSION}")
    set(PACKAGE_VERSION_EXACT TRUE)
  endif()
endif()
EOF

