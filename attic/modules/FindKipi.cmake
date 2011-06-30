# - Try to find the Kipi library
#
# If you have put a local version of libkipi into your source tree,
# set KIPI_LOCAL_DIR to the relative path to the local directory.
#
# Once done this will define
#
#  KIPI_FOUND - system has libkipi
#  KIPI_INCLUDE_DIR - the libkipi include directory
#  KIPI_LIBRARIES - Link these to use libkipi
#  KIPI_DEFINITIONS - Compiler switches required for using libkipi
#

# Copyright (c) 2008, Gilles Caulier, <caulier.gilles@gmail.com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

if (KIPI_INCLUDE_DIR AND KIPI_LIBRARIES AND KIPI_DEFINITIONS)

  message(STATUS "Found Kipi library in cache: ${KIPI_LIBRARIES}")

  # in cache already
  set(KIPI_FOUND TRUE)

else (KIPI_INCLUDE_DIR AND KIPI_LIBRARIES AND KIPI_DEFINITIONS)

  message(STATUS "Check Kipi library in local sub-folder...")

  # Check if library is not in local sub-folder

  if (KIPI_LOCAL_DIR)
    set (KIPI_LOCAL_FOUND TRUE)
  else (KIPI_LOCAL_DIR)
    find_file(KIPI_LOCAL_FOUND libkipi/kipi.h ${CMAKE_SOURCE_DIR}/libkipi ${CMAKE_SOURCE_DIR}/libs/libkipi NO_DEFAULT_PATH)

    if (KIPI_LOCAL_FOUND)
      # Was it found in libkdcraw/ or in libs/libkdcraw?
      find_file(KIPI_LOCAL_FOUND_IN_LIBS libkipi/kipi.h ${CMAKE_SOURCE_DIR}/libs/libkipi NO_DEFAULT_PATH)
      if (KIPI_LOCAL_FOUND_IN_LIBS)
        set(KIPI_LOCAL_DIR libs/libkipi)
      else (KIPI_LOCAL_FOUND_IN_LIBS)
        set(KIPI_LOCAL_DIR libkipi)
      endif (KIPI_LOCAL_FOUND_IN_LIBS)
    endif (KIPI_LOCAL_FOUND)
  endif (KIPI_LOCAL_DIR)

  if (KIPI_LOCAL_FOUND)
    # we need two include directories: because the version.h file is put into the build directory
    # TODO KIPI_INCLUDE_DIR sounds like it should contain only one directory...
    set(KIPI_INCLUDE_DIR ${CMAKE_SOURCE_DIR}/${KIPI_LOCAL_DIR} ${CMAKE_BINARY_DIR}/${KIPI_LOCAL_DIR})
    set(KIPI_DEFINITIONS "-I${CMAKE_SOURCE_DIR}/${KIPI_LOCAL_DIR}" "-I${CMAKE_BINARY_DIR}/${KIPI_LOCAL_DIR}")
    set(KIPI_LIBRARIES kipi)
    message(STATUS "Found Kipi library in local sub-folder: ${CMAKE_SOURCE_DIR}/${KIPI_LOCAL_DIR}")
    set(KIPI_FOUND TRUE)
    mark_as_advanced(KIPI_INCLUDE_DIR KIPI_LIBRARIES KIPI_DEFINITIONS)

  else (KIPI_LOCAL_FOUND)

    if (NOT WIN32)
      message(STATUS "Check Kipi library using pkg-config...")

      # use pkg-config to get the directories and then use these values
      # in the FIND_PATH() and FIND_LIBRARY() calls
      include(UsePkgConfig)

      PKGCONFIG(libkipi _KIPIIncDir _KIPILinkDir _KIPILinkFlags _KIPICflags)

      if (_KIPILinkFlags)
        # query pkg-config asking for a libkipi >= 0.2.0
        exec_program(${PKGCONFIG_EXECUTABLE} ARGS --atleast-version=0.2.0 libkipi RETURN_VALUE _return_VALUE OUTPUT_VARIABLE _pkgconfigDevNull )
        if (_return_VALUE STREQUAL "0")
            message(STATUS "Found libkipi release >= 0.2.0")
            set(KIPI_VERSION_GOOD_FOUND TRUE)
        else (_return_VALUE STREQUAL "0")
            message(STATUS "Found libkipi release < 0.2.0, too old")
            set(KIPI_VERSION_GOOD_FOUND FALSE)
            set(KIPI_FOUND FALSE)
        endif (_return_VALUE STREQUAL "0")
      else (_KIPILinkFlags)
        set(KIPI_VERSION_GOOD_FOUND FALSE)
        set(KIPI_FOUND FALSE)
      endif (_KIPILinkFlags)
    else (NOT WIN32)
      set(KIPI_VERSION_GOOD_FOUND TRUE)
    endif (NOT WIN32)
    if (KIPI_VERSION_GOOD_FOUND)
        set(KIPI_DEFINITIONS ${_KIPICflags})

        find_path(KIPI_INCLUDE_DIR NAMES libkipi/version.h PATHS ${KDE4_INCLUDE_DIR} ${_KIPIIncDir})
        find_library(KIPI_LIBRARIES NAMES kipi PATHS ${KDE4_LIB_DIR} ${_KIPILinkDir})

        if (KIPI_INCLUDE_DIR AND KIPI_LIBRARIES)
            set(KIPI_FOUND TRUE)
        endif (KIPI_INCLUDE_DIR AND KIPI_LIBRARIES)
      endif (KIPI_VERSION_GOOD_FOUND)
      if (KIPI_FOUND)
          if (NOT Kipi_FIND_QUIETLY)
              message(STATUS "Found libkipi: ${KIPI_LIBRARIES}")
          endif (NOT Kipi_FIND_QUIETLY)
      else (KIPI_FOUND)
          if (Kipi_FIND_REQUIRED)
              if (NOT KIPI_INCLUDE_DIR)
                  message(FATAL_ERROR "Could NOT find libkipi header files")
              endif (NOT KIPI_INCLUDE_DIR)
              if (NOT KIPI_LIBRARIES)
                  message(FATAL_ERROR "Could NOT find libkipi library")
              endif (NOT KIPI_LIBRARIES)
          endif (Kipi_FIND_REQUIRED)
      endif (KIPI_FOUND)

    mark_as_advanced(KIPI_INCLUDE_DIR KIPI_LIBRARIES KIPI_DEFINITIONS)

  endif (KIPI_LOCAL_FOUND)
  
endif (KIPI_INCLUDE_DIR AND KIPI_LIBRARIES AND KIPI_DEFINITIONS)
