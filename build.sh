#!/bin/bash

# Set up environment
export PATH="/mingw64/bin:/usr/bin:$PATH"
export CMAKE_PREFIX_PATH="/mingw64:/mingw64/x86_64-w64-mingw32"

# Remove existing build directory
rm -rf build

# Create build directory and enter it
mkdir build
cd build

# Configure with CMake
cmake .. \
    -G "MinGW Makefiles" \
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
    -DCMAKE_BUILD_TYPE=Debug \
    -DSDL2IMAGE_JXL=OFF \
    -DSDL2MIXER_WAVPACK=OFF \
    -DBUILD_TESTING=ON \
    -DLINEWRAP=1 \
    -DHAVE_STDINT_H=1 \
    -DGNULIB_UNISTR_U8_MBTOUC_UNSAFE=1

# Build the project
make -j4 