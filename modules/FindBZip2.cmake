# - Try to find BZip2
# Once done this will define
#
#  BZIP2_FOUND - system has BZip2
#  BZIP2_INCLUDE_DIR - the BZip2 include directory
#  BZIP2_LIBRARY - Link these to use OpenGL and GLU
#  BZIP2_DEFINITIONS - Compiler switches required for using BZip2
#  BZIP2_NEED_PREFIX - this is set if the functions are prefixed with BZ2_
#


FIND_PATH(BZIP2_INCLUDE_DIR bzlib.h
  /usr/include
  /usr/local/include
)

FIND_LIBRARY(BZIP2_LIBRARY NAMES bz2
  PATHS
  /usr/lib
  /usr/local/lib
)

IF(BZIP2_INCLUDE_DIR AND BZIP2_LIBRARY)
   SET(BZIP2_FOUND TRUE)
   INCLUDE(CheckLibraryExists)
   check_library_exists(${BZIP2_LIBRARY} BZ2_bzCompressInit "" BZIP2_NEED_PREFIX)
ENDIF(BZIP2_INCLUDE_DIR AND BZIP2_LIBRARY)

IF(BZIP2_FOUND)
  IF(NOT BZip2_FIND_QUIETLY)
    MESSAGE(STATUS "Found BZip2: ${BZIP2_LIBRARY}")
  ENDIF(NOT BZip2_FIND_QUIETLY)
ELSE(BZIP2_FOUND)
  IF(BZip2_FIND_REQUIRED)
    MESSAGE(FATAL_ERROR "Could not find BZip2")
  ENDIF(BZip2_FIND_REQUIRED)
ENDIF(BZIP2_FOUND)

