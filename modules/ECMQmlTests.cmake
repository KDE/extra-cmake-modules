#
# SPDX-FileCopyrightText: 2022 Arjen Hiemstra <ahiemstra@heimr.nl>
#
# SPDX-License-Identifier: BSD-3-Clause

#[========================================================================[.rst:
ECMQmlTests
-----------

This file contains convenience helpers to simplify test creation for QML
projects.

::
    ecm_create_qml_test_runner(
        [HEADER_CODE <code>]
        [APPLICATION_AVAILABLE_CODE <code>]
        [ENGINE_AVAILABLE_CODE <code>]
        [CLEANUP_TEST_CASE_CODE <code>]
        [NAME <name>]
    )

Create an executable that can run QML tests and report their status. This is
similar to the "qmltestrunner" executable, but built locally so it respects
local compile flags. In addition, the four ``_CODE`` arguments allow injecting
additional code into the runner. ``HEADER_CODE`` will be injected at the top of
the generated file and is intended to inject additional includes and similar
preprocessing directives. ``APPLICATION_AVAILABLE_CODE``,
``ENGINE_AVAILABLE_CODE`` and ``CLEANUP_TEST_CASE_CODE`` are injected into
functions that match those documented here:
https://doc.qt.io/qt-5/qtquicktest-index.html#executing-c-before-qml-tests .

The ``NAME`` argument sets both the target and executable name. If it is not
provided, ``ecm_qml_test_runner`` is used as default.

Note that the injected code is shared among all QML tests that use the same test
runner. It is intended for common initialization code that cannot be done from
QML. If you need separate C++ code for different QML tests, consider doing
these tests manually or call ``ecm_create_qml_test_runner`` multiple times using
different names and use the ``RUNNER`` argument for ``ecm_add_qml_test``.

::
    ecm_add_qml_test(SOURCE <source> [NAME <name>] [RUNNER <runner>] [IMPORT_PATH <path>])

Add a QML test. The required ``SOURCE`` argument specifies the QML file to use
for the test. The optional ``NAME`` argument specifies the name of the test. If
it is not provided, the source file will be used as test name. The optional
``RUNNER`` argument specifies the executable to use as test runner. This
executable is expected to run the tests and return the results. It will be
passed the input file using "-input" as command line parameter. It is also
expected to handle the "-platform" and "-import" command line parameters. The
optional ``IMPORT_PATH`` argument is passed to the runner as QML import path. If
it is not provided, the default of "${CMAKE_BINARY_DIR}/bin" is used.

The runner is executed with the current source directory as working directory,
so ``SOURCE`` can be a path relative to the current source directory.

If ``RUNNER`` has not been specified and a target ``ecm_qml_test_runner``
exists, that is used as runner executable. If that target does not exist,
``qmltestrunner`` is used instead.

::
    ecm_add_qml_tests(TESTS <testfile> [<testfile> ...] [RUNNER <runner>] [IMPORT_PATH <path>])

A convenience helper that will call ``ecm_add_qml_test`` for each file in
``TESTS``. The optional ``RUNNER`` and ``IMPORT_PATH`` arguments are forwarded
to each call of ``ecm_add_qml_test``.

::
    ecm_add_qml_instantiation_tests(
        MODULE <module>
        TESTS <type> [<type> ...]
        [VERSION <version>]
        [RUNNER <runner>]
        [IMPORT_PATH <path>]
    )

A convenience function that will create a simple test that tries to instantiate
the specified object. This verifies that the object, if used from QML, will be
created correctly, including correctly creating dependencies.

The ``MODULE`` argument specifies the name of the module that should be loaded
for these tests to work correctly. The optional ``VERSION`` argument specifies
the version of the module to load. If it is omitted, "1.0" is used as default.

The ``TESTS`` argument specifies QML type names that tests should be created
for. Each entry will create a test named "<type>Instantiation" that, when run
will try to create an instance of the specified type and verify that it was
created successfully.

The optional ``RUNNER`` and ``IMPORT_PATH`` arguments are forwarded to
``ecm_add_qml_test`` which this function uses internally.

Since 5.97

#]========================================================================]

include(CMakeParseArguments)

if (QT_MAJOR_VERSION STREQUAL "5")
    find_package(Qt5QuickTest QUIET)
    if (NOT TARGET Qt5::QuickTest)
        message(FATAL_ERROR "ECMQmlTests requires the Qt5QuickTest module")
    endif()
elseif(QT_MAJOR_VERSION STREQUAL "6")
    find_package(Qt6QuickTest QUIET CONFIG)
    if (NOT TARGET Qt6::QuickTest)
        message(FATAL_ERROR "ECMQmlTests requires the Qt6QuickTest module")
    endif()
endif()

set(_ECM_QML_TEST_RUNNER_SOURCE "${CMAKE_CURRENT_LIST_DIR}/ECMQmlTestRunner.cpp.in")
set(_ECM_QML_INSTANTIATION_TEST_SOURCE "${CMAKE_CURRENT_LIST_DIR}/ECMQmlInstantiationTest.qml.in")

