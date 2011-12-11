# - Selectively use some of the Find-modules provided by extra-cmake-modules
#
# ECM_USE_FIND_MODULES(DIR <dir> MODULES module1.cmake module2.cmake .. moduleN.cmake [NO_OVERRIDE] )
#
# This macro is automatically available once extra-cmake-modules has been found, so it is not
# necessary to include(ECMUseFindModules) explictely.
#
# Use this macro instead of simply adding ${EXTRA_CMAKE_MODULES_FIND_MODULE_DIR} to CMAKE_MODULE_PATH
# if you want to use only a subset or some specific find-modules coming with extra-cmake-modules.
# The given find-modules will be copied to the given directory. This directory should then be added
# to CMAKE_MODULE_PATH. The given modules override modules of the same name coming with CMake, except
# if the NO_OVERRIDE option has been used.
#
#   DIR <dir> : the selected module files will be copied to that directory. The directory should be
#               located somewhere inside ${CMAKE_BINARY_DIR}. It should then be added to CMAKE_MODULE_PATH .
#               The directory is created if it does not exist yet.
#   MODULES   : the list of find-modules to be used from extra-cmake-modules
#   NO_OVERRIDE: if used, the given modules will only be used if they do not exist in the currently used
#                CMake version
#
# Example:
#   find_package(extra-cmake-modules 0.0.2 REQUIRED)
#   ecm_use_find_modules(DIR ${CMAKE_BINARY_DIR}/cmake/ Modules FindBlueZ.cmake NO_OVERRIDE )
#   set(CMAKE_MODULE_PATH ${CMAKE_BINARY_DIR}/cmake/ )
#
# This example will make FindBlueZ.cmake available in your project, but only as long as it
# is not yet part of CMake. The file will be copied into ${CMAKE_BINARY_DIR}/cmake/, and then this
# directory is added to CMAKE_MODULE_PATH.

# Copyright 2011 Alexander Neundorf <neundorf@kde.org>
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.

include(CMakeParseArguments)

function(ecm_use_find_modules)
   set(_options NO_OVERRIDE )
   set(_oneValueArgs DIR )
   set(_multiValueArgs MODULES )
   cmake_parse_arguments(EUFM "${_options}" "${_oneValueArgs}" "${_multiValueArgs}" ${ARGN} )
   if(NOT EUFM_DIR)
      message(FATAL_ERROR "No DIR specified for ecm_use_find_modules() !")
   endif()

   if(NOT IS_ABSOLUTE "${EUFM_DIR}")
      set(EUFM_DIR "${CMAKE_CURRENT_BINARY_DIR}/${EUFM_DIR}")
   endif()
   file(MAKE_DIRECTORY "${EUFM_DIR}")

   foreach(file ${EUFM_MODULES})
      if(NOT EXISTS ${EXTRA_CMAKE_MODULES_FIND_MODULE_DIR}/${file} )
         message(FATAL_ERROR "File ${file} not found in ${EXTRA_CMAKE_MODULES_FIND_MODULE_DIR} !")
      endif()
      if(NOT EXISTS "${CMAKE_ROOT}/Modules/${file}" OR NOT EUFM_NO_OVERRIDE)
         configure_file("${EXTRA_CMAKE_MODULES_FIND_MODULE_DIR}/${file}" "${EUFM_DIR}/${file}" COPYONLY)
      endif()
   endforeach()

endfunction()
