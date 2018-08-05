@echo off

:: Install kernelspec at post-link because conda doesn't substitute Windows paths correctly in JSON files
"%PREFIX%"\Python.exe -m ipykernel install --sys-prefix > NUL 2>&1 && if errorlevel 1 exit 1
