#
# SPDX-FileCopyrightText: 2022 Arjen Hiemstra <ahiemstra@heimr.nl>
#
# SPDX-License-Identifier: BSD-3-Clause

project(extra-cmake-modules)
cmake_minimum_required(VERSION 3.5)

set(ECM_MODULE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../../modules)
set(CMAKE_MODULE_PATH "${ECM_FIND_MODULE_DIR}" "${ECM_MODULE_DIR}")
set(CMAKE_AUTOMOC ON)
include(QtVersionOption)

find_package(Qt${QT_MAJOR_VERSION} REQUIRED COMPONENTS Qml)
include(ECMQmlTests)

ecm_create_qml_test_runner(
    NAME ecm_qmltests_test
    HEADER_CODE
    "// This comment is for testing"
    "// As is this one"
    APPLICATION_AVAILABLE_CODE
    "// This comment is for testing"
    ENGINE_AVAILABLE_CODE
    "// This comment is for testing"
    CLEANUP_TEST_CASE_CODE
    "// This comment is for testing"
)

ecm_add_qml_instantiation_tests(
    MODULE EcmTest
    VERSION 1.2.3
    RUNNER ecm_qmltests_test
    TESTS
    TestType
    AnotherTestType
)

# this will be run by CTest
configure_file(check.cmake.in "${CMAKE_CURRENT_BINARY_DIR}/check.cmake" @ONLY)
