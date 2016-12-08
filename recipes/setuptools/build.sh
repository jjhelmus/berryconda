#!/bin/bash

export SETUPTOOLS_DISABLE_VERSIONED_EASY_INSTALL_SCRIPT=0
export DISTRIBUTE_DISABLE_VERSIONED_EASY_INSTALL_SCRIPT=0

$PYTHON bootstrap.py
$PYTHON setup.py install --single-version-externally-managed --record=record.txt
