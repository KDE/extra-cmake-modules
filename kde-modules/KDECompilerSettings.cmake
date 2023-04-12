# SPDX-FileCopyrightText: 2014 Alex Merry <alex.merry@kde.org>
# SPDX-FileCopyrightText: 2013 Stephen Kelly <steveire@gmail.com>
# SPDX-FileCopyrightText: 2012-2013 Raphael Kubo da Costa <rakuco@FreeBSD.org>
# SPDX-FileCopyrightText: 2007 Matthias Kretz <kretz@kde.org>
# SPDX-FileCopyrightText: 2006-2007 Laurent Montel <montel@kde.org>
# SPDX-FileCopyrightText: 2006-2013 Alex Neundorf <neundorf@kde.org>
# SPDX-FileCopyrightText: 2021 Friedrich W. H. Kossebau <kossebau@kde.org>
#
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
KDECompilerSettings
-------------------

Set useful compile and link flags for C++ (and C) code.

Enables many more warnings than the default, and sets stricter modes
for some compiler features.  By default, exceptions are disabled;
``kde_target_enable_exceptions()`` can be used to re-enable them for a
specific target.

.. note::
  It is recommended to include this module with the ``NO_POLICY_SCOPE``
  flag, otherwise you may get spurious warnings with some versions of CMake.

Since 5.85 newer settings are controlled by a variable
``KDE_COMPILERSETTINGS_LEVEL``, taking an ECM version as value. That
version can not be greater than the minimum required ECM version.
The settings which are default at that version will then be used,
but can be overridden by more fine-grained controls (see respective settings).
This variable needs to be set before including this module, otherwise
defaults to the minimum required ECM version.

Modern code
~~~~~~~~~~~

The following CMake C standard default variables are set:

For ``KDE_COMPILERSETTINGS_LEVEL`` >= 5.85:

- ``CMAKE_C_STANDARD``: ``99``
- ``CMAKE_C_STANDARD_REQUIRED``: ``TRUE``
- ``CMAKE_C_EXTENSIONS``: ``OFF``

Otherwise:

- ``CMAKE_C_STANDARD``: ``90``
- ``CMAKE_C_STANDARD_REQUIRED``: not modified
- ``CMAKE_C_EXTENSIONS``: not modified

If the variable ``CMAKE_C_STANDARD`` is already set when including this module,
none of the above variables will be modified.

The following CMake C++ standard default variables are set:

For ``KDE_COMPILERSETTINGS_LEVEL`` >= 5.85:

- ``CMAKE_CXX_STANDARD``: ``17``
- ``CMAKE_CXX_STANDARD_REQUIRED``: ``TRUE``
- ``CMAKE_CXX_EXTENSIONS``: ``OFF``

Otherwise:

- ``CMAKE_CXX_STANDARD``: ``11``
- ``CMAKE_CXX_STANDARD_REQUIRED``: ``TRUE``
- ``CMAKE_CXX_EXTENSIONS``: not modified.

If the variable ``CMAKE_CXX_STANDARD`` is already set when including this module,
none of the above variables will be modified.


The following C++ compiler flags are set:

- ``-pedantic`` (GNU and Clang compilers, since 5.85)

  Can be disabled by setting ``KDE_SKIP_PEDANTIC_WARNINGS_SETTINGS`` to ``TRUE``
  before including this module (default is ``FALSE`` for
  ``KDE_COMPILERSETTINGS_LEVEL`` >= 5.85, ``TRUE`` otherwise).

- ``-Wmissing-include-dirs`` (GNU compilers, since 5.85)

  Can be disabled by setting ``KDE_SKIP_MISSING_INCLUDE_DIRS_WARNINGS_SETTINGS`` to ``TRUE``
  before including this module (default is ``FALSE`` for
  ``KDE_COMPILERSETTINGS_LEVEL`` >= 5.85, ``TRUE`` otherwise).

- ``-Wzero-as-null-pointer-constant`` (GNU and Clang compilers, since 5.85)

  Can be disabled by setting ``KDE_SKIP_NULLPTR_WARNINGS_SETTINGS`` to ``TRUE``
  before including this module (default is ``FALSE`` for
  ``KDE_COMPILERSETTINGS_LEVEL`` >= 5.85, ``TRUE`` otherwise).

- ``-Werror=undef`` (GNU and Clang compilers, since 5.96.0)

