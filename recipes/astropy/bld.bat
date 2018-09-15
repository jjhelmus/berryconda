if "%ARCH%"=="64" (
    call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x86_amd64
)

%PYTHON% setup.py install --offline --old-and-unmanageable
if errorlevel 1 exit 1

if "%PY3K%"=="1" (
    rd /s /q %SP_DIR%\numpy
)
