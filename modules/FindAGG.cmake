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

SET(AGG_DEFINITIONS ${_AGGCflags})

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

IF(AGG_INCLUDE_DIR AND AGG_LIBRARIES)
   SET(AGG_FOUND TRUE)
ENDIF(AGG_INCLUDE_DIR AND AGG_LIBRARIES)

IF(AGG_FOUND)
  IF(NOT AGG_FIND_QUIETLY)
    MESSAGE(STATUS "Found AGG: ${AGG_LIBRARIES}")
  ENDIF(NOT AGG_FIND_QUIETLY)
ELSE(AGG_FOUND)
  IF(AGG_FIND_REQUIRED)
    MESSAGE(FATAL_ERROR "Could not find AGG")
  ENDIF(AGG_FIND_REQUIRED)
ENDIF(AGG_FOUND)

MARK_AS_ADVANCED(AGG_INCLUDE_DIR AGG_LIBRARIES)
