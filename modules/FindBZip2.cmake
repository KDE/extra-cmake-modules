# - Try to find BZip2
# Once done this will define
#
#  BZIP2_FOUND - system has BZip2
#  BZIP2_INCLUDE_DIR - the BZip2 include directory
#  BZIP2_LIBRARIES - Link these to use BZip2
#  BZIP2_DEFINITIONS - Compiler switches required for using BZip2
#  BZIP2_NEED_PREFIX - this is set if the functions are prefixed with BZ2_
#


FIND_PATH(BZIP2_INCLUDE_DIR bzlib.h
  /usr/include
  /usr/local/include
)

FIND_LIBRARY(BZIP2_LIBRARIES NAMES bz2 bzip2
  PATHS
  /usr/lib
  /usr/local/lib
)

if(BZIP2_INCLUDE_DIR AND BZIP2_LIBRARIES)
   set(BZIP2_FOUND TRUE)
   INCLUDE(CheckLibraryExists)
   CHECK_LIBRARY_EXISTS(${BZIP2_LIBRARIES} BZ2_bzCompressInit "" BZIP2_NEED_PREFIX)
endif(BZIP2_INCLUDE_DIR AND BZIP2_LIBRARIES)

if(BZIP2_FOUND)
  if(NOT BZip2_FIND_QUIETLY)
    message(STATUS "Found BZip2: ${BZIP2_LIBRARIES}")
  endif(NOT BZip2_FIND_QUIETLY)
else(BZIP2_FOUND)
  if(BZip2_FIND_REQUIRED)
    message(FATAL_ERROR "Could NOT find BZip2")
  endif(BZip2_FIND_REQUIRED)
endif(BZIP2_FOUND)

MARK_AS_ADVANCED(BZIP2_INCLUDE_DIR BZIP2_LIBRARIES)
