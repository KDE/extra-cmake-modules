# - Try to find HSPELL
# Once done this will define
#
#  HSPELL_FOUND - system has HSPELL
#  HSPELL_INCLUDE_DIR - the HSPELL include directory
#  HSPELL_LIBRARIES - The libraries needed to use HSPELL
#  HSPELL_DEFINITIONS - Compiler switches required for using HSPELL
#
# Copyright (c) 2006, Alexander Neundorf, <neundorf@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.


if (HSPELL_INCLUDE_DIR AND HSPELL_LIBRARIES)
  # Already in cache, be silent
  set(HSPELL_FIND_QUIETLY TRUE)
endif (HSPELL_INCLUDE_DIR AND HSPELL_LIBRARIES)


FIND_PATH(HSPELL_INCLUDE_DIR hspell.h
  /usr/include
  /usr/local/include
)

FIND_LIBRARY(HSPELL_LIBRARIES NAMES hspell
  PATHS
  /usr/lib
  /usr/local/lib
)

if (HSPELL_INCLUDE_DIR AND HSPELL_LIBRARIES)
   set(HSPELL_FOUND TRUE)
endif (HSPELL_INCLUDE_DIR AND HSPELL_LIBRARIES)

if (HSPELL_FOUND)
  if (NOT HSPELL_FIND_QUIETLY)
    message(STATUS "Found HSPELL: ${HSPELL_LIBRARIES}")
  endif (NOT HSPELL_FIND_QUIETLY)
else (HSPELL_FOUND)
  if (HSPELL_FIND_REQUIRED)
    message(FATAL_ERROR "Could NOT find HSPELL")
  endif (HSPELL_FIND_REQUIRED)
endif (HSPELL_FOUND)

MARK_AS_ADVANCED(HSPELL_INCLUDE_DIR HSPELL_LIBRARIES)

