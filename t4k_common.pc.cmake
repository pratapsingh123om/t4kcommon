prefix=@CMAKE_INSTALL_PREFIX@
exec_prefix=${prefix}
libdir=${exec_prefix}/lib
includedir=${prefix}/include

Name: t4kcommon
Description: Tux4Kids common routines
Version: @VERSION@

Requires: sdl2 >= 2.0.0 SDL2_image SDL2_ttf
Libs: -lt4k_common -L${libdir} @DEP_LIBS@
Cflags: -I${includedir}/t4k_common
Libs.private: @DEP_LIBS_PRIVATE@ 