# - Try to find blitz lib
# Once done this will define
#
#  BLITZ_FOUND - system has blitz lib
#  BLITZ_INCLUDE_DIR - the blitz include directory
#
# Copyright (c) 2006, Montel Laurent, <montel@kde.org>
# Copyright (c) 2007, Allen Winter, <winter@kde.org>
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

if (BLITZ_INCLUDE_DIR)

  # in cache already
  set(BLITZ_FOUND TRUE)

else (BLITZ_INCLUDE_DIR)

find_path(BLITZ_INCLUDE_DIR NAMES blitz.h
     PATHS
     ${INCLUDE_INSTALL_DIR}
   )

if(BLITZ_INCLUDE_DIR)
  set(BLITZ_FOUND TRUE)
endif(BLITZ_INCLUDE_DIR)

if(BLITZ_FOUND)
   if(NOT Blitz_FIND_QUIETLY)
      message(STATUS "Found Blitz: ${BLITZ_INCLUDE_DIR}")
   endif(NOT Blitz_FIND_QUIETLY)
else(BLITZ_FOUND)
   if(Blitz_FIND_REQUIRED)
      message(FATAL_ERROR "Could NOT find Blitz")
   endif(Blitz_FIND_REQUIRED)
endif(BLITZ_FOUND)

mark_as_advanced(BLITZ_INCLUDE_DIR)

endif(BLITZ_INCLUDE_DIR)

