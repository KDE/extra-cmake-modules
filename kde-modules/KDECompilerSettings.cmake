# This module sets more useful CMAKE_CXX_FLAGS.
#
# In particular, it enables many more warnings than the default,
# and sets stricter modes for some compiler features.  By default,
# it disables exceptions; kde_target_enable_exceptions() can be used
# to re-enable them for a specific target.
#
#
# This module provides the following functions:
#
#   kde_source_files_enable_exceptions([file1 [file2 [...]]])
#
# Enables exceptions for specific source files.  This should not be
# called on source files in a language other than C++.
#
#   kde_target_enable_exceptions(target <INTERFACE|PUBLIC|PRIVATE>)
#
# Enables exceptions for a specific target.  This should not be called
# on a target that has source files in a language other than C++.
#
#   kde_enable_exceptions()
#
# Enables exceptions for C++ source files compiled for the CMakeLists.txt file
# in the current directory and all subdirectories.
#


# TODO: Deal with QT_NO_EXCEPTIONS for non-gnu compilers?
#       This should be defined if and only if exceptions are disabled.
#       qglobal.h has some magic to set it when exceptions are disabled
#       with gcc, but other compilers are unaccounted for.

include(CheckCXXCompilerFlag)

# This macro is for adding definitions that affect the underlying
# platform API.  It makes sure that configure checks will also have
# the same defines, so that the checks match compiled code.
macro (_KDE_ADD_PLATFORM_DEFINITIONS)
    add_definitions(${ARGV})
    set(CMAKE_REQUIRED_DEFINITIONS ${CMAKE_REQUIRED_DEFINITIONS} ${ARGV})
endmacro()

if (WIN32)

   # windows, microsoft compiler
   if(MSVC OR "${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel")
      # FIXME: KDE_FULL_TEMPLATE_EXPORT_INSTANTIATION is a hangover from kdemacros.h
      #        and should probably be removed
      add_definitions(-DKDE_FULL_TEMPLATE_EXPORT_INSTANTIATION)

      # Speeds up compile times by not including everything with windows.h
      _kde_add_platform_definitions(-DWIN32_LEAN_AND_MEAN)

      # Disable warnings:
      # C4250: 'class1' : inherits 'class2::member' via dominance
      set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -wd4250" )
      # C4251: 'identifier' : class 'type' needs to have dll-interface to be
      #        used by clients of class 'type2'
      set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -wd4251" )
      # C4396: 'identifier' : 'function' the inline specifier cannot be used
      #        when a friend declaration refers to a specialization of a
      #        function template
      set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -wd4396" )
      # C4661: 'identifier' : no suitable definition provided for explicit
      #         template instantiation request
      set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -wd4661" )

      # to avoid a lot of deprecated warnings
      add_definitions(-D_CRT_SECURE_NO_DEPRECATE
                      -D_CRT_SECURE_NO_WARNINGS
                      -D_CRT_NONSTDC_NO_DEPRECATE
                      -D_SCL_SECURE_NO_WARNINGS
                     )
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

   # we don't support anything below w2k
   _kde_add_platform_definitions(-D_WIN32_WINNT=0x0501 -DWINVER=0x0501 -D_WIN32_IE=0x0501)
   # all winapi calls are unicodes
   _kde_add_platform_definitions(-DUNICODE)

endif (WIN32)

if (APPLE)
  # we need to set MACOSX_DEPLOYMENT_TARGET to (I believe) at least 10.2 or
  # maybe 10.3 to allow -undefined dynamic_lookup; in the future we should do
  # this programmatically

  # hmm... why doesn't this work?
  set (ENV{MACOSX_DEPLOYMENT_TARGET} 10.3)
endif()


if ("${CMAKE_SYSTEM_NAME}" MATCHES Linux OR "${CMAKE_SYSTEM_NAME}" STREQUAL GNU)
   # Get glibc to provide useful functions
   #
   # _BSD_SOURCE: is/was needed by glibc for snprintf to be available when
   # building C files.
   # See commit 4a44862b2d178c1d2e1eb4da90010d19a1e4a42c.
   _kde_add_platform_definitions(-D_XOPEN_SOURCE=500 -D_BSD_SOURCE -D_GNU_SOURCE)
endif()


if (UNIX)
   # 64-bit file offsets
   _kde_add_platform_definitions(-D_LARGEFILE64_SOURCE)
endif (UNIX)


if (APPLE)
  # "-undefined dynamic_lookup" means we don't care about missing symbols at
  # link-time by default this is bad, but unavoidable until there is the
  # equivalent of libtool -no-undefined implemented or perhaps it already is,
  # and I just don't know where to look  ;)

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

