# First, create the script in t4kcommon directory
cd /mnt/c/Users/gajen/t4kcommon

# Create the script using echo
echo '#!/bin/bash

# Set paths
CURRENT_DIR=$(pwd)
BUILD_DIR="/mnt/c/Users/gajen/tuxmath/build_wsl"

# Define required files and directories
REQUIRED_FILES=(
    "src/t4k_common.h"
    "src/t4k_common.c"
    "src/t4k_alphasort.h"
    "src/linebreak/linebreak.h"
)

REQUIRED_DIRS=(
    "src"
    "src/linebreak"
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

echo "✅ All required files and directories are present."
echo "✅ Build directory is properly linked to t4kcommon files."' > verify_t4k.sh

# Make the script executable
chmod +x verify_t4k.sh

# Run the script
./verify_t4k.sh


