#
# SPDX-FileCopyrightText: 2021 Arjen Hiemstra <ahiemstra@heimr.nl>
#
# SPDX-License-Identifier: BSD-3-Clause

#[========================================================================[.rst:
ECMQmlModule
------------

This file contains helper functions to make it easier to create QML modules. It
takes care of a number of things that often need to be repeated. It also takes
care of special handling of QML modules between shared and static builds. When
building a static version of a QML module, the relevant QML source files are
bundled into the static library. When using a shared build, the QML plugin and
relevant QML files are copied to the target's ``RUNTIME_OUTPUT_DIRECTORY`` to make
it easier to run things directly from the build directory.

Example usage:

.. code-block:: cmake

    ecm_add_qml_module(ExampleModule URI "org.example.Example" VERSION 1.4)

    target_sources(ExampleModule PRIVATE ExamplePlugin.cpp)
    target_link_libraries(ExampleModule PRIVATE Qt::Quick)

    ecm_target_qml_sources(ExampleModule SOURCES ExampleItem.qml)
    ecm_target_qml_sources(ExampleModule SOURCES AnotherExampleItem.qml VERSION 1.5)

    ecm_finalize_qml_module(ExampleModule DESTINATION ${KDE_INSTALL_QMLDIR})


::

    ecm_add_qml_module(<target name> URI <module uri> [VERSION <module version>] [NO_PLUGIN] [CLASSNAME <class name>])

This will declare a new CMake target called ``<target name>``. The ``URI``
argument is required and should be a proper QML module URI. The ``URI`` is used,
among others, to generate a subdirectory where the module will be installed to.

If the ``VERSION`` argument is specified, it is used to initialize the default
version that is used by  ``ecm_target_qml_sources`` when adding QML files. If it
is not specified, a  default of 1.0 is used. Additionally, if a version greater
than or equal to 2.0 is specified, the major version is appended to the
installation path of the module.

If the option ``NO_PLUGIN`` is set, a target is declared that is not expected to
contain any C++ QML plugin.

If the optional ``CLASSNAME`` argument is supplied, it will be used as class
name in the generated QMLDIR file. If it is not specified, the target name will
be used instead.

You can add C++ and QML source files to the target using ``target_sources`` and
``ecm_target_qml_sources``, respectively.

Since 5.91.0

::

    ecm_add_qml_module_dependencies(<target> DEPENDS <module string> [<module string> ...])

Add the list of dependencies specified by the ``DEPENDS`` argument to be listed
as dependencies in the generated QMLDIR file of ``<target>``.

Since 5.91.0

::

    ecm_target_qml_sources(<target> SOURCES <source.qml> [<source.qml> ...] [VERSION <version>] [PATH <path>] [PRIVATE])

Add the list of QML files specified by the ``SOURCES`` argument as source files
to the QML module target ``<target>``.

If the optional ``VERSION`` argument is specified, all QML files will be added
with the specified version. If it is not specified, they will use the version of
the QML module target.

If the optional ``PRIVATE`` argument is specified, the QML files will be
included in the target but not in the generated qmldir file. Any version
argument will be ignored.

The optional ``PATH`` argument declares a subdirectory of the module where the
files should be copied to. By default, files will be copied to the module root.

This function will fail if ``<target>`` is not a QML module target or any of the
specified files do not exist.

Since 5.91.0

::

    ecm_finalize_qml_module(<target> DESTINATION <QML install destination>)

Finalize the specified QML module target. This must be called after all other
setup (like adding sources) on the target has been done. It will perform a
number of tasks:

- It will generate a qmldir file from the QML files added to the target. If the
  module has a C++ plugin, this will also be included in the qmldir file.
- If ``BUILD_SHARED_LIBS`` is off, a QRC file is generated from the QML files
  added to the target. This QRC file will be included when compiling the C++ QML
  module. The built static library will be installed in a subdirection of
  ``DESTINATION`` based on the QML module's uri. Note that if ``NO_PLUGIN`` is
  set, a C++ QML plugin will be generated to include the QRC files.
- If ``BUILD_SHARED_LIBS`` in on, all generated files, QML sources and the C++
  plugin will be installed in a subdirectory of ``DESTINATION`` based upon the
  QML module's uri. In addition, these files will also be copied to the target's
  ``RUNTIME_OUTPUT_DIRECTORY`` in a similar subdirectory.

