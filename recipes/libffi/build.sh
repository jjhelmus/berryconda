#!/usr/bin/env bash

set -e -x
shopt -s extglob

# Adopt a Unix-friendly path if we're on Windows (see bld.bat).
[ -n "$PATH_OVERRIDE" ] && export PATH="$PATH_OVERRIDE"

export CFLAGS="${CFLAGS//-fvisibility=+([! ])/}"
export CXXFLAGS="${CXXFLAGS//-fvisibility=+([! ])/}"

# Some Windows builds also need the "mixed" Library prefix $LIBRARY_PREFIX_M
# (see bld.bat), but for this package we can keep things simple:
[ -n "$LIBRARY_PREFIX_U" ] && PREFIX="$LIBRARY_PREFIX_U"

configure_args=(
    --disable-debug
    --disable-dependency-tracking
    --prefix="${PREFIX}"
    --includedir="${PREFIX}/include"
)

# Windows fun

if [[ $(uname -o) == "Msys" ]] ; then
    am_version=1.15 # keep sync'ed with meta.yaml
    export ACLOCAL=aclocal-$am_version
    export AUTOMAKE=automake-$am_version

    export CC="$(pwd)/msvcc.sh -m64"
    export CXX="$(pwd)/msvcc.sh -m64"
    export LD="link"
    export CPP="cl -nologo -EP"
    export CXXCPP="cl -nologo -EP"
    export BUILD=x86_64-unknown-cygwin
    export HOST=x86_64-unknown-cygwin
fi

configure_args+=(--build=$BUILD --host=$HOST)

autoreconf -vfi

if [[ $(uname) == "Linux" ]]; then
  # this changes the install dir from ${PREFIX}/lib64 to ${PREFIX}/lib
  sed -i 's:@toolexeclibdir@:$(libdir):g' Makefile.in */Makefile.in
  sed -i 's:@toolexeclibdir@:${libdir}:g' libffi.pc.in
fi

./configure "${configure_args[@]}" || { cat config.log; exit 1;}

if [[ $(uname -o) == "Msys" ]] ; then
    # Currently, libtool has trouble building on Windows I think because the
    # "import library" that goes with the DLL has the same filename as the
    # static library that libtool would want to generate -- libffi.lib. For
    # some reason, configuring with --disable-static doesn't avoid the error,
    # but this hack does.
    sed -i 's|test.*func_append staticlibs.*|true|' $HOST/libtool
fi

make -j${CPU_COUNT} ${VERBOSE_AT}
make check
make install

if [[ $(uname -o) == "Msys" ]] ; then
    mkdir -p $PREFIX/bin
    mv $PREFIX/lib/libffi-*.dll $PREFIX/bin
    find $PREFIX/. -name '*.la' -delete
fi

# This overlaps with libgcc-ng:
rm -rf ${PREFIX}/share/info/dir
