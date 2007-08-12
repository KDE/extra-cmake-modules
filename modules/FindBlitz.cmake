# - Try to find blitz lib
# Once done this will define
#
#  BLITZ_FOUND - system has blitz lib
#  BLITZ_INCLUDES - the blitz include directory
#  BLITZ_LIBRARIES - The libraries needed to use blitz
#
# Copyright (c) 2006, Montel Laurent, <montel@kde.org>
# Copyright (c) 2007, Allen Winter, <winter@kde.org>
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

if (BLITZ_INCLUDES AND BLITZ_LIBRARIES)
  set(Blitz_FIND_QUIETLY TRUE)
endif (BLITZ_INCLUDES AND BLITZ_LIBRARIES)

find_path(BLITZ_INCLUDES
  NAMES
  blitz.h
  PATHS
  ${KDE4_INCLUDE_DIR}
  ${INCLUDE_INSTALL_DIR}
)

FIND_LIBRARY(BLITZ_LIBRARIES
 NAMES
 blitz
 PATHS
 ${KDE4_LIB_DIR}
 ${LIB_INSTALL_DIR}
)

if(BLITZ_INCLUDES AND BLITZ_LIBRARIES)
  set(BLITZ_FOUND TRUE)
endif(BLITZ_INCLUDES AND BLITZ_LIBRARIES)

if(BLITZ_FOUND)
  if(NOT Blitz_FIND_QUIETLY)
    message(STATUS "Found Blitz: ${BLITZ_INCLUDES}")
  endif(NOT Blitz_FIND_QUIETLY)
else(BLITZ_FOUND)
  if(Blitz_FIND_REQUIRED)
    message(FATAL_ERROR "Could NOT find Blitz")
  endif(Blitz_FIND_REQUIRED)
endif(BLITZ_FOUND)

mark_as_advanced(BLITZ_INCLUDES BLITZ_LIBRARIES)