This function will fail if ``<target>`` is not a QML module target.

Since 5.91.0

#]========================================================================]

include(CMakeParseArguments)

set(_ECM_QMLMODULE_STATIC_QMLONLY_H   "${CMAKE_CURRENT_LIST_DIR}/ECMQmlModule.h.in")
set(_ECM_QMLMODULE_STATIC_QMLONLY_CPP "${CMAKE_CURRENT_LIST_DIR}/ECMQmlModule.cpp.in")

set(_ECM_QMLMODULE_PROPERTY_URI "_ecm_qml_uri")
set(_ECM_QMLMODULE_PROPERTY_QMLDIR "_ecm_qmldir_file")
set(_ECM_QMLMODULE_PROPERTY_FILES "_ecm_qml_files")
set(_ECM_QMLMODULE_PROPERTY_QMLONLY "_ecm_qml_only")
set(_ECM_QMLMODULE_PROPERTY_VERSION "_ecm_qml_version")
set(_ECM_QMLMODULE_PROPERTY_PRIVATE "_ecm_qml_private")
set(_ECM_QMLMODULE_PROPERTY_PATH "_ecm_qml_path")
set(_ECM_QMLMODULE_PROPERTY_CLASSNAME "_ecm_qml_classname")
set(_ECM_QMLMODULE_PROPERTY_DEPENDS "_ecm_qml_depends")

macro(_ecm_qmlmodule_verify_qml_target ARG_TARGET)
    if (NOT TARGET ${ARG_TARGET})
        message(FATAL_ERROR "Target ${ARG_TARGET} does not exist")
    endif()
    get_target_property(_qml_uri ${ARG_TARGET} ${_ECM_QMLMODULE_PROPERTY_URI})
    if ("${_qml_uri}" STREQUAL "" OR "${_qml_uri}" STREQUAL "${_ECM_QMLMODULE_PROPERTY_URI}-NOTFOUND")
        message(FATAL_ERROR "Target ${ARG_TARGET} is not a QML plugin target")
    endif()
endmacro()

macro(_ecm_qmlmodule_uri_to_path ARG_OUTPUT ARG_PATH ARG_VERSION)
    string(REPLACE "." "/" _output "${ARG_PATH}")

    # If the major version of the module is >2.0, Qt expects a ".MajorVersion"
    # suffix on the directory. So handle that.
    if (${ARG_VERSION} VERSION_GREATER_EQUAL 2.0)
        string(REGEX MATCH "^([0-9]+)" _version_major ${ARG_VERSION})
        set("${ARG_OUTPUT}" "${_output}.${_version_major}")
    else()
        set("${ARG_OUTPUT}" "${_output}")
    endif()
endmacro()

function(_ecm_qmlmodule_generate_qmldir ARG_TARGET)
    get_target_property(_qml_uri ${ARG_TARGET} ${_ECM_QMLMODULE_PROPERTY_URI})
    get_target_property(_qml_files ${ARG_TARGET} ${_ECM_QMLMODULE_PROPERTY_FILES})
    get_target_property(_qml_only ${ARG_TARGET} ${_ECM_QMLMODULE_PROPERTY_QMLONLY})
    get_target_property(_qml_classname ${ARG_TARGET} ${_ECM_QMLMODULE_PROPERTY_CLASSNAME})

    set(_qmldir_template "# This file was automatically generated by ECMQmlModule and should not be modified")

    string(APPEND _qmldir_template "\nmodule ${_qml_uri}")

    if (NOT ${_qml_only})
        string(APPEND _qmldir_template "\nplugin ${ARG_TARGET}")

        if ("${_qml_classname}" STREQUAL "")
            string(APPEND _qmldir_template "\nclassname ${ARG_TARGET}")
        else()
            string(APPEND _qmldir_template "\nclassname ${_qml_classname}")
        endif()
    endif()

    get_target_property(_qml_depends ${ARG_TARGET} ${_ECM_QMLMODULE_PROPERTY_DEPENDS})
    if (NOT "${_qml_depends}" STREQUAL "")
        foreach(_depends ${_qml_depends})
            string(APPEND _qmldir_template "\ndepends ${_depends}")
        endforeach()
    endif()

    foreach(_file ${_qml_files})
        get_filename_component(_filename ${_file} NAME)
        get_filename_component(_classname ${_file} NAME_WE)
        get_property(_version SOURCE ${_file} PROPERTY ${_ECM_QMLMODULE_PROPERTY_VERSION})
        get_property(_private SOURCE ${_file} PROPERTY ${_ECM_QMLMODULE_PROPERTY_PRIVATE})
        if (NOT _private)
            string(APPEND _qmldir_template "\n${_classname} ${_version} ${_filename}")
        endif()
    endforeach()

    string(APPEND _qmldir_template "\n")

    file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/${ARG_TARGET}_qmldir" "${_qmldir_template}")
    set_target_properties(${ARG_TARGET} PROPERTIES _ecm_qmldir_file "${CMAKE_CURRENT_BINARY_DIR}/${ARG_TARGET}_qmldir")
