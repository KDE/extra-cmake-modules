# - Try to find the Cups printing system
# Once done this will define
#
#  CUPS_FOUND - system has Cups
#  CUPS_INCLUDE_DIR - the Cups include directory
#  CUPS_LIBRARIES - Libraries needed to use Cups
#  CUPS_DEFINITIONS - Compiler switches required for using Cups
#
# Copyright (c) 2006, Alexander Neundorf, <neundorf@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.


if (CUPS_INCLUDE_DIR AND CUPS_LIBRARIES)

  # in cache already
  SET(CUPS_FOUND TRUE)

else (CUPS_INCLUDE_DIR AND CUPS_LIBRARIES)

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
    if (NOT Cups_FIND_QUIETLY)
      message(STATUS "Found Cups: ${CUPS_LIBRARIES}")
    endif (NOT Cups_FIND_QUIETLY)
  else (CUPS_FOUND)
    set(CUPS_LIBRARIES )
    if (Cups_FIND_REQUIRED)
      message(FATAL_ERROR "Could NOT find Cups")
    endif (Cups_FIND_REQUIRED)
  endif (CUPS_FOUND)
  
  MARK_AS_ADVANCED(CUPS_INCLUDE_DIR CUPS_LIBRARIES)
  
endif (CUPS_INCLUDE_DIR AND CUPS_LIBRARIES)
