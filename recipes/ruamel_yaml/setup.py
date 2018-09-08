# -*- coding: utf-8 -*-
from __future__ import absolute_import, division, print_function
from distutils.core import setup, Extension
import os
import sys

from Cython.Build import cythonize

# When executing the setup.py, we need to be able to import ourselves, this
# means that we need to add the src directory to the sys.path.
here = os.path.abspath(os.path.dirname(__file__))
src_dir = os.path.join(here, "ruamel_yaml")
sys.path.insert(0, src_dir)
import ruamel_yaml  # NOQA


SP_DIR = os.getenv('SP_DIR', '.')
PREFIX = os.getenv('PREFIX', '.')
library_dirs = [os.path.join(SP_DIR, 'ruamel_yaml/ext'), os.path.join(PREFIX, 'lib')]
extensions = [Extension("ruamel_yaml.ext._ruamel_yaml",
                        ['ruamel_yaml/ext/_ruamel_yaml.pyx'],
                        libraries=['yaml'],
                        library_dirs=library_dirs,
                        include_dirs=[os.path.join(PREFIX, 'include')],
                        runtime_library_dirs=[] if sys.platform == 'win32' else library_dirs)]

setup(
    name=ruamel_yaml.__name__,
    version=ruamel_yaml.__version__,
    author=ruamel_yaml.__author__,
    author_email=ruamel_yaml.__author_email__,
    description=ruamel_yaml.__description__,
    ext_modules=cythonize(extensions),
    classifiers=[
        "Programming Language :: Python :: 2.6",
        "Programming Language :: Python :: 2.7",
        "Programming Language :: Python :: 3.3",
        "Programming Language :: Python :: 3.4",
        "Programming Language :: Python :: 3.5",
        "Programming Language :: Python :: Implementation :: CPython",
        "Programming Language :: Python :: Implementation :: PyPy",
        "Programming Language :: Python :: Implementation :: Jython",
        "Topic :: Software Development :: Libraries :: Python Modules",
        "Topic :: Text Processing :: Markup"
    ],
    packages=[
        'ruamel_yaml',
        'ruamel_yaml.ext',
    ],
    zip_safe=False,
)
