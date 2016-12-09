#!/bin/bash

rm -rf src/decorator.egg-info
$PYTHON setup.py install --old-and-unmanageable
