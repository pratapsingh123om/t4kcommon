#This script was sloppily frankensteined from a handful of tux4kids'
#other CMakeLists.txt and is not safe for human consumption. 
#Please hack responsibly.

# TODO - add cmake build support for t4k_test program - DSB

cmake_minimum_required(VERSION 3.10...3.22)

include(ConfigureChecks)
configure_file(${CMAKE_SOURCE_DIR}/config.h.cmake ${CMAKE_BINARY_DIR}/config.h)
include(T4K_Sugar)

#Cmake module contains the source files for this library
include(${CMAKE_SOURCE_DIR}/cmake-modules/Files.cmake)

find_package(LibXml2 REQUIRED)

#Look here for headers
include_directories(
    ${SDL_INCLUDE_DIR}
    ${SDLIMAGE_INCLUDE_DIR}
    ${SDLMIXER_INCLUDE_DIR}
    ${LIBXML2_INCLUDE_DIR}
    ${CMAKE_SOURCE_DIR}/gettext
    ${CMAKE_BINARY_DIR}
    ${CMAKE_BINARY_DIR}/src
    ${CMAKE_BINARY_DIR}/gettext
    ${CMAKE_BINARY_DIR}/src/linebreak
    ${CMAKE_SOURCE_DIR}/src/linebreak
    )

#Look here for optional headers
t4k_include_directory(SDLPANGO)
t4k_include_directory(SDLTTF)
t4k_include_directory(PNG)
t4k_include_directory(RSVG)

#include_directories( ${T4KCOMMON_INCLUDE_DIRS} )

set( T4K_COMMON_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR} )
if(T4K_DEVELOPER_WARNINGS)
    list(APPEND CMAKE_C_FLAGS -Wall) 
endif()

# Source files
set(T4K_COMMON_SOURCES
    ${CMAKE_CURRENT_SOURCE_DIR}/t4k_audio.c
    ${CMAKE_CURRENT_SOURCE_DIR}/t4k_convert_utf.c
    ${CMAKE_CURRENT_SOURCE_DIR}/t4k_linewrap.c
    ${CMAKE_CURRENT_SOURCE_DIR}/t4k_loaders.c
    ${CMAKE_CURRENT_SOURCE_DIR}/t4k_main.c
    ${CMAKE_CURRENT_SOURCE_DIR}/t4k_menu.c
    ${CMAKE_CURRENT_SOURCE_DIR}/t4k_pixels.c
    ${CMAKE_CURRENT_SOURCE_DIR}/t4k_replacements.c
    ${CMAKE_CURRENT_SOURCE_DIR}/t4k_sdl.c
    ${CMAKE_CURRENT_SOURCE_DIR}/t4k_throttle.c
    ${CMAKE_CURRENT_SOURCE_DIR}/t4k_tts.c
    ${CMAKE_CURRENT_SOURCE_DIR}/linebreak/linebreak.c
)

set(T4K_COMMON_HEADERS
    ${CMAKE_CURRENT_SOURCE_DIR}/t4k_common.h
    ${CMAKE_CURRENT_SOURCE_DIR}/t4k_compiler.h
    ${CMAKE_CURRENT_SOURCE_DIR}/t4k_globals.h
    ${CMAKE_CURRENT_SOURCE_DIR}/t4k_alphasort.h
    ${CMAKE_CURRENT_SOURCE_DIR}/t4k_scandir.h
    ${CMAKE_CURRENT_SOURCE_DIR}/linebreak/linebreak.h
    ${CMAKE_CURRENT_SOURCE_DIR}/linebreak/lbrkprop.h
    ${CMAKE_CURRENT_SOURCE_DIR}/linebreak/unistr.h
    ${CMAKE_CURRENT_SOURCE_DIR}/linebreak/uniwidth.h
    ${CMAKE_CURRENT_SOURCE_DIR}/linebreak/unitypes.h
)

# Test program sources
set(T4K_TEST_SOURCES
    ${CMAKE_CURRENT_SOURCE_DIR}/t4k_test.c
)

#Declare the library
add_library(t4k_common SHARED 
    ${T4K_COMMON_SOURCES}
    ${T4K_COMMON_HEADERS}
)

