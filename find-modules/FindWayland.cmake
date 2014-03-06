# Try to find Wayland on a Unix system
#
# This is a component-based find module, which makes use of the COMPONENTS
# and OPTIONAL_COMPONENTS arguments to find_module.  The following components
# are available:
#
#   Client  Server  Cursor  Egl
#
# If no components are specified, this module will act as though all components
# were passed to OPTIONAL_COMPONENTS.
#
# This module will define the following variables, independently of the
# components searched for or found:
#
#   Wayland_FOUND      - True if (the requestion version of) Wayland is available
#   Wayland_VERSION    - Found Wayland version
#
# For each searched-for components, Wayland_<component>_FOUND will be set to true
# if the corresponding Wayland library was found, and false otherwise.  If
# Wayland_<component>_FOUND is true, the imported target Wayland::<component> will be
# defined.  This module will also attempt to determine Wayland_*_VERSION variables
# for each imported target, although Wayland_VERSION should normally be sufficient.
#
# The following variable will also be defined for convenience, and for
# compatibility with old-style find module conventions:
#
#   Wayland_LIBRARIES  - A list of all Wayland imported targets

#=============================================================================
# Copyright 2014 Martin Gräßlin <mgraesslin@kde.org>
# Copyright 2014 Alex Merry <alex.merry@kde.org>
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file COPYING-CMAKE-SCRIPTS for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# (To distribute this file outside of extra-cmake-modules, substitute the full
#  License text for the above reference.)

include(${CMAKE_CURRENT_LIST_DIR}/../modules/ECMFindModuleHelpers.cmake)

ecm_find_package_version_check(Wayland)

if(NOT WIN32)
    set(Wayland_known_components
        Client
        Server
        Cursor
        Egl
    )
    foreach(_comp ${Wayland_known_components})
        string(TOLOWER "${_comp}" _lc_comp)
        set(Wayland_${_comp}_component_deps)
        set(Wayland_${_comp}_pkg_config "wayland-${_lc_comp}")
        set(Wayland_${_comp}_lib "wayland-${_lc_comp}")
        set(Wayland_${_comp}_header "wayland-${_lc_comp}.h")
    endforeach()
    set(Wayland_Egl_component_deps Client)

    ecm_find_package_parse_components(Wayland
        RESULT_VAR Wayland_components
        KNOWN_COMPONENTS ${Wayland_known_components}
    )
    ecm_find_package_handle_library_components(Wayland
        COMPONENTS ${Wayland_components}
    )

    # If pkg-config didn't provide us with version information,
    # try to extract it from wayland-version.h
    # (Note that the version from wayland-egl.pc will probably be
    # the Mesa version, rather than the Wayland version, but that
    # version will be ignored as we always find wayland-client.pc
    # first).
    if(NOT Wayland_VERSION)
        find_file(Wayland_VERSION_HEADER
            NAMES wayland-version.h
            HINTS ${Wayland_INCLUDE_DIRS}
        )
        mark_as_advanced(Wayland_VERSION_HEADER)
        if(Wayland_VERSION_HEADER)
            file(READ ${Wayland_VERSION_HEADER} _wayland_version_header_contents)
            string(REGEX REPLACE
                "^.*[ \\t]+WAYLAND_VERSION[ \\t]+\"([0-9.]*)\".*$"
                "\\1"
                Wayland_VERSION
                "${_wayland_version_header_contents}"
            )
            unset(_wayland_version_header_contents)
        endif()
    endif()

    find_package_handle_standard_args(Wayland
        FOUND_VAR
            Wayland_FOUND
        REQUIRED_VARS
            Wayland_LIBRARIES
        VERSION_VAR
            Wayland_VERSION
        HANDLE_COMPONENTS
    )

else()
    message(STATUS "Wayland is not available on Windows.")
    set(Wayland_FOUND FALSE)
endif()

include(FeatureSummary)
set_package_properties(Wayland PROPERTIES
    URL "http://wayland.freedesktop.org"
    DESCRIPTION "C library implementation of the Wayland protocol: a protocol for a compositor to talk to its clients"
)
