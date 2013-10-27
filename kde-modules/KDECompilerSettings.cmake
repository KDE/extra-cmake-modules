# This module provides the following variables:
#   KDE4_ENABLE_EXCEPTIONS - use this to enable exceptions
#
# This module also sets up CMAKE_CXX_FLAGS for a set of predefined buildtypes
# as documented below.
#
#  A note on the possible values for CMAKE_BUILD_TYPE and how KDE handles
#  the flags for those buildtypes. FindKDE4Internal supports the values
#  Debug, Release, RelWithDebInfo, Profile and Debugfull:
#
#  Release
#          optimised for speed, qDebug/kDebug turned off, no debug symbols, no asserts
#  RelWithDebInfo (Release with debug info)
#          similar to Release, optimised for speed, but with debugging symbols on (-g)
#  Debug
#          optimised but debuggable, debugging on (-g)
#          (-fno-reorder-blocks -fno-schedule-insns -fno-inline)
#  DebugFull
#          no optimisation, full debugging on (-g3)
#  Profile
#          DebugFull + -ftest-coverage -fprofile-arcs
#
#
#  The default buildtype is RelWithDebInfo.
#  It is expected that the "Debug" build type be still debuggable with gdb
#  without going all over the place, but still produce better performance.
#  It's also important to note that gcc cannot detect all warning conditions
#  unless the optimiser is active.

include(CheckCXXCompilerFlag)
include(GenerateExportHeader)

# TODO: what's up with this manifest stuff ?
#       setting the CMAKE_MODULE_PATH like this is definitely wrong.
#       FindKDEWin.cmake should probably come from ecm
#
# if (WIN32)
#    list(APPEND CMAKE_MODULE_PATH "${CMAKE_INSTALL_PREFIX}/share/apps/cmake/modules")
#    find_package(KDEWin REQUIRED)
#    option(KDE4_ENABLE_UAC_MANIFEST "add manifest to make vista uac happy" OFF)
#    if (KDE4_ENABLE_UAC_MANIFEST)
#       find_program(KDE4_MT_EXECUTABLE mt
#          PATHS ${KDEWIN_INCLUDE_DIR}/../bin
#          NO_DEFAULT_PATH
#       )
#       if (KDE4_MT_EXECUTABLE)
#          message(STATUS "Found KDE manifest tool at ${KDE4_MT_EXECUTABLE} ")
#       else (KDE4_MT_EXECUTABLE)
#          message(STATUS "KDE manifest tool not found, manifest generating for Windows Vista disabled")
#          set (KDE4_ENABLE_UAC_MANIFEST OFF)
#       endif (KDE4_MT_EXECUTABLE)
#    endif (KDE4_ENABLE_UAC_MANIFEST)
# endif (WIN32)


######################################################
#  and now the platform specific stuff
######################################################

# Set a default build type for single-configuration
# CMake generators if no build type is set.
if (NOT CMAKE_CONFIGURATION_TYPES AND NOT CMAKE_BUILD_TYPE)
   set(CMAKE_BUILD_TYPE RelWithDebInfo)
endif()


if (WIN32)

   # limit win32 packaging to kdelibs at now
   # don't know if package name, version and notes are always available

   # windows, microsoft compiler
   if(MSVC OR "${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel")
      set( _KDE4_PLATFORM_DEFINITIONS -DKDE_FULL_TEMPLATE_EXPORT_INSTANTIATION -DWIN32_LEAN_AND_MEAN )

      # C4250: 'class1' : inherits 'class2::member' via dominance
      set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -wd4250" )
      # C4251: 'identifier' : class 'type' needs to have dll-interface to be used by clients of class 'type2'
      set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -wd4251" )
      # C4396: 'identifier' : 'function' the inline specifier cannot be used when a friend declaration refers to a specialization of a function template
      set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -wd4396" )
      # to avoid a lot of deprecated warnings
      set(_KDE4_PLATFORM_DEFINITIONS ${_KDE4_PLATFORM_DEFINITIONS}
                       -D_CRT_SECURE_NO_DEPRECATE
                       -D_CRT_SECURE_NO_WARNINGS
                       -D_CRT_NONSTDC_NO_DEPRECATE
                       -D_SCL_SECURE_NO_WARNINGS
                       )
      # 'identifier' : no suitable definition provided for explicit template instantiation request
      set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -wd4661" )
   endif()

