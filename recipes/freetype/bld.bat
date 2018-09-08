set CXXFLAGS=
set CFLAGS=

mkdir build
cd build

:: Configure.
cmake -G"%CMAKE_GENERATOR%" ^
      -DCMAKE_INSTALL_PREFIX:PATH="%LIBRARY_PREFIX:/=\\%" ^
      -DCMAKE_BUILD_TYPE=Release ^
      -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%:/=\\" ^
      -DCMAKE_SYSTEM_PREFIX_PATH="%LIBRARY_PREFIX:/=\\%" ^
      -DBUILD_SHARED_LIBS:BOOL=true ^
      -DFT_WITH_BZIP2=False ^
      -DFT_WITH_HARFBUZZ=False ^
      -DCMAKE_DISABLE_FIND_PACKAGE_BZip2=True ^
      -DCMAKE_DISABLE_FIND_PACKAGE_HarfBuzz=True ^
      -DFT_WITH_ZLIB=True ^
      -DFT_WITH_PNG=True ^
      "%SRC_DIR:/=\\%"
if errorlevel 1 exit 1

:: Build.
cmake --build . --config Release
if errorlevel 1 exit 1

:: Test.
ctest -C Release
if errorlevel 1 exit 1

:: Install.
cmake --build . --config Release --target install
if errorlevel 1 exit 1

:: Move everything 1-level down.
move %LIBRARY_INC%\freetype2\freetype %LIBRARY_INC% || exit 1
move %LIBRARY_INC%\freetype2\ft2build.h %LIBRARY_INC% || exit 1
