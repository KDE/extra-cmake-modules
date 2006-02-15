# - Try to find HSPELL
# Once done this will define
#
#  HSPELL_FOUND - system has HSPELL
#  HSPELL_INCLUDE_DIR - the HSPELL include directory
#  HSPELL_LIBRARIES - The libraries needed to use HSPELL
#  HSPELL_DEFINITIONS - Compiler switches required for using HSPELL
#


FIND_PATH(HSPELL_INCLUDE_DIR hspell.h
  /usr/include
  /usr/local/include
)

FIND_LIBRARY(HSPELL_LIBRARIES NAMES hspell
  PATHS
  /usr/lib
  /usr/local/lib
)

if(HSPELL_INCLUDE_DIR AND HSPELL_LIBRARIES)
   set(HSPELL_FOUND TRUE)
endif(HSPELL_INCLUDE_DIR AND HSPELL_LIBRARIES)

if(HSPELL_FOUND)
  if(NOT HSPELL_FIND_QUIETLY)
    message(STATUS "Found HSPELL: ${HSPELL_LIBRARIES}")
  endif(NOT HSPELL_FIND_QUIETLY)
else(HSPELL_FOUND)
  if(HSPELL_FIND_REQUIRED)
    message(FATAL_ERROR "Could NOT find HSPELL")
  endif(HSPELL_FIND_REQUIRED)
endif(HSPELL_FOUND)

MARK_AS_ADVANCED(HSPELL_INCLUDE_DIR HSPELL_LIBRARIES)