- Qt related preprocessor definitions (since 5.85.0):

  - ``-DQT_NO_CAST_TO_ASCII``
  - ``-DQT_NO_CAST_FROM_ASCII``
  - ``-DQT_NO_URL_CAST_FROM_STRING``
  - ``-DQT_NO_CAST_FROM_BYTEARRAY``
  - ``-DQT_USE_QSTRINGBUILDER``
  - ``-DQT_NO_NARROWING_CONVERSIONS_IN_CONNECT``
  - ``-DQT_NO_KEYWORDS``
  - ``-DQT_NO_FOREACH``
  - ``-DQT_STRICT_ITERATORS``

    Strict iterators are not enabled on Windows, because they lead
    to a link error when application code iterates over a QVector<QPoint> for
    instance, unless Qt itself was also built with strict iterators.
    See example at https://bugreports.qt.io/browse/AUTOSUITE-946

  Can be controlled by setting ``KDE_QT_MODERNCODE_DEFINITIONS_LEVEL`` to the
  version of ECM where the wanted set of definitions has been added
  before including this module (default is ``KDE_COMPILERSETTINGS_LEVEL``).
  To disable individual definitions instead use ``remove_definitions()`` directly
  after including this module.

Functions
~~~~~~~~~

This module provides the following functions::

  kde_source_files_enable_exceptions([file1 [file2 [...]]])

Enables exceptions for specific source files.  This should not be
used on source files in a language other than C++.

::

  kde_target_enable_exceptions(target <INTERFACE|PUBLIC|PRIVATE>)

Enables exceptions for a specific target.  This should not be used
on a target that has source files in a language other than C++.

::

  kde_enable_exceptions()

Enables exceptions for C++ source files compiled for the
CMakeLists.txt file in the current directory and all subdirectories.

Variables
~~~~~~~~~

Inclusion of this module defines the following variables:

``ENABLE_BSYMBOLICFUNCTIONS``
    indicates whether we make use of ``-Bsymbolic-functions`` for linking.
    It ensures libraries bind global function references locally rather than
    at runtime.
    This option only has an effect on ELF-based systems.

    The option is disabled by default except when using
    :kde-module:`KDEFrameworkCompilerSettings` where it's enabled. Projects can enable
    it by calling ``set(ENABLE_BSYMBOLICFUNCTIONS ON)`` or passing
    ``-DENABLE BSYMBOLICFUNCTIONS=ON`` when configuring the build directory.

    Since 5.85

Example usages:

.. code-block:: cmake

  # needing some macro/feature only available with ECM 5.80.0
  find_package(ECM 5.80.0 NO_MODULE)

  # requiring ECM 5.80.0 above will default KDE_COMPILERSETTINGS_LEVEL also to 5.80.0,
  # thus not activate any newer settings
  include(KDECompilerSettings NO_POLICY_SCOPE)

.. code-block:: cmake

  # needing some macro/feature only available with ECM 5.87.0
  find_package(ECM 5.87.0 NO_MODULE)

  # project uses settings default as of KDECompilerSettings in ECM 5.85.0
  set(KDE_COMPILERSETTINGS_LEVEL 5.85.0)
  include(KDECompilerSettings NO_POLICY_SCOPE)

.. code-block:: cmake

  # needing some macro/feature only available with ECM 5.87.0
  find_package(ECM 5.87.0 NO_MODULE)

  # project mainly uses settings default as of KDECompilerSettings in ECM 5.85.0
  # with some small twisting
  set(KDE_COMPILERSETTINGS_LEVEL 5.85.0)
  # not ready yet for pedantic compilers
  set(KDE_SKIP_PEDANTIC_WARNINGS_SETTINGS TRUE)
  # avoid any Qt definitions
  set(KDE_QT_MODERNCODE_DEFINITIONS_LEVEL 5.84.0)
  include(KDECompilerSettings NO_POLICY_SCOPE)

.. code-block:: cmake

  # needing some macro/feature only available with ECM 5.85.0
  find_package(ECM 5.85.0 NO_MODULE)

  # requiring ECM 5.85.0 above will default KDE_COMPILERSETTINGS_LEVEL also to 5.85.0,
  # which again defaults KDE_QT_MODERNCODE_DEFINITIONS_LEVEL also to 5.85.0
  include(KDECompilerSettings NO_POLICY_SCOPE)
  # project is fine with almost all added Qt definitions as of 5.85.0, but not these ones:
  remove_definitions(
      -DQT_NO_KEYWORDS
      -DQT_NO_FOREACH
  )

