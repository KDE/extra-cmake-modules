# - Try to find shared-desktop-ontologies
# Once done this will define
#
#  DESKTOP_ONTOLOGIES_FOUND - system has shared-desktop-ontologies
#  DESKTOP_ONTOLOGIES_DIR - Folder where the ontologies are stored
#  DESKTOP_ONTOLOGIES_VERSION - version number of shared-desktop-ontologies

# Copyright (c) 2009, Sebastian Trueg, <trueg@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

IF (DESKTOP_ONTOLOGIES_DIR)
   # in cache already
   SET(SharedDesktopOntologies_FIND_QUIETLY TRUE)
ENDIF (DESKTOP_ONTOLOGIES_DIR)

IF (NOT WIN32)
   # use pkg-config to get the directories and then use these values
   # in the FIND_PATH() and FIND_LIBRARY() calls
   find_package(PkgConfig)
   PKG_SEARCH_MODULE( DESKTOP_ONTOLOGIES shared-desktop-ontologies )
   set(DESKTOP_ONTOLOGIES_DIR ${DESKTOP_ONTOLOGIES_PREFIX}/share/ontology)
ENDIF (NOT WIN32)

IF (DESKTOP_ONTOLOGIES_FOUND)
   IF (NOT SharedDesktopOntologies_FIND_QUIETLY)
      MESSAGE(STATUS "Found SharedDesktopOntologies ${DESKTOP_ONTOLOGIES_VERSION}: ${DESKTOP_ONTOLOGIES_DIR}")
   ENDIF (NOT SharedDesktopOntologies_FIND_QUIETLY)
ELSE (DESKTOP_ONTOLOGIES_FOUND)
   IF (SharedDesktopOntologies_FIND_REQUIRED)
      MESSAGE(FATAL_ERROR "Could NOT find SharedDesktopOntologies, check FindPkgConfig output above!")
   ENDIF (SharedDesktopOntologies_FIND_REQUIRED)
ENDIF (DESKTOP_ONTOLOGIES_FOUND)

MARK_AS_ADVANCED(DESKTOP_ONTOLOGIES_DIR)
