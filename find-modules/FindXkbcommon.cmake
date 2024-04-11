# SPDX-FileCopyrightText: 2014 Martin Gräßlin <mgraesslin@kde.org>
#
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
FindXkbcommon
-------------

Try to find xkbcommon on a Unix system.

If found, this will define the following variables:

  ``Xkbcommon_FOUND``
    True if xkbcommon is available

  ``Xkbcommon_LIBRARIES``
    Link these to use xkbcommon

  ``Xkbcommon_INCLUDE_DIRS``
    Include directory for xkbcommon

  ``Xkbcommon_DEFINITIONS``
    Compiler flags for using xkbcommon

Additionally, the following imported targets will be defined:

  ``Xkbcommon::Xkbcommon``
    The xkbcommon library

Since 6.2.0
#]=======================================================================]

find_package(PkgConfig)
pkg_check_modules(PKG_Xkbcommon QUIET xkbcommon)

set(Xkbcommon_DEFINITIONS ${PKG_Xkbcommon_CFLAGS_OTHER})

find_path(Xkbcommon_INCLUDE_DIR
    NAMES
        xkbcommon/xkbcommon.h
    HINTS
        ${PKG_Xkbcommon_INCLUDE_DIRS}
)
find_library(Xkbcommon_LIBRARY
    NAMES
        xkbcommon
    HINTS
        ${PKG_Xkbcommon_LIBRARY_DIRS}
)

set(Xkbcommon_LIBRARIES ${Xkbcommon_LIBRARY})
set(Xkbcommon_INCLUDE_DIRS ${Xkbcommon_INCLUDE_DIR})
set(Xkbcommon_VERSION ${PKG_Xkbcommon_VERSION})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Xkbcommon
    FOUND_VAR
        Xkbcommon_FOUND
    REQUIRED_VARS
        Xkbcommon_LIBRARY
        Xkbcommon_INCLUDE_DIR
    VERSION_VAR
        Xkbcommon_VERSION
)

if(Xkbcommon_FOUND AND NOT TARGET Xkbcommon::Xkbcommon)
    add_library(Xkbcommon::Xkbcommon UNKNOWN IMPORTED)
    set_target_properties(Xkbcommon::Xkbcommon PROPERTIES
        IMPORTED_LOCATION "${Xkbcommon_LIBRARY}"
        INTERFACE_COMPILE_OPTIONS "${Xkbcommon_DEFINITIONS}"
        INTERFACE_INCLUDE_DIRECTORIES "${Xkbcommon_INCLUDE_DIR}"
    )
endif()

include(FeatureSummary)
set_package_properties(Xkbcommon PROPERTIES
    URL "https://xkbcommon.org"
    DESCRIPTION "XKB API common to servers and clients"
)