endfunction()

function(_ecm_qmlmodule_generate_qrc ARG_TARGET)
    get_target_property(_qml_uri ${ARG_TARGET} ${_ECM_QMLMODULE_PROPERTY_URI})
    get_target_property(_qml_files ${ARG_TARGET} ${_ECM_QMLMODULE_PROPERTY_FILES})
    get_target_property(_qmldir_file ${ARG_TARGET} ${_ECM_QMLMODULE_PROPERTY_QMLDIR})
    get_target_property(_qml_version ${ARG_TARGET} ${_ECM_QMLMODULE_PROPERTY_VERSION})

    _ecm_qmlmodule_uri_to_path(_qml_prefix "${_qml_uri}" "${_qml_version}")

    set(_qrc_template "<!-- This file was automatically generated by ECMQmlModule and should not be modified -->")

    string(APPEND _qrc_template "\n<RCC>\n<qresource prefix=\"/${_qml_prefix}\">")
    string(APPEND _qrc_template "\n<file alias=\"qmldir\">${_qmldir_file}</file>")

    foreach(_file ${_qml_files})
        get_filename_component(_filename ${_file} NAME)
        get_property(_path SOURCE ${_file} PROPERTY ${_ECM_QMLMODULE_PROPERTY_PATH})

        set(_file_path "${_filename}")
        if (NOT "${_path}" STREQUAL "")
            set(_file_path "${_path}/${_filename}")
        endif()

        string(APPEND _qrc_template "\n<file alias=\"${_file_path}\">${_file}</file>")
    endforeach()

    string(APPEND _qrc_template "\n</qresource>\n</RCC>\n")

    file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/${ARG_TARGET}.qrc" "${_qrc_template}")
    qt_add_resources(_qrc_output "${CMAKE_CURRENT_BINARY_DIR}/${ARG_TARGET}.qrc")

    target_sources(${ARG_TARGET} PRIVATE ${_qrc_output})
endfunction()

function(ecm_add_qml_module ARG_TARGET)
    cmake_parse_arguments(PARSE_ARGV 1 ARG "NO_PLUGIN" "URI;VERSION;CLASSNAME" "")

    if ("${ARG_TARGET}" STREQUAL "")
        message(FATAL_ERROR "ecm_add_qml_module called without a valid target name.")
    endif()

    if ("${ARG_URI}" STREQUAL "")
        message(FATAL_ERROR "ecm_add_qml_module called without a valid module URI.")
    endif()

    string(FIND "${ARG_URI}" " " "_space")
    if (${_space} GREATER_EQUAL 0)
        message(FATAL_ERROR "ecm_add_qml_module called without a valid module URI.")
    endif()

    if (${BUILD_SHARED_LIBS} AND ${ARG_NO_PLUGIN})
        # CMake doesn't like library targets without sources, so if we have no
        # C++ sources, use a plain target that we can add all the install stuff
        # to.
        add_custom_target(${ARG_TARGET} ALL)
    else()
        add_library(${ARG_TARGET})
    endif()

    if ("${ARG_VERSION}" STREQUAL "")
        set(ARG_VERSION "1.0")
    endif()

    set_target_properties(${ARG_TARGET} PROPERTIES
        ${_ECM_QMLMODULE_PROPERTY_URI} "${ARG_URI}"
        ${_ECM_QMLMODULE_PROPERTY_FILES} ""
        ${_ECM_QMLMODULE_PROPERTY_QMLONLY} "${ARG_NO_PLUGIN}"
        ${_ECM_QMLMODULE_PROPERTY_VERSION} "${ARG_VERSION}"
        ${_ECM_QMLMODULE_PROPERTY_CLASSNAME} "${ARG_CLASSNAME}"
        ${_ECM_QMLMODULE_PROPERTY_DEPENDS} ""
    )

    # QQmlImportDatabase::resolvePlugin doesn't accept lib prefixes under
    # Windows, causing to fail to import when using as a dynamic plugin.
    if (MINGW)
        set_target_properties(${ARG_TARGET} PROPERTIES PREFIX "")
    endif()

    # -Muri is required for static QML plugins to work properly, see
    # https://bugreports.qt.io/browse/QTBUG-82598
    set_target_properties(${ARG_TARGET} PROPERTIES AUTOMOC_MOC_OPTIONS -Muri=${ARG_URI})