Since pre-1.0.0.
#]=======================================================================]

############################################################
# Select and check KDE_COMPILERSETTINGS_LEVEL
# For a specified version of KDE_COMPILERSETTINGS_LEVEL always the same set
# of settings needs to be used, to give that version a meaning, even more as
# the settings are usually more strict and can break builds which build fine
# without the setting.
# As at the time of version x it is usually unknown what future versions x+y
# will offer as settings, the minimum required version of ECM sets the upper
# limit then for the level version.
if(NOT DEFINED KDE_COMPILERSETTINGS_LEVEL)
    set(KDE_INTERNAL_COMPILERSETTINGS_LEVEL "${ECM_GLOBAL_FIND_VERSION}")
else()
    if(KDE_COMPILERSETTINGS_LEVEL VERSION_GREATER "${ECM_GLOBAL_FIND_VERSION}")
        message(FATAL_ERROR "KDE_COMPILERSETTINGS_LEVEL (${KDE_COMPILERSETTINGS_LEVEL}) cannot be newer than the min. required ECM version (${ECM_GLOBAL_FIND_VERSION}).")
    endif()
    set(KDE_INTERNAL_COMPILERSETTINGS_LEVEL "${KDE_COMPILERSETTINGS_LEVEL}")
endif()

include("${ECM_MODULE_DIR}/ECMSourceVersionControl.cmake")

############################################################
# Default build type
# If no build type was specified, default to using a debug build if the
# source directory is a git clone.
# Otherwise, leave it empty, to let distro packagers choose the flags.
############################################################
if (ECM_SOURCE_UNDER_VERSION_CONTROL AND NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    set(default_build_type "Debug")
    message(STATUS "Setting build type to '${default_build_type}' as none was specified.")
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY VALUE "${default_build_type}")
    # Set the possible values of build type for cmake-gui
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS
        "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()

############################################################
# Toolchain minimal requirements
#
# Note that only compilers officially supported by Qt are
# supported by this file; workarounds for older compilers
# will generally not be included.  See
# https://qt-project.org/doc/qt-5/supported-platforms.html
# and
# https://community.kde.org/Frameworks/Policies#Frameworks_compiler_requirements_and_C.2B.2B11
# for more details.
############################################################

macro(_kde_compiler_min_version min_version)
    if (CMAKE_CXX_COMPILER_VERSION VERSION_LESS ${min_version})
        message(WARNING "Version ${CMAKE_CXX_COMPILER_VERSION} of the ${CMAKE_CXX_COMPILER_ID} C++ compiler is not supported. Please use version ${min_version} or later.")
    endif()
endmacro()

if (MSVC)
    # MSVC_VERSION 1600 = VS 10.0 = Windows SDK 7
    # See: cmake --help-variable MSVC_VERSION
    # and https://developer.mozilla.org/en-US/docs/Windows_SDK_versions
    if (${MSVC_VERSION} LESS 1600)
        message(WARNING "Your MSVC version (${MSVC_VERSION}) is not supported. Please use the Windows SDK version 7 or later (or Microsoft Visual Studio 2010 or later).")
    endif()
elseif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    if (WIN32)
        _kde_compiler_min_version("4.7")
    elseif (APPLE)
        # FIXME: Apple heavily modifies GCC, so checking the
        # GCC version on OS/X is not very useful.
    else()
        _kde_compiler_min_version("4.5")
    endif()
