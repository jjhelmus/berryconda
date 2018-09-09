:: Needed so we can find stdint.h from msinttypes.
set LIB=%LIBRARY_LIB%;%LIB%
set LIBPATH=%LIBRARY_LIB%;%LIBPATH%
set INCLUDE=%LIBRARY_INC%;%INCLUDE%

:: VS2008 doesn't have stdbool.h so copy in our own
:: to 'lib' where the other headers are so it gets picked up.
if "%VS_MAJOR%" == "9" (
    copy %RECIPE_DIR%\stdbool.h lib\
    copy %LIBRARY_INC%\stdint.h lib\
)

:: set cflags because NDEBUG is set in Release configuration, which errors out in test suite due to no assert
cmake -G "%CMAKE_GENERATOR%" ^
      -D CMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
      -D CMAKE_C_FLAGS_RELEASE="%CFLAGS%" ^
      -D CMAKE_CXX_FLAGS_RELEASE="%CXXFLAGS%" ^
      %SRC_DIR%

:: Build.
cmake --build . --config Release
if errorlevel 1 exit 1

:: Install.
cmake --build . --config Release --target install
if errorlevel 1 exit 1

:: Test.
ctest -C Release
if errorlevel 1 exit 1
