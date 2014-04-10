#.rst:
# ECMDBusAddActivationService
# ---------------------------
#
# Install D-Bus activation .service files.
#
# ::
#
#   ecm_dbus_add_activation_service(<inputfile> [<inputfile> [...]])
#
# This macro will configure the input file to generate a .service file, and
# install it into the right directory for the dbus server to find it.
#
# Note that in the case of custom install prefixes, the user will have to add
# the prefix to XDG_DATA_DIRS before starting the DBus server.
#
# Example:
#
# .. code-block:: cmake
#
#   ecm_dbus_add_activation_service(org.mydomain.myapp.service.in)
#
# The file org.mydomain.myapp.service.in contains::
#
#   [D-BUS Service]
#   Name=org.mydomain.myapp
#   Exec=@CMAKE_INSTALL_PREFIX@/bin/myapp
#
# This will create and install PREFIX/share/dbus-1/services/org.mydomain.myapp.service
#
# See http://techbase.kde.org/Development/Tutorials/D-Bus/Autostart_Services for
# a more complete documentation.

#=============================================================================
# Copyright 2012 David Faure <faure@kde.org>
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

macro(ecm_dbus_add_activation_service _sources)
    foreach(_i ${_sources})
        get_filename_component(_service_file ${_i} ABSOLUTE)
        string(REGEX REPLACE "\\.service.*$" ".service" _output_file ${_i})
        set(_target ${CMAKE_CURRENT_BINARY_DIR}/${_output_file})
        configure_file(${_service_file} ${_target})
        # FIXME: document use of ${DBUS_SERVICES_INSTALL_DIR}, and provide a
        #        fallback
        install(FILES ${_target} DESTINATION ${DBUS_SERVICES_INSTALL_DIR})
    endforeach()
endmacro()