# TODO: we should not depend on Perl or Qt already been found here
#
#    # for visual studio IDE set the path correctly for custom commands
#    # maybe under windows bat-files should be generated for running apps during the build
#    if(MSVC_IDE)
#      get_filename_component(PERL_LOCATION "${PERL_EXECUTABLE}" PATH)
#      file(TO_NATIVE_PATH "${PERL_LOCATION}" PERL_PATH_WINDOWS)
#      file(TO_NATIVE_PATH "${QT_BINARY_DIR}" QT_BIN_DIR_WINDOWS)
#      set(CMAKE_MSVCIDE_RUN_PATH "${PERL_PATH_WINDOWS}\;${QT_BIN_DIR_WINDOWS}"
#        CACHE STATIC "MSVC IDE Run path" FORCE)
#    endif()

   # TODO: do we really want to have this line here ? Is it actually needed ?
   # we prefer to use a different postfix for debug libs only on Windows
   # does not work atm
   set(CMAKE_DEBUG_POSTFIX "")

   # we don't support anything below w2k and all winapi calls are unicodes
   set( _KDE4_PLATFORM_DEFINITIONS -D_WIN32_WINNT=0x0501 -DWINVER=0x0501 -D_WIN32_IE=0x0501 -DUNICODE )

endif (WIN32)

if (APPLE)
  # we need to set MACOSX_DEPLOYMENT_TARGET to (I believe) at least 10.2 or maybe 10.3 to allow
  # -undefined dynamic_lookup; in the future we should do this programmatically
  # hmm... why doesn't this work?
  set (ENV{MACOSX_DEPLOYMENT_TARGET} 10.3)
endif()


if ("${CMAKE_SYSTEM_NAME}" MATCHES Linux OR "${CMAKE_SYSTEM_NAME}" STREQUAL GNU)
   # _BSD_SOURCE: is/was needed by glibc for snprintf to be available when building C files.
   # See commit 4a44862b2d178c1d2e1eb4da90010d19a1e4a42c.

   set ( _KDE4_PLATFORM_DEFINITIONS -D_XOPEN_SOURCE=500 -D_BSD_SOURCE -D_GNU_SOURCE)
endif()


if (UNIX)
   set ( _KDE4_PLATFORM_DEFINITIONS ${_KDE4_PLATFORM_DEFINITIONS} -D_LARGEFILE64_SOURCE)
endif (UNIX)


if (APPLE)
  # "-undefined dynamic_lookup" means we don't care about missing symbols at link-time by default
  # this is bad, but unavoidable until there is the equivalent of libtool -no-undefined implemented
  # or perhaps it already is, and I just don't know where to look  ;)

  set (CMAKE_SHARED_LINKER_FLAGS "-single_module -multiply_defined suppress ${CMAKE_SHARED_LINKER_FLAGS}")
  set (CMAKE_MODULE_LINKER_FLAGS "-multiply_defined suppress ${CMAKE_MODULE_LINKER_FLAGS}")
  #set(CMAKE_SHARED_LINKER_FLAGS "-single_module -undefined dynamic_lookup -multiply_defined suppress")
  #set(CMAKE_MODULE_LINKER_FLAGS "-undefined dynamic_lookup -multiply_defined suppress")

  # removed -Os, was there a special reason for using -Os instead of -O2 ?, Alex
  # optimization flags are set below for the various build types
  set (CMAKE_C_FLAGS     "${CMAKE_C_FLAGS} -fno-common")
  set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-common")
