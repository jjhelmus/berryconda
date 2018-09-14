:: Need to set manifest for VS2008 otherwise exes crash (not sure why).
set MANIFEST=no
if "%VS_MAJOR%" == "9" (
    set MANIFEST=yes
)

cd win32
cscript configure.js prefix=%LIBRARY_PREFIX% include=%LIBRARY_INC% ^
        lib=%LIBRARY_LIB% sodir=%LIBRARY_BIN% iconv=yes zlib=yes vcmanifest=%MANIFEST%
if errorlevel 1 exit 1

nmake /f Makefile.msvc
if errorlevel 1 exit 1

nmake /f Makefile.msvc install
if errorlevel 1 exit 1
