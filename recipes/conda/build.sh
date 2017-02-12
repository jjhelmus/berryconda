#!/bin/bash

# Remove symlinks
unlink $PREFIX/bin/conda
unlink $PREFIX/bin/activate
unlink $PREFIX/bin/deactivate

# Prep conda install
export CONDA_DEFAULT_ENV=''
echo "${PKG_VERSION}" > conda/.version

# Install the Python code
$PYTHON conda.recipe/setup.py install

# Install the fish activation script.
mkdir -p $PREFIX/etc/fish/conf.d/
cp $SRC_DIR/shell/conda.fish $PREFIX/etc/fish/conf.d/

# Link everything in `exec`.
mkdir -p $PREFIX/exec
ln -s $PREFIX/bin/activate $PREFIX/exec/activate
ln -s $PREFIX/bin/deactivate $PREFIX/exec/deactivate
ln -s $PREFIX/bin/conda $PREFIX/exec/conda
