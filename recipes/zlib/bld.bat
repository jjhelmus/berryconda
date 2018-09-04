set LIB=%LIBRARY_LIB%;%LIB%
set LIBPATH=%LIBRARY_LIB%;%LIBPATH%
set INCLUDE=%LIBRARY_INC%;%INCLUDE%;%RECIPE_DIR%

:: Configure.
cmake -G "NMake Makefiles" ^
      -D CMAKE_BUILD_TYPE=Release ^
      -D CMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
      -D CMAKE_INSTALL_PREFIX:PATH=%LIBRARY_PREFIX% ^
      %SRC_DIR%
if errorlevel 1 exit 1

:: Build.
cmake --build %SRC_DIR% --target INSTALL --config Release
if errorlevel 1 exit 1

:: Test.
ctest
if errorlevel 1 exit 1

:: Some OSS libraries are happier if z.lib exists, even though it's not typical on Windows.
copy %LIBRARY_LIB%\zlib.lib %LIBRARY_LIB%\z.lib || exit 1

:: Qt in particular goes looking for this one (as of 4.8.7).
copy %LIBRARY_LIB%\zlib.lib %LIBRARY_LIB%\zdll.lib || exit 1

:: Copy license file to the source directory so conda-build can find it.
copy %RECIPE_DIR%\license.txt %SRC_DIR%\license.txt || exit 1
