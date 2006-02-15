# - Try to find the AGG graphics library
# Once done this will define
#
#  AGG_FOUND - system has AGG
#  AGG_INCLUDE_DIR - the AGG include directory
#  AGG_LIBRARIES - Link these to use AGG
#  AGG_DEFINITIONS - Compiler switches required for using AGG
#


# use pkg-config to get the directories and then use these values
# in the FIND_PATH() and FIND_LIBRARY() calls
INCLUDE(UsePkgConfig)

PKGCONFIG(libagg _AGGIncDir _AGGLinkDir _AGGLinkFlags _AGGCflags)

set(AGG_DEFINITIONS ${_AGGCflags})

FIND_PATH(AGG_INCLUDE_DIR agg2/agg_pixfmt_gray.h
  ${_AGGIncDir}
  /usr/include
  /usr/local/include
)

FIND_LIBRARY(AGG_LIBRARIES NAMES agg
  PATHS
  ${_AGGLinkDir}
  /usr/lib
  /usr/local/lib
)

if(AGG_INCLUDE_DIR AND AGG_LIBRARIES)
   set(AGG_FOUND TRUE)
endif(AGG_INCLUDE_DIR AND AGG_LIBRARIES)

if(AGG_FOUND)
  if(NOT AGG_FIND_QUIETLY)
    message(STATUS "Found AGG: ${AGG_LIBRARIES}")
  endif(NOT AGG_FIND_QUIETLY)
else(AGG_FOUND)
  if(AGG_FIND_REQUIRED)
    message(FATAL_ERROR "Could NOT find AGG")
  endif(AGG_FIND_REQUIRED)
endif(AGG_FOUND)

MARK_AS_ADVANCED(AGG_INCLUDE_DIR AGG_LIBRARIES)