endif (APPLE)

# TODO: why don't we go inside that block on the BSDs ?
if (CMAKE_SYSTEM_NAME MATCHES Linux OR CMAKE_SYSTEM_NAME STREQUAL GNU)
   if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU" OR "${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
     # TODO: does the Intel compiler also support --enable-new-dtags ? ...probably since they are only forwarded to the linker....
      set ( CMAKE_SHARED_LINKER_FLAGS "-Wl,--enable-new-dtags -Wl,--fatal-warnings -Wl,--no-undefined -lc ${CMAKE_SHARED_LINKER_FLAGS}")
      set ( CMAKE_MODULE_LINKER_FLAGS "-Wl,--enable-new-dtags -Wl,--fatal-warnings -Wl,--no-undefined -lc ${CMAKE_MODULE_LINKER_FLAGS}")
      set ( CMAKE_EXE_LINKER_FLAGS    "-Wl,--enable-new-dtags ${CMAKE_EXE_LINKER_FLAGS}")
   endif()

   if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel")
      set ( CMAKE_SHARED_LINKER_FLAGS "-Wl,--fatal-warnings -Wl,--no-undefined -lc ${CMAKE_SHARED_LINKER_FLAGS}")
      set ( CMAKE_MODULE_LINKER_FLAGS "-Wl,--fatal-warnings -Wl,--no-undefined -lc ${CMAKE_MODULE_LINKER_FLAGS}")
   endif ()
endif (CMAKE_SYSTEM_NAME MATCHES Linux OR CMAKE_SYSTEM_NAME STREQUAL GNU)


############################################################
# compiler specific settings
############################################################

if (CMAKE_BUILD_TYPE)
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "DebugFull" "Release" "RelWithDebInfo" "Profile" "Coverage")
endif()

