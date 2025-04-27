#!/bin/bash

# Set paths
CURRENT_DIR=$(pwd)
BUILD_DIR="/mnt/c/Users/gajen/tuxmath/build_wsl"

# Define required files and directories
REQUIRED_FILES=(
    "src/t4k_common.h"
    "src/t4k_main.c"
    "src/t4k_alphasort.h"
    "src/linebreak/uniwidth/width.c"
)

REQUIRED_DIRS=(
    "src"
    "src/linebreak"
    "src/linebreak/uniwidth"
)

echo "Checking t4kcommon directory structure in: $CURRENT_DIR"

# Check required directories
for dir in "${REQUIRED_DIRS[@]}"; do
    if [ ! -d "$dir" ]; then
        echo "❌ ERROR: Required directory not found: $dir"
        exit 1
    else
        echo "✓ Found directory: $dir"
    fi
done

# Check required files
for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "❌ ERROR: Required file not found: $file"
        exit 1
    else
        echo "✓ Found file: $file"
    fi
done

# Create build directory if it doesnt exist
mkdir -p "$BUILD_DIR"

# Create symbolic links in build directory
echo "Creating symbolic links in build directory: $BUILD_DIR"
for file in "${REQUIRED_FILES[@]}"; do
    filename=$(basename "$file")
    source_file="$CURRENT_DIR/$file"
    target_file="$BUILD_DIR/$filename"
    
    if [ ! -f "$target_file" ]; then
        ln -sf "$source_file" "$target_file"
        echo "✓ Created link: $filename"
    else
        echo "ℹ Link already exists: $filename"
    fi
done

# Additional files needed for compilation
ADDITIONAL_FILES=(
    "src/t4k_audio.c"
    "src/t4k_convert_utf.c"
    "src/t4k_linewrap.c"
    "src/t4k_loaders.c"
    "src/t4k_menu.c"
    "src/t4k_pixels.c"
    "src/t4k_replacements.c"
    "src/t4k_sdl.c"
    "src/t4k_throttle.c"
)

echo "Checking additional source files..."
for file in "${ADDITIONAL_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "⚠️ Warning: Additional file not found: $file"
    else
        echo "✓ Found additional file: $file"
        filename=$(basename "$file")
        target_file="$BUILD_DIR/$filename"
        if [ ! -f "$target_file" ]; then
            ln -sf "$CURRENT_DIR/$file" "$target_file"
            echo "✓ Created link: $filename"
        fi
    fi
done

echo "✅ All required files and directories are present."
echo "✅ Build directory is properly linked to t4kcommon files."
