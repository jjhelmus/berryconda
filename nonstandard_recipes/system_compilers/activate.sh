#!/bin/bash

export CC=gcc
export CXX=g++

export CFLAGS="${CFLAGS} -fPIC"
export CXXFLAGS="${CXXFLAGS} -fPIC"
export CPPFLAGS="${CPPFLAGS} -I${PREFIX}/include"

export LDFLAGS="${LDFLAGS} -Wl,-rpath,$PREFIX/lib -L${PREFIX}/lib"
export LINKFLAGS="${LDFLAGS}"
