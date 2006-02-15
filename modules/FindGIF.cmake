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

if(GIF_INCLUDE_DIR AND GIF_LIBRARIES)
   set(GIF_FOUND TRUE)
endif(GIF_INCLUDE_DIR AND GIF_LIBRARIES)

if(GIF_FOUND)
  if(NOT GIF_FIND_QUIETLY)
    message(STATUS "Found GIF: ${GIF_LIBRARIES}")
  endif(NOT GIF_FIND_QUIETLY)
else(GIF_FOUND)
  if(GIF_FIND_REQUIRED)
    message(FATAL_ERROR "Could NOT find GIF")
  endif(GIF_FIND_REQUIRED)
endif(GIF_FOUND)

MARK_AS_ADVANCED(GIF_INCLUDE_DIR GIF_LIBRARIES)
