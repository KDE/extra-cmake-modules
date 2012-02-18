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

# Position-Independent-Executable is a feature of Binutils, Libc, and GCC that creates an executable
# which is something between a shared library and a normal executable.
# Programs compiled with these features appear as ?shared object? with the file command.
# info from "http://www.linuxfromscratch.org/~manuel/hlfs-book/glibc-2.4/chapter02/pie.html"
option(KDE4_ENABLE_FPIE  "Enable platform supports PIE linking")

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

# TODO: with KDE frameworks, there is no bootstrapping of FindKDE4Internal.cmake, so can the following
#       lines simply be removed ?

#    if(_kdeBootStrapping)
#       find_package(KDEWIN_Packager)
#       if (KDEWIN_PACKAGER_FOUND)
#          kdewin_packager("kdelibs" "${KDE_VERSION}" "KDE base library" "")
#       endif (KDEWIN_PACKAGER_FOUND)
#
#       include(Win32Macros)
#       addExplorerWrapper("kdelibs")
#    endif(_kdeBootStrapping)

# TODO: I don't think we should set any include dirs in this file
#   set( _KDE4_PLATFORM_INCLUDE_DIRS ${KDEWIN_INCLUDES})

   # if we are compiling kdelibs, add KDEWIN_LIBRARIES explicitely,
   # otherwise they come from KDELibsDependencies.cmake, Alex

# TODO: bootstrapping, see above
#    if (_kdeBootStrapping)
#       set( KDE4_KDECORE_LIBS ${KDE4_KDECORE_LIBS} ${KDEWIN_LIBRARIES} )
#    endif (_kdeBootStrapping)


   # windows, microsoft compiler
   if(MSVC)
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

endif (WIN32)



# TODO: this should not be here, make sure nothing breaks without it
# if (Q_WS_X11)
#    # Done by FindQt4.cmake already
#    #find_package(X11 REQUIRED)
#    # UNIX has already set _KDE4_PLATFORM_INCLUDE_DIRS, so append
#    set(_KDE4_PLATFORM_INCLUDE_DIRS ${_KDE4_PLATFORM_INCLUDE_DIRS} ${X11_INCLUDE_DIR} )
# endif ()

if(CYGWIN)
   message(FATAL_ERROR "Cygwin is NOT supported, use mingw or MSVC.")
endif(CYGWIN)


if(WIN32)
# TODO: do we really want to have this line here ? Is it actually needed ?
   # we prefer to use a different postfix for debug libs only on Windows
   # does not work atm
   set(CMAKE_DEBUG_POSTFIX "")

   # we don't support anything below w2k and all winapi calls are unicodes
   set( _KDE4_PLATFORM_DEFINITIONS -D_WIN32_WINNT=0x0501 -DWINVER=0x0501 -D_WIN32_IE=0x0501 -DUNICODE )
endif()


# This will need to be modified later to support either Qt/X11 or Qt/Mac builds
if (APPLE)
  set ( _KDE4_PLATFORM_DEFINITIONS -D__APPLE_KDE__ )

  # we need to set MACOSX_DEPLOYMENT_TARGET to (I believe) at least 10.2 or maybe 10.3 to allow
  # -undefined dynamic_lookup; in the future we should do this programmatically
  # hmm... why doesn't this work?
  set (ENV{MACOSX_DEPLOYMENT_TARGET} 10.3)
endif()


if ("${CMAKE_SYSTEM_NAME}" MATCHES Linux OR "${CMAKE_SYSTEM_NAME}" STREQUAL GNU)
   set ( _KDE4_PLATFORM_DEFINITIONS -D_XOPEN_SOURCE=500 -D_BSD_SOURCE -D_GNU_SOURCE)
endif()


if ("${CMAKE_SYSTEM_NAME}" MATCHES BSD)
   set ( _KDE4_PLATFORM_DEFINITIONS -D_GNU_SOURCE )
endif()


if (UNIX)
   set ( _KDE4_PLATFORM_DEFINITIONS ${_KDE4_PLATFORM_DEFINITIONS} -D_LARGEFILE64_SOURCE)

# TODO: is this test really necessary, or is it good enough to simply add -D_FILE_OFFSET_BITS=64 , as done below ?
#    check_cxx_source_compiles("
# #include <sys/types.h>
#  /* Check that off_t can represent 2**63 - 1 correctly.
#     We can't simply define LARGE_OFF_T to be 9223372036854775807,
#     since some C++ compilers masquerading as C compilers
#     incorrectly reject 9223372036854775807.  */
# #define LARGE_OFF_T (((off_t) 1 << 62) - 1 + ((off_t) 1 << 62))
#
#   int off_t_is_large[(LARGE_OFF_T % 2147483629 == 721 && LARGE_OFF_T % 2147483647 == 1) ? 1 : -1];
#   int main() { return 0; }
# " _OFFT_IS_64BIT)
#
#    if (NOT _OFFT_IS_64BIT)
#      set ( _KDE4_PLATFORM_DEFINITIONS "${_KDE4_PLATFORM_DEFINITIONS} -D_FILE_OFFSET_BITS=64")
#    endif (NOT _OFFT_IS_64BIT)
   set ( _KDE4_PLATFORM_DEFINITIONS ${_KDE4_PLATFORM_DEFINITIONS} -D_FILE_OFFSET_BITS=64)
