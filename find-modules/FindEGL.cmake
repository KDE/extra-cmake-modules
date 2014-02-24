# Try to find EGL on a Unix system
#
# This will define:
#
#   EGL_FOUND        - True if EGL is available
#   EGL_LIBRARIES    - Link these to use EGL
#   EGL_INCLUDE_DIRS - Include directory for EGL
#   EGL_DEFINITIONS  - Compiler flags for using EGL
#
# Additionally, the following imported targets will be defined:
#
#   EGL::EGL
#
# Copyright (c) 2014 Martin Gräßlin <mgraesslin@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

if(CMAKE_VERSION VERSION_LESS 2.8.12)
    message(FATAL_ERROR "CMake 2.8.12 is required by FindEGL.cmake")
endif()
if(CMAKE_MINIMUM_REQUIRED_VERSION VERSION_LESS 2.8.12)
    message(AUTHOR_WARNING "Your project should require at least CMake 2.8.12 to use FindEGL.cmake")
endif()

if(NOT WIN32)
    # Use pkg-config to get the directories and then use these values
    # in the FIND_PATH() and FIND_LIBRARY() calls
    find_package(PkgConfig)
    pkg_check_modules(PKG_EGL QUIET ${pkgConfigModules})

    set(EGL_DEFINITIONS ${PKG_EGL_CFLAGS_OTHER})

    find_path(EGL_INCLUDE_DIR
        NAMES
            egl.h
        HINTS
            ${PKG_EGL_INCLUDE_DIRS}
        PATH_SUFFIXES
            EGL
    )
    find_library(EGL_LIBRARY
        NAMES
            EGL
        HINTS
            ${PKG_EGL_LIBRARY_DIRS}
    )

    set(EGL_LIBRARIES ${EGL_LIBRARY})
    set(EGL_INCLUDE_DIRS ${EGL_INCLUDE_DIR})

    include(FindPackageHandleStandardArgs)
    find_package_handle_standard_args(EGL
        FOUND_VAR
            EGL_FOUND
        REQUIRED_VARS
            EGL_LIBRARY
            EGL_INCLUDE_DIR
    )

    if(EGL_FOUND AND NOT TARGET EGL::EGL)
        add_library(EGL::EGL UNKNOWN IMPORTED)
        set_target_properties(EGL::EGL PROPERTIES
            IMPORTED_LOCATION "${EGL_LIBRARY}"
            INTERFACE_COMPILE_OPTIONS "${EGL_DEFINITIONS}"
            INTERFACE_INCLUDE_DIRECTORIES "${EGL_INCLUDE_DIR}"
        )
    endif()

else()
    message(STATUS "FindEGL.cmake cannot find EGL on Windows systems. Try finding WGL instead.")
    set(EGL_FOUND FALSE)
endif()

include(FeatureSummary)
set_package_properties(EGL PROPERTIES
    URL "https://www.khronos.org/egl/"
    DESCRIPTION "EGL provides a platform-agnostic mechanism for creating rendering surfaces for use with other graphics libraries, such as OpenGL|ES and OpenVG."
)
