# - Try to find BlueZ
# Once done this will define
#
#  BLUEZ_FOUND - system has BlueZ

# Copyright (c) 2006, Alexander Neundorf, <neundorf@kde.org>
# Copyright (c) 2007, Will Stephenson, <wstephenson@kde.org>
# Copyright (c) 2007, Daniel Gollub, <dgollub@suse.de>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.


IF (NOT WIN32)
   # use pkg-config to get the directories and then use these values
   # in the FIND_PATH() and FIND_LIBRARY() calls
   INCLUDE(UsePkgConfig)
   PKGCONFIG(bluez _BlueZIncDir _BlueZLinkDir _BlueZLinkFlags _BlueZCflags)
ENDIF (NOT WIN32)

find_path(BLUEZ_INCLUDE_DIR bluetooth/bluetooth.h
    PATHS
    ${_BlueZIncDir}
    /usr/X11/include
  )

find_library(BLUEZ_LIBRARIES NAMES bluetooth
    PATHS
    ${_BlueZLinkDir}
  )

include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(BlueZ DEFAULT_MSG BLUEZ_LIBRARIES BLUEZ_INCLUDE_DIR )

mark_as_advanced( BLUEZ_LIBRARIES BLUEZ_INCLUDE_DIR)
