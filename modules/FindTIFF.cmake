# - Find TIFF library
# Find the native TIFF includes and library
# This module defines
#  TIFF_INCLUDE_DIR, where to find tiff.h, etc.
#  TIFF_LIBRARIES, libraries to link against to use TIFF.
#  TIFF_FOUND, If false, do NOT try to use TIFF.
# also defined, but NOT for general use are
#  TIFF_LIBRARY, where to find the TIFF library.

FIND_PATH(TIFF_INCLUDE_DIR tiff.h
  /usr/local/include
  /usr/include
)

set(TIFF_NAMES ${TIFF_NAMES} tiff libtiff)
FIND_LIBRARY(TIFF_LIBRARY
  NAMES ${TIFF_NAMES}
  PATHS /usr/lib /usr/local/lib
  )


if(TIFF_INCLUDE_DIR AND TIFF_LIBRARY)
   set(TIFF_FOUND "YES")
   set(TIFF_LIBRARIES ${TIFF_LIBRARY} )
endif(TIFF_INCLUDE_DIR AND TIFF_LIBRARY)


if (TIFF_FOUND)
   if (NOT TIFF_FIND_QUIETLY)
      message(STATUS "Found TIFF: ${TIFF_LIBRARY}")
   endif (NOT TIFF_FIND_QUIETLY)
else (TIFF_FOUND)
   if (TIFF_FIND_REQUIRED)
      message(FATAL_ERROR "Could NOT find TIFF")
   endif (TIFF_FIND_REQUIRED)
endif (TIFF_FOUND)

MARK_AS_ADVANCED( TIFF_INCLUDE_DIR TIFF_LIBRARY )
