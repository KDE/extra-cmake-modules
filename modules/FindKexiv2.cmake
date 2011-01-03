# - Try to find the KExiv2 library
#
# If you have put a local version of libkexiv2 into your source tree,
# set KEXIV2_LOCAL_DIR to the relative path to the local directory.
#
# Once done this will define
#
#  KEXIV2_FOUND - system has libkexiv2
#  KEXIV2_INCLUDE_DIR - the libkexiv2 include directory
#  KEXIV2_LIBRARIES - Link these to use libkexiv2
#  KEXIV2_DEFINITIONS - Compiler switches required for using libkexiv2
#

# Copyright (c) 2008, Gilles Caulier, <caulier.gilles@gmail.com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

if (KEXIV2_INCLUDE_DIR AND KEXIV2_LIBRARIES AND KEXIV2_DEFINITIONS)

  message(STATUS "Found Kexiv2 library in cache: ${KEXIV2_LIBRARIES}")

  # in cache already
  set(KEXIV2_FOUND TRUE)

else (KEXIV2_INCLUDE_DIR AND KEXIV2_LIBRARIES AND KEXIV2_DEFINITIONS)

  message(STATUS "Check Kexiv2 library in local sub-folder...")

  # Check if library is not in local sub-folder

  if (KEXIV2_LOCAL_DIR)
    set(KEXIV2_LOCAL_FOUND TRUE)
  else (KEXIV2_LOCAL_DIR)
    find_file(KEXIV2_LOCAL_FOUND libkexiv2/version.h.cmake ${CMAKE_SOURCE_DIR}/libkexiv2 ${CMAKE_SOURCE_DIR}/libs/libkexiv2 NO_DEFAULT_PATH)

    if (KEXIV2_LOCAL_FOUND)
      # Was it found in libkexiv2/ or in libs/libkexiv2?
      find_file(KEXIV2_LOCAL_FOUND_IN_LIBS libkexiv2/version.h.cmake ${CMAKE_SOURCE_DIR}/libs/libkexiv2 NO_DEFAULT_PATH)
      if (KEXIV2_LOCAL_FOUND_IN_LIBS)
        set(KEXIV2_LOCAL_DIR libs/libkexiv2)
      else (KEXIV2_LOCAL_FOUND_IN_LIBS)
        set(KEXIV2_LOCAL_DIR libkexiv2)
      endif (KEXIV2_LOCAL_FOUND_IN_LIBS)
    endif (KEXIV2_LOCAL_FOUND)

  endif (KEXIV2_LOCAL_DIR)

  if (KEXIV2_LOCAL_FOUND)
    # we need two include directories: because the version.h file is put into the build directory
    # TODO KEXIV2_INCLUDE_DIR sounds like it should contain only one directory...
    set(KEXIV2_INCLUDE_DIR ${CMAKE_SOURCE_DIR}/${KEXIV2_LOCAL_DIR} ${CMAKE_BINARY_DIR}/${KEXIV2_LOCAL_DIR})
    set(KEXIV2_DEFINITIONS "-I${CMAKE_SOURCE_DIR}/${KEXIV2_LOCAL_DIR}" "-I${CMAKE_BINARY_DIR}/${KEXIV2_LOCAL_DIR}")
    set(KEXIV2_LIBRARIES kexiv2)
    message(STATUS "Found Kexiv2 library in local sub-folder: ${CMAKE_SOURCE_DIR}/${KEXIV2_LOCAL_DIR}")
    set(KEXIV2_FOUND TRUE)
    mark_as_advanced(KEXIV2_INCLUDE_DIR KEXIV2_LIBRARIES KEXIV2_DEFINITIONS)

  else(KEXIV2_LOCAL_FOUND)
    if(NOT WIN32) 
      message(STATUS "Check Kexiv2 library using pkg-config...")

      # use pkg-config to get the directories and then use these values
      # in the FIND_PATH() and FIND_LIBRARY() calls
      include(UsePkgConfig)
    
      PKGCONFIG(libkexiv2 _KEXIV2IncDir _KEXIV2LinkDir _KEXIV2LinkFlags _KEXIV2Cflags)
    
      if(_KEXIV2LinkFlags)
        # query pkg-config asking for a libkexiv2 >= 0.2.0
        exec_program(${PKGCONFIG_EXECUTABLE} ARGS --atleast-version=0.2.0 libkexiv2 RETURN_VALUE _return_VALUE OUTPUT_VARIABLE _pkgconfigDevNull )
        if(_return_VALUE STREQUAL "0")
            message(STATUS "Found libkexiv2 release >= 0.2.0")
            set(KEXIV2_VERSION_GOOD_FOUND TRUE)
        else(_return_VALUE STREQUAL "0")
            message(STATUS "Found libkexiv2 release < 0.2.0, too old")
            set(KEXIV2_VERSION_GOOD_FOUND FALSE)
            set(KEXIV2_FOUND FALSE)
        endif(_return_VALUE STREQUAL "0")
      else(_KEXIV2LinkFlags)
        set(KEXIV2_VERSION_GOOD_FOUND FALSE)
        set(KEXIV2_FOUND FALSE)
      endif(_KEXIV2LinkFlags)
    else(NOT WIN32)
      set(KEXIV2_VERSION_GOOD_FOUND TRUE)
    endif(NOT WIN32)

    if(KEXIV2_VERSION_GOOD_FOUND)
        set(KEXIV2_DEFINITIONS "${_KEXIV2Cflags}")
    
        find_path(KEXIV2_INCLUDE_DIR libkexiv2/version.h
        ${_KEXIV2IncDir}
        )
    
        find_library(KEXIV2_LIBRARIES NAMES kexiv2
        PATHS
        ${_KEXIV2LinkDir}
        )
    
        if (KEXIV2_INCLUDE_DIR AND KEXIV2_LIBRARIES)
            set(KEXIV2_FOUND TRUE)
        endif (KEXIV2_INCLUDE_DIR AND KEXIV2_LIBRARIES)
      endif(KEXIV2_VERSION_GOOD_FOUND) 
      if (KEXIV2_FOUND)
          if (NOT Kexiv2_FIND_QUIETLY)
              message(STATUS "Found libkexiv2: ${KEXIV2_LIBRARIES}")
          endif (NOT Kexiv2_FIND_QUIETLY)
      else (KEXIV2_FOUND)
          if (Kexiv2_FIND_REQUIRED)
              if (NOT KEXIV2_INCLUDE_DIR)
                  message(FATAL_ERROR "Could NOT find libkexiv2 header files")
              endif (NOT KEXIV2_INCLUDE_DIR)
              if (NOT KEXIV2_LIBRARIES)
                  message(FATAL_ERROR "Could NOT find libkexiv2 library")
              endif (NOT KEXIV2_LIBRARIES)
          endif (Kexiv2_FIND_REQUIRED)
      endif (KEXIV2_FOUND)
    
    mark_as_advanced(KEXIV2_INCLUDE_DIR KEXIV2_LIBRARIES KEXIV2_DEFINITIONS)

  endif(KEXIV2_LOCAL_FOUND)
  
endif (KEXIV2_INCLUDE_DIR AND KEXIV2_LIBRARIES AND KEXIV2_DEFINITIONS)
