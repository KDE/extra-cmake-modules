#.rst:
# FindEGL
# -------
#
# Try to find EGL on a Unix system.
#
# This will define the following variables:
#
# ``EGL_FOUND``
#     True if EGL is available
# ``EGL_LIBRARIES``
#     Link these to use EGL
# ``EGL_INCLUDE_DIRS``
#     Include directory for EGL
# ``EGL_DEFINITIONS``
#     Compiler flags for using EGL
#
# and the following imported targets:
#
# ``EGL::EGL``
#     The EGL library
#
# In general we recommend using the imported target, as it is easier to use.
# Bear in mind, however, that if the target is in the link interface of an
# exported library, it must be made available by the package config file.

#=============================================================================
# Copyright 2014 Martin Gräßlin <mgraesslin@kde.org>
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. The name of the author may not be used to endorse or promote products
#    derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
# OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
# NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
# THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#=============================================================================

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
