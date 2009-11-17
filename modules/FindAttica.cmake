# Try to find the Attica library
# Once done this will define
#
#   ATTICA_FOUND          Indicates that Attica was found
#   ATTICA_LIBRARIES      Libraries needed to use Attica
#   ATTICA_LIBRARY_DIRS   Paths needed for linking against Attica
#   ATTICA_INCLUDE_DIRS   Paths needed for finding Attica include files
#
# Copyright (c) 2009 Frederik Gladhorn <gladhorn@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.

IF (ATTICA_INCLUDE_DIR AND ATTICA_LIBRARIES)
   # in cache already
   SET(Attica_FIND_QUIETLY TRUE)
ENDIF (ATTICA_INCLUDE_DIR AND ATTICA_LIBRARIES)

IF (NOT WIN32)
   # use pkg-config to get the directories and then use these values
   # in the FIND_PATH() and FIND_LIBRARY() calls
   FIND_PACKAGE(PkgConfig)
   PKG_CHECK_MODULES(PC_ATTICA QUIET libattica-0.1)
   SET(ATTICA_DEFINITIONS ${PC_ATTICA_CFLAGS_OTHER})
ENDIF (NOT WIN32)

FIND_PATH(ATTICA_INCLUDE_DIR attica/provider.h
   HINTS
   ${PC_ATTICA_INCLUDEDIR}
   ${PC_ATTICA_INCLUDE_DIRS}
   PATH_SUFFIXES attica
   )

FIND_LIBRARY(ATTICA_LIBRARIES NAMES attica libattica
   HINTS
   ${PC_ATTICA_LIBDIR}
   ${PC_ATTICA_LIBRARY_DIRS}
   )

INCLUDE(FindPackageHandleStandardArgs)

# handle the QUIETLY and REQUIRED arguments and set ATTICA_FOUND to TRUE if
# all listed variables are TRUE
FIND_PACKAGE_HANDLE_STANDARD_ARGS(libattica DEFAULT_MSG ATTICA_LIBRARIES ATTICA_INCLUDE_DIR)

MARK_AS_ADVANCED(ATTICA_INCLUDE_DIR ATTICA_LIBRARIES)


