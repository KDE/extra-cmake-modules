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

# enable the code below again when cmake also searches in lib64/ (should be 2.6.2), Alex
# # check if we are inside KDESupport and automoc is enabled
# if("${KDESupport_SOURCE_DIR}" STREQUAL "${CMAKE_SOURCE_DIR}")
#    # when building this project as part of kdesupport
#    include("${KDESupport_SOURCE_DIR}/automoc/Automoc4Config.cmake")
# else("${KDESupport_SOURCE_DIR}" STREQUAL "${CMAKE_SOURCE_DIR}")
#    # when building this project outside kdesupport
#    # use the new "config-mode" of cmake 2.6, which searches the installed Automoc4Config.cmake file
#    # see the man page for details
#    find_package(Automoc4 QUIET NO_MODULE)
# endif("${KDESupport_SOURCE_DIR}" STREQUAL "${CMAKE_SOURCE_DIR}")

if("${KDESupport_SOURCE_DIR}" STREQUAL "${CMAKE_SOURCE_DIR}")   
   # when building this project as part of kdesupport   
   set(AUTOMOC4_CONFIG_FILE "${KDESupport_SOURCE_DIR}/automoc/Automoc4Config.cmake")
else("${KDESupport_SOURCE_DIR}" STREQUAL "${CMAKE_SOURCE_DIR}")   
   # when building this project outside kdesupport   
   # CMAKE_[SYSTEM_]PREFIX_PATH exists starting with cmake 2.6.0   
   file(TO_CMAKE_PATH "$ENV{CMAKE_PREFIX_PATH}" _env_CMAKE_PREFIX_PATH)   
   file(TO_CMAKE_PATH "$ENV{CMAKE_LIBRARY_PATH}" _env_CMAKE_LIBRARY_PATH)   
   find_file(AUTOMOC4_CONFIG_FILE NAMES Automoc4Config.cmake              
                                  PATH_SUFFIXES automoc4 lib/automoc4 lib64/automoc4             
                                  PATHS ${_env_CMAKE_PREFIX_PATH} ${CMAKE_PREFIX_PATH} ${CMAKE_SYSTEM_PREFIX_PATH}
                                 ${_env_CMAKE_LIBRARY_PATH} ${CMAKE_LIBRARY_PATH} ${CMAKE_SYSTEM_LIBRARY_PATH}
                                 ${CMAKE_INSTALL_PREFIX}             
                                 NO_DEFAULT_PATH )
endif("${KDESupport_SOURCE_DIR}" STREQUAL "${CMAKE_SOURCE_DIR}")

if(AUTOMOC4_CONFIG_FILE)   
   include(${AUTOMOC4_CONFIG_FILE})   
endif(AUTOMOC4_CONFIG_FILE)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Automoc4 "Did not find automoc4 (part of kdesupport)." AUTOMOC4_EXECUTABLE)
