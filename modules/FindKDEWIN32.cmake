# - Try to find the KDEWIN32 library
# 
# Once done this will define
#
#  KDEWIN32_FOUND - system has KDEWIN32
#  KDEWIN32_INCLUDES - the KDEWIN32 include directories
#  KDEWIN32_LIBRARIES - The libraries needed to use KDEWIN32
#
# Copyright (c) 2006, Alexander Neundorf, <neundorf@kde.org>
# Copyright (c) 2007, Ralf Habacker, <ralf.habacker@freenet.de>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.


if (WIN32)
  include(FindLibraryWithDebug)

  if (NOT KDEWIN32_DIR)
    if(NOT KDEWIN_FOUND)
      find_package(KDEWIN REQUIRED)
    endif(NOT KDEWIN_FOUND)

    find_path(KDEWIN32_INCLUDE_DIR winposix_export.h
      ${CMAKE_INCLUDE_PATH}
      ${CMAKE_INSTALL_PREFIX}/include
    )
 
    # search for kdewin32 in the default install directory for applications (default of (n)make install)

    find_library_with_debug(KDEWIN32_LIBRARY
      WIN32_DEBUG_POSTFIX d
      NAMES kdewin32
      PATHS 
        ${CMAKE_LIBRARY_PATH}
        ${CMAKE_INSTALL_PREFIX}/lib
      NO_SYSTEM_ENVIRONMENT_PATH
    )

    # kdelibs/win/ has to be built before the rest of kdelibs/
    # eventually it will be moved out from kdelibs/
    if (KDEWIN32_LIBRARY AND KDEWIN32_INCLUDE_DIR)
      set(KDEWIN32_FOUND TRUE)
      # add needed system libs
      set(KDEWIN32_LIBRARIES ${KDEWIN32_LIBRARY} user32 shell32 ws2_32 netapi32 userenv)
  
      if (MINGW)
        #mingw compiler
        set(KDEWIN32_INCLUDES ${KDEWIN32_INCLUDE_DIR} ${KDEWIN32_INCLUDE_DIR}/mingw ${QT_INCLUDES})
      else (MINGW)
        # msvc compiler
        # add the MS SDK include directory if available
        file(TO_CMAKE_PATH "$ENV{MSSDK}" MSSDK_DIR)
        set(KDEWIN32_INCLUDES ${KDEWIN32_INCLUDE_DIR} ${KDEWIN32_INCLUDE_DIR}/msvc  ${QT_INCLUDES} ${MSSDK_DIR})
      endif (MINGW)
  
    endif (KDEWIN32_LIBRARY AND KDEWIN32_INCLUDE_DIR)
    # required for configure
    set(CMAKE_REQUIRED_INCLUDES ${CMAKE_REQUIRED_INCLUDES} ${KDEWIN32_INCLUDES})
    set(CMAKE_REQUIRED_LIBRARIES ${CMAKE_REQUIRED_LIBRARIES} ${KDEWIN32_LIBRARIES})      

  endif (NOT KDEWIN32_DIR)

  if (KDEWIN32_FOUND)
    if (NOT KDEWIN32_FIND_QUIETLY)
      message(STATUS "Found kdewin32 library: ${KDEWIN32_LIBRARY}")
    endif (NOT KDEWIN32_FIND_QUIETLY)

  else (KDEWIN32_FOUND)
    if (KDEWIN32_FIND_REQUIRED)
      message(FATAL_ERROR "Could NOT find KDEWIN32 library\nPlease install it first")
    endif (KDEWIN32_FIND_REQUIRED)
  endif (KDEWIN32_FOUND)
  MACRO (KDE_ADD_RESOURCES2 outfiles )

    FOREACH (it ${ARGN})
      GET_FILENAME_COMPONENT(outfilename ${it} NAME_WE)
      GET_FILENAME_COMPONENT(infile ${it} ABSOLUTE)
      GET_FILENAME_COMPONENT(rc_path ${infile} PATH)
      SET(outfile ${CMAKE_CURRENT_BINARY_DIR}/${outfilename}_res.o)
      #  parse file for dependencies
      FILE(READ "${infile}" _RC_FILE_CONTENTS)
      STRING(REGEX MATCHALL "<file>[^<]*" _RC_FILES "${_RC_FILE_CONTENTS}")
      SET(_RC_DEPENDS)
      FOREACH(_RC_FILE ${_RC_FILES})
        STRING(REGEX REPLACE "^<file>" "" _RC_FILE "${_RC_FILE}")
        SET(_RC_DEPENDS ${_RC_DEPENDS} "${rc_path}/${_RC_FILE}")
      ENDFOREACH(_RC_FILE)
      ADD_CUSTOM_COMMAND(OUTPUT ${outfile}
        COMMAND windres
        ARGS -i ${infile} -o ${outfile} --include-dir=${CMAKE_CURRENT_SOURCE_DIR}
        MAIN_DEPENDENCY ${infile}
        DEPENDS ${_RC_DEPENDS})
      SET(${outfiles} ${${outfiles}} ${outfile})
    ENDFOREACH (it)

  ENDMACRO (KDE_ADD_RESOURCES2)

endif (WIN32)
