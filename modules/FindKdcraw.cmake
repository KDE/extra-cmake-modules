# - Try to find the Kdcraw library
#
# If you have put a local version of libkdcraw into your source tree,
# set KDCRAW_LOCAL_DIR to the relative path to the local directory.
#
# Once done this will define
#
#  KDCRAW_FOUND - system has libkdcraw
#  KDCRAW_INCLUDE_DIR - the libkdcraw include directory
#  KDCRAW_LIBRARIES - Link these to use libkdcraw
#  KDCRAW_DEFINITIONS - Compiler switches required for using libkdcraw
#

# Copyright (c) 2008, Gilles Caulier, <caulier.gilles@gmail.com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.


if (KDCRAW_INCLUDE_DIR AND KDCRAW_LIBRARIES AND KDCRAW_DEFINITIONS)

  message(STATUS "Found Kdcraw library in cache: ${KDCRAW_LIBRARIES}")

  # in cache already
  set(KDCRAW_FOUND TRUE)

else (KDCRAW_INCLUDE_DIR AND KDCRAW_LIBRARIES AND KDCRAW_DEFINITIONS)

  message(STATUS "Check Kdcraw library in local sub-folder...")

  # Check if library is not in local sub-folder

  if (KDCRAW_LOCAL_DIR)
    set (KDCRAW_LOCAL_FOUND TRUE)
  else (KDCRAW_LOCAL_DIR)
    find_file(KDCRAW_LOCAL_FOUND libkdcraw/kdcraw.h ${CMAKE_SOURCE_DIR}/libkdcraw ${CMAKE_SOURCE_DIR}/libs/libkdcraw NO_DEFAULT_PATH)

    if (KDCRAW_LOCAL_FOUND)
      # Was it found in libkdcraw/ or in libs/libkdcraw?
      find_file(KDCRAW_LOCAL_FOUND_IN_LIBS libkdcraw/kdcraw.h ${CMAKE_SOURCE_DIR}/libs/libkdcraw NO_DEFAULT_PATH)
      if (KDCRAW_LOCAL_FOUND_IN_LIBS)
        set(KDCRAW_LOCAL_DIR libs/libkdcraw)
      else (KDCRAW_LOCAL_FOUND_IN_LIBS)
        set(KDCRAW_LOCAL_DIR libkdcraw)
      endif (KDCRAW_LOCAL_FOUND_IN_LIBS)
    endif (KDCRAW_LOCAL_FOUND)
  endif (KDCRAW_LOCAL_DIR)

  if (KDCRAW_LOCAL_FOUND)

    # we need two include directories: because the version.h file is put into the build directory
    # TODO KDCRAW_INCLUDE_DIR sounds like it should contain only one directory...
    set(KDCRAW_INCLUDE_DIR ${CMAKE_SOURCE_DIR}/${KDCRAW_LOCAL_DIR} ${CMAKE_BINARY_DIR}/${KDCRAW_LOCAL_DIR})
    set(KDCRAW_DEFINITIONS "-I${CMAKE_SOURCE_DIR}/${KDCRAW_LOCAL_DIR}" "-I${CMAKE_BINARY_DIR}/${KDCRAW_LOCAL_DIR}")
    set(KDCRAW_LIBRARIES kdcraw)
    message(STATUS "Found Kdcraw library in local sub-folder: ${CMAKE_SOURCE_DIR}/${KDCRAW_LOCAL_DIR}")
    set(KDCRAW_FOUND TRUE)
    mark_as_advanced(KDCRAW_INCLUDE_DIR KDCRAW_LIBRARIES KDCRAW_DEFINITIONS)

  else(KDCRAW_LOCAL_FOUND)

    message(STATUS "Check Kdcraw library using pkg-config...")
    if (NOT WIN32)
      # use pkg-config to get the directories and then use these values
      # in the FIND_PATH() and FIND_LIBRARY() calls
      include(UsePkgConfig)
    
      PKGCONFIG(libkdcraw _KDCRAWIncDir _KDCRAWLinkDir _KDCRAWLinkFlags _KDCRAWCflags)
    
      if (_KDCRAWLinkFlags)
        # query pkg-config asking for a libkdcraw >= 0.2.0
        exec_program(${PKGCONFIG_EXECUTABLE} ARGS --atleast-version=0.2.0 libkdcraw RETURN_VALUE _return_VALUE OUTPUT_VARIABLE _pkgconfigDevNull )
        if (_return_VALUE STREQUAL "0")
            message(STATUS "Found libkdcraw release >= 0.2.0")
            set(KDCRAW_VERSION_GOOD_FOUND TRUE)
        else (_return_VALUE STREQUAL "0")
            message(STATUS "Found libkdcaw release < 0.2.0, too old")
            set(KDCRAW_VERSION_GOOD_FOUND FALSE)
            set(KDCRAW_FOUND FALSE)
        endif (_return_VALUE STREQUAL "0")
      else (_KDCRAWLinkFlags)
        set(KDCRAW_VERSION_GOOD_FOUND FALSE)
        set(KDCRAW_FOUND FALSE)
      endif (_KDCRAWLinkFlags)
    else (NOT WIN32)
      set(KDCRAW_VERSION_GOOD_FOUND TRUE)
    endif (NOT WIN32)

    if (KDCRAW_VERSION_GOOD_FOUND)
        set(KDCRAW_DEFINITIONS "${_KDCRAWCflags}")
    
        find_path(KDCRAW_INCLUDE_DIR libkdcraw/version.h
        ${_KDCRAWIncDir}
        )
    
        find_library(KDCRAW_LIBRARIES NAMES kdcraw
        PATHS
        ${_KDCRAWLinkDir}
        )
    
        if (KDCRAW_INCLUDE_DIR AND KDCRAW_LIBRARIES)
            set(KDCRAW_FOUND TRUE)
        endif (KDCRAW_INCLUDE_DIR AND KDCRAW_LIBRARIES)
     endif (KDCRAW_VERSION_GOOD_FOUND) 
     if (KDCRAW_FOUND)
         if (NOT Kdcraw_FIND_QUIETLY)
             message(STATUS "Found libkdcraw: ${KDCRAW_LIBRARIES}")
         endif (NOT Kdcraw_FIND_QUIETLY)
     else (KDCRAW_FOUND)
         if (Kdcraw_FIND_REQUIRED)
             if (NOT KDCRAW_INCLUDE_DIR)
                 message(FATAL_ERROR "Could NOT find libkdcraw header files")
             endif (NOT KDCRAW_INCLUDE_DIR)
             if (NOT KDCRAW_LIBRARIES)
                 message(FATAL_ERROR "Could NOT find libkdcraw library")
             endif (NOT KDCRAW_LIBRARIES)
         endif (Kdcraw_FIND_REQUIRED)
     endif (KDCRAW_FOUND)
    
    mark_as_advanced(KDCRAW_INCLUDE_DIR KDCRAW_LIBRARIES KDCRAW_DEFINITIONS)

  endif(KDCRAW_LOCAL_FOUND)
  
endif (KDCRAW_INCLUDE_DIR AND KDCRAW_LIBRARIES AND KDCRAW_DEFINITIONS)
