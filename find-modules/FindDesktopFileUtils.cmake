# SPDX-FileCopyrightText: 2026 Volker Krause <vkrause@kde.org>
#
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
FindDesktopFileUtils
--------------------

Try to find the desktop-file-utils package.

This will define the following variables:

``DesktopFileUtils_FOUND``
    True if system has the desktop-file-utils package

and the following imported targets:

``DesktopFileUtils::UpdateDesktopDatabase``
    The update-desktop-database executable

The follow macro is available::

  update_desktop_database(<path>)

Updates the XDG desktop database at install time (unless the ``$DESTDIR``
environment variable is set, in which case it is up to package managers to
perform this task).

This should follow an `install()` command for a .desktop file containing
implementing an XDG Intent.

Since 6.31
#]=======================================================================]

cmake_policy(VERSION 3.16)

include(${CMAKE_CURRENT_LIST_DIR}/ECMFindModuleHelpersStub.cmake)

ecm_find_package_version_check(DesktopFileUtils)

find_program (UPDATE_DESKTOP_DATABASE_EXECUTABLE NAMES update-desktop-database)

if (UPDATE_DESKTOP_DATABASE_EXECUTABLE)
    execute_process(
        COMMAND "${UPDATE_DESKTOP_DATABASE_EXECUTABLE}" --version
        OUTPUT_VARIABLE _versionRaw
        ERROR_VARIABLE _versionRaw)

    string(REGEX REPLACE "update-desktop-database ([0-9]\\.[0-9]+).*"
           "\\1" DesktopFileUtils_VERSION_STRING "${_versionRaw}")
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(DesktopFileUtils
    FOUND_VAR
        DesktopFileUtils_FOUND
    REQUIRED_VARS
        UPDATE_DESKTOP_DATABASE_EXECUTABLE
    VERSION_VAR
        DesktopFileUtils_VERSION_STRING)

if(DesktopFileUtils_FOUND AND NOT TARGET DesktopFileUtils::UpdateDesktopDatabase)
    add_executable(DesktopFileUtils::UpdateDesktopDatabase IMPORTED)
    set_target_properties(DesktopFileUtils::UpdateDesktopDatabase PROPERTIES
        IMPORTED_LOCATION "${UPDATE_DESKTOP_DATABASE_EXECUTABLE}"
    )
endif()

mark_as_advanced(UPDATE_DESKTOP_DATABASE_EXECUTABLE)

function(update_desktop_database _path)
    if(NOT UPDATE_DESKTOP_DATABASE_EXECUTABLE)
        return()
    endif()
    # Note that targets and most variables are not available to install code
    install(CODE "
set(DESTDIR_VALUE \"\$ENV{DESTDIR}\")
if (NOT DESTDIR_VALUE)
    message(STATUS \"Updating desktop database at \${CMAKE_INSTALL_PREFIX}/${_path}\")
    execute_process(COMMAND \"${UPDATE_DESKTOP_DATABASE_EXECUTABLE}\" -q \"${_path}\"
                    WORKING_DIRECTORY \"\${CMAKE_INSTALL_PREFIX}\")
endif (NOT DESTDIR_VALUE)
")
endfunction()

include(FeatureSummary)
set_package_properties(DesktopFileUtils PROPERTIES
    URL https://gitlab.freedesktop.org/xdg/desktop-file-utils
    DESCRIPTION "Desktop File Utils")
