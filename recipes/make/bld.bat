@echo off
setlocal EnableDelayedExpansion

call build_w32.bat gcc
if errorlevel 1 exit 1

copy .\\GccRel\\gnumake.exe  %LIBRARY_BIN%\\gnumake.exe
if errorlevel 1 exit 1

copy .\\GccRel\\gnumake.exe  %LIBRARY_BIN%\\make.exe
if errorlevel 1 exit 1