#Avoid linking to both libraries
if(SDLPANGO_FOUND)
    set(SDLTTF_LIBRARY "")
else()
    set(SDLPANGO_LIBRARY "")
endif()

# Link against dependencies
target_link_libraries(t4k_common PRIVATE
    SDL2::SDL2
    SDL2::SDL2main
    SDL2_image::SDL2_image
    SDL2_mixer::SDL2_mixer
    SDL2_ttf::SDL2_ttf
    ${LIBXML2_LIBRARIES}
    linebreak
)

if(UNISTRING_FOUND)
    target_link_libraries(t4k_common PRIVATE ${UNISTRING_LIBRARY})
    target_include_directories(t4k_common PRIVATE ${UNISTRING_INCLUDE_DIR})
endif()

if(SPEECHD_FOUND)
    target_link_libraries(t4k_common PRIVATE ${SPEECHD_LIBRARY})
    target_include_directories(t4k_common PRIVATE ${SPEECHD_INCLUDE_DIR})
endif()

if(PNG_FOUND)
    target_link_libraries(t4k_common PRIVATE ${PNG_LIBRARIES})
endif()

if(RSVG_FOUND)
    target_link_libraries(t4k_common PRIVATE ${RSVG_LIBRARIES})
endif()

# Add compile definitions for SDL2
target_compile_definitions(t4k_common PRIVATE
    SDL_MAIN_HANDLED
    _SDL_main_h
)

t4k_include_definition(HAVE_LIBSDL_PANGO)
t4k_include_definition(HAVE_LIBPNG)
set_target_properties(t4k_common PROPERTIES 
    COMPILE_FLAGS "${_rsvg_def} ${_pango_def} ${_rsvg_cflags} ${_cairo_cflags}"
    COMPILE_DEFINITIONS
    "COMMON_DATA_PREFIX=\"${DATA_PREFIX}\";USE_T4K_PREFIX=1;PACKAGE_STRING=\"${PACKAGE_NAME}\""
    LINK_INTERFACE_LIBRARIES ""
    VERSION ${VERSION}
    SOVERSION 1
)

add_dependencies(t4k_common linebreak)

# Installation rules
install(TARGETS t4k_common
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
)

install(FILES 
    ${T4K_COMMON_HEADERS}
    DESTINATION include/t4k_common
)

include(UseDoxygen OPTIONAL)

#process subdirectories
add_subdirectory(linebreak)

#Build t4k_test app
option(BUILD_TESTING "Build the testing tree." ON)
if(BUILD_TESTING)
    add_executable(t4k_test ${T4K_TEST_SOURCES})
    target_link_libraries(t4k_test PRIVATE
        t4k_common
        SDL2::SDL2
        SDL2::SDL2main
        SDL2_image::SDL2_image
        SDL2_mixer::SDL2_mixer
        SDL2_ttf::SDL2_ttf
        ${LIBXML2_LIBRARIES}
    )
    
    if(UNISTRING_FOUND)
        target_link_libraries(t4k_test PRIVATE ${UNISTRING_LIBRARY})
        target_include_directories(t4k_test PRIVATE ${UNISTRING_INCLUDE_DIR})
    endif()
    
    if(SPEECHD_FOUND)
        target_link_libraries(t4k_test PRIVATE ${SPEECHD_LIBRARY})
        target_include_directories(t4k_test PRIVATE ${SPEECHD_INCLUDE_DIR})
    endif()
    
    if(PNG_FOUND)
        target_link_libraries(t4k_test PRIVATE ${PNG_LIBRARIES})
    endif()
    
    if(RSVG_FOUND)
        target_link_libraries(t4k_test PRIVATE ${RSVG_LIBRARIES})
    endif()
endif()

include_directories(${CMAKE_BINARY_DIR}/src)
include_directories(${CMAKE_SOURCE_DIR}/src)
include_directories(${LINEBREAK_SOURCE_DIR})

# Add SDL2 include directories
include_directories(${SDL2_INCLUDE_DIRS})

# Add other dependencies' include directories
if(PNG_FOUND)
    include_directories(${PNG_INCLUDE_DIRS})
endif()

if(RSVG_FOUND)
    include_directories(${RSVG_INCLUDE_DIRS})
endif()
