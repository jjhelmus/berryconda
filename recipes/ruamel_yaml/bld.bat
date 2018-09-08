set INCLUDE=%LIBRARY_INC%;%INCLUDE%
set LIBPATH=%LIBRARY_LIB%;%LIBPATH%
set LIB=%LIBRARY_LIB%;%LIB%

FOR /F "delims=" %%i IN ('cygpath.exe -u %SRC_DIR%') DO set "SRC_DIRU=%%i"
FOR /F "delims=" %%i IN ('cygpath.exe -u %RECIPE_DIR%') DO set "RECIPE_DIRU=%%i"

bash %RECIPE_DIR%\prepare.bash %RECIPE_DIRU% %SRC_DIRU%
if errorlevel 1 exit 1

%PYTHON% -m pip install . --no-deps --ignore-installed --no-cache-dir -vvv
if errorlevel 1 exit 1

copy %LIBRARY_BIN%\yaml.dll %SP_DIR%\ruamel_yaml\ext\
if errorlevel 1 exit 1

rd /s /q %SP_DIR%\__pycache__
if errorlevel 1 echo nvd
