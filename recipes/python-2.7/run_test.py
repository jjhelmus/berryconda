# make sure Grammar pickle files are present
import os
from os.path import dirname, isfile, join
for fn in ('Grammar2.7.14.final.0.pickle',
           'PatternGrammar2.7.14.final.0.pickle'):
    assert isfile(join(dirname(os.__file__), 'lib2to3', fn))

import platform
import sys
import subprocess
from pprint import pprint

# it is important to run the test for the 2to3 command *after* the existance
# of the Grammar pickle files has been checked (because running 2to3) will
# create them
subprocess.check_call([join(sys.prefix,
      'Scripts/2to3.exe' if sys.platform == 'win32' else 'bin/2to3'), '-h'])

armv6l = bool(platform.machine() == 'armv6l')
armv7l = bool(platform.machine() == 'armv7l')
ppc64le = bool(platform.machine() == 'ppc64le')
debug = int(os.getenv('DEBUG', 0))

print('Python version:', platform.python_version())
assert platform.python_version() == '2.7.14'
assert sys.version_info[:3] == (2, 7, 14)
if sys.platform == 'win32':
    assert 'MSC v.1500' in sys.version
print('max unicode:', sys.maxunicode)
print('architecture:', platform.architecture())
print('sys.version:', sys.version)
print('platform.machine():', platform.machine())
print('DEBUG:', debug)

assert hasattr(sys, 'gettotalrefcount') == bool(debug)
if debug:
    print('sys.gettotalrefcount:', sys.gettotalrefcount())

import _bisect
import _codecs_cn
import _codecs_hk
import _codecs_iso2022
import _codecs_jp
import _codecs_kr
import _codecs_tw
import _collections
import _csv
import _ctypes
import _ctypes_test
import _elementtree
import _functools
import _hashlib
import _heapq
import _hotshot
import _io
import _json
import _locale
import _lsprof
import _multibytecodec
import _multiprocessing
import _random
import _socket
import _sqlite3
import _ssl
import _struct
import _testcapi
import array
import audioop
import binascii
import bz2
import cPickle
import cStringIO
import cmath
import datetime
import future_builtins
import itertools
import math
import mmap
import operator
import parser
import pyexpat
import select
import ssl
import strop
import time
import unicodedata
import zlib
import gzip
from os import urandom

a = 20 * 'Ilan'
b = 'x\x9c\xf3\xccI\xcc\xf3\xa4"\x06\x00\xc8L\x1eQ'
assert zlib.compress(a) == b
assert zlib.decompress(b) == a
with gzip.open('x.gz', 'wb') as fo:
    fo.write(a)
with open('x.gz', 'rb') as fi:
    assert len(fi.read()) == 29

if sys.platform != 'win32':
    if not ppc64le:
        import _curses
        import _curses_panel
    import crypt
    import fcntl
    import grp
    import nis
    import readline
    import resource
    import syslog
    import termios

    from distutils import sysconfig
    for var_name in 'LDSHARED', 'CC':
        value = sysconfig.get_config_var(var_name)
        assert value.split()[0] == 'gcc', value
    value = sysconfig.get_config_var('CXX')
    assert value.split()[0] == 'g++', value
    readline.clear_history()

if not ppc64le:
    import _tkinter
    import Tkinter
    import turtle
    print('TK_VERSION:', _tkinter.TK_VERSION)
    print('TCL_VERSION:', _tkinter.TCL_VERSION)
    TCLTK_VER = '8.6' if (sys.platform == 'win32' or armv6l or armv7l) else '8.5'
    assert _tkinter.TK_VERSION == _tkinter.TCL_VERSION == TCLTK_VER

print('OPENSSL_VERSION:', ssl.OPENSSL_VERSION)
if sys.platform != 'win32':
    assert '1.0.2l' in ssl.OPENSSL_VERSION

pprint(platform._sys_version())
# This is in the anaconda-recipes test file but is not working...
#sys.version = ('2.7.6 (#1, Jan  9 2013, 06:47:03)\n'
#               '[GCC 4.1.2 20080704 (Red Hat 4.1.2-54)] on linux2')
#pprint(platform._sys_version())

if int(os.getenv('GUI_TEST', 0)):
    turtle.forward(100)
