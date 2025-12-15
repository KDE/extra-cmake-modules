# SPDX-FileCopyrightText: 2016 Tobias C. Berner <tcberner@FreeBSD.org>
# SPDX-FileCopyrightText: 2017 Adriaan de Groot <groot@kde.org>
#
# SPDX-License-Identifier: BSD-2-Clause

#[=======================================================================[.rst:
FindInotify
--------------

Try to find inotify on this system. This finds:
 - libinotify on Unix like systems, or
 - the kernel's inotify.

This will define the following variables:

``Inotify_FOUND``
   True if inotify is available
``Inotify_LIBRARIES``
   This has to be passed to target_link_libraries()
``Inotify_INCLUDE_DIRS``
   This has to be passed to target_include_directories()

On some platforms like Linux and SunOS, the libraries and include directories
are empty, even though ``Inotify_FOUND`` may be set to TRUE. This is because
no special includes or libraries are needed. On other systems
these may be needed to use inotify.

Since 5.32.0.
#]=======================================================================]

cmake_policy(VERSION 3.16)

# Reset the cache var before searching for sys/inotify.h
# This is required, because on systems with native inotify we reset Inotify_INCLUDE_DIRS
# to an empty string. Rerunning CMake in this case will reuse the empty variable
# and we will not get into if(Inotify_INCLUDE_DIRS) the second time
unset(Inotify_INCLUDE_DIRS CACHE)
find_path(Inotify_INCLUDE_DIRS sys/inotify.h PATHS /usr/include NO_DEFAULT_PATH)
find_path(Inotify_INCLUDE_DIRS sys/inotify.h)

if(Inotify_INCLUDE_DIRS)
    # On OSes with a kernel implementation, there is no library to link against.
    # On some others inotify is implemented through a library, libinotify.
    # If we found a header, but not a library, assume a kernel implementation
    find_library(Inotify_LIBRARIES NAMES inotify)
    if(NOT Inotify_LIBRARIES)
        set(Inotify_FOUND TRUE)
        set(Inotify_LIBRARIES "" CACHE STRING "" FORCE)
        set(Inotify_INCLUDE_DIRS "" CACHE STRING "" FORCE)
    else()
        # On FreeBSD 15+ we may end up with both in-kernel and libinotify
        # implementation. To discern between them, compare prefixes of
        # ${Inotify_INCLUDE_DIRS} and ${Inotify_LIBRARIES}: if we get
        # /usr/include and /usr/local/lib/libinotify.so then assume that the
        # kernel implementation is available and user wants it, instead of libinotify
        cmake_path(GET Inotify_INCLUDE_DIRS PARENT_PATH includes_prefix)
        cmake_path(GET Inotify_LIBRARIES PARENT_PATH lib_prefix)
        cmake_path(GET lib_prefix PARENT_PATH lib_prefix)
        cmake_path(COMPARE ${includes_prefix} EQUAL ${lib_prefix} prefixes_match)

        if(NOT prefixes_match)
            set(Inotify_FOUND TRUE)
            set(Inotify_LIBRARIES "" CACHE STRING "" FORCE)
            set(Inotify_INCLUDE_DIRS "" CACHE STRING "" FORCE)
        else()
            include(FindPackageHandleStandardArgs)
            find_package_handle_standard_args(Inotify
                FOUND_VAR
                    Inotify_FOUND
                REQUIRED_VARS
                    Inotify_LIBRARIES
                    Inotify_INCLUDE_DIRS
            )
            include(FeatureSummary)
            set_package_properties(Inotify PROPERTIES
                URL "https://github.com/libinotify-kqueue/"
                DESCRIPTION "inotify API on the *BSD family of operating systems."
            )
        endif()
    endif()
    if(NOT TARGET Inotify::Inotify)
        add_library(Inotify::Inotify INTERFACE IMPORTED)
        set_property(TARGET Inotify::Inotify PROPERTY INTERFACE_INCLUDE_DIRECTORIES "${Inotify_INCLUDE_DIRS}")
        set_property(TARGET Inotify::Inotify PROPERTY INTERFACE_LINK_LIBRARIES "${Inotify_LIBRARIES}")
    endif()
else()
    set(Inotify_FOUND FALSE)
endif()

mark_as_advanced(Inotify_LIBRARIES Inotify_INCLUDE_DIRS) 
