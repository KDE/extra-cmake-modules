# Try to find the OpenEXR libraries
# This check defines:
#
#  OPENEXR_FOUND - system has OpenEXR
#  OPENEXR_INCLUDE_DIR - OpenEXR include directory
#  OPENEXR_LIBRARIES - Libraries needed to use OpenEXR
#
# Copyright (c) 2006, Alexander Neundorf, <neundorf@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.


if (OPENEXR_INCLUDE_DIR AND OPENEXR_LIBRARIES)
  # in cache already
  SET(OPENEXR_FOUND TRUE)

else (OPENEXR_INCLUDE_DIR AND OPENEXR_LIBRARIES)
IF (NOT WIN32)
  # use pkg-config to get the directories and then use these values
  # in the FIND_PATH() and FIND_LIBRARY() calls
  INCLUDE(UsePkgConfig)
  
  PKGCONFIG(OpenEXR _OpenEXRIncDir _OpenEXRLinkDir _OpenEXRLinkFlags _OpenEXRCflags)
ENDIF (NOT WIN32)  
  FIND_PATH(OPENEXR_INCLUDE_DIR ImfRgbaFile.h
     ${_OpenEXRIncDir}
     ${_OpenEXRIncDir}/OpenEXR/
     /usr/include
     /usr/local/include
  )
  
  FIND_LIBRARY(OPENEXR_HALF_LIBRARY NAMES Half
    PATHS
    ${_OPENEXRLinkDir}
    /usr/lib
    /usr/local/lib
  )
  
  
  FIND_LIBRARY(OPENEXR_IEX_LIBRARY NAMES Iex
    PATHS
    ${_OPENEXRLinkDir}
    /usr/lib
    /usr/local/lib
  )
  
  FIND_LIBRARY(OPENEXR_IMATH_LIBRARY NAMES Imath
    PATHS
    ${_OPENEXRLinkDir}
    /usr/lib
    /usr/local/lib
  )
  
  
  FIND_LIBRARY(OPENEXR_ILMIMF_LIBRARY NAMES IlmImf 
    PATHS
    ${_OPENEXRLinkDir}
    /usr/lib
    /usr/local/lib
  )
  
  if (OPENEXR_INCLUDE_DIR AND OPENEXR_IMATH_LIBRARY AND OPENEXR_ILMIMF_LIBRARY AND OPENEXR_IEX_LIBRARY AND OPENEXR_HALF_LIBRARY)
     set(OPENEXR_FOUND TRUE)
     set(OPENEXR_LIBRARIES ${OPENEXR_IMATH_LIBRARY} ${OPENEXR_ILMIMF_LIBRARY} ${OPENEXR_IEX_LIBRARY} ${OPENEXR_HALF_LIBRARY} CACHE STRING "The libraries needed to use OpenEXR")
  endif (OPENEXR_INCLUDE_DIR AND OPENEXR_IMATH_LIBRARY AND OPENEXR_ILMIMF_LIBRARY AND OPENEXR_IEX_LIBRARY AND OPENEXR_HALF_LIBRARY)
  
  
  
  if (OPENEXR_FOUND)
    if (NOT OpenEXR_FIND_QUIETLY)
      message(STATUS "Found OPENEXR: ${OPENEXR_LIBRARIES}")
    endif (NOT OpenEXR_FIND_QUIETLY)
  else (OPENEXR_FOUND)
    if (OpenEXR_FIND_REQUIRED)
      message(FATAL_ERROR "Could NOT find OPENEXR")
    endif (OpenEXR_FIND_REQUIRED)
  endif (OPENEXR_FOUND)
  
  MARK_AS_ADVANCED(
     OPENEXR_INCLUDE_DIR 
     OPENEXR_LIBRARIES 
     OPENEXR_ILMIMF_LIBRARY 
     OPENEXR_IMATH_LIBRARY 
     OPENEXR_IEX_LIBRARY 
     OPENEXR_HALF_LIBRARY )
  
endif (OPENEXR_INCLUDE_DIR AND OPENEXR_LIBRARIES)
