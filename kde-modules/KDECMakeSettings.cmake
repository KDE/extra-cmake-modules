#.rst:
# KDECMakeSettings
# ----------------
#
# Changes various CMake settings to what the KDE community views as more
# sensible defaults.
#
# It is split into three parts, which can be independently disabled if desired.
#
# Runtime Paths
# ~~~~~~~~~~~~~
#
# The default runtime path (used on Unix systems to search for
# dynamically-linked libraries) is set to include the location that libraries
# will be installed to (as set in LIB_INSTALL_DIR), and also the linker search
# path.
#
# Note that ``LIB_INSTALL_DIR`` needs to be set before including this module.
# Typically, this is done by including the :kde-module:`KDEInstallDirs` module.
#
# This section can be disabled by setting ``KDE_SKIP_RPATH_SETTINGS`` to TRUE
# before including this module.
#
#
# Testing
# ~~~~~~~
#
# Testing is enabled by default, and an option (BUILD_TESTING) is provided for
# users to control this. See the CTest module documentation in the CMake manual
# for more details.
#
# This section can be disabled by setting ``KDE_SKIP_TEST_SETTINGS`` to TRUE
# before including this module.
#
#
# Build Settings
# ~~~~~~~~~~~~~~
#
# Various CMake build defaults are altered, such as searching source and build
# directories for includes first and enabling automoc by default.
#
# This section can be disabled by setting ``KDE_SKIP_BUILD_SETTINGS`` to TRUE
# before including this module.
#
# This section also provides an "uninstall" target that can be individually
# disabled by setting ``KDE_SKIP_UNINSTALL_TARGET`` to TRUE before including
# this module.
#
# Since pre-1.0.0.
#
# Uninstall target functionality since 1.7.0.

#=============================================================================
# Copyright 2014      Alex Merry <alex.merry@kde.org>
# Copyright 2013      Aleix Pol <aleixpol@kde.org>
# Copyright 2012-2013 Stephen Kelly <steveire@gmail.com>
# Copyright 2007      Matthias Kretz <kretz@kde.org>
# Copyright 2006-2007 Laurent Montel <montel@kde.org>
# Copyright 2006-2013 Alex Neundorf <neundorf@kde.org>
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


################# RPATH handling ##################################

if(NOT KDE_SKIP_RPATH_SETTINGS)

   # Set the default RPATH to point to useful locations, namely where the
   # libraries will be installed and the linker search path

   if(NOT LIB_INSTALL_DIR)
      message(FATAL_ERROR "LIB_INSTALL_DIR not set. This is necessary for using the RPATH settings.")
   endif()

   set(_abs_LIB_INSTALL_DIR "${LIB_INSTALL_DIR}")
   if (NOT IS_ABSOLUTE "${_abs_LIB_INSTALL_DIR}")
      set(_abs_LIB_INSTALL_DIR "${CMAKE_INSTALL_PREFIX}/${LIB_INSTALL_DIR}")
   endif()

   if (UNIX)
      if (APPLE)
         set(CMAKE_INSTALL_NAME_DIR ${_abs_LIB_INSTALL_DIR})
      else ()
         # add our LIB_INSTALL_DIR to the RPATH (but only when it is not one of
         # the standard system link directories - such as /usr/lib on UNIX)
         list(FIND CMAKE_PLATFORM_IMPLICIT_LINK_DIRECTORIES "${_abs_LIB_INSTALL_DIR}" _isSystemLibDir)
         list(FIND CMAKE_CXX_IMPLICIT_LINK_DIRECTORIES      "${_abs_LIB_INSTALL_DIR}" _isSystemCxxLibDir)
         list(FIND CMAKE_C_IMPLICIT_LINK_DIRECTORIES        "${_abs_LIB_INSTALL_DIR}" _isSystemCLibDir)
         if("${_isSystemLibDir}" STREQUAL "-1"  AND  "${_isSystemCxxLibDir}" STREQUAL "-1"  AND  "${_isSystemCLibDir}" STREQUAL "-1")
            set(CMAKE_INSTALL_RPATH "${_abs_LIB_INSTALL_DIR}")
         endif()

         # Append directories in the linker search path (but outside the project)
         set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
      endif ()
   endif (UNIX)

endif()

################ Testing setup ####################################


if(NOT KDE_SKIP_TEST_SETTINGS)

   # If there is a CTestConfig.cmake, include CTest.
   # Otherwise, there will not be any useful settings, so just
   # fake the functionality we care about from CTest.

   if (EXISTS ${CMAKE_SOURCE_DIR}/CTestConfig.cmake)
      include(CTest)
   else()
      option(BUILD_TESTING "Build the testing tree." ON)
      if(BUILD_TESTING)
         enable_testing()
      endif ()
   endif ()

endif()



################ Build-related settings ###########################

if(NOT KDE_SKIP_BUILD_SETTINGS)

   # Always include srcdir and builddir in include path
   # This saves typing ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR} in about every subdir
   # since cmake 2.4.0
   set(CMAKE_INCLUDE_CURRENT_DIR ON)

   # put the include dirs which are in the source or build tree
   # before all other include dirs, so the headers in the sources
   # are prefered over the already installed ones
   # since cmake 2.4.1
   set(CMAKE_INCLUDE_DIRECTORIES_PROJECT_BEFORE ON)

   # Add the src and build dir to the BUILD_INTERFACE include directories
   # of all targets. Similar to CMAKE_INCLUDE_CURRENT_DIR, but transitive.
   # Since CMake 2.8.11
   set(CMAKE_INCLUDE_CURRENT_DIR_IN_INTERFACE ON)

   # When a shared library changes, but its includes do not, don't relink
   # all dependencies. It is not needed.
   # Since CMake 2.8.11
   set(CMAKE_LINK_DEPENDS_NO_SHARED ON)

   # Default to shared libs for KDE, if no type is explicitely given to add_library():
   set(BUILD_SHARED_LIBS TRUE CACHE BOOL "If enabled, shared libs will be built by default, otherwise static libs")

   # Enable automoc in cmake
   # Since CMake 2.8.6
   set(CMAKE_AUTOMOC ON)

   # By default, create 'GUI' executables. This can be reverted on a per-target basis
   # using ECMMarkNonGuiExecutable
   # Since CMake 2.8.8
   set(CMAKE_WIN32_EXECUTABLE ON)
   set(CMAKE_MACOSX_BUNDLE ON)

   # By default, don't put a prefix on MODULE targets. add_library(MODULE) is basically for plugin targets,
   # and in KDE plugins don't have a prefix.
   set(CMAKE_SHARED_MODULE_PREFIX "")

   unset(EXECUTABLE_OUTPUT_PATH)
   unset(LIBRARY_OUTPUT_PATH)
   unset(CMAKE_ARCHIVE_OUTPUT_DIRECTORY)
   unset(CMAKE_LIBRARY_OUTPUT_DIRECTORY)
   unset(CMAKE_RUNTIME_OUTPUT_DIRECTORY)

   # under Windows, output all executables and dlls into
   # one common directory, and all static|import libraries and plugins
   # into another one. This way test executables can find their dlls
   # even without installation.
   if(WIN32)
      set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib")
      set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
      set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
   endif()

   option(KDE_SKIP_UNINSTALL_TARGET "Prevent an \"uninstall\" target from being generated." OFF)
   if(NOT KDE_SKIP_UNINSTALL_TARGET)
       include("${ECM_MODULE_DIR}/ECMUninstallTarget.cmake")
   endif()

endif()
###################################################################
