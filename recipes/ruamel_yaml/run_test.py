import os
import ruamel_yaml
try:
    import pytest
except ImportError:
    pytest = None

if pytest:
    print('ruamel_yaml.__version__: %s' % ruamel_yaml.__version__)

# version_info is used in the package
# check that it exists and matches __version__
from ruamel_yaml import version_info
ver_string = '.'.join([str(i) for i in version_info])
print(ver_string)
assert ver_string == ruamel_yaml.__version__