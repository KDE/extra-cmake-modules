#.rst:
# ECMGeneratePriFile
# ------------------
#
# Generate a ``.pri`` file for the benefit of qmake-based projects.
#
# As well as the function below, this module creates the cache variable
# ``ECM_MKSPECS_INSTALL_DIR`` and sets the default value to ``mkspecs/modules``.
# This assumes Qt and the current project are both installed to the same
# non-system prefix.  Packagers who use ``-DCMAKE_INSTALL_PREFIX=/usr`` will
# certainly want to set ``ECM_MKSPECS_INSTALL_DIR`` to something like
# ``share/qt5/mkspecs/modules``.
#
# The main thing is that this should be the ``modules`` subdirectory of either
# the default qmake ``mkspecs`` directory or of a directory that will be in the
# ``$QMAKEPATH`` environment variable when qmake is run.
#
# ::
#
#   ecm_generate_pri_file(BASE_NAME <baseName>
#                         LIB_NAME <libName>
#                         [DEPS "<dep> [<dep> [...]]"]
#                         [FILENAME_VAR <filename_variable>])
#
# If your CMake project produces a Qt-based library, you may expect there to be
# applications that wish to use it that use a qmake-based build system, rather
# than a CMake-based one.  Creating a ``.pri`` file will make use of your
# library convenient for them, in much the same way that CMake config files make
# things convenient for CMake-based applications.
#
# ecm_generate_pri_file() generates just such a file.  It depends on a few
# variables being set:
#
# * ``PROJECT_VERSION_STRING``: typically set by :module:`ECMSetupVersion`,
#   although the project() command in CMake 3.0.0 and later can also set this.
# * ``INCLUDE_INSTALL_DIR``: this must be relative to ``CMAKE_INSTALL_PREFIX``,
#   and includes are assumed to be install in the <baseName> subdirectory.
# * ``LIB_INSTALL_DIR``: this must be relative to ``CMAKE_INSTALL_PREFIX``.
#
# BASE_NAME specifies the name qmake project (.pro) files should use to refer to
# the library (eg: KArchive).  LIB_NAME is the name of the actual library to
# link to (ie: the first argument to add_library()).  DEPS is a space-separated
# list of the base names of other libraries (for Qt libraries, use the same
# names you use with the ``QT`` variable in a qmake project file, such as "core"
# for QtCore).  FILENAME_VAR specifies the name of a variable to store the path
# to the generated file in.
#
# Example usage:
#
# .. code-block:: cmake
#
#   ecm_generate_pri_file(
#       BASE_NAME KArchive
#       LIB_NAME KF5KArchive
#       DEPS "core"
#       FILENAME_VAR pri_filename
#   )
#   install(FILES ${pri_filename} DESTINATION ${ECM_MKSPECS_INSTALL_DIR})
#
# A qmake-based project that wished to use this would then do::
#
#   QT += KArchive
#
# in their ``.pro`` file.

#=============================================================================
# Copyright 2014 David Faure <faure@kde.org>
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
  # FIXME: Default value for INCLUDE_INSTALL_DIR, argument to override?
  #        What about absolute paths?
  set(PRI_TARGET_INCLUDES "${CMAKE_INSTALL_PREFIX}/${INCLUDE_INSTALL_DIR}/${PRI_TARGET_BASENAME}")
  set(PRI_TARGET_DEFINES "")

  set(PRI_FILENAME ${CMAKE_CURRENT_BINARY_DIR}/qt_${PRI_TARGET_BASENAME}.pri)
  if (EGPF_FILENAME_VAR)
     set(${EGPF_FILENAME_VAR} ${PRI_FILENAME} PARENT_SCOPE)
  endif()

  # FIXME: Default value for LIB_INSTALL_DIR, argument to override?
  #        What about absolute paths?
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

