#!/bin/bash

# Update package database
pacman -Syu --noconfirm

# Install development tools
pacman -S --needed --noconfirm \
  mingw-w64-x86_64-toolchain \
  mingw-w64-x86_64-cmake \
  make

# Install SDL2 and related libraries
pacman -S --needed --noconfirm \
  mingw-w64-x86_64-SDL2 \
  mingw-w64-x86_64-SDL2_image \
  mingw-w64-x86_64-SDL2_mixer \
  mingw-w64-x86_64-SDL2_ttf \
  mingw-w64-x86_64-SDL2_net

# Install additional dependencies
pacman -S --needed --noconfirm \
  mingw-w64-x86_64-libpng \
  mingw-w64-x86_64-cairo \
  mingw-w64-x86_64-librsvg \
  mingw-w64-x86_64-libxml2 