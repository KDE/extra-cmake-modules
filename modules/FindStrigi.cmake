# - Try to find Strigi
# Once done this will define
#
#  STRIGI_FOUND - system has Strigi
#  STRIGI_INCLUDE_DIR - the Strigi include directory
#  STRIGI_STREAMANALYZER_LIBRARY - Link these to use Strigi streamanalyzer
#  STRIGI_STREAMS_LIBRARY - Link these to use Strigi streams
#  STRIGI_LIBRARIES - Link these to use both Strigi libraries


set(STRIGI_MIN_VERSION "0.5.3")

if (WIN32)
  file(TO_CMAKE_PATH "$ENV{PROGRAMFILES}" _program_FILES_DIR)
endif(WIN32)

FIND_PATH(STRIGI_INCLUDE_DIR strigi/streamanalyzer.h
  PATHS
  $ENV{STRIGI_HOME}/include
  ${CMAKE_INSTALL_PREFIX}/include
  ${_program_FILES_DIR}/strigi/include
)

if (NOT WIN32)
   include(UsePkgConfig)

   EXEC_PROGRAM(${PKGCONFIG_EXECUTABLE} ARGS --atleast-version=${STRIGI_MIN_VERSION}
      libstreamanalyzer RETURN_VALUE _return_VALUE OUTPUT_VARIABLE _pkgconfigDevNull )

   if(NOT _return_VALUE STREQUAL "0")
      message(STATUS "pkg-config query failed. did you set $PKG_CONFIG_PATH to the directory where strigi is installed?")
      message(FATAL_ERROR "Didn't find strigi >= ${STRIGI_MIN_VERSION}")
   else(NOT _return_VALUE STREQUAL "0")
     if(NOT Strigi_FIND_QUIETLY)
       message(STATUS "Found Strigi >= ${STRIGI_MIN_VERSION}")
     endif(NOT Strigi_FIND_QUIETLY)
   endif(NOT _return_VALUE STREQUAL "0")
endif (NOT WIN32)

FIND_LIBRARY(STRIGI_STREAMANALYZER_LIBRARY NAMES streamanalyzer
  PATHS
  $ENV{STRIGI_HOME}/lib
  ${CMAKE_INSTALL_PREFIX}/lib
  ${_program_FILES_DIR}/strigi/lib
)
FIND_LIBRARY(STRIGI_STREAMS_LIBRARY NAMES streams
  PATHS
  $ENV{STRIGI_HOME}/lib
  ${CMAKE_INSTALL_PREFIX}/lib
  ${_program_FILES_DIR}/strigi/lib
)

IF(STRIGI_INCLUDE_DIR AND STRIGI_STREAMANALYZER_LIBRARY AND STRIGI_STREAMS_LIBRARY)
   SET(STRIGI_FOUND TRUE)
ENDIF(STRIGI_INCLUDE_DIR AND STRIGI_STREAMANALYZER_LIBRARY AND STRIGI_STREAMS_LIBRARY)

IF(STRIGI_FOUND)
  SET(STRIGI_LIBRARIES ${STRIGI_STREAMANALYZER_LIBRARY} ${STRIGI_STREAMS_LIBRARY})

  IF(NOT Strigi_FIND_QUIETLY)
    MESSAGE(STATUS "Found Strigi: ${STRIGI_STREAMANALYZER_LIBRARY} ${STRIGI_STREAMS_LIBRARY} ")
  ENDIF(NOT Strigi_FIND_QUIETLY)
ELSE(STRIGI_FOUND)
  IF(Strigi_FIND_REQUIRED)
    MESSAGE(FATAL_ERROR "Could not find Strigi")
  ENDIF(Strigi_FIND_REQUIRED)
ENDIF(STRIGI_FOUND)

