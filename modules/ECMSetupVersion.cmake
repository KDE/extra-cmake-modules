#.rst:
# ECMSetupVersion
# ---------------
#
# Handle library version information.
#
# ::
#
#   ecm_setup_version(<version>
#                     VARIABLE_PREFIX <prefix>
#                     [SOVERSION <soversion>]
#                     [VERSION_HEADER <filename>]
#                     [PACKAGE_VERSION_FILE <filename>] )
#
# This parses a version string and sets up a standard set of version variables.
# It can optionally also create a C version header file and a CMake package
# version file to install along with the library.
#
# If the ``<version>`` argument is of the form ``<major>.<minor>.<patch>``
# (or ``<major>.<minor>.<patch>.<tweak>``), The following CMake variables are
# set::
#
#   <prefix>_VERSION_MAJOR  - <major>
#   <prefix>_VERSION_MINOR  - <minor>
#   <prefix>_VERSION_PATCH  - <patch>
#   <prefix>_VERSION_STRING - <version>
#   <prefix>_SOVERSION      - <soversion>, or <major> if SOVERSION was not given
#   PROJECT_VERSION_MAJOR   - <major>
#   PROJECT_VERSION_MINOR   - <minor>
#   PROJECT_VERSION_PATCH   - <patch>
#   PROJECT_VERSION_STRING  - <version>
#
# If the VERSION_HEADER option is used, a simple C header is generated with the
# given filename. If filename is a relative path, it is interpreted as relative
# to CMAKE_CURRENT_BINARY_DIR.  The generated header contains the following
# macros::
#
#    <prefix>_VERSION_MAJOR  - <major> as an integer
#    <prefix>_VERSION_MINOR  - <minor> as an integer
#    <prefix>_VERSION_PATCH  - <patch> as an integer
#    <prefix>_VERSION_STRING - <version> as a C string
#    <prefix>_VERSION        - the version as an integer
#
# ``<prefix>_VERSION`` has ``<patch>`` in the bottom 8 bits, ``<minor>`` in the
# next 8 bits and ``<major>`` in the remaining bits.  Note that ``<patch>`` and
# ``<minor>`` must be less than 256.
#
# If the PACKAGE_VERSION_FILE option is used, a simple CMake package version
# file is created using the write_basic_package_version_file() macro provided by
# CMake. It should be installed in the same location as the Config.cmake file of
# the library so that it can be found by find_package().  If the filename is a
# relative path, it is interpreted as relative to CMAKE_CURRENT_BINARY_DIR.

#=============================================================================
# Copyright 2012 Alexander Neundorf <neundorf@kde.org>
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file COPYING-CMAKE-SCRIPTS for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# (To distribute this file outside of extra-cmake-modules, substitute the full
#  License text for the above reference.)

# FIXME: Figure out how this should interact with CMP0048 in CMake 3.0.0

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
