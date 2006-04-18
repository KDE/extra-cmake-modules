# - Try to find the Cups printing system
# Once done this will define
#
#  CUPS_FOUND - system has Cups
#  CUPS_INCLUDE_DIR - the Cups include directory
#  CUPS_LIBRARIES - Libraries needed to use Cups
#  CUPS_DEFINITIONS - Compiler switches required for using Cups
#

IF (DEFINED CACHED_CUPS)

  # in cache already
  IF ("${CACHED_CUPS}" STREQUAL "YES")
    SET(CUPS_FOUND TRUE)
  ENDIF ("${CACHED_CUPS}" STREQUAL "YES")

ELSE (DEFINED CACHED_CUPS)

  FIND_PATH(CUPS_INCLUDE_DIR cups/cups.h
    /usr/include
    /usr/local/include
  )
  
  FIND_LIBRARY(CUPS_LIBRARIES NAMES cups
    PATHS
    /usr/lib
    /usr/local/lib
  )
  
  if (CUPS_INCLUDE_DIR AND CUPS_LIBRARIES)
     # ippDeleteAttribute is new in cups-1.1.19 (and used by kdeprint)
     check_library_exists(cups ippDeleteAttribute "" CUPS_FOUND)
  endif (CUPS_INCLUDE_DIR AND CUPS_LIBRARIES)
  
  if (CUPS_FOUND)
    set (CACHED_CUPS "YES")
    if (NOT Cups_FIND_QUIETLY)
      message(STATUS "Found Cups: ${CUPS_LIBRARIES}")
    endif (NOT Cups_FIND_QUIETLY)
  else (CUPS_FOUND)
    set (CACHED_CUPS "NO")
    if (Cups_FIND_REQUIRED)
      message(FATAL_ERROR "Could NOT find Cups")
    endif (Cups_FIND_REQUIRED)
  endif (CUPS_FOUND)
  
  set(CACHED_CUPS ${CACHED_CUPS} CACHE INTERNAL "If cups was checked")
  MARK_AS_ADVANCED(CUPS_INCLUDE_DIR CUPS_LIBRARIES)
  
ENDIF (DEFINED CACHED_CUPS)
