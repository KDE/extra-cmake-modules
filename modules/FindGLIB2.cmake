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
IF (NOT WIN32)
   INCLUDE(UsePkgConfig)
   PKGCONFIG(glib-2.0 _LibGLIB2IncDir _LibGLIB2LinkDir _LibGLIB2LinkFlags _LibGLIB2Cflags)
endif(NOT WIN32)

FIND_PATH(GLIB2_INCLUDE_DIR glib.h
   ${_LibGLIB2IncDir}
   ${_LibGLIB2IncDir}/glib-2.0
   /usr/include/glib-2.0
   /usr/local/include/glib-2.0
)

FIND_LIBRARY(GLIB2_LIBRARIES NAMES glib-2.0
    PATHS
    ${_LibGLIB2LinkDir}
)

if(GLIB2_INCLUDE_DIR AND GLIB2_LIBRARIES)
   set(GLIB2_FOUND TRUE)
endif(GLIB2_INCLUDE_DIR AND GLIB2_LIBRARIES)

if(GLIB2_FOUND)
   if(NOT GLIB2_FIND_QUIETLY)
      message(STATUS "Found glib2: ${GLIB2_LIBRARIES} ${GLIB2_LIBRARIES}")
   endif(NOT GLIB2_FIND_QUIETLY)
else(GLIB2_FOUND)
   if (GLIB2_FIND_REQUIRED)
      message(FATAL_ERROR "Could NOT find glib2 library")
   endif (GLIB2_FIND_REQUIRED)
endif(GLIB2_FOUND)

MARK_AS_ADVANCED(GLIB2_INCLUDE_DIR GLIB2_LIBRARIES)
