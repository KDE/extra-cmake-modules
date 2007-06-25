# - Try to find NetworkManager
# Once done this will define
#
#  NETWORKMANAGER_FOUND - system has NetworkManager
#  NETWORKMANAGER_INCLUDE_DIR - the NetworkManager include directory
#  NETWORKMANAGER_LIBRARIES - the libraries needed to use NetworkManager
#  NETWORKMANAGER_DEFINITIONS - Compiler switches required for using NetworkManager

# Copyright (c) 2006, Alexander Neundorf, <neundorf@kde.org>
# Copyright (c) 2007, Will Stephenson, <wstephenson@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.


IF (NETWORKMANAGER_INCLUDE_DIR AND NM-UTIL_LIBRARY)
   # in cache already
   SET(NetworkManager_FIND_QUIETLY TRUE)
ENDIF (NETWORKMANAGER_INCLUDE_DIR AND NM-UTIL_LIBRARY)

IF (NOT WIN32)
   # use pkg-config to get the directories and then use these values
   # in the FIND_PATH() and FIND_LIBRARY() calls
   INCLUDE(UsePkgConfig)
   PKGCONFIG(NetworkManager _NetworkManagerIncDir _NetworkManagerLinkDir _NetworkManagerLinkFlags _NetworkManagerCflags)
   SET(NETWORKMANAGER_DEFINITIONS ${_NetworkManagerCflags})
   PKGCONFIG(libnm-util _libnm-utilIncDir _libnm-utilLinkDir _libnm-utilLinkFlags _libnm-utilCflags)
   SET(NM-UTILS_DEFINITIONS ${_libnm-utilCflags})
ENDIF (NOT WIN32)

MESSAGE(STATUS "Found NetworkManager: ${_NetworkManagerLinkFlags}")
FIND_PATH(NETWORKMANAGER_INCLUDE_DIR NetworkManager/NetworkManager.h
   PATHS
   ${_NetworkManagerIncDir}
   )

FIND_LIBRARY(NM-UTIL_LIBRARY NAMES nm-util
   PATHS
   ${_libnm-utilLinkDir}
   )

IF (NETWORKMANAGER_INCLUDE_DIR AND NM-UTIL_LIBRARY)
   SET(NETWORKMANAGER_FOUND TRUE)
ELSE (NETWORKMANAGER_INCLUDE_DIR AND NM-UTIL_LIBRARY)
   SET(NETWORKMANAGER_FOUND FALSE)
ENDIF (NETWORKMANAGER_INCLUDE_DIR AND NM-UTIL_LIBRARY)

IF (NETWORKMANAGER_FOUND)
   IF (NOT NetworkManager_FIND_QUIETLY)
      MESSAGE(STATUS "Found libnm-util: ${NM-UTIL_LIBRARY}")
   ENDIF (NOT NetworkManager_FIND_QUIETLY)
ELSE (NETWORKMANAGER_FOUND)
   IF (NetworkManager_FIND_REQUIRED)
      MESSAGE(SEND_ERROR "Could NOT find NetworkManager")
   ENDIF (NetworkManager_FIND_REQUIRED)
ENDIF (NETWORKMANAGER_FOUND)

MARK_AS_ADVANCED(NETWORKMANAGER_INCLUDE_DIR NM-UTIL_LIBRARY)

