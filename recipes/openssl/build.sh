#!/bin/bash

./config shared --prefix=$PREFIX
make -j4
make test
make install
