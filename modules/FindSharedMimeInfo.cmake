# - Try to find the shared-mime-info package
# Once done this will define
#
#  SHARED_MIME_INFO_FOUND - system has the shared-mime-info package
#  UPDATE_MIME_DATABASE_EXECUTABLE - the update-mime-database executable
#
# Copyright (c) 2007, Pino Toscano, <toscano.pino@tiscali.it>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

# the minimum version of shared-mime-database we require
set(SHARED_MIME_INFO_MINIMUM_VERSION "0.18")

if (UPDATE_MIME_DATABASE_EXECUTABLE)

    # in cache already
    set(SHARED_MIME_INFO_FOUND TRUE)

else (UPDATE_MIME_DATABASE_EXECUTABLE)

    include (MacroEnsureVersion)

    find_program (UPDATE_MIME_DATABASE_EXECUTABLE NAMES update-mime-database)

    if (UPDATE_MIME_DATABASE_EXECUTABLE)

        exec_program (${UPDATE_MIME_DATABASE_EXECUTABLE} ARGS -v RETURN_VALUE _null OUTPUT_VARIABLE _smiVersionRaw)

        string(REGEX REPLACE "update-mime-database \\(shared-mime-info\\) ([0-9]\\.[0-9]+).*"
               "\\1" smiVersion "${_smiVersionRaw}")

        set (SHARED_MIME_INFO_FOUND TRUE)
    endif (UPDATE_MIME_DATABASE_EXECUTABLE)

    if (SHARED_MIME_INFO_FOUND)
        if (NOT SharedMimeInfo_FIND_QUIETLY)
            message(STATUS "Found shared-mime-info version: ${smiVersion}")

            macro_ensure_version2(${SHARED_MIME_INFO_MINIMUM_VERSION} ${smiVersion} _smiVersion_OK)
            if (NOT _smiVersion_OK)
                message(STATUS "WARNING: the found version of shared-mime-info (${smiVersion}) is below the minimum required (${SHARED_MIME_INFO_MINIMUM_VERSION})")
            endif (NOT _smiVersion_OK)

        endif (NOT SharedMimeInfo_FIND_QUIETLY)
    else (SHARED_MIME_INFO_FOUND)
        if (SharedMimeInfo_FIND_REQUIRED)
            message(FATAL_ERROR "Could NOT find shared-mime-info")
        endif (SharedMimeInfo_FIND_REQUIRED)
    endif (SHARED_MIME_INFO_FOUND)

    # ensure that they are cached
    set(UPDATE_MIME_DATABASE_EXECUTABLE ${UPDATE_MIME_DATABASE_EXECUTABLE} CACHE INTERNAL "The update-mime-database executable")

endif (UPDATE_MIME_DATABASE_EXECUTABLE)
