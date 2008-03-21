# - Try to find the Taglib library
# Once done this will define
#
#  TAGLIB_FOUND - system has the taglib library
#  TAGLIB_CFLAGS - the taglib cflags
#  TAGLIB_LIBRARIES - The libraries needed to use taglib

# Copyright (c) 2006, Laurent Montel, <montel@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

if(NOT TAGLIB_MIN_VERSION)
  set(TAGLIB_MIN_VERSION "1.4")
endif(NOT TAGLIB_MIN_VERSION)

IF(NOT WIN32)
    FIND_PROGRAM(TAGLIBCONFIG_EXECUTABLE NAMES taglib-config PATHS
       ${BIN_INSTALL_DIR}
    )
ENDIF(NOT WIN32)
#reset vars
set(TAGLIB_LIBRARIES)
set(TAGLIB_CFLAGS)

# if taglib-config has been found
IF(TAGLIBCONFIG_EXECUTABLE)

  EXEC_PROGRAM(${TAGLIBCONFIG_EXECUTABLE} ARGS --version RETURN_VALUE _return_VALUE OUTPUT_VARIABLE TAGLIB_VERSION)

  if(TAGLIB_VERSION STRLESS "${TAGLIB_MIN_VERSION}")
     MESSAGE(STATUS "TagLib version not found: version searched :${TAGLIB_MIN_VERSION}, found ${TAGLIB_VERSION}")
     SET(TAGLIB_FOUND FALSE)
  else(TAGLIB_VERSION STRLESS "${TAGLIB_MIN_VERSION}")

     EXEC_PROGRAM(${TAGLIBCONFIG_EXECUTABLE} ARGS --libs RETURN_VALUE _return_VALUE OUTPUT_VARIABLE TAGLIB_LIBRARIES)

     EXEC_PROGRAM(${TAGLIBCONFIG_EXECUTABLE} ARGS --cflags RETURN_VALUE _return_VALUE OUTPUT_VARIABLE TAGLIB_CFLAGS)

     IF(TAGLIB_LIBRARIES AND TAGLIB_CFLAGS)
        SET(TAGLIB_FOUND TRUE)
        message(STATUS "Found taglib: ${TAGLIB_LIBRARIES}")
     ENDIF(TAGLIB_LIBRARIES AND TAGLIB_CFLAGS)

     endif(TAGLIB_VERSION STRLESS "${TAGLIB_MIN_VERSION}") 
  MARK_AS_ADVANCED(TAGLIB_CFLAGS TAGLIB_LIBRARIES)
ELSE(TAGLIBCONFIG_EXECUTABLE)
  include(FindLibraryWithDebug)
  include(FindPackageHandleStandardArgs)

  find_path(TAGLIB_INCLUDES
    NAMES
    tag.h
    PATH_SUFFIXES taglib
    PATHS
    ${KDE4_INCLUDE_DIR}
    ${INCLUDE_INSTALL_DIR}
  )

  find_library_with_debug(TAGLIB_LIBRARIES
    WIN32_DEBUG_POSTFIX d
    NAMES tag
    PATHS
    ${KDE4_LIB_DIR}
    ${LIB_INSTALL_DIR}
  )
  
  find_package_handle_standard_args(Taglib DEFAULT_MSG 
                                    TAGLIB_INCLUDES TAGLIB_LIBRARIES)
ENDIF(TAGLIBCONFIG_EXECUTABLE)


if(TAGLIB_FOUND)
  IF(NOT Taglib_FIND_QUIETLY AND TAGLIBCONFIG_EXECUTABLE)
    MESSAGE(STATUS "Taglib found: ${TAGLIB_LIBRARIES}")
  ENDIF(NOT Taglib_FIND_QUIETLY AND TAGLIBCONFIG_EXECUTABLE)
ELSE(TAGLIB_FOUND)
  IF(Taglib_FIND_REQUIRED)
    MESSAGE(FATAL_ERROR "Could not find Taglib")
  ENDIF(Taglib_FIND_REQUIRED)
endif(TAGLIB_FOUND)

