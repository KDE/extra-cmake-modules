#.rst:
# FindPng2Ico
# -----------
#
# Try to find png2ico.
#
# If the png2ico executable is not in your PATH, you can provide
# an alternative name or full path location with the ``Png2Ico_EXECUTABLE``
# variable.
#
# This will define the following variables:
#
# ``Png2Ico_FOUND``
#     True if png2ico is available.
#
# ``Png2Ico_EXECUTABLE``
#     The png2ico executable.
#
# If ``Png2Ico_FOUND`` is TRUE, it will also define the following imported
# target:
#
# ``Png2Ico::Png2Ico``
#     The png2ico executable.
#
# and the following variables:
#
# ``Png2Ico_HAS_COLORS_ARGUMENT``
#     Whether png2ico accepts a ``--colors`` argument. `Matthias Benkmann's
#     tool <https://www.winterdrache.de/freeware/png2ico/>`_ does, while the
#     version of png2ico from the `"KDE On Windows" (kdewin)
#     <https://commits.kde.org/kdewin>`_ project does not.
#
# ``Png2Ico_HAS_RCFILE_ARGUMENT``
#     Whether png2ico accepts an ``--rcfile`` argument. The version of png2ico
#     from the `"KDE On Windows" (kdewin)
#     <https://commits.kde.org/kdewin>`_ project does,
#     while `Matthias Benkmann's tool
#     <https://www.winterdrache.de/freeware/png2ico/>`_ does not.
#
# Since 1.7.0.

#=============================================================================
# SPDX-FileCopyrightText: 2014 Alex Merry <alex.merry@kde.org>
#
# SPDX-License-Identifier: BSD-3-Clause
#=============================================================================

include(${CMAKE_CURRENT_LIST_DIR}/ECMFindModuleHelpersStub.cmake)

ecm_find_package_version_check(Png2Ico)

# Find png2ico
find_program(Png2Ico_EXECUTABLE NAMES png2ico)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Png2Ico
    FOUND_VAR
        Png2Ico_FOUND
    REQUIRED_VARS
        Png2Ico_EXECUTABLE
)

mark_as_advanced(Png2Ico_EXECUTABLE)

if (Png2Ico_FOUND)
    execute_process(
        COMMAND "${Png2Ico_EXECUTABLE}" --help
        OUTPUT_VARIABLE _png2ico_help_text
        ERROR_VARIABLE _png2ico_help_text
    )
    if (_png2ico_help_text MATCHES ".*--rcfile .*")
        set(Png2Ico_HAS_RCFILE_ARGUMENT TRUE)
    else()
        set(Png2Ico_HAS_RCFILE_ARGUMENT FALSE)
    endif()
    if (_png2ico_help_text MATCHES ".*--colors .*")
        set(Png2Ico_HAS_COLORS_ARGUMENT TRUE)
    else()
        set(Png2Ico_HAS_COLORS_ARGUMENT FALSE)
    endif()
    unset(_png2ico_help_text)

    if (NOT TARGET Png2Ico::Png2Ico)
        add_executable(Png2Ico::Png2Ico IMPORTED)
        set_target_properties(Png2Ico::Png2Ico PROPERTIES
            IMPORTED_LOCATION "${Png2Ico_EXECUTABLE}"
        )
    endif()
endif()

include(FeatureSummary)
set_package_properties(Png2Ico PROPERTIES
    URL "https://www.winterdrache.de/freeware/png2ico/ or https://commits.kde.org/kdewin"
    DESCRIPTION "Executable that converts a collection of PNG files into a Windows icon file"
)