endfunction()

function(ecm_add_qml_module_dependencies ARG_TARGET)
    cmake_parse_arguments(PARSE_ARGV 1 ARG "" "" "DEPENDS")

    _ecm_qmlmodule_verify_qml_target(${ARG_TARGET})

    if ("${ARG_DEPENDS}" STREQUAL "")
        message(FATAL_ERROR "ecm_add_qml_module_dependencies called without required argument DEPENDS")
    endif()

    set_target_properties(${ARG_TARGET} PROPERTIES ${_ECM_QMLMODULE_PROPERTY_DEPENDS} "${ARG_DEPENDS}")
endfunction()

function(ecm_target_qml_sources ARG_TARGET)
    cmake_parse_arguments(PARSE_ARGV 1 ARG "PRIVATE" "VERSION;PATH" "SOURCES")

    _ecm_qmlmodule_verify_qml_target(${ARG_TARGET})

    if ("${ARG_SOURCES}" STREQUAL "")
        message(FATAL_ERROR "ecm_target_qml_sources called without required argument SOURCES")
    endif()

    if ("${ARG_VERSION}" STREQUAL "")
        get_target_property(ARG_VERSION ${ARG_TARGET} "_ecm_qml_version")
    endif()

    foreach(_file ${ARG_SOURCES})
        # Check if a given file exists, but only for files that are not
        # automatically generated.
        set(_path "${_file}")
        get_source_file_property(_generated ${_file} GENERATED)
        if (NOT _generated)
            if (IS_ABSOLUTE ${_path})
                # Assume absolute paths are generated, which may not always be
                # true but is fairly likely.
                set(_generated TRUE)
            else()
                string(FIND ${_file} ${CMAKE_BINARY_DIR} _in_binary_dir)
                if (${_in_binary_dir} GREATER_EQUAL 0)
                    # Assume anything in binary dir is generated.
                    set(_generated TRUE)
                else()
                    set(_path "${CMAKE_CURRENT_SOURCE_DIR}/${_file}")
                endif()
            endif()
        endif()

        if (NOT ${_generated} AND NOT EXISTS ${_path})
            message(FATAL_ERROR "ecm_target_qml_sources called with nonexistent file ${_file}")
        endif()

        if (NOT ARG_PRIVATE)
            set_property(SOURCE ${_file} PROPERTY ${_ECM_QMLMODULE_PROPERTY_VERSION} "${ARG_VERSION}")
        else()
            set_property(SOURCE ${_file} PROPERTY ${_ECM_QMLMODULE_PROPERTY_PRIVATE} TRUE)
        endif()
        set_property(SOURCE ${_file} PROPERTY ${_ECM_QMLMODULE_PROPERTY_PATH} "${ARG_PATH}")
        set_property(TARGET ${ARG_TARGET}
            APPEND PROPERTY ${_ECM_QMLMODULE_PROPERTY_FILES} ${_path}
        )
    endforeach()
endfunction()