endif (UNIX)


if (APPLE)
  # "-undefined dynamic_lookup" means we don't care about missing symbols at link-time by default
  # this is bad, but unavoidable until there is the equivalent of libtool -no-undefined implemented
  # or perhaps it already is, and I just don't know where to look  ;)

  set (CMAKE_SHARED_LINKER_FLAGS "-single_module -multiply_defined suppress ${CMAKE_SHARED_LINKER_FLAGS}")
  set (CMAKE_MODULE_LINKER_FLAGS "-multiply_defined suppress ${CMAKE_MODULE_LINKER_FLAGS}")
  #set(CMAKE_SHARED_LINKER_FLAGS "-single_module -undefined dynamic_lookup -multiply_defined suppress")
  #set(CMAKE_MODULE_LINKER_FLAGS "-undefined dynamic_lookup -multiply_defined suppress")

  # we profile...
  if(CMAKE_BUILD_TYPE_TOLOWER MATCHES profile)
    set (CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -fprofile-arcs -ftest-coverage")
    set (CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -fprofile-arcs -ftest-coverage")
  endif()

  # removed -Os, was there a special reason for using -Os instead of -O2 ?, Alex
  # optimization flags are set below for the various build types
  set (CMAKE_C_FLAGS     "${CMAKE_C_FLAGS} -fno-common")
  set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-common")
endif (APPLE)


# TODO: why don't we go inside that block on the BSDs ?
if (CMAKE_SYSTEM_NAME MATCHES Linux OR CMAKE_SYSTEM_NAME STREQUAL GNU)
   if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
     # TODO: does the Intel compiler also support --enable-new-dtags ? ...probably since they are only forwarded to the linker....
      set ( CMAKE_SHARED_LINKER_FLAGS "-Wl,--enable-new-dtags -Wl,--fatal-warnings -Wl,--no-undefined -lc ${CMAKE_SHARED_LINKER_FLAGS}")
      set ( CMAKE_MODULE_LINKER_FLAGS "-Wl,--enable-new-dtags -Wl,--fatal-warnings -Wl,--no-undefined -lc ${CMAKE_MODULE_LINKER_FLAGS}")
      set ( CMAKE_EXE_LINKER_FLAGS    "-Wl,--enable-new-dtags ${CMAKE_EXE_LINKER_FLAGS}")

      # we profile...
      if(CMAKE_BUILD_TYPE_TOLOWER MATCHES profile)
        # TODO: do those flags also apply to the Intel compiler ?
        set (CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -fprofile-arcs -ftest-coverage")
        set (CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -fprofile-arcs -ftest-coverage")
      endif(CMAKE_BUILD_TYPE_TOLOWER MATCHES profile)
   endif()

   if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel")
      set ( CMAKE_SHARED_LINKER_FLAGS "-Wl,--fatal-warnings -Wl,--no-undefined -lc ${CMAKE_SHARED_LINKER_FLAGS}")
      set ( CMAKE_MODULE_LINKER_FLAGS "-Wl,--fatal-warnings -Wl,--no-undefined -lc ${CMAKE_MODULE_LINKER_FLAGS}")
   endif ()
endif (CMAKE_SYSTEM_NAME MATCHES Linux OR CMAKE_SYSTEM_NAME STREQUAL GNU)



if (CMAKE_SYSTEM_NAME MATCHES BSD)
   set ( CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -lc")
   set ( CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -lc")
endif (CMAKE_SYSTEM_NAME MATCHES BSD)


############################################################
# compiler specific settings
############################################################



if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")

   # this macro is for internal use only.
   macro(_KDE_INSERT_FLAG FLAG VAR DOC)
      if(NOT ${VAR} MATCHES "${FLAG}")
         set(${VAR} "${${VAR}} ${FLAG}" CACHE STRING "Flags used by the linker during ${DOC} builds." FORCE)
      endif()
   endmacro()

   set (KDE4_ENABLE_EXCEPTIONS -EHsc)

   # Qt disables the native wchar_t type, do it too to avoid linking issues
   set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Zc:wchar_t-" )

   # make sure that no header adds libcmt by default using #pragma comment(lib, "libcmt.lib") as done by mfc/afx.h
   _kde_insert_flag("/NODEFAULTLIB:libcmt /DEFAULTLIB:msvcrt" CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO "Release with Debug Info")
   _kde_insert_flag("/NODEFAULTLIB:libcmt /DEFAULTLIB:msvcrt" CMAKE_EXE_LINKER_FLAGS_RELEASE "release")
   _kde_insert_flag("/NODEFAULTLIB:libcmt /DEFAULTLIB:msvcrt" CMAKE_EXE_LINKER_FLAGS_MINSIZEREL "release minsize")
   _kde_insert_flag("/NODEFAULTLIB:libcmtd /DEFAULTLIB:msvcrtd" CMAKE_EXE_LINKER_FLAGS_DEBUG "debug")
endif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")

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

# if (CMAKE_COMPILER_IS_GNUCC)
#    _DETERMINE_GCC_SYSTEM_INCLUDE_DIRS(c _dirs)
#    set(CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES
#        ${CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES} ${_dirs})
# endif (CMAKE_COMPILER_IS_GNUCC)


#    _DETERMINE_GCC_SYSTEM_INCLUDE_DIRS(c++ _dirs)
#    set(CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES
#        ${CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES} ${_dirs})

   set (KDE4_ENABLE_EXCEPTIONS "-fexceptions -UQT_NO_EXCEPTIONS")
   # Select flags.
   set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-O2 -g -DNDEBUG -DQT_NO_DEBUG")
   set(CMAKE_CXX_FLAGS_RELEASE        "-O2 -DNDEBUG -DQT_NO_DEBUG")
   set(CMAKE_CXX_FLAGS_DEBUG          "-g -O2 -fno-reorder-blocks -fno-schedule-insns -fno-inline")
   set(CMAKE_CXX_FLAGS_DEBUGFULL      "-g3 -fno-inline")
   set(CMAKE_CXX_FLAGS_PROFILE        "-g3 -fno-inline -ftest-coverage -fprofile-arcs")
   set(CMAKE_C_FLAGS_RELWITHDEBINFO   "-O2 -g -DNDEBUG -DQT_NO_DEBUG")
   set(CMAKE_C_FLAGS_RELEASE          "-O2 -DNDEBUG -DQT_NO_DEBUG")
   set(CMAKE_C_FLAGS_DEBUG            "-g -O2 -fno-reorder-blocks -fno-schedule-insns -fno-inline")
   set(CMAKE_C_FLAGS_DEBUGFULL        "-g3 -fno-inline")
   set(CMAKE_C_FLAGS_PROFILE          "-g3 -fno-inline -ftest-coverage -fprofile-arcs")

   if (CMAKE_SYSTEM_NAME MATCHES Linux OR CMAKE_SYSTEM_NAME STREQUAL GNU)
     set ( CMAKE_C_FLAGS     "${CMAKE_C_FLAGS} -Wno-long-long -std=iso9899:1990 -Wundef -Wcast-align -Werror-implicit-function-declaration -Wchar-subscripts -Wall -W -Wpointer-arith -Wwrite-strings -Wformat-security -Wmissing-format-attribute -fno-common")
     # As off Qt 4.6.x we need to override the new exception macros if we want compile with -fno-exceptions
     set ( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wnon-virtual-dtor -Wno-long-long -ansi -Wundef -Wcast-align -Wchar-subscripts -Wall -W -Wpointer-arith -Wformat-security -fno-exceptions -DQT_NO_EXCEPTIONS -fno-check-new -fno-common")
# TODO: the following line was added by Dirk in 2007 to make snprintf() available. But this should not be necessary, since
#       _BSD_SOURCE is already added to _KDE4_PLATFORM_DEFINITIONS (http://quickgit.kde.org/index.php?p=kdelibs.git&a=commitdiff&h=4a44862b2d178c1d2e1eb4da90010d19a1e4a42c&hp=6531561cb4ed978ff86b8d840dcafc9705af5527)
#     add_definitions (-D_BSD_SOURCE)
   endif ()

   if (CMAKE_SYSTEM_NAME STREQUAL GNU)
      set (CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -pthread")
      set (CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -pthread")
   endif ()

   # gcc under Windows
   if (MINGW)
      set (CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,--export-all-symbols -Wl,--disable-auto-import")
      set (CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -Wl,--export-all-symbols -Wl,--disable-auto-import")
   endif ()

   check_cxx_compiler_flag(-fPIE __KDE_HAVE_FPIE_SUPPORT)
   if(KDE4_ENABLE_FPIE)
      if(__KDE_HAVE_FPIE_SUPPORT)
         set (KDE4_CXX_FPIE_FLAGS "-fPIE")
         set (KDE4_PIE_LDFLAGS "-pie")
      else()
         message(STATUS "Your compiler doesn't support the PIE flag")
      endif()
   endif()

   check_cxx_compiler_flag(-Woverloaded-virtual __KDE_HAVE_W_OVERLOADED_VIRTUAL)
   if(__KDE_HAVE_W_OVERLOADED_VIRTUAL)
      set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Woverloaded-virtual")
   endif()

   # visibility support
   check_cxx_compiler_flag(-fvisibility=hidden __KDE_HAVE_GCC_VISIBILITY)
   set( __KDE_HAVE_GCC_VISIBILITY ${__KDE_HAVE_GCC_VISIBILITY} CACHE BOOL "GCC support for hidden visibility")

   # CMAKE_CXX_COMPILER_VERSION exists since cmake 2.8.7.20120217
   if(NOT CMAKE_CXX_COMPILER_VERSION)
      message(FATAL_ERROR "Your CMake is too old. You need current git master.")
   endif()

   if(NOT "${CMAKE_CXX_COMPILER_VERSION}"  VERSION_LESS  "4.1.0")
      set(GCC_IS_NEWER_THAN_4_1 TRUE)
   endif()

   if(NOT "${CMAKE_CXX_COMPILER_VERSION}"  VERSION_LESS  "4.2.0")
      set(GCC_IS_NEWER_THAN_4_2 TRUE)
   endif()

   if(NOT "${CMAKE_CXX_COMPILER_VERSION}"  VERSION_LESS  "4.3.0")
      set(GCC_IS_NEWER_THAN_4_3 TRUE)
   endif()

   # save a little by making local statics not threadsafe
   # ### do not enable it for older compilers, see
   # ### http://gcc.gnu.org/bugzilla/show_bug.cgi?id=31806
   if (GCC_IS_NEWER_THAN_4_3)
       set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-threadsafe-statics")
   endif()

   set(_GCC_COMPILED_WITH_BAD_ALLOCATOR FALSE)
   if (GCC_IS_NEWER_THAN_4_1)
      exec_program(${CMAKE_C_COMPILER} ARGS ${CMAKE_C_COMPILER_ARG1} -v OUTPUT_VARIABLE _gcc_alloc_info)
      string(REGEX MATCH "(--enable-libstdcxx-allocator=mt)" _GCC_COMPILED_WITH_BAD_ALLOCATOR "${_gcc_alloc_info}")
   endif ()

   if (__KDE_HAVE_GCC_VISIBILITY AND GCC_IS_NEWER_THAN_4_1 AND NOT _GCC_COMPILED_WITH_BAD_ALLOCATOR AND NOT WIN32)


       set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fvisibility=hidden")

# TODO: this variable is not documented and not used anywhere
#       added by Thiago here http://quickgit.kde.org/index.php?p=kdelibs.git&a=commitdiff&h=6bb4ef06259281d643d410cc4e84cd40bf4cd43f
#       and moved by Thiago into this extra variable here: http://quickgit.kde.org/index.php?p=kdelibs.git&a=commitdiff&h=a47300bd88435735bca6518926bc6c0e4c6cd708
#       set (KDE4_C_FLAGS "-fvisibility=hidden")

# TODO: get the following information from QtConfig.cmake
#       # check that Qt defines Q_DECL_EXPORT as __attribute__ ((visibility("default")))
#       # if it doesn't and KDE compiles with hidden default visibiltiy plugins will break
#       set(_source "#include <QtCore/QtGlobal>\n int main()\n {\n #ifndef QT_VISIBILITY_AVAILABLE \n #error QT_VISIBILITY_AVAILABLE is not available\n #endif \n }\n")
#       set(_source_file ${CMAKE_BINARY_DIR}/CMakeTmp/check_qt_visibility.cpp)
#       file(WRITE "${_source_file}" "${_source}")
#       set(_include_dirs "-DINCLUDE_DIRECTORIES:STRING=${QT_INCLUDES}")
#
#       try_compile(_compile_result ${CMAKE_BINARY_DIR} ${_source_file} CMAKE_FLAGS "${_include_dirs}" COMPILE_OUTPUT_VARIABLE _compile_output_var)
#
#       if(NOT _compile_result)
#          message(FATAL_ERROR "Qt compiled without support for -fvisibility=hidden. This will break plugins and linking of some applications. Please fix your Qt installation (try passing --reduce-exports to configure).")
#       endif(NOT _compile_result)

      if (GCC_IS_NEWER_THAN_4_2)
         set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Werror=return-type -fvisibility-inlines-hidden")
      endif()
   else()
      set (__KDE_HAVE_GCC_VISIBILITY 0)
   endif()

endif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")


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

   # visibility support
   set(__KDE_HAVE_ICC_VISIBILITY)
#   check_cxx_compiler_flag(-fvisibility=hidden __KDE_HAVE_ICC_VISIBILITY)
#   if (__KDE_HAVE_ICC_VISIBILITY)
#      set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fvisibility=hidden")
#   endif (__KDE_HAVE_ICC_VISIBILITY)

endif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel")
