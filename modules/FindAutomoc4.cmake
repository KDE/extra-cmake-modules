# - Try to find automoc4
# Once done this will define
#
#  AUTOMOC4_FOUND - automoc4 has been found
#  AUTOMOC4_EXECUTABLE - the automoc4 tool
#
# It also adds the following macros
#  AUTOMOC4(<target> <SRCS_VAR>)
#    Use this to run automoc4 on all files contained in the list <SRCS_VAR>.
#
#  AUTOMOC4_MOC_HEADERS(<target> header1.h header2.h)
#    Use this to add more header files to be processed with automoc4.


# Copyright (c) 2008, Alexander Neundorf, <neundorf@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

# check if we are inside KDESupport and automoc is enabled
if("${KDESupport_SOURCE_DIR}" STREQUAL "${CMAKE_SOURCE_DIR}")
   # when building this project as part of kdesupport
   include("${KDESupport_SOURCE_DIR}/automoc/Automoc4Config.cmake")
else("${KDESupport_SOURCE_DIR}" STREQUAL "${CMAKE_SOURCE_DIR}")
   # when building this project outside kdesupport
   # use the new "config-mode" of cmake 2.6, which searches the installed Automoc4Config.cmake file
   # see the man page for details
   set(_Automoc4_FIND_QUIETLY ${Automoc4_FIND_QUIETLY})
   find_package(Automoc4 QUIET NO_MODULE)
   set(Automoc4_FIND_QUIETLY ${_Automoc4_FIND_QUIETLY})
endif("${KDESupport_SOURCE_DIR}" STREQUAL "${CMAKE_SOURCE_DIR}")

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Automoc4 "Did not find automoc4 (part of kdesupport). Searched for Automoc4Config.cmake in ${AUTOMOC4_SEARCH_PATHS} using suffixes automoc4 lib/automoc4 lib64/automoc4." AUTOMOC4_EXECUTABLE)
