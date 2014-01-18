# This file provides the function ecm_generate_pri_file().
# ECM_GENERATE_PRI_FILE() creates a .pri file for a library so that qmake-based
# apps can more easily use the library.
# It also sets ECM_MKSPECS_INSTALL_DIR as the directory to install the .pri file to.
#
# Requirement: ${PROJECT_VERSION_STRING} must be set before ecm_generate_pri_file.
# This is usually done by calling ecm_setup_version, which sets it.
#
# Syntax:
#   ecm_generate_pri_file(BASE_NAME baseName
#                         LIB_NAME libName
#                         [DEPS "dep1 dep2"]
#                         [FILENAME_VAR filename_variable] )
#
# * baseName is the name which .pro files will use to refer to the library, i.e. the public name, like KArchive.
# * libName is the name of the actual library to link to, i.e. the first argument to add_library().
# * the deps are a space-separated list of base names of other libraries. Use core, widgets, etc. for Qt libs.
# * filename_variable is the name of a variable, which will be set to contain the path of the .pri file to install
#
# Example usage:
#   ecm_generate_pri_file(BASE_NAME KArchive LIB_NAME KF5KArchive DEPS "core" FILENAME_VAR PRI_FILENAME)
#   install(FILES ${PRI_FILENAME} DESTINATION ${ECM_MKSPECS_INSTALL_DIR})
#
# Copyright (c) 2014, David Faure <faure@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

# This default value makes "installing qt and this lib into the same prefix" work out of the box.
# Packagers who use -DCMAKE_INSTALL_PREFIX=/usr will certainly want to set ECM_MKSPECS_INSTALL_DIR to something like share/qt5/mkspecs/modules
set(ECM_MKSPECS_INSTALL_DIR mkspecs/modules CACHE PATH "The directory where mkspecs will be installed to.")

function(ECM_GENERATE_PRI_FILE)
  set(options )
  set(oneValueArgs BASE_NAME LIB_NAME DEPS FILENAME_VAR)
  set(multiValueArgs )

  cmake_parse_arguments(EGPF "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(EGPF_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "Unknown keywords given to ECM_GENERATE_PRI_FILE(): \"${EGPF_UNPARSED_ARGUMENTS}\"")
  endif()

  if(NOT EGPF_BASE_NAME)
    message(FATAL_ERROR "Required argument BASE_NAME missing in ECM_GENERATE_PRI_FILE() call")
  endif()
  if(NOT EGPF_LIB_NAME)
    message(FATAL_ERROR "Required argument LIB_NAME missing in ECM_GENERATE_PRI_FILE() call")
  endif()
  if(NOT PROJECT_VERSION_STRING)
    message(FATAL_ERROR "Required variable PROJECT_VERSION_STRING not set before ECM_GENERATE_PRI_FILE() call. Did you call ecm_setup_version?")
  endif()

  string(REGEX REPLACE "^([0-9]+)\\.[0-9]+\\.[0-9]+.*" "\\1" PROJECT_VERSION_MAJOR "${PROJECT_VERSION_STRING}")
  string(REGEX REPLACE "^[0-9]+\\.([0-9]+)\\.[0-9]+.*" "\\1" PROJECT_VERSION_MINOR "${PROJECT_VERSION_STRING}")
  string(REGEX REPLACE "^[0-9]+\\.[0-9]+\\.([0-9]+).*" "\\1" PROJECT_VERSION_PATCH "${PROJECT_VERSION_STRING}")

  set(PRI_TARGET_BASENAME ${EGPF_BASE_NAME})
  set(PRI_TARGET_LIBNAME ${EGPF_LIB_NAME})
  set(PRI_TARGET_QTDEPS ${EGPF_DEPS})
  set(PRI_TARGET_INCLUDES "${CMAKE_INSTALL_PREFIX}/${INCLUDE_INSTALL_DIR}/${PRI_TARGET_BASENAME}")
  set(PRI_TARGET_DEFINES "")

  set(PRI_FILENAME ${CMAKE_CURRENT_BINARY_DIR}/qt_${PRI_TARGET_BASENAME}.pri)
  if (EGPF_FILENAME_VAR)
     set(${EGPF_FILENAME_VAR} ${PRI_FILENAME} PARENT_SCOPE)
  endif()

  file(GENERATE
     OUTPUT ${PRI_FILENAME}
     CONTENT
     "QT.@PRI_TARGET_BASENAME@.VERSION = @PROJECT_VERSION_STRING@
QT.@PRI_TARGET_BASENAME@.MAJOR_VERSION = @PROJECT_VERSION_MAJOR@
QT.@PRI_TARGET_BASENAME@.MINOR_VERSION = @PROJECT_VERSION_MINOR@
QT.@PRI_TARGET_BASENAME@.PATCH_VERSION = @PROJECT_VERSION_PATCH@
QT.@PRI_TARGET_BASENAME@.name = @PRI_TARGET_LIBNAME@
QT.@PRI_TARGET_BASENAME@.defines = @PRI_TARGET_DEFINES@
QT.@PRI_TARGET_BASENAME@.includes = @PRI_TARGET_INCLUDES@
QT.@PRI_TARGET_BASENAME@.private_includes =
QT.@PRI_TARGET_BASENAME@.libs = @CMAKE_INSTALL_PREFIX@/@LIB_INSTALL_DIR@
QT.@PRI_TARGET_BASENAME@.depends = @PRI_TARGET_QTDEPS@
"
  )
endfunction()

