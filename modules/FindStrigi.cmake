# - Try to find Strigi
# Once done this will define
#
#  STRIGI_FOUND - system has Strigi
#  STRIGI_INCLUDE_DIR - the Strigi include directory
#  STREAMANALYZER_LIBRARY - Link these to use Strigi streamanalyzer
#  STREAMS_LIBRARY - Link these to use Strigi streams
#  STRIGI_LIBRARIES - Link these to use both Strigi libraries
#

if (WIN32)
  file(TO_CMAKE_PATH "$ENV{PROGRAMFILES}" _program_FILES_DIR)
endif(WIN32)

FIND_PATH(STRIGI_INCLUDE_DIR strigi/streamanalyzer.h
  PATHS
  /usr/include
  /usr/local/include
  $ENV{STRIGI_HOME}/include
  ${CMAKE_INSTALL_PREFIX}/include
  ${_program_FILES_DIR}/strigi/include
)
FIND_LIBRARY(STREAMANALYZER_LIBRARY NAMES streamanalyzer
  PATHS
  /usr/lib
  /usr/local/lib
  $ENV{STRIGI_HOME}/lib
  ${CMAKE_INSTALL_PREFIX}/lib
  ${_program_FILES_DIR}/strigi/lib
)
FIND_LIBRARY(STREAMS_LIBRARY NAMES streams
  PATHS
  /usr/lib
  /usr/local/lib
  $ENV{STRIGI_HOME}/lib
  ${CMAKE_INSTALL_PREFIX}/lib
  ${_program_FILES_DIR}/strigi/lib
)

IF(STRIGI_INCLUDE_DIR AND STREAMANALYZER_LIBRARY AND STREAMS_LIBRARY)
   SET(STRIGI_FOUND TRUE)
ENDIF(STRIGI_INCLUDE_DIR AND STREAMANALYZER_LIBRARY AND STREAMS_LIBRARY)

IF(STRIGI_FOUND)
  SET(STRIGI_LIBRARIES ${STREAMANALYZER_LIBRARY} ${STREAMS_LIBRARY})
  IF(NOT Strigi_FIND_QUIETLY)
    MESSAGE(STATUS "Found Strigi: ${STREAMANALYZER_LIBRARY}")
    MESSAGE(STATUS "Found Strigi: ${STREAMS_LIBRARY}")
  ENDIF(NOT Strigi_FIND_QUIETLY)
ELSE(STRIGI_FOUND)
  IF(Strigi_FIND_REQUIRED)
    MESSAGE(FATAL_ERROR "Could not find Strigi")
  ENDIF(Strigi_FIND_REQUIRED)
ENDIF(STRIGI_FOUND)

