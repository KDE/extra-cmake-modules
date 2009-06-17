# - Try to find the KDEWIN library
# 
# Once done this will define
#
#  KDEWIN_FOUND - system has KDEWIN
#  KDEWIN_INCLUDES - the KDEWIN include directories
#  KDEWIN_LIBRARIES - The libraries needed to use KDEWIN

# Copyright (c) 2006, Alexander Neundorf, <neundorf@kde.org>
# Copyright (c) 2007-2009, Ralf Habacker, <ralf.habacker@freenet.de>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.


if (WIN32)
  if (NOT KDEWIN_LIBRARIES)

    find_path(KDEWIN_INCLUDE_DIR kdewin_export.h
      ${CMAKE_INCLUDE_PATH}
      ${CMAKE_INSTALL_PREFIX}/include
    )
 
    # search for kdewin in the default install directory for applications (default of (n)make install)
    FILE(TO_CMAKE_PATH "${CMAKE_LIBRARY_PATH}" _cmakeLibraryPathCmakeStyle)

    if (CMAKE_BUILD_TYPE STREQUAL "Debug")
        set (LIBRARY_NAME kdewind)
    else (CMAKE_BUILD_TYPE STREQUAL "Debug")
        set (LIBRARY_NAME kdewin)
    endif (CMAKE_BUILD_TYPE STREQUAL "Debug")

    find_library(KDEWIN_LIBRARY
      NAMES ${LIBRARY_NAME}
      PATHS 
        ${_cmakeLibraryPathCmakeStyle}
        ${CMAKE_INSTALL_PREFIX}/lib
      NO_SYSTEM_ENVIRONMENT_PATH
    )

    if (KDEWIN_LIBRARY AND KDEWIN_INCLUDE_DIR)
      set(KDEWIN_FOUND TRUE)
      # add needed system libs
      set(KDEWIN_LIBRARIES ${KDEWIN_LIBRARY} user32 shell32 ws2_32 netapi32 userenv)
  
      if (MINGW)
        #mingw compiler
        set(KDEWIN_INCLUDES ${KDEWIN_INCLUDE_DIR} ${KDEWIN_INCLUDE_DIR}/mingw ${QT_INCLUDES})
      else (MINGW)
        # msvc compiler
        # add the MS SDK include directory if available
        file(TO_CMAKE_PATH "$ENV{MSSDK}" MSSDK_DIR)
        set(KDEWIN_INCLUDES ${KDEWIN_INCLUDE_DIR} ${KDEWIN_INCLUDE_DIR}/msvc  ${QT_INCLUDES} ${MSSDK_DIR})
      endif (MINGW)
  
    endif (KDEWIN_LIBRARY AND KDEWIN_INCLUDE_DIR)
    # required for configure
    set(CMAKE_REQUIRED_INCLUDES ${CMAKE_REQUIRED_INCLUDES} ${KDEWIN_INCLUDES})
    set(CMAKE_REQUIRED_LIBRARIES ${CMAKE_REQUIRED_LIBRARIES} ${KDEWIN_LIBRARIES})      

  endif (NOT KDEWIN_LIBRARIES)

  if (KDEWIN_FOUND)
    if (NOT KDEWIN_FIND_QUIETLY)
      message(STATUS "Found KDEWIN library: ${KDEWIN_LIBRARY}")
    endif (NOT KDEWIN_FIND_QUIETLY)

  else (KDEWIN_FOUND)
    if (KDEWIN_FIND_REQUIRED)
      message(FATAL_ERROR "Could NOT find KDEWIN library\nPlease install it first")
    endif (KDEWIN_FIND_REQUIRED)
  endif (KDEWIN_FOUND)
endif (WIN32)