function(ecm_create_qml_test_runner)
    set(_single_args
        "NAME"
    )
    set(_multi_args
        "HEADER_CODE"
        "APPLICATION_AVAILABLE_CODE"
        "ENGINE_AVAILABLE_CODE"
        "CLEANUP_TEST_CASE_CODE"
    )
    cmake_parse_arguments(PARSE_ARGV 0 ARG "" "${_single_args}" "${_multi_args}")

    set(_runner_name "${ARG_NAME}")
    if ("${_runner_name}" STREQUAL "")
        set(_runner_name "ecm_qml_test_runner")
    endif()

    list(JOIN ARG_HEADER_CODE "\n" _runner_header_code)
    list(JOIN ARG_APPLICATION_AVAILABLE_CODE "\n" _runner_application_code)
    list(JOIN ARG_ENGINE_AVAILABLE_CODE "\n" _runner_engine_code)
    list(JOIN ARG_CLEANUP_TEST_CASE_CODE "\n" _runner_cleanup_code)

    configure_file("${_ECM_QML_TEST_RUNNER_SOURCE}" "${CMAKE_CURRENT_BINARY_DIR}/${_runner_name}.cpp" @ONLY)

    add_executable(${_runner_name} "${CMAKE_CURRENT_BINARY_DIR}/${_runner_name}.cpp")
    if (TARGET Qt::Qml)
        target_link_libraries(${_runner_name} PRIVATE Qt::Qml Qt::QuickTest)
    else()
        target_link_libraries(${_runner_name} PRIVATE Qt5::Qml Qt5::QuickTest)
    endif()
endfunction()

function(ecm_add_qml_test)
    cmake_parse_arguments(PARSE_ARGV 0 ARG "" "NAME;SOURCE;RUNNER;IMPORT_PATH" "")

    if ("${ARG_SOURCE}" STREQUAL "")
        message(FATAL_ERROR "ecm_add_qml_test called without required argument SOURCE")
    endif()

    set(_runner "${ARG_RUNNER}")
    if ("${_runner}" STREQUAL "")
        if (TARGET ecm_qml_test_runner)
            set(_runner ecm_qml_test_runner)
        else()
            set(_runner qmltestrunner)
        endif()
    endif()

    set(_import_path "${ARG_IMPORT_PATH}")
    if ("${_import_path}" STREQUAL "")
        set(_import_path "${CMAKE_BINARY_DIR}/bin")
    endif()

    if (WIN32)
        set(_extra_args -platform offscreen)
    endif()

    set(_name "${ARG_NAME}")
    if ("${_name}" STREQUAL "")
        set(_name "${ARG_SOURCE}")
    endif()

    add_test(NAME ${_name}
        COMMAND "${_runner}"
            ${_extra_args}
            -import "${_import_path}"
            -input "${ARG_SOURCE}"
        WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
    )
endfunction()

function(ecm_add_qml_tests)
    cmake_parse_arguments(PARSE_ARGV 0 ARG "" "RUNNER;IMPORT_PATH" "TESTS")

    if ("${ARG_TESTS}" STREQUAL "")
        message(FATAL_ERROR "ecm_add_qml_tests called without required argument TESTS")
    endif()

    foreach(test ${ARG_TESTS})
        ecm_add_qml_test(SOURCE ${test} RUNNER "${ARG_RUNNER}" IMPORT_PATH "${ARG_IMPORT_PATH}")
    endforeach()
endfunction()

function(ecm_add_qml_instantiation_tests)
    cmake_parse_arguments(PARSE_ARGV 0 ARG "" "MODULE;VERSION;RUNNER;IMPORT_PATH" "TESTS")

    if ("${ARG_MODULE}" STREQUAL "")
        message(FATAL_ERROR "ecm_add_qml_instantiation_tests called without required argument MODULE")
    endif()

    if ("${ARG_TESTS}" STREQUAL "")
        message(FATAL_ERROR "ecm_add_qml_instantiation_tests called without required argument TESTS")
    endif()

    set(_version "${ARG_VERSION}")
    if ("${_version}" STREQUAL "")
        set(_version "1.0")
    endif()

    foreach(test ${ARG_TESTS})
        set(_IMPORT "import ${ARG_MODULE} ${_version}")
        set(_OBJECT "${test}")

        configure_file(
            "${_ECM_QML_INSTANTIATION_TEST_SOURCE}"
            "${CMAKE_CURRENT_BINARY_DIR}/instantiation/Test${test}.qml"
            @ONLY
        )

        ecm_add_qml_test(
            NAME ${test}Instantiation
            SOURCE "${CMAKE_CURRENT_BINARY_DIR}/instantiation/Test${test}.qml"
            RUNNER "${ARG_RUNNER}"
            IMPORT_PATH "${ARG_IMPORT_PATH}"
        )
    endforeach()
endfunction()
