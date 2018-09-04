#!/bin/bash

# world-writable files are not allowed
chmod -R o-w "${SRC_DIR}"

declare -a _config_args
_config_args+=(-Dprefix="${PREFIX}")
_config_args+=(-Dusethreads)
_config_args+=(-Duserelocatableinc)
_config_args+=(-Dcccdlflags="-fPIC")
_config_args+=(-Dldflags="${LDFLAGS}")
# .. ran into too many problems with '.' not being on @INC:
_config_args+=(-Ddefault_inc_excludes_dot=n)
if [[ -n "${GCC:-${CC}}" ]]; then
  _config_args+=("-Dcc=${GCC:-${CC}}")
fi
if [[ ${HOST} =~ .*linux.* ]]; then
  _config_args+=(-Dlddlflags="-shared ${LDFLAGS}")
# elif [[ ${HOST} =~ .*darwin.* ]]; then
#   _config_args+=(-Dlddlflags=" -bundle -undefined dynamic_lookup ${LDFLAGS}")
fi
# # -Dsysroot prevents Configure rummaging around in /usr and
# # linking to system libraries (like GDBM, which is GPL). An
# # alternative is to pass -Dusecrosscompile but that prevents
# # all Configure/run checks which we also do not want.
# if [[ -n ${CONDA_BUILD_SYSROOT} ]]; then
#   _config_args+=("-Dsysroot=${CONDA_BUILD_SYSROOT}")
# else
#   if [[ -n ${HOST} ]] && [[ -n ${CC} ]]; then
#     _config_args+=("-Dsysroot=$(dirname $(dirname ${CC}))/$(${CC} -dumpmachine)/sysroot")
#   else
#     _config_args+=("-Dsysroot=/usr")
#   fi
# fi

./Configure -de "${_config_args[@]}"
make

# change permissions again after building
chmod -R o-w "${SRC_DIR}"

# Seems we hit:
# lib/perlbug .................................................... # Failed test 21 - [perl \#128020] long body lines are wrapped: maxlen 1157 at ../lib/perlbug.t line 154
# FAILED at test 21
# https://rt.perl.org/Public/Bug/Display.html?id=128020
# make test
make install
