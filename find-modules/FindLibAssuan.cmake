# SPDX-FileCopyrightText: 2022 g10 Code GmbH
# SPDX-FileContributor: Ingo Klöcker <dev@ingo-kloecker.de>
#
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
FindLibAssuan
-------------

Try to find the Libassuan library.

This will define the following variables:

``LibAssuan_FOUND``
    True if (the requested version of) Libassuan was found
``LibAssuan_VERSION``
    The version of the Libassuan library which was found
``LibAssuan_LIBRARIES``
    Libraries you need to link when using Libassuan. This can be passed to
    target_link_libraries() instead of the ``LibAssuan::LibAssuan`` target.
``LibAssuan_INCLUDE_DIRS``
    Include directories needed to use Libassuan. This should be passed to
    target_include_directories() if the target is not used for linking.
``LibAssuan_DEFINITIONS``
    Compile definitions to use when compiling code that uses Libassuan.
    This should be passed to target_compile_options() if the target is not
    used for linking.

If ``LibAssuan_FOUND`` is TRUE, it will also define the following imported target:

``LibAssuan::LibAssuan``
    The Libassuan library

Since 5.103.0.
#]=======================================================================]

find_package(PkgConfig QUIET)
pkg_check_modules(PC_LibAssuan QUIET libassuan)

set(LibAssuan_VERSION ${PC_LibAssuan_VERSION})
set(LibAssuan_DEFINITIONS ${PC_LibAssuan_CFLAGS_OTHER})

find_path(LibAssuan_INCLUDE_DIR
    NAMES
        assuan.h
    PATHS
        ${PC_LibAssuan_INCLUDE_DIRS}
)
find_library(LibAssuan_LIBRARY
    NAMES
        assuan
    PATHS
        ${PC_LibAssuan_LIBRARY_DIRS}
)

if(WIN32)
    set(_LibAssuan_ADDITIONAL_LIBRARIES ws2_32)
endif()

if(LibAssuan_INCLUDE_DIR AND NOT LibAssuan_VERSION)
    # The version is given in the format MAJOR.MINOR.PATCH optionally followed
    # by an intermediate "beta" version given as -betaNUM, e.g. "2.5.6-beta38".
    file(STRINGS "${LibAssuan_INCLUDE_DIR}/assuan.h" LibAssuan_VERSION_STR
         REGEX "^#[\t ]*define[\t ]+ASSUAN_VERSION[\t ]+\"([0-9])+\\.([0-9])+\\.([0-9])+(-[a-z0-9]*)?\".*")
    string(REGEX REPLACE "^.*ASSUAN_VERSION[\t ]+\"([0-9]+\\.[0-9]+\\.[0-9]+(-[a-z0-9]*)?)\".*$"
           "\\1" LibAssuan_VERSION_STR "${LibAssuan_VERSION_STR}")

    set(LibAssuan_VERSION "${LibAssuan_VERSION_STR}")

    unset(LibAssuan_VERSION_STR)
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(LibAssuan
    REQUIRED_VARS
        LibAssuan_LIBRARY
        LibAssuan_INCLUDE_DIR
        LibAssuan_VERSION
    VERSION_VAR
        LibAssuan_VERSION
)

if(LibAssuan_FOUND AND NOT TARGET LibAssuan::LibAssuan)
    add_library(LibAssuan::LibAssuan UNKNOWN IMPORTED)
    set_target_properties(LibAssuan::LibAssuan PROPERTIES
        IMPORTED_LOCATION "${LibAssuan_LIBRARY}"
        INTERFACE_COMPILE_OPTIONS "${LibAssuan_DEFINITIONS}"
        INTERFACE_INCLUDE_DIRECTORIES "${LibAssuan_INCLUDE_DIR}"
    )
    set_property(TARGET LibAssuan::LibAssuan APPEND PROPERTY INTERFACE_LINK_LIBRARIES ${_LibAssuan_ADDITIONAL_LIBRARIES})
endif()

mark_as_advanced(
    LibAssuan_INCLUDE_DIR
    LibAssuan_LIBRARY
)

if(LibAssuan_FOUND)
    set(LibAssuan_LIBRARIES ${LibAssuan_LIBRARY} ${_LibAssuan_ADDITIONAL_LIBRARIES})
    set(LibAssuan_INCLUDE_DIRS ${LibAssuan_INCLUDE_DIR})
endif()

include(FeatureSummary)
set_package_properties(LibAssuan PROPERTIES
    DESCRIPTION "IPC library for the GnuPG components"
    URL https://www.gnupg.org/software/libassuan
)
