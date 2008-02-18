# - Try to find the Enchant spell checker
# Once done this will define
#
#  ENCHANT_FOUND - system has ENCHANT
#  ENCHANT_INCLUDE_DIR - the ENCHANT include directory
#  ENCHANT_LIBRARIES - Link these to use ENCHANT
#  ENCHANT_DEFINITIONS - Compiler switches required for using ENCHANT

# Copyright (c) 2006, Zack Rusin, <zack@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.


if (ENCHANT_INCLUDE_DIR AND ENCHANT_LIBRARIES)

  # in cache already
  set(ENCHANT_FOUND TRUE)

else (ENCHANT_INCLUDE_DIR AND ENCHANT_LIBRARIES)
  if (NOT WIN32)
    # use pkg-config to get the directories and then use these values
    # in the FIND_PATH() and FIND_LIBRARY() calls
    include(UsePkgConfig)

    pkgconfig(enchant _ENCHANTIncDir _ENCHANTLinkDir _ENCHANTLinkFlags _ENCHANTCflags)

    set(ENCHANT_DEFINITIONS ${_ENCHANTCflags})
  endif (NOT WIN32)

  find_path(ENCHANT_INCLUDE_DIR 
    NAMES enchant++.h
    PATH_SUFFIXES enchant
    PATHS ${_ENCHANTIncDir} )

  find_library(ENCHANT_LIBRARIES NAMES enchant
               PATHS    ${_ENCHANTLinkDir} )

  include(FindPackageHandleStandardArgs)
  FIND_PACKAGE_HANDLE_STANDARD_ARGS(ENCHANT DEFAULT_MSG ENCHANT_INCLUDE_DIR ENCHANT_LIBRARIES )

  mark_as_advanced(ENCHANT_INCLUDE_DIR ENCHANT_LIBRARIES)
  
endif (ENCHANT_INCLUDE_DIR AND ENCHANT_LIBRARIES)
