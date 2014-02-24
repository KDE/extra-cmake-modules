# Try to find Wayland on a Unix system
#
# This will define:
#
#   Wayland_FOUND          - True if Wayland is available
#   Wayland_LIBRARIES      - Link these to use Wayland
#   Wayland_INCLUDE_DIRS   - Include directory for Wayland
#   Wayland_DEFINITIONS    - Compiler flags for using Wayland
#   Wayland_VERSION_STRING - Found Wayland version
#
# In addition the following more fine grained variables will be defined:
#
#   Wayland_Client_FOUND  Wayland_Client_INCLUDE_DIR  Wayland_Client_LIBRARY Wayland_Client_VERSION_STRING
#   Wayland_Server_FOUND  Wayland_Server_INCLUDE_DIR  Wayland_Server_LIBRARY Wayland_Server_VERSION_STRING
#   Wayland_Cursor_FOUND  Wayland_Cursor_INCLUDE_DIR  Wayland_Cursor_LIBRARY Wayland_Cursor_VERSION_STRING
#   Wayland_Egl_FOUND     Wayland_Egl_INCLUDE_DIR     Wayland_Egl_LIBRARY    Wayland_Egl_VERSION_STRING
#
# Additionally, the following imported targets will be defined:
#
#   Wayland::Client
#   Wayland::Server
#   Wayland::Cursor
#   Wayland::Egl
#
# Copyright (c) 2014 Martin Gräßlin <mgraesslin@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

if(CMAKE_VERSION VERSION_LESS 2.8.12)
    message(FATAL_ERROR "CMake 2.8.12 is required by FindWayland.cmake")
endif()
if(CMAKE_MINIMUM_REQUIRED_VERSION VERSION_LESS 2.8.12)
    message(AUTHOR_WARNING "Your project should require at least CMake 2.8.12 to use FindWayland.cmake")
endif()

set(knownComponents Client
                    Server
                    Cursor
                    Egl
    )

unset(unknownComponents)

set(pkgConfigModules)

if (Wayland_FIND_COMPONENTS)
  set(comps ${Wayland_FIND_COMPONENTS})
else()
  set(comps ${knownComponents})
endif()

# iterate through the list of requested components, and check that we know them all.
# If not, fail.
foreach(comp ${comps})
    list(FIND knownComponents ${comp} index )
    if("${index}" STREQUAL "-1")
        list(APPEND unknownComponents "${comp}")
    else()
        if("${comp}" STREQUAL "Client")
            list(APPEND pkgConfigModules "wayland-client")
        elseif("${comp}" STREQUAL "Server")
            list(APPEND pkgConfigModules "wayland-server")
        elseif("${comp}" STREQUAL "Cursor")
            list(APPEND pkgConfigModules "wayland-cursor")
        elseif("${comp}" STREQUAL "Egl")
            list(APPEND pkgConfigModules "wayland-egl")
        endif()
    endif()
endforeach()


if(DEFINED unknownComponents)
   set(msgType STATUS)
   if(Wayland_FIND_REQUIRED)
      set(msgType FATAL_ERROR)
   endif()
   if(NOT Wayland_FIND_QUIETLY)
      message(${msgType} "Wayland: requested unknown components ${unknownComponents}")
   endif()
   return()
endif()

macro(_wayland_handle_component _comp)
    set(_header )
    set(_lib )
    set(_pkgconfig_module_var)
    if("${_comp}" STREQUAL "Client")
        set(_header "wayland-client.h")
        set(_lib "wayland-client")
        set(_pkgconfig_module_var "wayland-client")
    elseif("${_comp}" STREQUAL "Server")
        set(_header "wayland-server.h")
        set(_lib "wayland-server")
        set(_pkgconfig_module_var "wayland-server")
    elseif("${_comp}" STREQUAL "Cursor")
        set(_header "wayland-cursor.h")
        set(_lib "wayland-cursor")
        set(_pkgconfig_module_var "wayland-cursor")
    elseif("${_comp}" STREQUAL "Egl")
        set(_header "wayland-egl.h")
        set(_lib "wayland-egl")
        set(_pkgconfig_module_var "wayland-egl")
    endif()

    find_path(Wayland_${_comp}_INCLUDE_DIR
        NAMES ${_header}
        HINTS ${PKG_Wayland_INCLUDE_DIRS}
    )
    find_library(Wayland_${_comp}_LIBRARY
        NAMES ${_lib}
        HINTS ${PKG_Wayland_LIBRARY_DIRS}
    )

    if(Wayland_${_comp}_INCLUDE_DIR AND Wayland_${_comp}_LIBRARY)
        list(APPEND Wayland_INCLUDE_DIRS ${Wayland_${_comp}_INCLUDE_DIR})
        list(APPEND Wayland_LIBRARIES ${Wayland_${_comp}_LIBRARY})
    endif()

    if(PKG_Wayland_VERSION AND NOT PKG_Wayland_${_pkgconfig_module_var}_VERSION)
        # this is what gets set if we only search for one module
        set(Wayland_${_comp}_VERSION_STRING "${PKG_Wayland_VERSION}")
    else()
        set(Wayland_${_comp}_VERSION_STRING "${PKG_Wayland_${_pkgconfig_module_var}_VERSION}")
    endif()

    if(NOT Wayland_VERSION_STRING)
        set(Wayland_VERSION_STRING ${Wayland_${_comp}_VERSION_STRING})
    endif()

    find_package_handle_standard_args(Wayland_${_comp}
        FOUND_VAR
            Wayland_${_comp}_FOUND
        REQUIRED_VARS
            Wayland_${_comp}_LIBRARY
            Wayland_${_comp}_INCLUDE_DIR
        VERSION_VAR
            Wayland_${_comp}_VERSION_STRING
        )

    mark_as_advanced(
        Wayland_${_comp}_LIBRARY
        Wayland_${_comp}_INCLUDE_DIR
    )

    if(Wayland_${_comp}_FOUND AND NOT TARGET Wayland::${_comp})
        add_library(Wayland::${_comp} UNKNOWN IMPORTED)
        set_target_properties(Wayland::${_comp} PROPERTIES
            IMPORTED_LOCATION "${Wayland_${_comp}_LIBRARY}"
            INTERFACE_COMPILE_OPTIONS "${Wayland_DEFINITIONS}"
            INTERFACE_INCLUDE_DIRECTORIES "${Wayland_${_comp}_INCLUDE_DIR}"
        )
    endif()
endmacro()

if(NOT WIN32)
    include(FindPackageHandleStandardArgs)
    # Use pkg-config to get the directories and then use these values
    # in the FIND_PATH() and FIND_LIBRARY() calls
    find_package(PkgConfig)
    pkg_check_modules(PKG_Wayland QUIET ${pkgConfigModules})

    set(Wayland_DEFINITIONS ${PKG_Wayland_CFLAGS_OTHER})

    foreach(comp ${comps})
        _wayland_handle_component(${comp})
    endforeach()

    if(Wayland_INCLUDE_DIRS)
        list(REMOVE_DUPLICATES Wayland_INCLUDE_DIRS)
    endif()

    find_package_handle_standard_args(Wayland
        FOUND_VAR
            Wayland_FOUND
        REQUIRED_VARS
            Wayland_LIBRARIES
            Wayland_INCLUDE_DIRS
        VERSION_VAR
            Wayland_VERSION_STRING
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
