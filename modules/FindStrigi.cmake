# - Try to find Strigi
# Once done this will define
#
#  STRIGI_FOUND - system has Strigi
#  STRIGI_INCLUDE_DIR - the Strigi include directory
#  STREAMINDEXER_LIBRARY - Link these to use Strigi streamindexer
#

FIND_PATH(STRIGI_INCLUDE_DIR strigi/streamindexer.h
  PATHS
  /usr/include
  /usr/local/include
  $ENV{STRIGI_HOME}/include
  ${CMAKE_INSTALL_PREFIX}/include
)
FIND_LIBRARY(STREAMINDEXER_LIBRARY NAMES streamindexer
  PATHS
  /usr/lib
  /usr/local/lib
  $ENV{STRIGI_HOME}/lib
  ${CMAKE_INSTALL_PREFIX}/lib
)

IF(STRIGI_INCLUDE_DIR AND STREAMINDEXER_LIBRARY)
   SET(STRIGI_FOUND TRUE)
ENDIF(STRIGI_INCLUDE_DIR AND STREAMINDEXER_LIBRARY)

IF(STRIGI_FOUND)
  IF(NOT Strigi_FIND_QUIETLY)
    MESSAGE(STATUS "Found Strigi: ${STREAMINDEXER_LIBRARY}")
  ENDIF(NOT Strigi_FIND_QUIETLY)
ELSE(STRIGI_FOUND)
  IF(Strigi_FIND_REQUIRED)
    MESSAGE(FATAL_ERROR "Could not find Strigi")
  ENDIF(Strigi_FIND_REQUIRED)
ENDIF(STRIGI_FOUND)

