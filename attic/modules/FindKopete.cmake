# - Try to find the Kopete library
# Once done this will define
#
#  Kopete_FOUND - system has kopete
#  KOPETE_INCLUDE_DIR - the kopete include directory
#  KOPETE_LIBRARIES - Link these to use kopete

# Copyright (c) 2007 Charles Connell <charles@connells.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

if(KOPETE_INCLUDE_DIR AND KOPETE_LIBRARIES)

  # read from cache
  set(Kopete_FOUND TRUE)

else()

  FIND_PATH(KOPETE_INCLUDE_DIR 
    NAMES
    kopete/kopete_export.h
    PATHS 
    ${KDE4_INCLUDE_DIR}
    ${INCLUDE_INSTALL_DIR}
    )
  
  FIND_LIBRARY(KOPETE_LIBRARIES 
    NAMES
    kopete
    PATHS
    ${KDE4_LIB_DIR}
    ${LIB_INSTALL_DIR}
    )
  if(KOPETE_INCLUDE_DIR AND KOPETE_LIBRARIES)
    set(Kopete_FOUND TRUE)
  endif()

  if(MSVC)
    FIND_LIBRARY(KOPETE_LIBRARIES_DEBUG 
      NAMES
      kopeted
      PATHS
      ${KDE4_LIB_DIR}
      ${LIB_INSTALL_DIR}
      )
    if(NOT KOPETE_LIBRARIES_DEBUG)
      set(Kopete_FOUND FALSE)
    endif()
    
    if(MSVC_IDE)
      if( NOT KOPETE_LIBRARIES_DEBUG OR NOT KOPETE_LIBRARIES)
        message(FATAL_ERROR "\nCould NOT find the debug AND release version of the Kopete library.\nYou need to have both to use MSVC projects.\nPlease build and install both kopete libraries first.\n")
      endif()
    else()
      string(TOLOWER ${CMAKE_BUILD_TYPE} CMAKE_BUILD_TYPE_TOLOWER)
      if(CMAKE_BUILD_TYPE_TOLOWER MATCHES debug)
        set(KOPETE_LIBRARIES ${KOPETE_LIBRARIES_DEBUG})
      else()
        set(KOPETE_LIBRARIES ${KOPETE_LIBRARIES})
      endif()
    endif()
  endif()

  if(Kopete_FOUND)
    if(NOT Kopete_FIND_QUIETLY)
      message(STATUS "Found Kopete: ${KOPETE_LIBRARIES}")
    endif()
  else()
    if(Kopete_FIND_REQUIRED)
      if(NOT KOPETE_INCLUDE_DIR)
	message(FATAL_ERROR "Could not find Kopete includes.")
      endif()
      if(NOT KOPETE_LIBRARIES)
	message(FATAL_ERROR "Could not find Kopete library.")
      endif()
    else()
      if(NOT KOPETE_INCLUDE_DIR)
        message(STATUS "Could not find Kopete includes.")
      endif()
      if(NOT KOPETE_LIBRARIES)
        message(STATUS "Could not find Kopete library.")
      endif()
    endif()
  endif()

endif()
