#.rst:
# ECMGenerateDBusServiceFile
# ---------------------------
#
# This module provides the ``ecm_generate_dbus_service_file`` function for
# generating and installing a D-Bus service file.
#
# ::
#
#   ecm_generate_dbus_service_file(
#       NAME <service name>
#       EXECUTABLE <executable>
#       [SYSTEMD_SERVICE <systemd service>]
#       DESTINATION <install_path>
#   )
#
# A D-Bus service file ``<service name>.service`` will be generated and installed
# in the relevant D-Bus config location.
#
# ``<executable>`` must be an absolute path to the installed service executable. When using it with
# ``KDEInstallDirs`` it needs to be the ``_FULL_`` variant of the path variable.
#
# Note: On Windows, the macro will only use the file name part of ``<executable>`` since D-Bus
# service executables are to be installed in the same directory as the D-Bus daemon.
#
# Optionally, a ``<systemd service>`` can be specified to launch the corresponding
# systemd service instead of the ``<executable>`` if the D-Bus daemon is started by systemd.
#
# Example usage:
#
# .. code-block:: cmake
#
#   ecm_generate_dbus_service_file(
#       NAME org.kde.kded5
#       EXECUTABLE ${KDE_INSTALL_FULL_BINDIR}/kded5
#       DESTINATION ${KDE_INSTALL_DBUSSERVICEDIR}
#   )
#
# .. code-block:: cmake
#
#   ecm_generate_dbus_service_file(
#       NAME org.kde.kded5
#       EXECUTABLE ${KDE_INSTALL_FULL_BINDIR}/kded5
#       SYSTEMD_SERVICE plasma-kded.service
#       DESTINATION ${KDE_INSTALL_DBUSSERVICEDIR}
#   )
#
# Since 5.73.0.

#=============================================================================
# Copyright 2020 Kai Uwe Broulik <kde@broulik.de>
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

include(CMakeParseArguments)

function(ecm_generate_dbus_service_file)
    set(options)
    set(oneValueArgs EXECUTABLE NAME SYSTEMD_SERVICE DESTINATION)
    set(multiValueArgs)
    cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if(ARG_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Unexpected arguments to ecm_generate_dbus_service_file: ${ARG_UNPARSED_ARGUMENTS}")
    endif()
    if(NOT ARG_NAME)
        message(FATAL_ERROR "Missing NAME argument for ecm_generate_dbus_service_file")
    endif()
    if(NOT ARG_EXECUTABLE)
        message(FATAL_ERROR "Missing EXECUTABLE argument for ecm_generate_dbus_service_file")
    endif()
    if(NOT ARG_DESTINATION)
        message(FATAL_ERROR "Missing DESTINATION argument for ecm_generate_dbus_service_file")
    endif()

    if(WIN32)
        get_filename_component(_exec "${ARG_EXECUTABLE}" NAME)
    else()
        if (NOT IS_ABSOLUTE ${ARG_EXECUTABLE})
            message(FATAL_ERROR "EXECUTABLE must be an absolute path in ecm_generate_dbus_service_file")
        else()
            set(_exec ${ARG_EXECUTABLE})
        endif()
    endif()

    set(_service_file ${CMAKE_CURRENT_BINARY_DIR}/${ARG_NAME}.service)

    file(WRITE ${_service_file}
    "[D-BUS Service]
Name=${ARG_NAME}
Exec=${_exec}
")

    if (ARG_SYSTEMD_SERVICE)
        file(APPEND ${_service_file} "SystemdService=${ARG_SYSTEMD_SERVICE}\n")
    endif()

    install(FILES ${_service_file} DESTINATION ${ARG_DESTINATION})
endfunction()