if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC" OR (WIN32 AND "${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel"))

   # this macro is for internal use only.
   macro(_KDE_INSERT_FLAG FLAG VAR DOC)
      if(NOT ${VAR} MATCHES "${FLAG}")
         set(${VAR} "${${VAR}} ${FLAG}" CACHE STRING "Flags used by the linker during ${DOC} builds." FORCE)
      endif()
   endmacro()

   set (KDE4_ENABLE_EXCEPTIONS -EHsc)

   # make sure that no header adds libcmt by default using #pragma comment(lib, "libcmt.lib") as done by mfc/afx.h
   _kde_insert_flag("/NODEFAULTLIB:libcmt /DEFAULTLIB:msvcrt" CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO "Release with Debug Info")
   _kde_insert_flag("/NODEFAULTLIB:libcmt /DEFAULTLIB:msvcrt" CMAKE_EXE_LINKER_FLAGS_RELEASE "release")
   _kde_insert_flag("/NODEFAULTLIB:libcmt /DEFAULTLIB:msvcrt" CMAKE_EXE_LINKER_FLAGS_MINSIZEREL "release minsize")
   _kde_insert_flag("/NODEFAULTLIB:libcmtd /DEFAULTLIB:msvcrtd" CMAKE_EXE_LINKER_FLAGS_DEBUG "debug")
endif()

# TODO: this is for BSD, this looks like something which should be done in CMake
# # This macro is for internal use only
# # Return the directories present in gcc's include path.
# macro(_DETERMINE_GCC_SYSTEM_INCLUDE_DIRS _lang _result)
#   set(${_result})
#   set(_gccOutput)
#   file(WRITE "${CMAKE_BINARY_DIR}/CMakeFiles/dummy" "\n" )
#   execute_process(COMMAND ${CMAKE_C_COMPILER} -v -E -x ${_lang} -dD dummy
#                   WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/CMakeFiles
#                   ERROR_VARIABLE _gccOutput
#                   OUTPUT_VARIABLE _gccStdout )
#   file(REMOVE "${CMAKE_BINARY_DIR}/CMakeFiles/dummy")
#
#   if( "${_gccOutput}" MATCHES "> search starts here[^\n]+\n *(.+) *\n *End of (search) list" )
#     SET(${_result} ${CMAKE_MATCH_1})
#     STRING(REPLACE "\n" " " ${_result} "${${_result}}")
#     SEPARATE_ARGUMENTS(${_result})
#   ENDIF( "${_gccOutput}" MATCHES "> search starts here[^\n]+\n *(.+) *\n *End of (search) list" )
# endmacro(_DETERMINE_GCC_SYSTEM_INCLUDE_DIRS _lang)


if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")

   if("${CMAKE_CXX_COMPILER_VERSION}" VERSION_LESS "4.2.0")
      message(FATAL_ERROR "GCC 4.2 or later is required")
   endif()

# if (CMAKE_COMPILER_IS_GNUCC)
#    _DETERMINE_GCC_SYSTEM_INCLUDE_DIRS(c _dirs)
#    set(CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES
#        ${CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES} ${_dirs})
# endif (CMAKE_COMPILER_IS_GNUCC)


#    _DETERMINE_GCC_SYSTEM_INCLUDE_DIRS(c++ _dirs)
#    set(CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES
#        ${CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES} ${_dirs})

endif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")


if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
# TODO: why do the other KDE4_ENABLE_EXCEPTIONS not have -UQT_NO_EXCEPTIONS ?
   set (KDE4_ENABLE_EXCEPTIONS "-fexceptions -UQT_NO_EXCEPTIONS")
   # Select flags.
   set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-O2 -g -DNDEBUG -DQT_NO_DEBUG")
   set(CMAKE_CXX_FLAGS_RELEASE        "-O2 -DNDEBUG -DQT_NO_DEBUG")
   set(CMAKE_CXX_FLAGS_DEBUG          "-g -O2 -fno-reorder-blocks -fno-schedule-insns -fno-inline")
   set(CMAKE_CXX_FLAGS_DEBUGFULL      "-g3 -fno-inline")
   set(CMAKE_CXX_FLAGS_PROFILE        "-g3 -fno-inline -ftest-coverage -fprofile-arcs")
   set(CMAKE_CXX_FLAGS_COVERAGE       "${CMAKE_CXX_FLAGS_DEBUG} -fprofile-arcs -ftest-coverage")
   set(CMAKE_C_FLAGS_RELWITHDEBINFO   "-O2 -g -DNDEBUG -DQT_NO_DEBUG")
   set(CMAKE_C_FLAGS_RELEASE          "-O2 -DNDEBUG -DQT_NO_DEBUG")
   set(CMAKE_C_FLAGS_DEBUG            "-g -O2 -fno-reorder-blocks -fno-schedule-insns -fno-inline")
   set(CMAKE_C_FLAGS_DEBUGFULL        "-g3 -fno-inline")
   set(CMAKE_C_FLAGS_PROFILE          "-g3 -fno-inline -ftest-coverage -fprofile-arcs")
   set(CMAKE_C_FLAGS_COVERAGE         "${CMAKE_C_FLAGS_DEBUG} -fprofile-arcs -ftest-coverage")

   # TODO: do those flags also apply to the Intel compiler ? What about clang ?
   set(CMAKE_EXE_LINKER_FLAGS_COVERAGE "${CMAKE_EXE_LINKER_FLAGS} -fprofile-arcs -ftest-coverage")
   set (CMAKE_SHARED_LINKER_FLAGS_PROFILE "${CMAKE_SHARED_LINKER_FLAGS} -fprofile-arcs -ftest-coverage")
   set (CMAKE_MODULE_LINKER_FLAGS_PROFILE "${CMAKE_MODULE_LINKER_FLAGS} -fprofile-arcs -ftest-coverage")

   set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -Wno-long-long -std=iso9899:1990 -Wundef -Wcast-align -Werror-implicit-function-declaration -Wchar-subscripts -Wall -W -Wpointer-arith -Wwrite-strings -Wformat-security -Wmissing-format-attribute -fno-common")
   # As of Qt 4.6.x we need to override the new exception macros if we want compile with -fno-exceptions
   set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wnon-virtual-dtor -Wno-long-long -Wundef -Wcast-align -Wchar-subscripts -Wall -W -Wpointer-arith -Wformat-security -fno-exceptions -DQT_NO_EXCEPTIONS -fno-check-new -fno-common")

   if (CMAKE_SYSTEM_NAME STREQUAL GNU)
      set (CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -pthread")
      set (CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -pthread")
   endif ()

   # gcc under Windows
   if (MINGW)
      set (CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,--export-all-symbols")
      set (CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -Wl,--export-all-symbols")
   endif ()

   check_cxx_compiler_flag(-Woverloaded-virtual __KDE_HAVE_W_OVERLOADED_VIRTUAL)
   if(__KDE_HAVE_W_OVERLOADED_VIRTUAL)
      set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Woverloaded-virtual")
   endif()

   set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Werror=return-type")

   set(_GCC_COMPILED_WITH_BAD_ALLOCATOR FALSE)
   exec_program(${CMAKE_C_COMPILER} ARGS ${CMAKE_C_COMPILER_ARG1} -v OUTPUT_VARIABLE _gcc_alloc_info)
   string(REGEX MATCH "(--enable-libstdcxx-allocator=mt)" _GCC_COMPILED_WITH_BAD_ALLOCATOR "${_gcc_alloc_info}")

   if (NOT _GCC_COMPILED_WITH_BAD_ALLOCATOR AND NOT WIN32)
      if (TARGET Qt5::Core)
         if(NOT QT_VISIBILITY_AVAILABLE)
            message(FATAL_ERROR "Qt compiled without support for -fvisibility=hidden. This will break plugins and linking of some applications. Please fix your Qt installation (try passing --reduce-exports to configure).")
         endif()
      endif()
   endif()

endif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")


if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
# TODO: why do the other KDE4_ENABLE_EXCEPTIONS not have -UQT_NO_EXCEPTIONS ?
   set (KDE4_ENABLE_EXCEPTIONS "-fexceptions -UQT_NO_EXCEPTIONS")
   # Select flags.
   set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-O2 -g -DNDEBUG -DQT_NO_DEBUG")
   set(CMAKE_CXX_FLAGS_RELEASE        "-O2 -DNDEBUG -DQT_NO_DEBUG")
   set(CMAKE_CXX_FLAGS_DEBUG          "-g -O2 -fno-inline")
   set(CMAKE_CXX_FLAGS_DEBUGFULL      "-g3 -fno-inline")
   set(CMAKE_CXX_FLAGS_PROFILE        "-g3 -fno-inline -ftest-coverage -fprofile-arcs")
   set(CMAKE_CXX_FLAGS_COVERAGE       "${CMAKE_CXX_FLAGS_DEBUG} -fprofile-arcs -ftest-coverage")
   set(CMAKE_C_FLAGS_RELWITHDEBINFO   "-O2 -g -DNDEBUG -DQT_NO_DEBUG")
   set(CMAKE_C_FLAGS_RELEASE          "-O2 -DNDEBUG -DQT_NO_DEBUG")
   set(CMAKE_C_FLAGS_DEBUG            "-g -O2 -fno-inline")
   set(CMAKE_C_FLAGS_DEBUGFULL        "-g3 -fno-inline")
   set(CMAKE_C_FLAGS_PROFILE          "-g3 -fno-inline -ftest-coverage -fprofile-arcs")
   set(CMAKE_C_FLAGS_COVERAGE         "${CMAKE_C_FLAGS_DEBUG} -fprofile-arcs -ftest-coverage")

   # TODO: do those flags also apply to the Intel compiler?
   set(CMAKE_EXE_LINKER_FLAGS_COVERAGE "${CMAKE_EXE_LINKER_FLAGS} -fprofile-arcs -ftest-coverage")
   set (CMAKE_SHARED_LINKER_FLAGS_PROFILE "${CMAKE_SHARED_LINKER_FLAGS} -fprofile-arcs -ftest-coverage")
   set (CMAKE_MODULE_LINKER_FLAGS_PROFILE "${CMAKE_MODULE_LINKER_FLAGS} -fprofile-arcs -ftest-coverage")

   set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -Wno-long-long -std=iso9899:1990 -Wundef -Wcast-align -Werror-implicit-function-declaration -Wchar-subscripts -Wall -W -Wpointer-arith -Wwrite-strings -Wformat-security -Wmissing-format-attribute -fno-common")
   # As of Qt 4.6.x we need to override the new exception macros if we want compile with -fno-exceptions
   set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wnon-virtual-dtor -Wno-long-long -Wundef -Wcast-align -Wchar-subscripts -Wall -W -Wpointer-arith -Wformat-security -Woverloaded-virtual -fno-exceptions -DQT_NO_EXCEPTIONS -fno-common -Werror=return-type")

   # There is a lot of code out there that includes headers that throw
   # exceptions, but we disable exceptions by default.
   # GCC, MSVC and ICC do not complain about these cases when the exceptions
   # are thrown inside some template code that is not expanded/used, which is
   # what happens most of the time.
   # We have to follow suit and be less strict in order not to break the build
   # in many places.
   set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fdelayed-template-parsing")

   if (CMAKE_SYSTEM_NAME STREQUAL GNU)
      set (CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -pthread")
      set (CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -pthread")
   endif ()

   if (NOT WIN32)
      if (TARGET Qt5::Core)
         if(NOT QT_VISIBILITY_AVAILABLE)
            message(FATAL_ERROR "Qt compiled without support for -fvisibility=hidden. This will break plugins and linking of some applications. Please fix your Qt installation (try passing --reduce-exports to configure).")
         endif()
      endif()
   endif()
endif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")


if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel")

   set (KDE4_ENABLE_EXCEPTIONS -fexceptions)
   # Select flags.
   set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-O2 -g")
   set(CMAKE_CXX_FLAGS_RELEASE        "-O2 -DNDEBUG -DQT_NO_DEBUG")
   set(CMAKE_CXX_FLAGS_DEBUG          "-O2 -g -fno-inline -noalign")
   set(CMAKE_CXX_FLAGS_DEBUGFULL      "-g -fno-inline -noalign")
   set(CMAKE_C_FLAGS_RELWITHDEBINFO   "-O2 -g")
   set(CMAKE_C_FLAGS_RELEASE          "-O2 -DNDEBUG -DQT_NO_DEBUG")
   set(CMAKE_C_FLAGS_DEBUG            "-O2 -g -fno-inline -noalign")
   set(CMAKE_C_FLAGS_DEBUGFULL        "-g -fno-inline -noalign")

   set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS}   -ansi -Wall -w1 -Wpointer-arith -fno-common")
   set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -ansi -Wall -w1 -Wpointer-arith -fno-exceptions -fno-common")

endif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel")

add_compiler_export_flags()  # from GenerateExportHeader.cmake

add_definitions(${_KDE4_PLATFORM_DEFINITIONS})

# add some more Qt-related definitions:
add_definitions(-DQT_NO_CAST_TO_ASCII
                -DQT_NO_CAST_FROM_ASCII
                -DQT_STRICT_ITERATORS
                -DQT_NO_URL_CAST_FROM_STRING
                -DQT_NO_CAST_FROM_BYTEARRAY
                -DQT_NO_SIGNALS_SLOTS_KEYWORDS
                -DQT_USE_FAST_CONCATENATION
                -DQT_USE_FAST_OPERATOR_PLUS
               )
