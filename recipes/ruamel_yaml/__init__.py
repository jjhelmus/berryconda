# coding: utf-8
from __future__ import print_function, absolute_import

__version__ = "$VERSION"
version_info = tuple(int(e) for e in __version__.split("."))
__name__ = "ruamel_yaml"
__author__ = "Anthon van der Neut"
__author_email__ ="a.van.der.neut@ruamel.eu"
__description__ = ("ruamel_yaml is a YAML parser/emitter that supports roundtrip preservation "
                   "of comments, seq/map flow style, and map key order")

try:
    from .cyaml import *                               # NOQA
    __with_libyaml__ = True
except (ImportError, ValueError):  # for Jython
    __with_libyaml__ = False


# body extracted to main.py
try:
    from .main import *                               # NOQA
except ImportError:
    from ruamel_yaml.main import *                               # NOQA
