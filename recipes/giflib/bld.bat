cd %SRC_DIR%

set SLN_FILE=giflib.sln
set SLN_CFG=Release
if "%ARCH%"=="32" (set SLN_PLAT=x86) else (set SLN_PLAT=x64)
if "%ARCH%"=="32" (set RLS_PLAT=%SRC_DIR%\vs2015\Release) else (set RLS_PLAT=%SRC_DIR%\vs2015\%SLN_PLAT%\Release)
set PATH=%PATH%;C:\windows\Microsoft.NET\Framework\v4.0

:: wget http://www.chemformatter.com/build-with-visual-studio-2015/giflib/giflib-5.1.4-vs14.zip
appveyor DownloadFile http://www.chemformatter.com/build-with-visual-studio-2015/giflib/giflib-5.1.4-vs14.zip
7z x -o%SRC_DIR% -y giflib-5.1.4-vs14.zip vs2015
cd vs2015

:: Build step
MSBuild %SLN_FILE% /p:Configuration=Release,Platform=%SLN_PLAT%
if errorlevel 1 exit 1

copy %RLS_PLAT%\*.dll %LIBRARY_BIN%\
copy %RLS_PLAT%\*.exe %LIBRARY_BIN%\
copy %RLS_PLAT%\*.lib %LIBRARY_LIB%\
:: copy %SRC_DIR%\lib\%SLN_PLAT%\blitz.lib %LIBRARY_LIB%\