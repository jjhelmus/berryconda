mkdir build-%SUBDIR%-%c_compiler%
cd build-%SUBDIR%-%c_compiler%

:: Configure.
cmake -G "%CMAKE_GENERATOR%"                    ^
      -D CMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX%  ^
      -D ZLIB_LIBRARY=%LIBRARY_LIB%\zlib.lib    ^
      -D ZLIB_INCLUDE_DIR=%LIBRARY_INC%         ^
      -DCMAKE_C_FLAGS="%CFLAGS% -DWIN32"        ^
      %SRC_DIR%
if errorlevel 1 exit /b 1

cmake --build . --target install --config Release
if errorlevel 1 exit /b 1

:: Test.
ctest -C Release
if errorlevel 1 exit 1

:: Make copies of the .lib files without the embedded version number.
copy %LIBRARY_LIB%\libpng16.lib %LIBRARY_LIB%\libpng.lib
if errorlevel 1 exit 1

copy %LIBRARY_LIB%\libpng16_static.lib %LIBRARY_LIB%\libpng_static.lib
if errorlevel 1 exit 1
