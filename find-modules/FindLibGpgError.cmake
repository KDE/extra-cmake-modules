# SPDX-FileCopyrightText: 2022 g10 Code GmbH
# SPDX-FileContributor: Ingo Klöcker <dev@ingo-kloecker.de>
#
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
FindLibGpgError
---------------

Try to find the Libgpg-error library.

This will define the following variables:

``LibGpgError_FOUND``
    True if (the requested version of) Libgpg-error was found
``LibGpgError_VERSION``
    The version of the Libgpg-error library which was found
``LibGpgError_LIBRARIES``
    Libraries you need to link when using Libgpg-error This can be passed to
    target_link_libraries() instead of the ``LibGpgError::LibGpgError`` target.
``LibGpgError_INCLUDE_DIRS``
    Include directories needed to use Libgpg-error This should be passed to
    target_include_directories() if the target is not used for linking.
``LibGpgError_DEFINITIONS``
    Compile definitions to use when compiling code that uses Libgpg-error
    This should be passed to target_compile_options() if the target is not
    used for linking.

If ``LibGpgError_FOUND`` is TRUE, it will also define the following imported target:

``LibGpgError::LibGpgError``
    The Libgpg-error library

Since 5.103.0.
#]=======================================================================]

find_package(PkgConfig QUIET)
pkg_check_modules(PC_LibGpgError QUIET gpg-error)

set(LibGpgError_VERSION ${PC_LibGpgError_VERSION})
set(LibGpgError_DEFINITIONS ${PC_LibGpgError_CFLAGS_OTHER})

find_path(LibGpgError_INCLUDE_DIR
    NAMES
        gpg-error.h
    PATHS
        ${PC_LibGpgError_INCLUDE_DIRS}
)
find_library(LibGpgError_LIBRARY
    NAMES
        gpg-error
    PATHS
        ${PC_LibGpgError_LIBRARY_DIRS}
)

if(LibGpgError_INCLUDE_DIR AND NOT LibGpgError_VERSION)
    # The version is given in the format MAJOR.MINOR optionally followed
    # by an intermediate "beta" version given as -betaNUM, e.g. "1.47-beta7".
    file(STRINGS "${LibGpgError_INCLUDE_DIR}/gpg-error.h" LibGpgError_VERSION_STR
         REGEX "^#[\t ]*define[\t ]+GPG_ERROR_VERSION[\t ]+\"([0-9])+\\.([0-9])+(-[a-z0-9]*)?\".*")
    string(REGEX REPLACE "^.*GPG_ERROR_VERSION[\t ]+\"([0-9]+\\.[0-9]+(-[a-z0-9]*)?)\".*$"
           "\\1" LibGpgError_VERSION_STR "${LibGpgError_VERSION_STR}")

    set(LibGpgError_VERSION "${LibGpgError_VERSION_STR}")

    unset(LibGpgError_VERSION_STR)
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(LibGpgError
    REQUIRED_VARS
        LibGpgError_LIBRARY
        LibGpgError_INCLUDE_DIR
        LibGpgError_VERSION
    VERSION_VAR
        LibGpgError_VERSION
)

if(LibGpgError_FOUND AND NOT TARGET LibGpgError::LibGpgError)
    add_library(LibGpgError::LibGpgError UNKNOWN IMPORTED)
    set_target_properties(LibGpgError::LibGpgError PROPERTIES
        IMPORTED_LOCATION "${LibGpgError_LIBRARY}"
        INTERFACE_COMPILE_OPTIONS "${LibGpgError_DEFINITIONS}"
        INTERFACE_INCLUDE_DIRECTORIES "${LibGpgError_INCLUDE_DIR}"
    )
endif()

mark_as_advanced(
    LibGpgError_INCLUDE_DIR
    LibGpgError_LIBRARY
)

if(LibGpgError_FOUND)
    set(LibGpgError_LIBRARIES ${LibGpgError_LIBRARY})
    set(LibGpgError_INCLUDE_DIRS ${LibGpgError_INCLUDE_DIR})
endif()

include(FeatureSummary)
set_package_properties(LibGpgError PROPERTIES
    DESCRIPTION "Runtime library for all GnuPG components"
    URL https://www.gnupg.org/software/libgpg-error
)
