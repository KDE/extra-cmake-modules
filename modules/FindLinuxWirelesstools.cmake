# - Try to find wireless extensions support libraries
# Once done this will define
#
#  IW_FOUND - system has IW
#  IW_INCLUDE_DIR - the IW include directory
#  IW_LIBRARIES - Link to these to use IW

# Copyright (c) 2006, Thorsten Roeder, <thorsten.roeder@weihenstephan.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.


IF (IW_INCLUDE_DIR)
  # Already in cache, be silent
  SET(LinuxWirelesstools_FIND_QUIETLY TRUE)
ENDIF (IW_INCLUDE_DIR)

FIND_PATH(IW_INCLUDE_DIR iwlib.h)

FIND_LIBRARY(IW_LIBRARIES NAMES iw)

IF(IW_INCLUDE_DIR AND IW_LIBRARIES)
   SET(IW_FOUND TRUE)
ENDIF(IW_INCLUDE_DIR AND IW_LIBRARIES)

IF(IW_FOUND)
  IF(NOT LinuxWirelesstools_FIND_QUIETLY)
    MESSAGE(STATUS "Found Linux Wirelesstools lib : ${IW_LIBRARIES}")
  ENDIF(NOT LinuxWirelesstools_FIND_QUIETLY)
ELSE(IW_FOUND)
  IF(LinuxWirelesstools_FIND_REQUIRED)
    MESSAGE(FATAL_ERROR "Could not find Linux Wirelesstools (libIW)")
  ENDIF(LinuxWirelesstools_FIND_REQUIRED)
ENDIF(IW_FOUND)

# show the IW_INCLUDE_DIR and IW_LIBRARIES variables only in the advanced view
MARK_AS_ADVANCED(IW_INCLUDE_DIR IW_LIBRARIES )

