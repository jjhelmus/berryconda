import netCDF4

# OPeNDAP.
url = 'http://geoport-dev.whoi.edu/thredds/dodsC/estofs/atlantic'
nc = netCDF4.Dataset(url)

# Compiled with cython.
assert nc.filepath() == url
