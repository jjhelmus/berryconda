set DISTUTILS_USE_SDK=1

set ZMQ=%LIBRARY_PREFIX%

"%PYTHON%" -m pip install . "--install-option=--zmq=%ZMQ%"
if errorlevel 1 exit 1
