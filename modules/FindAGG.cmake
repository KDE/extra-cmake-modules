# - Try to find the AGG graphics library
# Once done this will define
#
#  AGG_FOUND - system has AGG
#  AGG_INCLUDE_DIR - the AGG include directory
#  AGG_LIBRARIES - Link these to use AGG
#  AGG_DEFINITIONS - Compiler switches required for using AGG

# Copyright (c) 2006, Alexander Neundorf, <neundorf@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

if (AGG_INCLUDE_DIR AND AGG_LIBRARIES)

  # in cache already
  SET(AGG_FOUND TRUE)

else (AGG_INCLUDE_DIR AND AGG_LIBRARIES)
IF (NOT WIN32)
  # use pkg-config to get the directories and then use these values
  # in the FIND_PATH() and FIND_LIBRARY() calls
  INCLUDE(UsePkgConfig)
  
  PKGCONFIG(libagg _AGGIncDir _AGGLinkDir _AGGLinkFlags _AGGCflags)
  
  set(AGG_DEFINITIONS ${_AGGCflags})
ENDIF (NOT WIN32)  
  FIND_PATH(AGG_INCLUDE_DIR agg2/agg_pixfmt_gray.h
    ${_AGGIncDir}
  )
  
  FIND_LIBRARY(AGG_LIBRARIES NAMES agg
    PATHS
    ${_AGGLinkDir}
  )
  
  if (AGG_INCLUDE_DIR AND AGG_LIBRARIES)
     set(AGG_FOUND TRUE)
  endif (AGG_INCLUDE_DIR AND AGG_LIBRARIES)
  
  if (AGG_FOUND)
    if (NOT AGG_FIND_QUIETLY)
      message(STATUS "Found AGG: ${AGG_LIBRARIES}")
    endif (NOT AGG_FIND_QUIETLY)
  else (AGG_FOUND)
    if (AGG_FIND_REQUIRED)
      message(FATAL_ERROR "Could NOT find AGG")
    endif (AGG_FIND_REQUIRED)
  endif (AGG_FOUND)
  
  MARK_AS_ADVANCED(AGG_INCLUDE_DIR AGG_LIBRARIES)
  
endif (AGG_INCLUDE_DIR AND AGG_LIBRARIES)
