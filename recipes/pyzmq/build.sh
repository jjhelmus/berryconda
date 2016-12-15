#!/bin/bash

"${PYTHON}" setup.py configure --zmq "${PREFIX}"
"${PYTHON}" setup.py install
