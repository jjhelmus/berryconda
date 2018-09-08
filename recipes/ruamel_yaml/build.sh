#!/bin/bash

bash $RECIPE_DIR/prepare.bash
$PYTHON -m pip install . --no-deps --ignore-installed --no-cache-dir -vvv
