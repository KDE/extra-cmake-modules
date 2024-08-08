# SPDX-FileCopyrightText: 2023 The Qt Company Ltd.
# SPDX-FileCopyrightText: 2024 Manuel Alcaraz Zambrano <manuelalcarazzam@gmail.com>
# SPDX-License-Identifier: BSD-3-Clause

# Based on https://code.qt.io/cgit/pyside/pyside-setup.git/tree/examples/widgetbinding/CMakeLists.txt

#[=======================================================================[.rst:
ECMGeneratePythonBindings
-------------------------

Generate Python bindings using Shiboken.

::

  ecm_generate_python_bindings(PACKAGE_NAME <pythonlibrary>
                               VERSION <version>
                               WRAPPED_HEADER <filename>
                               TYPESYSTEM <filename>
                               GENERATED_SOURCES <filename> [<filename> [...]]
                               INCLUDE_DIRS <directory> [<directory> [...]]
                               QT_LIBS <target> [<target> [...]]
                               QT_VERSION <version>
                               HOMEPAGE_URL <url>
                               ISSUES_URL <url> )

``<pythonlibrary>`` is the name of the Python library that will be created.

``VERSION`` is the version of the library.

``WRAPPED_HEADER`` is a C++ header that contains all the required includes
for the library.

``TYPESYSTEM`` is the XML file where the bindings are defined.

``GENERATED_SOURCES`` is the list of generated C++ source files by Shiboken
that will be used to build the shared library.

``INCLUDE_DIRS`` is a list of directories to be included by Shiboken.

``QT_LIBS`` is the list of Qt libraries that the original library uses.

``QT_VERSION`` is the minimum required Qt version of the library.

``HOMEPAGE_URL`` is a URL to the proyect homepage.

``ISSUES_URL` is a URL where users can report bugs and feature requests.

#]=======================================================================]

set(MODULES_DIR ${CMAKE_CURRENT_LIST_DIR})

function(ecm_generate_python_bindings)
    set(options )
    set(oneValueArgs PACKAGE_NAME WRAPPED_HEADER TYPESYSTEM VERSION QT_VERSION HOMEPAGE_URL ISSUES_URL)
    set(multiValueArgs GENERATED_SOURCES INCLUDE_DIRS QT_LIBS)

    cmake_parse_arguments(PB "${options}" "${oneValueArgs}" "${multiValueArgs}"  ${ARGN})

    list(APPEND PB_QT_LIBS PySide6::pyside6)
    list(APPEND PB_QT_LIBS Shiboken6::libshiboken)

    # Enable rpaths so that the built shared libraries find their dependencies.
    set(CMAKE_SKIP_BUILD_RPATH FALSE)
    set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
    set(CMAKE_INSTALL_RPATH ${SHIBOKEN_PYTHON_MODULE_DIR} ${CMAKE_CURRENT_SOURCE_DIR})
    set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

    # Get the relevant include dirs, to pass them on to shiboken.
    set(INCLUDES "")

    foreach(DEPENDENCY ${PB_QT_LIBS})
        get_property(DEPENDENCY_INCLUDE_DIRS TARGET "${DEPENDENCY}" PROPERTY INTERFACE_INCLUDE_DIRECTORIES)

        foreach(INCLUDE_DIR ${DEPENDENCY_INCLUDE_DIRS})
            list(APPEND INCLUDES "-I${INCLUDE_DIR}")
        endforeach()
    endforeach()

    foreach(INCLUDE_DIR ${PB_INCLUDE_DIRS})
        list(APPEND INCLUDES "-I${INCLUDE_DIR}")
    endforeach()

    # Set up the options to pass to shiboken.
    set(shiboken_options --enable-pyside-extensions
        ${INCLUDES}
        -I${CMAKE_SOURCE_DIR}
        -T${CMAKE_SOURCE_DIR}
        -T${PYSIDE_TYPESYSTEMS}
        --output-directory=${CMAKE_CURRENT_BINARY_DIR})

    set(generated_sources_dependencies ${PB_WRAPPED_HEADER} ${PB_TYPESYSTEM})

    # Add custom target to run shiboken to generate the binding cpp files.
    add_custom_command(
        OUTPUT ${PB_GENERATED_SOURCES}
        COMMAND shiboken6 ${shiboken_options} ${PB_WRAPPED_HEADER} ${PB_TYPESYSTEM}
        DEPENDS ${generated_sources_dependencies}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Running generator for ${PB_TYPESYSTEM}"
    )

    # Set the cpp files which will be used for the bindings library.
    set(${PB_PACKAGE_NAME}_sources ${PB_GENERATED_SOURCES})

    # PySide6 uses deprecated code.
    get_property(_defs DIRECTORY ${CMAKE_SOURCE_DIR} PROPERTY COMPILE_DEFINITIONS)
    list(FILTER _defs EXCLUDE REGEX [[^QT_DISABLE_DEPRECATED_BEFORE=]])
    set_property(DIRECTORY ${CMAKE_SOURCE_DIR} PROPERTY COMPILE_DEFINITIONS ${_defs})
    get_property(_defs DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY COMPILE_DEFINITIONS)
    list(FILTER _defs EXCLUDE REGEX [[^QT_DISABLE_DEPRECATED_BEFORE=]])
    set_property(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY COMPILE_DEFINITIONS ${_defs})

    # Define and build the bindings library.
    add_library(${PB_PACKAGE_NAME} SHARED ${${PB_PACKAGE_NAME}_sources})

    target_link_libraries(${PB_PACKAGE_NAME} PRIVATE
        PySide6::pyside6
        Shiboken6::libshiboken
        ${Python3_LIBRARIES}
    )

    # Apply relevant include and link flags.
    target_include_directories(${PB_PACKAGE_NAME} PRIVATE
        ${PYSIDE_PYTHONPATH}/include
        ${SHIBOKEN_PYTHON_INCLUDE_DIRS}
        $<TARGET_PROPERTY:PySide6::pyside6,INTERFACE_INCLUDE_DIRECTORIES>
        $<TARGET_PROPERTY:Shiboken6::libshiboken,INTERFACE_INCLUDE_DIRECTORIES>
    )

    foreach(DEPENDENCY ${PB_QT_LIBS})
        target_link_libraries(${PB_PACKAGE_NAME} PRIVATE "${DEPENDENCY}")
    endforeach()

    # Adjust the name of generated module.
    set_property(TARGET ${PB_PACKAGE_NAME} PROPERTY PREFIX "")
    set_property(TARGET ${PB_PACKAGE_NAME} PROPERTY LIBRARY_OUTPUT_NAME "${PB_PACKAGE_NAME}.${Python3_SOABI}")
    set_property(TARGET ${PB_PACKAGE_NAME} PROPERTY LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${PB_PACKAGE_NAME}/build/lib)

    # Build Python Wheel
    file(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/${PB_PACKAGE_NAME}/${PB_PACKAGE_NAME}")
    configure_file("${MODULES_DIR}/ECMGeneratePythonBindings.toml.in" "${CMAKE_CURRENT_BINARY_DIR}/${PB_PACKAGE_NAME}/pyproject.toml")
    configure_file("${MODULES_DIR}/ECMGeneratePythonBindings.md.in" "${CMAKE_CURRENT_BINARY_DIR}/${PB_PACKAGE_NAME}/README.md")

    add_custom_command(
        TARGET ${PB_PACKAGE_NAME}
        POST_BUILD
        COMMAND Python3::Interpreter -m build --wheel
        WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/${PB_PACKAGE_NAME}"
        COMMENT "Building Python Wheel"
    )

endfunction()
