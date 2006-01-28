# - Try to find GIF
# Once done this will define
#
#  GIF_FOUND - system has GIF
#  GIF_INCLUDE_DIR - the GIF include directory
#  GIF_LIBRARY - Link these to use OpenGL and GLU
#  GIF_DEFINITIONS - Compiler switches required for using GIF
#


FIND_PATH(GIF_INCLUDE_DIR gif_lib.h
  /usr/include
  /usr/local/include
)

FIND_LIBRARY(GIF_LIBRARY NAMES gif ungif
  PATHS
  /usr/lib
  /usr/local/lib
)

IF(GIF_INCLUDE_DIR AND GIF_LIBRARY)
   SET(GIF_FOUND TRUE)
ENDIF(GIF_INCLUDE_DIR AND GIF_LIBRARY)

IF(GIF_FOUND)
  IF(NOT GIF_FIND_QUIETLY)
    MESSAGE(STATUS "Found GIF: ${GIF_LIBRARY}")
  ENDIF(NOT GIF_FIND_QUIETLY)
ELSE(GIF_FOUND)
  IF(GIF_FIND_REQUIRED)
    MESSAGE(FATAL_ERROR "Could not find GIF")
  ENDIF(GIF_FIND_REQUIRED)
ENDIF(GIF_FOUND)

