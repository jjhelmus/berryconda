%PYTHON% setup.py install --single-version-externally-managed --record record.txt
if errorlevel 1 exit 1

cd %SCRIPTS%
del *.exe
del *.exe.manifest
del pip2*
del pip3*
:: del %SP_DIR%\__pycache__\pkg_res*
