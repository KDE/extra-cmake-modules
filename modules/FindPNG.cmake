# - Try to find PNG
# Once done this will define
#
#  PNG_FOUND - system has PNG
#  PNG_INCLUDE_DIR - the PNG include directory
#  PNG_LIBRARY - Link these to use OpenGL and GLU
#  PNG_DEFINITIONS - Compiler switches required for using PNG
#


FIND_PATH(PNG_INCLUDE_DIR png.h
  /usr/include
  /usr/local/include
)

FIND_LIBRARY(PNG_LIBRARY NAMES png
  PATHS
  /usr/lib
  /usr/local/lib
)

IF(PNG_INCLUDE_DIR AND PNG_LIBRARY)
   SET(PNG_FOUND TRUE)
ENDIF(PNG_INCLUDE_DIR AND PNG_LIBRARY)

IF(PNG_FOUND)
  IF(NOT PNG_FIND_QUIETLY)
    MESSAGE(STATUS "Found PNG: ${PNG_LIBRARY}")
  ENDIF(NOT PNG_FIND_QUIETLY)
ELSE(PNG_FOUND)
  IF(PNG_FIND_REQUIRED)
    MESSAGE(FATAL_ERROR "Could not find PNG")
  ENDIF(PNG_FIND_REQUIRED)
ENDIF(PNG_FOUND)

