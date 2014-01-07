# The following variables can be set to TRUE to skip parts of the functionality:
#  KDE_SKIP_RPATH_SETTINGS
#  KDE_SKIP_BUILD_SETTINGS
#  KDE_SKIP_TEST_SETTINGS


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

         # Ensure these default settings have not been overridden
         # by careless users
         set(CMAKE_SKIP_BUILD_RPATH FALSE)
         set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
      endif ()
   endif (UNIX)

endif()

################ Testing setup ####################################


if(NOT KDE_SKIP_TEST_SETTINGS)
   # support for cdash dashboards
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

   # By default don't add any linked libraries to the "exported"
   # link interfaces of shared libraries, so that executables linking
   # against these libraries will not automatically add implicit
   # dependencies to their link list.
   #
   # This reduces inter-package dependencies and makes it easier to remove
   # dependencies of shared libraries without breaking binary compatibility.
   # Since CMake 2.8.7
#    set(CMAKE_LINK_INTERFACE_LIBRARIES "")
   # TODO: Remove this and the above line.
   cmake_policy(SET CMP0022 OLD)

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
   unset(ARCHIVE_OUTPUT_DIRECTORY)
   unset(LIBRARY_OUTPUT_DIRECTORY)
   unset(RUNTIME_OUTPUT_DIRECTORY)

   # under Windows, generate all executables and libraries into
   # one common directory, so the executables find their dlls
   if(WIN32)
      set(ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
      set(LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
      set(RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
   endif()

endif()

###################################################################
