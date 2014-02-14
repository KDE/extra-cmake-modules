# Try to find the shared-mime-info package
#
# This will define
#
#   SharedMimeInfo_FOUND            - True if system has the shared-mime-info package
#   UPDATE_MIME_DATABASE_EXECUTABLE - The update-mime-database executable
#
# In addition, the following targets are defined:
#
#   SharedMimeInfo::UpdateMimeDatabase
#
# The follow macro is available:
#
#     update_xdg_mimetypes(path)
#
# Updates the XDG mime database at install time (unless the DESTDIR environment
# variable is set, in which case it is up to package managers to perform this
# task).
#


# Copyright (c) 2007, Pino Toscano, <toscano.pino@tiscali.it>
# Copyright (c) 2013-2014, Alex Merry, <alex.merry@kdemail.net>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

if(CMAKE_VERSION VERSION_LESS 2.8.12)
    message(FATAL_ERROR "CMake 2.8.12 is required by FindSharedMimeInfo.cmake")
endif()
if(CMAKE_MINIMUM_REQUIRED_VERSION VERSION_LESS 2.8.12)
    message(AUTHOR_WARNING "Your project should require at least CMake 2.8.12 to use FindSharedMimeInfo.cmake")
endif()

find_program (UPDATE_MIME_DATABASE_EXECUTABLE NAMES update-mime-database)

if (UPDATE_MIME_DATABASE_EXECUTABLE)
    execute_process(
        COMMAND "${UPDATE_MIME_DATABASE_EXECUTABLE}" -v
        OUTPUT_VARIABLE _smiVersionRaw
        ERROR_VARIABLE _smiVersionRaw)

    string(REGEX REPLACE "update-mime-database \\([a-zA-Z\\-]+\\) ([0-9]\\.[0-9]+).*"
           "\\1" SharedMimeInfo_VERSION_STRING "${_smiVersionRaw}")
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(SharedMimeInfo
    FOUND_VAR
        SharedMimeInfo_FOUND
    REQUIRED_VARS
        UPDATE_MIME_DATABASE_EXECUTABLE
    VERSION_VAR
        SharedMimeInfo_VERSION_STRING)

if(SharedMimeInfo_FOUND AND NOT TARGET SharedMimeInfo::UpdateMimeDatabase)
    add_executable(SharedMimeInfo::UpdateMimeDatabase IMPORTED)
    set_target_properties(SharedMimeInfo::UpdateMimeDatabase PROPERTIES
        IMPORTED_LOCATION "${UPDATE_MIME_DATABASE_EXECUTABLE}"
    )
endif()

mark_as_advanced(UPDATE_MIME_DATABASE_EXECUTABLE)

function(UPDATE_XDG_MIMETYPES _path)
    get_filename_component(_xdgmimeDir "${_path}" NAME)
    if("${_xdgmimeDir}" STREQUAL packages )
        get_filename_component(_xdgmimeDir "${_path}" PATH)
    else("${_xdgmimeDir}" STREQUAL packages )
        set(_xdgmimeDir "${_path}")
    endif("${_xdgmimeDir}" STREQUAL packages )

    # Note that targets and most variables are not available to install code
    install(CODE "
set(DESTDIR_VALUE \"\$ENV{DESTDIR}\")
if (NOT DESTDIR_VALUE)
    # under Windows relative paths are used, that's why it runs from CMAKE_INSTALL_PREFIX
    message(STATUS \"Updating MIME database at \${CMAKE_INSTALL_PREFIX}/${_xdgmimeDir}\")
    execute_process(COMMAND \"${UPDATE_MIME_DATABASE_EXECUTABLE}\" \"${_xdgmimeDir}\"
                    WORKING_DIRECTORY \"\${CMAKE_INSTALL_PREFIX}\")
endif (NOT DESTDIR_VALUE)
")
endfunction()

include(FeatureSummary)
set_package_properties(SharedMimeInfo PROPERTIES
    URL http://freedesktop.org/wiki/Software/shared-mime-info/
    DESCRIPTION "A database of common MIME types")
