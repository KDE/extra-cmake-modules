# - Try to find GIF
# Once done this will define
#
#  GIF_FOUND - system has GIF
#  GIF_INCLUDE_DIR - the GIF include directory
#  GIF_LIBRARIES - Libraries needed to use GIF
#  GIF_DEFINITIONS - Compiler switches required for using GIF
#


FIND_PATH(GIF_INCLUDE_DIR gif_lib.h
  /usr/include
  /usr/local/include
)

FIND_LIBRARY(GIF_LIBRARIES NAMES gif libgif ungif libungif giflib
  PATHS
  /usr/lib
  /usr/local/lib
)

IF(GIF_INCLUDE_DIR AND GIF_LIBRARIES)
   SET(GIF_FOUND TRUE)
ENDIF(GIF_INCLUDE_DIR AND GIF_LIBRARIES)

IF(GIF_FOUND)
  IF(NOT GIF_FIND_QUIETLY)
    MESSAGE(STATUS "Found GIF: ${GIF_LIBRARIES}")
  ENDIF(NOT GIF_FIND_QUIETLY)
ELSE(GIF_FOUND)
  IF(GIF_FIND_REQUIRED)
    MESSAGE(FATAL_ERROR "Could not find GIF")
  ENDIF(GIF_FIND_REQUIRED)
ENDIF(GIF_FOUND)

MARK_AS_ADVANCED(GIF_INCLUDE_DIR GIF_LIBRARIES)
