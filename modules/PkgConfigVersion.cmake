# - pkg-config module for CMake

# Copyright (c) 2007 Will Stephenson <wstephenson@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.


#
# Defines the following macros:
#
# PKGCONFIG_VERSION(package includedir libdir linkflags cflags)
#
# ### ADD DOCUMENTATION!
#

include(UsePkgConfig)

MACRO(PKGCONFIG_VERSION _package _include_DIR _link_DIR _link_FLAGS _cflags _found_version)
   #reset variable
   SET(${_found_version})
   IF(PKGCONFIG_EXECUTABLE)
      #call PKGCONFIG
      PKGCONFIG(${_package} ${_include_DIR} ${_link_DIR} ${_link_FLAGS} ${_cflags})
      IF(${_include_DIR})
         EXEC_PROGRAM(${PKGCONFIG_EXECUTABLE} ARGS ${_package} --modversion OUTPUT_VARIABLE ${_found_version})
         IF(NOT ${_found_version})
            MESSAGE(FATAL_ERROR "UsePkgConfig.cmake: No version found for ${_package}")
         ENDIF(NOT ${_found_version})
      ENDIF(${_include_DIR})
   ENDIF(PKGCONFIG_EXECUTABLE)
ENDMACRO(PKGCONFIG_VERSION _package _include_DIR _link_DIR _link_FLAGS _cflags _found_version)

MARK_AS_ADVANCED(PKGCONFIG_EXECUTABLE)
