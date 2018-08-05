copy %RECIPE_DIR%\setup.py %SRC_DIR% || exit 1

%PYTHON% setup.py install
if errorlevel 1 exit 1
