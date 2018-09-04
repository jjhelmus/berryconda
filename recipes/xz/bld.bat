@echo on
if "%ARCH%" == "64" (
   set ARCH=x64
) else (
   set ARCH=Win32
)

:: The vc9 build uses a patch that added CMake support from a fork.
:: We do not want to use it for vc14 since upstream provide a sln.

:: Let us not bother with the bundled VS solution files since they
:: do not build the CLI programs.
:: if "%vc%" == "9" goto vc9_build
:: goto vc14_build

:vc9_build
if "%vc%" NEQ "9" goto skip_c99_wrapper
set COMPILER=-DCMAKE_C_COMPILER=c99-to-c89-cmake-nmake-wrap.bat
set C99_TO_C89_WRAP_DEBUG_LEVEL=1
set C99_TO_C89_WRAP_SAVE_TEMPS=1
set C99_TO_C89_WRAP_NO_LINE_DIRECTIVES=1
set C99_TO_C89_CONV_DEBUG_LEVEL=1
COPY %LIBRARY_INC%\inttypes.h src\common\inttypes.h
COPY %LIBRARY_INC%\stdint.h src\common\stdint.h
:skip_c99_wrapper
cmake -G "NMake Makefiles" ^
      -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
      %COMPILER% ^
      -DCMAKE_C_USE_RESPONSE_FILE_FOR_OBJECTS:BOOL=FALSE ^
      -DCMAKE_BUILD_TYPE=Release ^
      --debug-trycompile ^
      .
nmake VERBOSE=1
if errorlevel 1 exit /b 1
nmake VERBOSE=1 install
if errorlevel 1 exit /b 1
DEL src\common\inttypes.h
DEL src\common\stdint.h
goto common_exit

:vc14_build
cd Windows
devenv /Upgrade xz_win.sln
msbuild xz_win.sln /p:Configuration="Release" /p:Platform="%ARCH%" /verbosity:normal
if errorlevel 1 exit /b 1
COPY Release\%ARCH%\liblzma_dll\liblzma.dll %LIBRARY_BIN%\
COPY Release\%ARCH%\liblzma_dll\liblzma.lib %LIBRARY_LIB%\
COPY Release\%ARCH%\liblzma\liblzma.lib %LIBRARY_LIB%\liblzma_static.lib

:common_exit
cd %SRC_DIR%
MOVE src\liblzma\api\lzma %LIBRARY_INC%\
COPY src\liblzma\api\lzma.h %LIBRARY_INC%\
exit /b 0