# - Try to find GIF
# Once done this will define
#
#  GIF_FOUND - system has GIF
#  GIF_INCLUDE_DIR - the GIF include directory
#  GIF_LIBRARIES - Libraries needed to use GIF
#  GIF_DEFINITIONS - Compiler switches required for using GIF
#

if (GIF_INCLUDE_DIR AND GIF_LIBRARIES)
  # Already in cache, be silent
  set(GIF_FIND_QUIETLY TRUE)
endif (GIF_INCLUDE_DIR AND GIF_LIBRARIES)

FIND_PATH(GIF_INCLUDE_DIR gif_lib.h
  /usr/include
  /usr/local/include
)

set(POTENTIAL_GIF_LIBS gif libgif ungif libungif giflib)
FIND_LIBRARY(GIF_LIBRARIES NAMES ${POTENTIAL_GIF_LIBS}
  PATHS
  /usr/lib
  /usr/local/lib
)

if (GIF_INCLUDE_DIR AND GIF_LIBRARIES)
   set(CMAKE_REQUIRED_INCLUDES "${GIF_INCLUDE_DIR}" "${CMAKE_REQUIRED_INCLUDES}")
   CHECK_STRUCT_MEMBER(GifFileType UserData gif_lib.h GIF_FOUND)
endif (GIF_INCLUDE_DIR AND GIF_LIBRARIES)

if (GIF_FOUND)
  if (NOT GIF_FIND_QUIETLY)
    message(STATUS "Found GIF: ${GIF_LIBRARIES}")
  endif (NOT GIF_FIND_QUIETLY)
else (GIF_FOUND)
  if (GIF_FIND_REQUIRED)
    message(STATUS "Looked for GIF libraries named ${POTENTIAL_GIF_LIBS}.")
    message(STATUS "Found no acceptable GIF library. This is fatal.")
    message(FATAL_ERROR "Could NOT find GIF")
  endif (GIF_FIND_REQUIRED)
endif (GIF_FOUND)

MARK_AS_ADVANCED(GIF_INCLUDE_DIR GIF_LIBRARIES)
