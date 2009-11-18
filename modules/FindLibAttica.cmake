# Try to find the Attica library
# Once done this will define
#
#   LIBATTICA_FOUND          Indicates that Attica was found
#   LIBATTICA_LIBRARIES      Libraries needed to use Attica
#   LIBATTICA_LIBRARY_DIRS   Paths needed for linking against Attica
#   LIBATTICA_INCLUDE_DIRS   Paths needed for finding Attica include files
#
# Copyright (c) 2009 Frederik Gladhorn <gladhorn@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.

IF (LIBATTICA_INCLUDE_DIR AND LIBATTICA_LIBRARIES)
   # in cache already
   SET(libattica_FIND_QUIETLY TRUE)
ENDIF (LIBATTICA_INCLUDE_DIR AND LIBATTICA_LIBRARIES)

IF (NOT WIN32)
   # use pkg-config to get the directories and then use these values
   # in the FIND_PATH() and FIND_LIBRARY() calls
   FIND_PACKAGE(PkgConfig)
   PKG_CHECK_MODULES(PC_LIBATTICA QUIET libattica-0.1)
   SET(LIBATTICA_DEFINITIONS ${PC_ATTICA_CFLAGS_OTHER})
ENDIF (NOT WIN32)

FIND_PATH(LIBATTICA_INCLUDE_DIR attica/provider.h
   HINTS
   ${PC_LIBATTICA_INCLUDEDIR}
   ${PC_LIBATTICA_INCLUDE_DIRS}
   PATH_SUFFIXES attica
   )

FIND_LIBRARY(LIBATTICA_LIBRARIES NAMES attica libattica
   HINTS
   ${PC_LIBATTICA_LIBDIR}
   ${PC_LIBATTICA_LIBRARY_DIRS}
   )

INCLUDE(FindPackageHandleStandardArgs)

# handle the QUIETLY and REQUIRED arguments and set ATTICA_FOUND to TRUE if
# all listed variables are TRUE
FIND_PACKAGE_HANDLE_STANDARD_ARGS(libattica DEFAULT_MSG LIBATTICA_LIBRARIES LIBATTICA_INCLUDE_DIR)

MARK_AS_ADVANCED(LIBATTICA_INCLUDE_DIR LIBATTICA_LIBRARIES)


