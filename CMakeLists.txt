#This script was sloppily frankensteined from a handful of tux4kids'
#other CMakeLists.txt and is not safe for human consumption. 
#Please hack responsibly.

cmake_minimum_required(VERSION 3.10...3.22)

# Set vcpkg toolchain file if not already set
if(NOT DEFINED CMAKE_TOOLCHAIN_FILE)
    set(CMAKE_TOOLCHAIN_FILE "${CMAKE_CURRENT_SOURCE_DIR}/vcpkg/scripts/buildsystems/vcpkg.cmake"
        CACHE STRING "Vcpkg toolchain file")
endif()

set(PACKAGE_NAME "Tux4Kids_common")
set(PACKAGE_VERSION 1.0.0)
set(T4K_COMMON_PACKAGE_STRING "${PACKAGE_NAME}-${PACKAGE_VERSION}" )
set(LIB_NAME "t4k_common")
set(VERSION ${PACKAGE_VERSION})
project(${PACKAGE_NAME} VERSION ${PACKAGE_VERSION})

# Add modern CMake features
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_C_STANDARD 11)

set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake-modules")
include(T4K_Sugar)

set(SDL_BUILDING_LIBRARY 1) #indicate we don't need to (and shouldn't) link SDLmain

set(T4K_DEVELOPER_WARNINGS OFF CACHE STRING "Change or override to enable warnings")
if(CMAKE_BUILD_TYPE MATCHES Release)
    set(T4K_DEVELOPER_WARNINGS ON)
endif()

# Find required packages using vcpkg
find_package(SDL2 CONFIG REQUIRED)
find_package(SDL2_image CONFIG REQUIRED)
find_package(SDL2_mixer CONFIG REQUIRED)
find_package(SDL2_ttf CONFIG REQUIRED)

# Find libunistring
find_library(UNISTRING_LIBRARY unistring)
find_path(UNISTRING_INCLUDE_DIR unistr.h PATH_SUFFIXES "unistring")
if(UNISTRING_LIBRARY AND UNISTRING_INCLUDE_DIR)
    set(UNISTRING_FOUND TRUE)
    message("libunistring found: ${UNISTRING_FOUND}")
else()
    set(UNISTRING_FOUND FALSE)
    message("libunistring not found")
endif()

# Optional packages
find_package(SDL2-net CONFIG)
if(SDL2-net_FOUND)
    add_definitions(-DHAVE_SDL_NET)
endif()

# Find speech-dispatcher
find_library(SPEECHD_LIBRARY speechd)
find_path(SPEECHD_INCLUDE_DIR libspeechd.h)
if(SPEECHD_LIBRARY AND SPEECHD_INCLUDE_DIR)
    set(SPEECHD_FOUND TRUE)
    add_definitions(-DWITH_SPEECHD)
    message("Speech-dispatcher found: ${SPEECHD_FOUND}")
else()
    set(SPEECHD_FOUND FALSE)
    message("Speech-dispatcher not found")
endif()

# needed for SVG loading and caching
find_package(PNG)
find_package(RSVG)
set(HAVE_RSVG ${RSVG_FOUND})
set(HAVE_LIBPNG ${PNG_FOUND})

message("SDL2 found: ${SDL2_FOUND}")
message("SDL2_image found: ${SDL2_image_FOUND}")
message("SDL2_mixer found: ${SDL2_mixer_FOUND}")
message("SDL2_ttf found: ${SDL2_ttf_FOUND}")
message("SDL2-net found: ${SDL2-net_FOUND}")

# based on tuxmath's CMakeLists.txt
if (APPLE)
    set(MACOSX_BUNDLE_NAME ${PACKAGE_NAME})
    set(DATA_PREFIX
        ${T4K_COMMON_MACOSX_BUNDLE_NAME}.app/Contents/Resources)
elseif(UNIX)
    set (DATA_PREFIX
        ${CMAKE_INSTALL_PREFIX}/share/${LIB_NAME})
elseif(WIN32)
    set(DATA_PREFIX "${CMAKE_INSTALL_PREFIX}")
else()
    message(SEND_ERROR "What OS are you on?")
endif()

set(LINEBREAK_BINARY_DIR ${CMAKE_BINARY_DIR}/src/linebreak)
set(LINEBREAK_SOURCE_DIR ${CMAKE_SOURCE_DIR}/src/linebreak)

#process subdirectories
add_subdirectory(src)
add_subdirectory(data)

include(CPack)

# Update pkg-config dependencies for SDL2
set(DEP_PKGS "sdl2 >= 2.0.0 SDL2_image SDL2_ttf librsvg-2.0 libxml-2.0") 
set(DEP_LIBS "-lSDL2_mixer") 
if(WIN32)
    set(DEP_LIBS_PRIVATE "-mwindows -lstdc++ -lSDL2main -luser32 -lgdi32 -lwinmm -ldxguid -lSDL2 -lpthread") 
endif()

# Configure and install pkg-config file
configure_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/t4k_common.pc.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/t4k_common.pc
    @ONLY
)

install(
    FILES ${CMAKE_CURRENT_BINARY_DIR}/t4k_common.pc
    DESTINATION lib/pkgconfig
)
