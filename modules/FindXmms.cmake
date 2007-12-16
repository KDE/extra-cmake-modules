# Search xmms
## Once done this will define
#
#  XMMS_FOUND       - system has xmms
#  XMMS_INCLUDE_DIR - the xmms include directory
#  XMMS_LIBRARIES   - Link these to use xmms
#
# Copyright (c) 2006, 2007 Laurent Montel, <montel@kde.org>
# Copyright (c) 2007 Allen Winter <winter@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

if (XMMS_INCLUDE_DIR AND XMMS_LIBRARIES)
  # in cache already
  SET(XMMS_FOUND TRUE)

else (XMMS_INCLUDE_DIR AND XMMS_LIBRARIES)
  IF (NOT WIN32)
    # use pkg-config to get the directories and then use these values
    # in the FIND_PATH() and FIND_LIBRARY() calls
    INCLUDE(UsePkgConfig)

    PKGCONFIG(xmms _XMMSIncDir _XMMSLinkDir _XMMSLinkFlags _XMMSCflags)
  ENDIF(NOT WIN32)

  FIND_PATH(XMMS_INCLUDE_DIR xmmsctrl.h
    PATHS ${_XMMSIncDir} PATH_SUFFIXES xmms)

  FIND_LIBRARY(XMMS_LIBRARIES NAMES xmms
    PATHS ${_XMMSLinkDir})

  INCLUDE(FindPackageHandleStandardArgs)
  FIND_PACKAGE_HANDLE_STANDARD_ARGS(Xmms DEFAULT_MSG
                                    XMMS_LIBRARIES XMMS_INCLUDE_DIR)

  MARK_AS_ADVANCED(XMMS_INCLUDE_DIR XMMS_LIBRARIES)

endif (XMMS_INCLUDE_DIR AND XMMS_LIBRARIES)
