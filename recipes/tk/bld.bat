if "%ARCH%"=="32" (
   set MACHINE="IX86"
) else (
  set MACHINE="AMD64"
)

curl -L -o tcl%PKG_VERSION%.tar.gz "ftp://ftp.tcl.tk/pub/tcl/tcl8_6/tcl%PKG_VERSION%-src.tar.gz"
curl -L -o tk%PKG_VERSION%.tar.gz "ftp://ftp.tcl.tk/pub/tcl/tcl8_6/tk%PKG_VERSION%-src.tar.gz"

7za x -so tcl%PKG_VERSION%.tar.gz | 7za x -si -aoa -ttar
7za x -so tk%PKG_VERSION%.tar.gz | 7za x -si -aoa -ttar

cd tcl%PKG_VERSION%\win
nmake -f makefile.vc INSTALLDIR=%LIBRARY_PREFIX% MACHINE=%MACHINE% release
nmake -f makefile.vc INSTALLDIR=%LIBRARY_PREFIX% MACHINE=%MACHINE% install
if %ERRORLEVEL% GTR 0 exit 1

REM Required for having tmschema.h accessible.  Newer VS versions do not include this.
REM If you don't have this path, you are missing the Windows 7 SDK.  Please install this.
REM   NOTE: Later SDKs remove tmschema.h.  It really is necessary to use the Win 7 SDK.
set INCLUDE=%INCLUDE%;c:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\Include

:: Tk build

cd ..\..\tk%PKG_VERSION%\win
nmake -f makefile.vc INSTALLDIR=%LIBRARY_PREFIX% MACHINE=%MACHINE% TCLDIR=..\..\tcl%PKG_VERSION% release
nmake -f makefile.vc INSTALLDIR=%LIBRARY_PREFIX% MACHINE=%MACHINE% TCLDIR=..\..\tcl%PKG_VERSION% install
if %ERRORLEVEL% GTR 0 exit 1

:: Make sure that `wish` can be called without the version info.
copy %LIBRARY_PREFIX%\bin\wish86t.exe %LIBRARY_PREFIX%\bin\wish.exe
copy %LIBRARY_PREFIX%\bin\tclsh86t.exe %LIBRARY_PREFIX%\bin\tclsh.exe

:: No `t` version of wish86.exe
copy %LIBRARY_PREFIX%\bin\wish86t.exe %LIBRARY_PREFIX%\bin\wish86.exe
copy %LIBRARY_PREFIX%\bin\tclsh86t.exe %LIBRARY_PREFIX%\bin\tclsh86.exe

