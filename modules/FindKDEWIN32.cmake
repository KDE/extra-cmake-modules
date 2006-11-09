# - Try to find the KDEWIN32 library
# Once done this will define
#
#  KDEWIN32_FOUND - system has KDEWIN32
#  KDEWIN32_INCLUDES - the KDEWIN32 include directories
#  KDEWIN32_LIBRARIES - The libraries needed to use KDEWIN32
#
# Copyright (c) 2006, Alexander Neundorf, <neundorf@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.


if (WIN32)

file(TO_CMAKE_PATH "$ENV{PROGRAMFILES}" _program_FILES_DIR)

if(NOT QT4_FOUND)
   find_package(Qt4 REQUIRED)
endif(NOT QT4_FOUND)

find_path(KDEWIN32_INCLUDE_DIR winposix_export.h
   ${_program_FILES_DIR}/kdewin32/include ${CMAKE_INSTALL_PREFIX}/include
)


# at first find the kdewin32 library, this has to be compiled and installed before kdelibs/
# search for kdewin32 in the default install directory for applications (default of (n)make install)

set(KDEWIN32_LIBRARY_PATH ${_program_FILES_DIR}/kdewin32/lib)
find_library(KDEWIN32_LIBRARY_RELEASE NAMES kdewin32
   PATHS 
   ${KDEWIN32_LIBRARY_PATH} ${CMAKE_INSTALL_PREFIX}/lib
)

# msvc makes a difference between debug and release
if(MSVC)
	find_library(KDEWIN32_LIBRARY_DEBUG NAMES kdewin32d
	   PATHS 
	   ${_program_FILES_DIR}/kdewin32/lib ${CMAKE_INSTALL_PREFIX}/lib
	)
	if(MSVC_IDE)
		# the ide needs	the debug and release version
		if( NOT KDEWIN32_LIBRARY_DEBUG OR NOT KDEWIN32_LIBRARY_RELEASE)
		   message(FATAL_ERROR "\nCould NOT find the debug AND release version of the KDEWIN32 library.\nYou need to have both to use MSVC projects.\nPlease build and install both kdelibs/win/ libraries first.\n")
		endif( NOT KDEWIN32_LIBRARY_DEBUG OR NOT KDEWIN32_LIBRARY_RELEASE)
		SET(KDEWIN32_LIBRARY optimized ${KDEWIN32_LIBRARY_RELEASE} debug ${KDEWIN32_LIBRARY_DEBUG})
	else(MSVC_IDE)
		string(TOLOWER ${CMAKE_BUILD_TYPE} CMAKE_BUILD_TYPE_TOLOWER)
		if(CMAKE_BUILD_TYPE_TOLOWER MATCHES debug)
		  set(KDEWIN32_LIBRARY ${KDEWIN32_LIBRARY_DEBUG})
		else(CMAKE_BUILD_TYPE_TOLOWER MATCHES debug)
		  set(KDEWIN32_LIBRARY ${KDEWIN32_LIBRARY_RELEASE})
		endif(CMAKE_BUILD_TYPE_TOLOWER MATCHES debug)
	endif(MSVC_IDE)	
else(MSVC)
	set(KDEWIN32_LIBRARY ${KDEWIN32_LIBRARY_RELEASE})
endif(MSVC)
 
# kdelibs/win/ has to be built before the rest of kdelibs/
# eventually it will be moved out from kdelibs/
if (KDEWIN32_LIBRARY AND KDEWIN32_INCLUDE_DIR)
   set(KDEWIN32_FOUND TRUE)
   # add needed system libs
   set(KDEWIN32_LIBRARIES ${KDEWIN32_LIBRARY} user32 shell32 ws2_32)

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

if (KDEWIN32_FOUND)
   if (NOT KDEWIN32_FIND_QUIETLY)
      message(STATUS "Found KDEWIN32: ${KDEWIN32_LIBRARY}")
   endif (NOT KDEWIN32_FIND_QUIETLY)
else (KDEWIN32_FOUND)
   if (KDEWIN32_FIND_REQUIRED)
      message(FATAL_ERROR "Could NOT find KDEWIN32 library\nPlease build and install kdelibs/win/ first")
   endif (KDEWIN32_FIND_REQUIRED)
endif (KDEWIN32_FOUND)

endif (WIN32)
