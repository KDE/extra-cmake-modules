# - Try to find the Enchant spell checker
# Once done this will define
#
#  ENCHANT_FOUND - system has ENCHANT
#  ENCHANT_INCLUDE_DIR - the ENCHANT include directory
#  ENCHANT_LIBRARIES - Link these to use ENCHANT
#  ENCHANT_DEFINITIONS - Compiler switches required for using ENCHANT
#
# Copyright (c) 2006, Zack Rusin, <zack@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.


if (ENCHANT_INCLUDE_DIR AND ENCHANT_LIBRARIES)

  # in cache already
  SET(ENCHANT_FOUND TRUE)

else (ENCHANT_INCLUDE_DIR AND ENCHANT_LIBRARIES)

  # use pkg-config to get the directories and then use these values
  # in the FIND_PATH() and FIND_LIBRARY() calls
  INCLUDE(UsePkgConfig)
  
  PKGCONFIG(enchant _ENCHANTIncDir _ENCHANTLinkDir _ENCHANTLinkFlags _ENCHANTCflags)
  
  set(ENCHANT_DEFINITIONS ${_ENCHANTCflags})
  
  FIND_PATH(ENCHANT_INCLUDE_DIR enchant/enchant.h
    ${_ENCHANTIncDir}
    /usr/include
    /usr/local/include
  )
  
  FIND_LIBRARY(ENCHANT_LIBRARIES NAMES enchant
    PATHS
    ${_ENCHANTLinkDir}
    /usr/lib
    /usr/local/lib
  )
  
  if (ENCHANT_INCLUDE_DIR AND ENCHANT_LIBRARIES)
     set(ENCHANT_FOUND TRUE)
  endif (ENCHANT_INCLUDE_DIR AND ENCHANT_LIBRARIES)
  
  if (ENCHANT_FOUND)
    if (NOT ENCHANT_FIND_QUIETLY)
      message(STATUS "Found ENCHANT: ${ENCHANT_LIBRARIES}")
    endif (NOT ENCHANT_FIND_QUIETLY)
  else (ENCHANT_FOUND)
    if (ENCHANT_FIND_REQUIRED)
      message(FATAL_ERROR "Could NOT find ENCHANT")
    endif (ENCHANT_FIND_REQUIRED)
  endif (ENCHANT_FOUND)
  
  MARK_AS_ADVANCED(ENCHANT_INCLUDE_DIR ENCHANT_LIBRARIES)
  
endif (ENCHANT_INCLUDE_DIR AND ENCHANT_LIBRARIES)
