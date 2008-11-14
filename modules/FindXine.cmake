# - Try to find the XINE  library
# Once done this will define
#
#  XINE_FOUND - system has the XINE library
#  XINE_VERSION - XINE version
#  XINE_BUGFIX_VERSION - the XINE bugfix version
#  XINE_INCLUDE_DIR - the XINE include directory
#  XINE_LIBRARY - The libraries needed to use XINE
#  XINE_XCB_FOUND - libxine can use XCB for video output

# Copyright (c) 2006,2007 Laurent Montel, <montel@kde.org>
# Copyright (c) 2006, Matthias Kretz, <kretz@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

if (XINE_INCLUDE_DIR AND XINE_LIBRARY)
  # Already in cache, be silent
  set(Xine_FIND_QUIETLY TRUE)
endif (XINE_INCLUDE_DIR AND XINE_LIBRARY)
  IF (NOT WIN32)
	INCLUDE(UsePkgConfig)
	PKGCONFIG(libxine _LibXineIncDir _LibXineLinkDir _LibXineLinkFlags _LibXineCflags)
	EXEC_PROGRAM(${PKGCONFIG_EXECUTABLE} ARGS "--variable=prefix libxine" OUTPUT_VARIABLE _LibXinePrefix)
  ENDIF (NOT WIN32)
FIND_PATH(XINE_INCLUDE_DIR NAMES xine.h 
    PATHS 
    ${_LibXineIncDir} 
    NO_DEFAULT_PATH)

FIND_LIBRARY(XINE_LIBRARY NAMES xine
 PATHS
  ${_LibXineLinkDir}
 NO_DEFAULT_PATH
)

FIND_PROGRAM(XINECONFIG_EXECUTABLE NAMES xine-config PATHS
   ${_LibXinePrefix}/bin
)

if (XINE_INCLUDE_DIR AND XINE_LIBRARY AND XINECONFIG_EXECUTABLE)
   EXEC_PROGRAM(${XINECONFIG_EXECUTABLE} ARGS --version RETURN_VALUE _return_VALUE OUTPUT_VARIABLE XINE_VERSION)
   macro_ensure_version(1.1.1 ${XINE_VERSION} XINE_VERSION_OK)
   if (XINE_VERSION_OK)
      set(XINE_FOUND TRUE)
      string(REGEX REPLACE "[0-9].[0-9]." "" XINE_BUGFIX_VERSION ${XINE_VERSION})
   endif (XINE_VERSION_OK)
endif (XINE_INCLUDE_DIR AND XINE_LIBRARY AND XINECONFIG_EXECUTABLE)


if( XINE_FOUND )
  INCLUDE(CheckCSourceCompiles)
  SET(CMAKE_REQUIRED_INCLUDES ${XINE_INCLUDE_DIR})
  SET(CMAKE_REQUIRED_LIBRARIES ${XINE_LIBRARY})
  CHECK_C_SOURCE_COMPILES("#include <xine.h>\nint main()\n{\n  xine_open_video_driver(xine_new(), \"auto\", XINE_VISUAL_TYPE_XCB, NULL);\n  return 0;\n}\n" XINE_XCB_FOUND)
endif(XINE_FOUND)

if (XINE_FOUND)
   if (NOT Xine_FIND_QUIETLY)
      message(STATUS "Found XINE: ${XINE_LIBRARY}")
   endif (NOT Xine_FIND_QUIETLY)
   #   if(XINECONFIG_EXECUTABLE)
   #      EXEC_PROGRAM(${XINECONFIG_EXECUTABLE} ARGS --plugindir RETURN_VALUE _return_VALUE OUTPUT_VARIABLE XINEPLUGINSDIR)
   #      MESSAGE(STATUS "XINEPLUGINSDIR :<${XINEPLUGINSDIR}>")
   #   endif(XINECONFIG_EXECUTABLE)
else (XINE_FOUND)
   if (Xine_FIND_REQUIRED)
      message(FATAL_ERROR "Could NOT find XINE 1.1.1 or greater")
   endif (Xine_FIND_REQUIRED)
endif (XINE_FOUND)

MARK_AS_ADVANCED(XINE_INCLUDE_DIR XINE_LIBRARY)