function(ecm_finalize_qml_module ARG_TARGET)
    cmake_parse_arguments(PARSE_ARGV 1 ARG "" "DESTINATION" "")

    _ecm_qmlmodule_verify_qml_target(${ARG_TARGET})

    if ("${ARG_DESTINATION}" STREQUAL "")
        message(FATAL_ERROR "ecm_finalize_qml_module called without required argument DESTINATION")
    endif()

    _ecm_qmlmodule_generate_qmldir(${ARG_TARGET})

    get_target_property(_qml_uri ${ARG_TARGET} ${_ECM_QMLMODULE_PROPERTY_URI})
    get_target_property(_version ${ARG_TARGET} ${_ECM_QMLMODULE_PROPERTY_VERSION})

    _ecm_qmlmodule_uri_to_path(_plugin_path "${_qml_uri}" "${_version}")

    get_target_property(_qml_only ${ARG_TARGET} ${_ECM_QMLMODULE_PROPERTY_QMLONLY})

    if (NOT BUILD_SHARED_LIBS)
        _ecm_qmlmodule_generate_qrc(${ARG_TARGET})

        if (${_qml_only})
            # If we do not have any C++ sources for the target, we need a way to
            # compile the generated QRC file. So generate a very plain C++ QML
            # plugin that we include in the target.
            configure_file(${_ECM_QMLMODULE_STATIC_QMLONLY_H} ${CMAKE_CURRENT_BINARY_DIR}/QmlModule.h @ONLY)
            configure_file(${_ECM_QMLMODULE_STATIC_QMLONLY_CPP} ${CMAKE_CURRENT_BINARY_DIR}/QmlModule.cpp @ONLY)

            target_sources(${ARG_TARGET} PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/QmlModule.cpp)
            if (TARGET Qt::Qml)
                target_link_libraries(${ARG_TARGET} PRIVATE Qt::Qml)
            else()
                target_link_libraries(${ARG_TARGET} PRIVATE Qt5::Qml)
            endif()
        endif()

        install(TARGETS ${ARG_TARGET} DESTINATION ${ARG_DESTINATION}/${_plugin_path})

        return()
    endif()

    get_target_property(_runtime_output_dir ${ARG_TARGET} RUNTIME_OUTPUT_DIRECTORY)
    if (NOT ${_runtime_output_dir})
        if ("${CMAKE_RUNTIME_OUTPUT_DIRECTORY}" STREQUAL "")
            set(_runtime_output_dir ${CMAKE_CURRENT_BINARY_DIR})
        else()
            set(_runtime_output_dir ${CMAKE_RUNTIME_OUTPUT_DIRECTORY})
        endif()
    endif()

    add_custom_command(
        TARGET ${ARG_TARGET}
        POST_BUILD
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        COMMAND ${CMAKE_COMMAND} -E make_directory ${_runtime_output_dir}/${_plugin_path}
        BYPRODUCTS ${_runtime_output_dir}/${_plugin_path}
    )

    get_target_property(_qmldir_file ${ARG_TARGET} ${_ECM_QMLMODULE_PROPERTY_QMLDIR})
    install(FILES ${_qmldir_file} DESTINATION ${ARG_DESTINATION}/${_plugin_path} RENAME "qmldir")

    add_custom_command(
        TARGET ${ARG_TARGET}
        POST_BUILD
        WORKING_DIRECTORY ${_runtime_output_dir}
        COMMAND ${CMAKE_COMMAND} -E copy ${_qmldir_file} ${_plugin_path}/qmldir
    )

    if (NOT ${_qml_only})
        install(TARGETS ${ARG_TARGET} DESTINATION ${ARG_DESTINATION}/${_plugin_path})

        add_custom_command(
            TARGET ${ARG_TARGET}
            POST_BUILD
            WORKING_DIRECTORY ${_runtime_output_dir}
            COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:${ARG_TARGET}> ${_plugin_path}
        )
    endif()

    get_target_property(_qml_files ${ARG_TARGET} ${_ECM_QMLMODULE_PROPERTY_FILES})
    foreach(_file ${_qml_files})
        get_filename_component(_filename ${_file} NAME)
        get_property(_path SOURCE ${_file} PROPERTY ${_ECM_QMLMODULE_PROPERTY_PATH})

        set(_file_path "${_plugin_path}/")
        if (NOT "${_path}" STREQUAL "")
            set(_file_path "${_plugin_path}/${_path}/")
        endif()

        install(FILES ${_file} DESTINATION ${ARG_DESTINATION}/${_file_path})

        add_custom_command(
            TARGET ${ARG_TARGET}
            POST_BUILD
            WORKING_DIRECTORY ${_runtime_output_dir}
            COMMAND ${CMAKE_COMMAND} -E make_directory ${_file_path}
            COMMAND ${CMAKE_COMMAND} -E copy ${_file} ${_file_path}
            BYPRODUCTS ${_file_path}/${_filename}
        )
    endforeach()
endfunction()
