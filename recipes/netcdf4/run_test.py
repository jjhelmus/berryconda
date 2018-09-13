import netCDF4

# OPeNDAP.
url = 'http://geoport-dev.whoi.edu/thredds/dodsC/estofs/atlantic'
with netCDF4.Dataset(url) as nc:
    # Compiled with cython.
    assert nc.filepath() == url


url = 'http://geoport.whoi.edu/thredds/dodsC/usgs/vault0/models/tides/vdatum_gulf_of_maine/adcirc54_38_orig.nc'

with netCDF4.Dataset(url) as nc:
    nc['tidenames'][:]
