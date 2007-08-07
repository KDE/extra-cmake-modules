# - Try to find the GLIB2 libraries
# Once done this will define
#
#  GLIB2_FOUND - system has glib2
#  GLIB2_INCLUDE_DIR - the glib2 include directory
#  GLIB2_LIBRARIES - glib2 library

if(GLIB2_INCLUDE_DIR AND GLIB2_LIBRARIES)
    # Already in cache, be silent
    set(GLIB2_FIND_QUIETLY TRUE)
endif(GLIB2_INCLUDE_DIR AND GLIB2_LIBRARIES)

if (NOT WIN32)
   include(UsePkgConfig)
   pkgconfig(glib-2.0 _LibGLIB2IncDir _LibGLIB2LinkDir _LibGLIB2LinkFlags _LibGLIB2Cflags)
endif(NOT WIN32)

find_path(GLIB2_INCLUDE_DIR glib.h
          PATH_SUFFIXES glib-2.0
          PATHS ${_LibGLIB2IncDir} )

find_library(GLIB2_LIBRARIES 
             NAMES glib-2.0 
             PATHS ${_LibGLIB2LinkDir} )

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(GLIB2  DEFAULT_MSG  GLIB2_LIBRARIES GLIB2_INCLUDE_DIR)

mark_as_advanced(GLIB2_INCLUDE_DIR GLIB2_LIBRARIES)
