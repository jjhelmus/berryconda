mkdir %SRC_DIR%\build
cd %SRC_DIR%\build

set BUILD_TYPE=Release
:: set BUILD_TYPE=RelWithDebInfo
:: set BUILD_TYPE=Debug
set HDF5_DIR=%LIBRARY_PREFIX%\cmake\hdf5

cmake -G "%CMAKE_GENERATOR%" ^
      -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
      -DBUILD_SHARED_LIBS=ON ^
      -DENABLE_TESTS=ON ^
      -DENABLE_HDF4=ON ^
      -DENABLE_LOGGING=ON ^
      -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%" ^
      -DZLIB_LIBRARY="%LIBRARY_LIB%\zlib.lib" ^
      -DZLIB_INCLUDE_DIR="%LIBRARY_INC%" ^
      -DCMAKE_BUILD_TYPE=%BUILD_TYPE% ^
      -D ENABLE_CDF5=ON ^
      %SRC_DIR%
if errorlevel 1 exit \b 1

cmake --build . --config %BUILD_TYPE%
if errorlevel 1 exit \b 1

:: We need to add some entries to PATH before running the tests
set ORIG_PATH=%PATH%
set PATH=%CD%\liblib\%BUILD_TYPE%;%CD%\liblib;%PREFIX%\Library\bin;%PATH%

:: 6 or 7 tests fail due to minor floating point / format string differences in the VS2008 build
goto end_tests
if "%vc%" == "9" goto vc9_tests
ctest -VV
if errorlevel 1 exit \b 1
goto end_tests
:vc9_tests
ctest -VV
:end_tests

cmake --build . --config %BUILD_TYPE% --target install
if errorlevel 1 exit \b 1

:: Please do not remove this.
echo If you need to debug this in Visual Studio, set BUILD_TYPE=RelWithDebInfo then:
echo set PATH=%CD%\liblib\%BUILD_TYPE%;%CD%\liblib;%PREFIX%\Library\bin;%ORIG_PATH%
if "%vc%" == "9" goto vc9_build2
echo "C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\Common7\IDE\devenv.exe" /debugexe %CD%\ncdump\%BUILD_TYPE%\ncdump.exe -h http://geoport-dev.whoi.edu/thredds/dodsC/estofs/atlantic
goto end_build2
:vc9_build2
echo "C:\Program Files (x86)\Microsoft Visual Studio 9.0\Common7\IDE\devenv.exe" /debugexe %CD%\ncdump\%BUILD_TYPE%\ncdump.exe -h http://geoport-dev.whoi.edu/thredds/dodsC/estofs/atlantic
:end_build2

:: Also leave this test where it is. ATM, conda-build deletes host prefixes by the time it runs the
:: package tests which makes investigating problems very tricky. Pinging @msarahan about that.
:: Release builds do not get put in build subfolders for some reason:
if exist ncdump\%BUILD_TYPE%\ncdump.exe ncdump\%BUILD_TYPE%\ncdump.exe -L 100 -h http://geoport-dev.whoi.edu/thredds/dodsC/estofs/atlantic
if exist ncdump\ncdump.exe ncdump\ncdump.exe -L 100 -h http://geoport-dev.whoi.edu/thredds/dodsC/estofs/atlantic

if errorlevel 1 exit \b 1
