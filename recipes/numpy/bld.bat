%PYTHON% -m pip install --no-deps --ignore-installed .
if errorlevel 1 exit 1

XCOPY %RECIPE_DIR%\f2py.bat %SCRIPTS% /s /e
if errorlevel 1 exit 1

del %SCRIPTS%\f2py.exe
if errorlevel 1 exit 1
