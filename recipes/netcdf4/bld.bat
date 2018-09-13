set SITECFG=%SRC_DIR%/setup.cfg

echo [options] > %SITECFG%
echo use_cython=True >> %SITECFG%
echo [directories] >> %SITECFG%
echo HDF5_libdir = %LIBRARY_LIB% >> %SITECFG%
echo HDF5_incdir = %LIBRARY_INC% >> %SITECFG%
echo netCDF4_libdir = %LIBRARY_LIB% >> %SITECFG%
echo netCDF4_incdir = %LIBRARY_INC% >> %SITECFG%

"%PYTHON%" -m pip install --no-deps --ignore-installed .
if errorlevel 1 exit 1
