# SPDX-FileCopyrightText: 2015 Aleix Pol Gonzalez <aleixpol@blue-systems.com>
# SPDX-FileCopyrightText: 2023 Alexander Lohnau <alexander.lohnau@gmx.de>
#
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
ECMFindQmlModule
----------------

Find QML import modules through a ``find_qmlmodule()`` call.
It uses the qmlplugindump application to find the plugins and sets them up as
runtime dependencies.

This is useful so that when we configure a project we are notified when some
QML imports are not present in the system, thus having the application compilable
but fail at runtime.

::

  ecm_find_qmlmodule(<module_name>
    [version] # Optional for Qt6 builds
    [REQUIRED]
  )

Usage example:

.. code-block:: cmake

  ecm_find_qmlmodule(org.kde.kirigami 2.1)
  ecm_find_qmlmodule(org.kde.kirigami 2.1 REQUIRED) # CMake will fail if the required version is not found
  ecm_find_qmlmodule(org.kde.kirigami) # Find it without a given version
  ecm_find_qmlmodule(org.kde.kirigami REQUIRED) # CMake will fail if it is not found

Since 5.38.0.
#]=======================================================================]

set(MODULES_DIR ${CMAKE_CURRENT_LIST_DIR})

function(ecm_find_qmlmodule MODULE_NAME)
    list(LENGTH ARGN ARGC)
    if (QT_MAJOR_VERSION STREQUAL 6)
        if (ARGC GREATER_EQUAL 1)
        list(GET ARGN 0 ARG_VERSION)
        if ("${ARG_VERSION}" MATCHES "([0-9]+(\\.[0-9]+)*)") # Check if it is a version or anything passed on to find_package call
          set(VERSION ${ARG_VERSION})
          list(REMOVE_AT ARGN 0) # If it is a version, remove it from the args
        endif()
      endif()
    else()
      if (ARGC EQUAL 1)
        list(GET ARGN 0 VERSION)
      else()
        message(FATAL_ERROR "No version provided for ecm_find_qmlmodule, this is required for Qt5 builds")
      endif()
    endif()
    set(GENMODULE "${MODULE_NAME}-QMLModule")
    configure_file("${MODULES_DIR}/ECMFindQmlModule.cmake.in" "Find${GENMODULE}.cmake" @ONLY)
    set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_BINARY_DIR}" ${CMAKE_MODULE_PATH})
    find_package(${GENMODULE} ${ARGN})

    if(COMMAND set_package_properties)
        set_package_properties(${GENMODULE} PROPERTIES
            DESCRIPTION "QML module '${MODULE_NAME}' is a runtime dependency."
            TYPE RUNTIME)
    endif()
endfunction()
