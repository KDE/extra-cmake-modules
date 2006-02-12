# - Try to find the Cups printing system
# Once done this will define
#
#  CUPS_FOUND - system has Cups
#  CUPS_INCLUDE_DIR - the Cups include directory
#  CUPS_LIBRARIES - Libraries needed to use Cups
#  CUPS_DEFINITIONS - Compiler switches required for using Cups
#


FIND_PATH(CUPS_INCLUDE_DIR cups/cups.h
  /usr/include
  /usr/local/include
)

FIND_LIBRARY(CUPS_LIBRARIES NAMES cups
  PATHS
  /usr/lib
  /usr/local/lib
)

IF(CUPS_INCLUDE_DIR AND CUPS_LIBRARIES)
   SET(CUPS_FOUND TRUE)
ENDIF(CUPS_INCLUDE_DIR AND CUPS_LIBRARIES)

IF(CUPS_FOUND)
  IF(NOT Cups_FIND_QUIETLY)
    MESSAGE(STATUS "Found Cups: ${CUPS_LIBRARIES}")
  ENDIF(NOT Cups_FIND_QUIETLY)
ELSE(CUPS_FOUND)
  IF(Cups_FIND_REQUIRED)
    MESSAGE(FATAL_ERROR "Could not find Cups")
  ENDIF(Cups_FIND_REQUIRED)
ENDIF(CUPS_FOUND)

MARK_AS_ADVANCED(CUPS_INCLUDE_DIR CUPS_LIBRARIES)