elseif (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    _kde_compiler_min_version("3.1")
else()
    message(WARNING "${CMAKE_CXX_COMPILER_ID} is not a supported C++ compiler.")
endif()



############################################################
# System API features
############################################################

# This macro is for adding definitions that affect the underlying
# platform API.  It makes sure that configure checks will also have
# the same defines, so that the checks match compiled code.
macro (_KDE_ADD_PLATFORM_DEFINITIONS)
    add_definitions(${ARGV})
    set(CMAKE_REQUIRED_DEFINITIONS ${CMAKE_REQUIRED_DEFINITIONS} ${ARGV})
endmacro()

include(CheckSymbolExists)
check_symbol_exists("__GLIBC__" "stdlib.h" LIBC_IS_GLIBC)
if (LIBC_IS_GLIBC)
    # Enable everything in GNU libc.  Any code using non-portable features
    # needs to perform feature tests, but this ensures that any such features
    # will be found if they exist.
    #
    # NB: we do NOT define _BSD_SOURCE, as with GNU libc that requires linking
    # against the -lbsd-compat library (it changes the behaviour of some
    # functions).  This, however, means that strlcat and strlcpy are not
    # provided by glibc.
    _kde_add_platform_definitions(-D_GNU_SOURCE)
endif ()

if (UNIX)
    # Enable extra API for using 64-bit file offsets on 32-bit systems.
    # FIXME: this is included in _GNU_SOURCE in glibc; do other libc
    # implementation recognize it?
    _kde_add_platform_definitions(-D_LARGEFILE64_SOURCE)

    include(CheckCXXSourceCompiles)

    # By default (in glibc, at least), on 32bit platforms off_t is 32 bits,
    # which causes a SIGXFSZ when trying to manipulate files larger than 2Gb
    # using libc calls (note that this issue does not occur when using QFile).
    check_cxx_source_compiles("
#include <sys/types.h>
 /* Check that off_t can represent 2**63 - 1 correctly.
    We can't simply define LARGE_OFF_T to be 9223372036854775807,
    since some C++ compilers masquerading as C compilers
    incorrectly reject 9223372036854775807.  */
#define LARGE_OFF_T (((off_t) 1 << 62) - 1 + ((off_t) 1 << 62))
  int off_t_is_large[(LARGE_OFF_T % 2147483629 == 721 && LARGE_OFF_T % 2147483647 == 1) ? 1 : -1];
  int main() { return 0; }
" _OFFT_IS_64BIT)

    if (NOT _OFFT_IS_64BIT)
        _kde_add_platform_definitions(-D_FILE_OFFSET_BITS=64)
    endif ()
endif()

if (WIN32)
    # Speeds up compile times by not including everything with windows.h
    # See http://msdn.microsoft.com/en-us/library/windows/desktop/aa383745%28v=vs.85%29.aspx
    _kde_add_platform_definitions(-DWIN32_LEAN_AND_MEAN)

    # Target Windows Vista
    # This enables various bits of new API
    # See http://msdn.microsoft.com/en-us/library/windows/desktop/aa383745%28v=vs.85%29.aspx
    _kde_add_platform_definitions(-D_WIN32_WINNT=0x0600 -DWINVER=0x0600 -D_WIN32_IE=0x0600)

    # Use the Unicode versions of Windows API by default
    # See http://msdn.microsoft.com/en-us/library/windows/desktop/dd317766%28v=vs.85%29.aspx
    _kde_add_platform_definitions(-DUNICODE -D_UNICODE)

    # As stated in http://msdn.microsoft.com/en-us/library/4hwaceh6.aspx M_PI only gets defined
    # if _USE_MATH_DEFINES is defined, with mingw this has a similar effect as -D_GNU_SOURCE on math.h
    _kde_add_platform_definitions(-D_USE_MATH_DEFINES)

    # Don't define MIN and MAX in windows.h
    # the defines break the use of std::max
    _kde_add_platform_definitions(-DNOMINMAX)
endif()



############################################################
# Language and toolchain features
############################################################

# Pick sensible versions of the C and C++ standards.
if (NOT CMAKE_C_STANDARD)
    if (KDE_INTERNAL_COMPILERSETTINGS_LEVEL VERSION_GREATER_EQUAL 5.85.0)
        set(CMAKE_C_STANDARD 99)
        set(CMAKE_C_STANDARD_REQUIRED TRUE)
        set(CMAKE_C_EXTENSIONS OFF)
    else()
        set(CMAKE_C_STANDARD 90)
    endif()
endif()
if (NOT CMAKE_CXX_STANDARD)
    if (KDE_INTERNAL_COMPILERSETTINGS_LEVEL VERSION_GREATER_EQUAL 5.85.0)
        set(CMAKE_CXX_STANDARD 17)
        set(CMAKE_CXX_EXTENSIONS OFF)
    else()
        set(CMAKE_CXX_STANDARD 11)
    endif()
    set(CMAKE_CXX_STANDARD_REQUIRED TRUE)
endif()

# Do not merge uninitialized global variables.
# This is mostly a "principle of least surprise" thing, but also
# has performance benefits.
# See https://www.ibm.com/developerworks/community/blogs/zTPF/entry/benefits_of_the_fnocommon_compile_option_peter_lemieszewski?lang=en
# Note that this only applies to C code; C++ already behaves like this.
if (CMAKE_C_COMPILER_ID STREQUAL "GNU" OR
        CMAKE_C_COMPILER_ID MATCHES "Clang" OR
        (CMAKE_C_COMPILER_ID STREQUAL "Intel" AND NOT WIN32))
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fno-common")
endif()

# Do not treat the operator name keywords and, bitand, bitor, compl, not, or and xor as synonyms as keywords.
# They're not supported under Visual Studio out of the box thus using them limits the portability of code
if (CMAKE_C_COMPILER_ID STREQUAL "GNU" OR
        CMAKE_C_COMPILER_ID MATCHES "Clang" OR
        (CMAKE_C_COMPILER_ID STREQUAL "Intel" AND NOT WIN32))
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-operator-names")
endif()

# Default to hidden visibility for symbols
set(CMAKE_C_VISIBILITY_PRESET hidden)
set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN 1)
if (POLICY CMP0063)
    # No sane project should be affected by CMP0063, so suppress the warnings
    # generated by the above visibility settings in CMake >= 3.3
    cmake_policy(SET CMP0063 NEW)
endif()

if (UNIX AND NOT APPLE AND NOT CYGWIN)
    # Enable adding DT_RUNPATH, which means that LD_LIBRARY_PATH takes precedence
    # over the built-in rPath
    set(CMAKE_SHARED_LINKER_FLAGS "-Wl,--enable-new-dtags ${CMAKE_SHARED_LINKER_FLAGS}")
    set(CMAKE_MODULE_LINKER_FLAGS "-Wl,--enable-new-dtags ${CMAKE_MODULE_LINKER_FLAGS}")
    set(CMAKE_EXE_LINKER_FLAGS    "-Wl,--enable-new-dtags ${CMAKE_EXE_LINKER_FLAGS}")
endif()

if (CMAKE_SYSTEM_NAME STREQUAL GNU)
    # Enable multithreading with the pthread library
    # FIXME: Is this actually necessary to have here?
    #        Can CMakeLists.txt files that require it use FindThreads.cmake
    #        instead?
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -pthread")
    set(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -pthread")
endif()

if (MSVC)
    # Our source files are UTF-8 encoded, and assuming that is also the
    # default behavior of GCC/Clang. Not so for MSVC though, so force
    # that to UTF-8 explicitly, as that will otherwise cause compile-time
    # and runtime issues when dealing with string literals outside of 7-bit ASCII.
    add_compile_options(/utf-8)
endif()


############################################################
# Turn off exceptions by default
#
# This involves enough code to be separate from the
# previous section.
############################################################

# TODO: Deal with QT_NO_EXCEPTIONS for non-gnu compilers?
#       This should be defined if and only if exceptions are disabled.
#       qglobal.h has some magic to set it when exceptions are disabled
#       with gcc, but other compilers are unaccounted for.

# Turn off exceptions by default
if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-exceptions")
elseif(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-exceptions")
elseif (CMAKE_CXX_COMPILER_ID STREQUAL "Intel" AND NOT WIN32)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-exceptions")
#elseif (MSVC OR (WIN32 AND CMAKE_CXX_COMPILER_ID STREQUAL "Intel"))
    # Exceptions appear to be disabled by default for MSVC
    # http://msdn.microsoft.com/en-us/library/1deeycx5.aspx

    # FIXME: are exceptions disabled by default for Intel?
endif()

macro(_kdecompilersettings_append_exception_flag VAR)
    if (MSVC)
        set(${VAR} "${${VAR}} -EHsc")
    elseif (CMAKE_CXX_COMPILER_ID STREQUAL "Intel")
        if (WIN32)
            set(${VAR} "${${VAR}} -EHsc")
        else()
            set(${VAR} "${${VAR}} -fexceptions")
        endif()
    elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        set(${VAR} "${${VAR}} -fexceptions")
    elseif(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
        set(${VAR} "${${VAR}} -fexceptions")
    endif()
    string(STRIP "${${VAR}}" ${VAR})
endmacro()

function(KDE_SOURCE_FILES_ENABLE_EXCEPTIONS)
    foreach(source_file ${ARGV})
        get_source_file_property(flags ${source_file} COMPILE_FLAGS)
        if(NOT flags)
            # If COMPILE_FLAGS is not set, get_source_file_property() sets it to
            # NOTFOUND, which breaks build if we concatenate anything to
            # the "NOTFOUND" string.
            # Note that NOTFOUND evaluates to False, so we do enter the if.
            set(flags "")
        endif()
        _kdecompilersettings_append_exception_flag(flags)
        set_source_files_properties(${source_file} COMPILE_FLAGS "${flags}")
    endforeach()
endfunction()

function(KDE_TARGET_ENABLE_EXCEPTIONS target mode)
    target_compile_options(${target} ${mode} "$<$<CXX_COMPILER_ID:MSVC>:-EHsc>")
    if (WIN32)
        target_compile_options(${target} ${mode} "$<$<CXX_COMPILER_ID:Intel>:-EHsc>")
    else()
        target_compile_options(${target} ${mode} "$<$<CXX_COMPILER_ID:Intel>:-fexceptions>")
    endif()
    target_compile_options(${target} ${mode}
        "$<$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>,$<CXX_COMPILER_ID:AppleClang>>:-fexceptions>")
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



############################################################
# Better diagnostics (warnings, errors)
############################################################

if ((CMAKE_CXX_COMPILER_ID STREQUAL "GNU" AND NOT APPLE) OR
        (CMAKE_CXX_COMPILER_ID MATCHES "Clang" AND NOT APPLE) OR
        (CMAKE_CXX_COMPILER_ID STREQUAL "Intel" AND NOT WIN32))
    # Linker warnings should be treated as errors
    set(CMAKE_SHARED_LINKER_FLAGS "-Wl,--fatal-warnings ${CMAKE_SHARED_LINKER_FLAGS}")
    set(CMAKE_MODULE_LINKER_FLAGS "-Wl,--fatal-warnings ${CMAKE_MODULE_LINKER_FLAGS}")

    # Do not allow undefined symbols, even in non-symbolic shared libraries
    # On OpenBSD we must disable this to allow the stuff to properly compile without explicit libc specification
    if (NOT CMAKE_SYSTEM_NAME MATCHES "OpenBSD")
        set(CMAKE_SHARED_LINKER_FLAGS "-Wl,--no-undefined ${CMAKE_SHARED_LINKER_FLAGS}")
        set(CMAKE_MODULE_LINKER_FLAGS "-Wl,--no-undefined ${CMAKE_MODULE_LINKER_FLAGS}")
    endif()
endif()

set(_KDE_GCC_COMMON_WARNING_FLAGS "-Wall -Wextra -Wcast-align -Wchar-subscripts -Wformat-security -Wno-long-long -Wpointer-arith -Wundef")
if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    # -Wgnu-zero-variadic-macro-arguments (part of -pedantic) is triggered by every qCDebug() call and therefore results
    # in a lot of noise. This warning is only notifying us that clang is emulating the GCC behaviour
    # instead of the exact standard wording so we can safely ignore it
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-gnu-zero-variadic-macro-arguments")
endif()
if(CMAKE_C_COMPILER_ID STREQUAL "GNU" OR CMAKE_C_COMPILER_ID MATCHES "Clang")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${_KDE_GCC_COMMON_WARNING_FLAGS} -Wmissing-format-attribute -Wwrite-strings")
    # Make some warnings errors
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Werror=implicit-function-declaration")
endif()
if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${_KDE_GCC_COMMON_WARNING_FLAGS} -Wnon-virtual-dtor -Woverloaded-virtual")
    # Make some warnings errors
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Werror=return-type -Werror=init-self")
    if (KDE_INTERNAL_COMPILERSETTINGS_LEVEL VERSION_GREATER_EQUAL 5.96.0)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Werror=undef")
    endif()
elseif(MSVC)
  # similar to -Werror=return-type
  # https://learn.microsoft.com/en-us/cpp/error-messages/compiler-warnings/compiler-warning-level-1-c4715?view=msvc-170
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /we4715")
endif()
if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR
    (CMAKE_CXX_COMPILER_ID MATCHES "Clang" AND CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 3.5))
    # -Wvla: use of variable-length arrays (an extension to C++)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wvla")
endif()
if ((CMAKE_CXX_COMPILER_ID STREQUAL "GNU" AND CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 5.0) OR
    (CMAKE_CXX_COMPILER_ID MATCHES "Clang" AND CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 3.5))
    include(CheckCXXCompilerFlag)
    check_cxx_compiler_flag(-Wdate-time HAVE_DATE_TIME)
    if (HAVE_DATE_TIME)
        # -Wdate-time: warn if we use __DATE__ or __TIME__ (we want to be able to reproduce the exact same binary)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wdate-time")
    endif()
endif()

if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
   if (CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 5.0.0)
      set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wsuggest-override -Wlogical-op" )
   endif()
endif()

# -w1 turns on warnings and errors
# FIXME: someone needs to have a closer look at the Intel compiler options
if (CMAKE_C_COMPILER_ID STREQUAL "Intel" AND NOT WIN32)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -w1 -Wpointer-arith")
endif()
if (CMAKE_CXX_COMPILER_ID STREQUAL "Intel" AND NOT WIN32)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -w1 -Wpointer-arith")
endif()

if (MSVC)
    # enable linter like warnings including deprecation warnings
    # https://learn.microsoft.com/en-us/cpp/build/reference/compiler-option-warning-level?view=msvc-170
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /W3")
    # Disable warnings:
    # C4250: 'class1' : inherits 'class2::member' via dominance
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /wd4250")
    # C4251: 'identifier' : class 'type' needs to have dll-interface to be
    #        used by clients of class 'type2'
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /wd4251")
    # C4396: 'identifier' : 'function' the inline specifier cannot be used
    #        when a friend declaration refers to a specialization of a
    #        function template
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /wd4396")
    # C4661: 'identifier' : no suitable definition provided for explicit
    #         template instantiation request
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /wd4661")

    if (CMAKE_CXX_STANDARD GREATER_EQUAL 11)
        # Ensure __cplusplus is correct, otherwise it defaults to 199711L which isn't true
        # https://docs.microsoft.com/en-us/cpp/build/reference/zc-cplusplus?view=msvc-160
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /Zc:__cplusplus")
    endif()
endif()

option(ENABLE_BSYMBOLICFUNCTIONS "Make use of -Bsymbolic-functions" OFF)
if (ENABLE_BSYMBOLICFUNCTIONS)
    set(_SYMBOLIC_FUNCTIONS_COMPILER_OPTION "-Wl,-Bsymbolic-functions")
    list(APPEND CMAKE_REQUIRED_LIBRARIES "${_SYMBOLIC_FUNCTIONS_COMPILER_OPTION}")

    include(CheckCXXSourceCompiles)

    check_cxx_source_compiles( "int main () { return 0; }" BSYMBOLICFUNCTIONS_AVAILABLE )
    list(REMOVE_ITEM CMAKE_REQUIRED_LIBRARIES "${_SYMBOLIC_FUNCTIONS_COMPILER_OPTION}")
    if (BSYMBOLICFUNCTIONS_AVAILABLE)
        set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} ${_SYMBOLIC_FUNCTIONS_COMPILER_OPTION}")
        set(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} ${_SYMBOLIC_FUNCTIONS_COMPILER_OPTION}")
    endif()
endif()

if (WIN32)
    # Disable deprecation warnings for some API
    # FIXME: do we really want this?
    add_definitions(-D_CRT_SECURE_NO_DEPRECATE
                    -D_CRT_SECURE_NO_WARNINGS
                    -D_CRT_NONSTDC_NO_DEPRECATE
                    -D_SCL_SECURE_NO_WARNINGS
                   )
endif()

if (APPLE)
    #full Single Unix Standard v3 (SUSv3) conformance (the Unix API)
    _kde_add_platform_definitions(-D_DARWIN_C_SOURCE)
    #Cocoa is unconditional since we only support OS X 10.6 and above
    _kde_add_platform_definitions(-DQT_MAC_USE_COCOA)
endif()

############################################################
# Modern code
############################################################

function(_kde_set_default_skip_variable_by_min_ecm _var_name _ecm_version)
    if(NOT DEFINED ${_var_name})
        if (KDE_INTERNAL_COMPILERSETTINGS_LEVEL VERSION_LESS ${_ecm_version})
            set(${_var_name} TRUE PARENT_SCOPE)
        else()
            set(${_var_name} FALSE PARENT_SCOPE)
        endif()
    endif()
endfunction()

if(NOT DEFINED KDE_QT_MODERNCODE_DEFINITIONS_LEVEL)
    set(KDE_INTERNAL_QT_MODERNCODE_DEFINITIONS_LEVEL ${KDE_INTERNAL_COMPILERSETTINGS_LEVEL})
else()
    set(KDE_INTERNAL_QT_MODERNCODE_DEFINITIONS_LEVEL ${KDE_QT_MODERNCODE_DEFINITIONS_LEVEL})
endif()

if (KDE_INTERNAL_QT_MODERNCODE_DEFINITIONS_LEVEL VERSION_GREATER_EQUAL "5.85.0")
    add_definitions(
        -DQT_NO_CAST_TO_ASCII
        -DQT_NO_CAST_FROM_ASCII
        -DQT_NO_URL_CAST_FROM_STRING
        -DQT_NO_CAST_FROM_BYTEARRAY
        -DQT_USE_QSTRINGBUILDER
        -DQT_NO_NARROWING_CONVERSIONS_IN_CONNECT
        -DQT_NO_KEYWORDS
        -DQT_NO_FOREACH
    )
    if (NOT WIN32)
        # Strict iterators can't be used on Windows, they lead to a link error
        # when application code iterates over a QVector<QPoint> for instance, unless
        # Qt itself was also built with strict iterators.
        # See example at https://bugreports.qt.io/browse/AUTOSUITE-946
        add_definitions(-DQT_STRICT_ITERATORS)
    endif()
endif()

_kde_set_default_skip_variable_by_min_ecm(KDE_SKIP_PEDANTIC_WARNINGS_SETTINGS "5.85.0")

if (NOT KDE_SKIP_PEDANTIC_WARNINGS_SETTINGS)
    if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pedantic")
    endif()
endif()

_kde_set_default_skip_variable_by_min_ecm(KDE_SKIP_NULLPTR_WARNINGS_SETTINGS "5.85.0")

if (NOT KDE_SKIP_NULLPTR_WARNINGS_SETTINGS)
    if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        if (NOT CMAKE_CXX_COMPILER_VERSION VERSION_LESS "5.0.0")
            set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wzero-as-null-pointer-constant" )
        endif()
    endif()

    if (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
        if (NOT CMAKE_CXX_COMPILER_VERSION VERSION_LESS "5.0.0")
            set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wzero-as-null-pointer-constant" )
        endif()
    endif()
endif()

_kde_set_default_skip_variable_by_min_ecm(KDE_SKIP_MISSING_INCLUDE_DIRS_WARNINGS_SETTINGS "5.85.0")

if (NOT KDE_SKIP_MISSING_INCLUDE_DIRS_WARNINGS_SETTINGS)
    if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wmissing-include-dirs")
    endif()
endif()

############################################################
# Hacks
#
# Anything in this section should be thoroughly documented,
# including what problems it is supposed to fix and in what
# circumstances those problems occur.  Include links to any
# relevant bug reports.
############################################################

if (APPLE)
    # FIXME: why are these needed?  The commit log is unhelpful
    # (it was introduced in svn path=/trunk/KDE/kdelibs/; revision=503025 -
    # kdelibs git commit 4e4cb9cb9a2216b63d3eabf88b8fe94ee3c898cf -
    # with the message "mac os x fixes for the cmake build")
    set (CMAKE_SHARED_LINKER_FLAGS "-single_module -multiply_defined suppress ${CMAKE_SHARED_LINKER_FLAGS}")
    set (CMAKE_MODULE_LINKER_FLAGS "-multiply_defined suppress ${CMAKE_MODULE_LINKER_FLAGS}")
endif()

if (MINGW AND CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    # This was copied from the Phonon build settings, where it had the comment
    # "otherwise undefined symbol in phononcore.dll errors occurs", with the commit
    # message "set linker flag --export-all-symbols for all targets, otherwise
    # some depending targets could not be build"
    # FIXME: do our export macros not deal with this properly?
    set (CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,--export-all-symbols")
    set (CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -Wl,--export-all-symbols")
endif()

if (CMAKE_GENERATOR STREQUAL "Ninja" AND
    ((CMAKE_CXX_COMPILER_ID STREQUAL "GNU" AND CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 4.9) OR
     (CMAKE_CXX_COMPILER_ID MATCHES "Clang" AND CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 3.5)))
    # Force colored warnings in Ninja's output, if the compiler has -fdiagnostics-color support.
    # Rationale in https://github.com/ninja-build/ninja/issues/814
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fdiagnostics-color=always")
endif()

include("${ECM_MODULE_DIR}/ECMEnableSanitizers.cmake")
include("${ECM_MODULE_DIR}/ECMCoverageOption.cmake")

############################################################
# Clean-up
############################################################
# unset again, to not leak into caller scope and avoid usage there
set(KDE_INTERNAL_COMPILERSETTINGS_LEVEL)
set(KDE_INTERNAL_QT_MODERNCODE_DEFINITIONS_LEVEL)
