# - Try to find the Taglib library
# Once done this will define
#
#  TAGLIB_FOUND - system has the taglib library
#  TAGLIB_CFLAGS - the taglib cflags
#  TAGLIB_LIBRARIES - The libraries needed to use taglib
#
# Copyright (c) 2006, Laurent Montel, <montel@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.


FIND_PROGRAM(TAGLIBCONFIG_EXECUTABLE NAMES taglib-config PATHS
   /usr/bin
   /usr/local/bin
)

#reset vars
set(TAGLIB_LIBRARIES)
set(TAGLIB_CFLAGS)

# if taglib-config has been found
IF(TAGLIBCONFIG_EXECUTABLE)

  EXEC_PROGRAM(${TAGLIBCONFIG_EXECUTABLE} ARGS --libs RETURN_VALUE _return_VALUE OUTPUT_VARIABLE TAGLIB_LIBRARIES)

  EXEC_PROGRAM(${TAGLIBCONFIG_EXECUTABLE} ARGS --cflags RETURN_VALUE _return_VALUE OUTPUT_VARIABLE TAGLIB_CFLAGS)

  IF(TAGLIB_LIBRARIES AND TAGLIB_CFLAGS)
    SET(TAGLIB_FOUND TRUE)
    message(STATUS "Found taglib: ${TAGLIB_LIBRARIES}")
  ENDIF(TAGLIB_LIBRARIES AND TAGLIB_CFLAGS)

  MARK_AS_ADVANCED(TAGLIB_CFLAGS TAGLIB_LIBRARIES)

ENDIF(TAGLIBCONFIG_EXECUTABLE)
