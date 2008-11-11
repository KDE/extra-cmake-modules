# Search xmms
## Once done this will define
#
#  XMMS_FOUND        - system has xmms
#  XMMS_INCLUDE_DIRS - the xmms include directory
#  XMMS_LDFLAGS      - Link these to use xmms

# Copyright (c) 2006, 2007 Laurent Montel, <montel@kde.org>
# Copyright (c) 2007 Allen Winter <winter@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

if (XMMS_INCLUDE_DIRS AND XMMS_LDFLAGS)
  # in cache already
  SET(XMMS_FOUND TRUE)

else (XMMS_INCLUDE_DIRS AND XMMS_LDFLAGS)
  IF (NOT WIN32)
    # use pkg-config to get the directories and then use these values
    # in the FIND_PATH() and FIND_LIBRARY() calls
    find_package(PkgConfig)

    pkg_check_modules(XMMS xmms)
  ENDIF(NOT WIN32)

  FIND_PATH(XMMS_INCLUDE_DIRS xmmsctrl.h
    PATHS ${_XMMSIncDir} PATH_SUFFIXES xmms)

  FIND_LIBRARY(XMMS_LDFLAGS NAMES xmms
    PATHS ${_XMMSLinkDir})

  INCLUDE(FindPackageHandleStandardArgs)
  FIND_PACKAGE_HANDLE_STANDARD_ARGS(Xmms DEFAULT_MSG
                                    XMMS_LDFLAGS XMMS_INCLUDE_DIRS)

  MARK_AS_ADVANCED(XMMS_INCLUDE_DIRS XMMS_LDFLAGS)

endif (XMMS_INCLUDE_DIRS AND XMMS_LDFLAGS)
