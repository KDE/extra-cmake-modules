# This file provides the function ecm_setup_version().
# ECM_SETUP_VERSION() bundles three things which are usually done for versioned libraries:
#  - it sets a set of version variables
#  - optionally it creates a C version header file, which can then be installed along with the library
#  - optionally it creates a CMake package version file, which can then be installed along with a
#    CMake package Config.cmake file
#
#   ecm_setup_version(<version>
#                     VARIABLE_PREFIX prefix
#                     [SOVERSION <soversion>]
#                     [VERSION_HEADER filename]
#                     [PACKAGE_VERSION_FILE filename] )
#
#
# ecm_setup_version() sets the following CMake variables
#    <prefix>_VERSION_MAJOR = <version_major_component>
#    <prefix>_VERSION_MINOR = <version_minor_component>
#    <prefix>_VERSION_PATCH = <version_patch_component>
#    <prefix>_VERSION_STRING = <major>.<minor>.<patch>
#    <prefix>_SOVERSION is set to <major> if <soversion> has not been specified.
#
# It also sets PROJECT_VERSION_MAJOR, PROJECT_VERSION_MINOR, PROJECT_VERSION_PATCH and
# PROJECT_VERSION_STRING, for easier use with configure_file and file(GENERATE).
#
# If the VERSION_HEADER option is used, a simple C header is generated with the given
# filename. If filename is a relative path, it is interpreted as relative to
# CMAKE_CURRENT_BINARY_DIR.
# The generated header contains the following macros:
#    <prefix>_VERSION_MAJOR
#    <prefix>_VERSION_MINOR
#    <prefix>_VERSION_PATCH
#    <prefix>_VERSION_STRING - containing the full version number as a C string
#    <prefix>_VERSION - containing the full version combined into one integer
#
# If the PACKAGE_VERSION_FILE option is used, a simple CMake package version
# file is created using the write_basic_package_version_file() macro coming
# with CMake. It should be installed along the Config.cmake file of the library
# into the same directory where it can be found by find_package().
# Also here, if the given filename is a relative path, it is interpreted as
# relative to CMAKE_CURRENT_BINARY_DIR.

# Copyright (c) 2012, Alexander Neundorf, <neundorf@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.


include(CMakePackageConfigHelpers)

function(ECM_SETUP_VERSION _version)
  set(options )
  set(oneValueArgs VARIABLE_PREFIX SOVERSION VERSION_HEADER PACKAGE_VERSION_FILE)
  set(multiValueArgs )

  cmake_parse_arguments(ESV "${options}" "${oneValueArgs}" "${multiValueArgs}"  ${ARGN})

  if(ESV_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "Unknown keywords given to ECM_SETUP_VERSION(): \"${ESV_UNPARSED_ARGUMENTS}\"")
  endif()

  if(NOT ESV_VARIABLE_PREFIX)
    message(FATAL_ERROR "Required argument PREFIX missing in ECM_SETUP_VERSION() call")
  endif()

  string(REGEX REPLACE "^([0-9]+)\\.[0-9]+\\.[0-9]+.*" "\\1" _major "${_version}")
  string(REGEX REPLACE "^[0-9]+\\.([0-9]+)\\.[0-9]+.*" "\\1" _minor "${_version}")
  string(REGEX REPLACE "^[0-9]+\\.[0-9]+\\.([0-9]+).*" "\\1" _patch "${_version}")

  if(NOT ESV_SOVERSION)
    set(ESV_SOVERSION ${_major})
  endif()

  set(${ESV_VARIABLE_PREFIX}_VERSION_MAJOR ${_major})
  set(${ESV_VARIABLE_PREFIX}_VERSION_MINOR ${_minor})
  set(${ESV_VARIABLE_PREFIX}_VERSION_PATCH ${_patch})
  set(${ESV_VARIABLE_PREFIX}_SOVERSION ${ESV_SOVERSION})
  set(${ESV_VARIABLE_PREFIX}_VERSION_STRING "${_version}")

  set(PROJECT_VERSION_STRING "${${ESV_VARIABLE_PREFIX}_VERSION_STRING}")
  set(PROJECT_VERSION_MAJOR "${${ESV_VARIABLE_PREFIX}_VERSION_MAJOR}")
  set(PROJECT_VERSION_MINOR "${${ESV_VARIABLE_PREFIX}_VERSION_MINOR}")
  set(PROJECT_VERSION_PATCH "${${ESV_VARIABLE_PREFIX}_VERSION_PATCH}")

  if(ESV_VERSION_HEADER)
    set(PROJECT_NAME_UPPER "${ESV_VARIABLE_PREFIX}")
    configure_file("${ECM_MODULE_DIR}/ECMVersionHeader.h.in" "${ESV_VERSION_HEADER}")
  endif()

  if(ESV_PACKAGE_VERSION_FILE)
    write_basic_package_version_file("${ESV_PACKAGE_VERSION_FILE}" VERSION ${_version} COMPATIBILITY AnyNewerVersion)
  endif()

  set(${ESV_VARIABLE_PREFIX}_VERSION_MAJOR  "${${ESV_VARIABLE_PREFIX}_VERSION_MAJOR}"  PARENT_SCOPE)
  set(${ESV_VARIABLE_PREFIX}_VERSION_MINOR  "${${ESV_VARIABLE_PREFIX}_VERSION_MINOR}"  PARENT_SCOPE)
  set(${ESV_VARIABLE_PREFIX}_VERSION_PATCH  "${${ESV_VARIABLE_PREFIX}_VERSION_PATCH}"  PARENT_SCOPE)
  set(${ESV_VARIABLE_PREFIX}_SOVERSION      "${${ESV_VARIABLE_PREFIX}_SOVERSION}"      PARENT_SCOPE)
  set(${ESV_VARIABLE_PREFIX}_VERSION_STRING "${${ESV_VARIABLE_PREFIX}_VERSION_STRING}" PARENT_SCOPE)

  set(PROJECT_VERSION_STRING "${PROJECT_VERSION_STRING}" PARENT_SCOPE)
  set(PROJECT_VERSION_MAJOR  "${PROJECT_VERSION_MAJOR}"  PARENT_SCOPE)
  set(PROJECT_VERSION_MINOR  "${PROJECT_VERSION_MINOR}"  PARENT_SCOPE)
  set(PROJECT_VERSION_PATCH  "${PROJECT_VERSION_PATCH}"  PARENT_SCOPE)

endfunction()