if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC" OR (WIN32 AND "${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel"))

   # this macro is for internal use only.
   macro(_KDE_INSERT_FLAG FLAG VAR DOC)
      if(NOT ${VAR} MATCHES "${FLAG}")
         set(${VAR} "${${VAR}} ${FLAG}" CACHE STRING "Flags used by the linker during ${DOC} builds." FORCE)
      endif()
   endmacro()

   # make sure that no header adds libcmt by default using
   # #pragma comment(lib, "libcmt.lib") as done by mfc/afx.h
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
   set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -Wno-long-long -std=iso9899:1990 -Wundef -Wcast-align -Werror-implicit-function-declaration -Wchar-subscripts -Wall -W -Wpointer-arith -Wwrite-strings -Wformat-security -Wmissing-format-attribute -fno-common")
   # As of Qt 4.6.x we need to override the new exception macros if we want compile with -fno-exceptions
   set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++0x -Wnon-virtual-dtor -Wno-long-long -Wundef -Wcast-align -Wchar-subscripts -Wall -W -Wpointer-arith -Wformat-security -fno-exceptions -fno-check-new -fno-common")

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
   # Note that exceptions are enabled by default when building with clang. That
   # is, -fno-exceptions is not set in CMAKE_CXX_FLAGS below. This is because a
   # lot of code in different KDE modules ends up including code that throws
   # exceptions. Most (or all) of the occurrences are in template code that
   # never gets instantiated. Contrary to GCC, ICC and MSVC, clang (most likely
   # rightfully) complains about that. Trying to work around the issue by
   # passing -fdelayed-template-parsing brings other problems, as noted in
   # http://lists.kde.org/?l=kde-core-devel&m=138157459706783&w=2.
   # The generated code will be slightly bigger, but there is no way to avoid
   # it.

   set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -Wno-long-long -std=iso9899:1990 -Wundef -Wcast-align -Werror-implicit-function-declaration -Wchar-subscripts -Wall -W -Wpointer-arith -Wwrite-strings -Wformat-security -Wmissing-format-attribute -fno-common")
   set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++0x -Wnon-virtual-dtor -Wno-long-long -Wundef -Wcast-align -Wchar-subscripts -Wall -W -Wpointer-arith -Wformat-security -Woverloaded-virtual -fno-common -Werror=return-type")

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
   set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS}   -Wall -w1 -Wpointer-arith -fno-common")
   set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++0x -Wall -w1 -Wpointer-arith -fno-exceptions -fno-common")

endif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel")

set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN 1)

macro(_kdecompilersettings_append_exception_flag VAR)
    if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
        set(${VAR} "${${VAR}} -EHsc")
    elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel")
        if (WIN32)
            set(${VAR} "${${VAR}} -EHsc")
        else()
            set(${VAR} "${${VAR}} -fexceptions")
        endif()
    elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
        set(${VAR} "${${VAR}} -fexceptions")
    elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
        # We never disabled exceptions for Clang anyway, but this makes it
        # blindingly obvious to anyone building with make VERBOSE=1
        set(${VAR} "${${VAR}} -fexceptions")
    endif()
    string(STRIP "${${VAR}}" ${VAR})
endmacro()

function(KDE_SOURCE_FILES_ENABLE_EXCEPTIONS)
    foreach(source_file ${ARGV})
        get_source_file_property(flags ${source_file} COMPILE_FLAGS)
        _kdecompilersettings_append_exception_flag(flags)
        set_source_files_properties(${source_file} COMPILE_FLAGS "${flags}")
    endforeach()
endfunction()

function(KDE_TARGET_ENABLE_EXCEPTIONS target mode)
    # TODO we need to unset QT_NO_EXCEPTIONS for non-GNU compilers
    #      (although we currently do not set it anyway)
    target_compile_options(${target} ${mode} "$<$<CXX_COMPILER_ID:MSVC>:-EHsc>")
    if (WIN32)
        target_compile_options(${target} ${mode} "$<$<CXX_COMPILER_ID:Intel>:-EHsc>")
    else()
        target_compile_options(${target} ${mode} "$<$<CXX_COMPILER_ID:Intel>:-fexceptions>")
    endif()
    # We never disabled exceptions for Clang anyway, but this makes it
    # blindingly obvious to anyone building with make VERBOSE=1
    target_compile_options(${target} ${mode}
        "$<$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>>:-fexceptions>")
endfunction()

function(KDE_ENABLE_EXCEPTIONS)

    # We set CMAKE_CXX_FLAGS, rather than add_compile_options(), because
    # we only want to affect the compilation of C++ source files.

    # strip any occurrences of -DQT_NO_EXCEPTIONS; this should only be defined
    # if exceptions are disabled
    # the extra spaces mean we will not accentially mangle any other options
    string(REPLACE " -DQT_NO_EXCEPTIONS " " " CMAKE_CXX_FLAGS " ${CMAKE_CXX_FLAGS} ")
    # this option is common to several compilers, so just always remove it
    string(REPLACE " -fno-exceptions " " " CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
    # strip undoes the extra spaces we put in above
    string(STRIP "${CMAKE_CXX_FLAGS}" CMAKE_CXX_FLAGS)

    _kdecompilersettings_append_exception_flag(CMAKE_CXX_FLAGS)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}" PARENT_SCOPE)

endfunction()

