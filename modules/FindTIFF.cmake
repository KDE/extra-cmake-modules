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

if(TIFF_INCLUDE_DIR)
  if(TIFF_LIBRARY)
    set( TIFF_FOUND "YES" )
    set( TIFF_LIBRARIES ${TIFF_LIBRARY} )
  endif(TIFF_LIBRARY)
endif(TIFF_INCLUDE_DIR)

