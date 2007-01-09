# - Try to find the  Fontconfig
# Once done this will define
#
#  FONTCONFIG_FOUND - system has Fontconfig
#  FONTCONFIG_LIBRARIES - Link these to use FONTCONFIG
#  FONTCONFIG_DEFINITIONS - Compiler switches required for using FONTCONFIG

# Copyright (c) 2006, Laurent Montel, <montel@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.


if (FONTCONFIG_LIBRARIES AND FONTCONFIG_INCLUDE_DIR)

  # in cache already
  set(FONTCONFIG_FOUND TRUE)

else (FONTCONFIG_LIBRARIES AND FONTCONFIG_INCLUDE_DIR)

  if (NOT WIN32)
    # use pkg-config to get the directories and then use these values
    # in the FIND_PATH() and FIND_LIBRARY() calls
    include(UsePkgConfig)

    pkgconfig(fontconfig _FONTCONFIGIncDir _FONTCONFIGLinkDir _FONTCONFIGLinkFlags _FONTCONFIGCflags)

    set(FONTCONFIG_DEFINITIONS ${_FONTCONFIGCflags} CACHE INTERNAL "The compilation flags for fontconfig")
  endif (NOT WIN32)

  find_path(FONTCONFIG_INCLUDE_DIR fontconfig/fontconfig.h
    PATHS
    ${_FONTCONFIGIncDir}
    /usr/X11/include
  )

  find_library(FONTCONFIG_LIBRARIES NAMES fontconfig
    PATHS
    ${_FONTCONFIGLinkDir}
  )

  if (FONTCONFIG_LIBRARIES)
     set(FONTCONFIG_FOUND TRUE)
  endif (FONTCONFIG_LIBRARIES)

  if (FONTCONFIG_FOUND)
    if (NOT FONTCONFIG_FIND_QUIETLY)
      message(STATUS "Found FONTCONFIG: ${FONTCONFIG_LIBRARIES}")
    endif (NOT FONTCONFIG_FIND_QUIETLY)
  else (FONTCONFIG_FOUND)
    if (FONTCONFIG_FIND_REQUIRED)
      message(FATAL_ERROR "Could NOT find FONTCONFIG")
    endif (FONTCONFIG_FIND_REQUIRED)
  endif (FONTCONFIG_FOUND)

  mark_as_advanced(FONTCONFIG_LIBRARIES)

endif (FONTCONFIG_LIBRARIES AND FONTCONFIG_INCLUDE_DIR)
