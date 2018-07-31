#!/bin/bash

# Prep conda install
echo "${PKG_VERSION}" > conda/.version

# Install conda using bash function
. utils/functions.sh && install_conda_full
