# - Try to find a z compression library
# under Windows the zlib exists with a variety of slightly different names
# Once done this will define
#
#  ZLIB_FOUND - system has zlib
#  ZLIB_INCLUDE_DIR - the zlib include directory
#  ZLIB_LIBRARY - The libraries needed to use zlib


IF (ZLIB_INCLUDE_DIR)
  # Already in cache, be silent
  SET(ZLIB_FIND_QUIETLY TRUE)
ENDIF (ZLIB_INCLUDE_DIR)

FIND_PATH(ZLIB_INCLUDE_DIR zlib.h
 /usr/include
 /usr/local/include
)

SET(POTENTIAL_Z_LIBS z zlib zdll)
FIND_LIBRARY(ZLIB_LIBRARY NAMES ${POTENTIAL_Z_LIBS}
   PATHS
   /usr/lib
   /usr/local/lib
)

IF (ZLIB_INCLUDE_DIR AND ZLIB_LIBRARY)
   SET(ZLIB_FOUND TRUE)
ELSE (ZLIB_INCLUDE_DIR AND ZLIB_LIBRARY)
   SET(ZLIB_FOUND FALSE)
ENDIF (ZLIB_INCLUDE_DIR AND ZLIB_LIBRARY)

IF (ZLIB_FOUND)
   IF (NOT ZLIB_FIND_QUIETLY)
      MESSAGE(STATUS "Found Z: ${ZLIB_LIBRARY}")
   ENDIF (NOT ZLIB_FIND_QUIETLY)
ELSE (ZLIB_FOUND)
   IF (ZLIB_FIND_REQUIRED)
      MESSAGE(STATUS "Looked for Z libraries named ${POTENTIAL_Z_LIBS}.")
      MESSAGE(STATUS "Found no acceptable Z library. This is fatal.")
      MESSAGE(FATAL_ERROR "Could NOT find z library")
   ENDIF (ZLIB_FIND_REQUIRED)
ENDIF (ZLIB_FOUND)

MARK_AS_ADVANCED(ZLIB_LIBRARY ZLIB_INCLUDE_DIR)
