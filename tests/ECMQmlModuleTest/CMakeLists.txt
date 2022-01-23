#
# SPDX-FileCopyrightText: 2021 Arjen Hiemstra <ahiemstra@heimr.nl>
#
# SPDX-License-Identifier: BSD-3-Clause

project(extra-cmake-modules)
cmake_minimum_required(VERSION 3.5)

set(ECM_MODULE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../../modules)
set(CMAKE_MODULE_PATH "${ECM_FIND_MODULE_DIR}" "${ECM_MODULE_DIR}")
include(QtVersionOption)

find_package(Qt${QT_MAJOR_VERSION} REQUIRED COMPONENTS Qml)
include(ECMQmlModule)

if(QML_ONLY)
    ecm_add_qml_module(TestModule URI Test NO_PLUGIN)
else()
    ecm_add_qml_module(TestModule URI Test)
    target_sources(TestModule PRIVATE qmlmodule.cpp)
    target_link_libraries(TestModule Qt${QT_MAJOR_VERSION}::Qml)
endif()

if (DEPENDS)
    ecm_add_qml_module_dependencies(TestModule DEPENDS OtherTest)
endif()

ecm_target_qml_sources(TestModule SOURCES QmlModule.qml)

ecm_finalize_qml_module(TestModule DESTINATION "test")

# this will be run by CTest
configure_file(check.cmake.in "${CMAKE_CURRENT_BINARY_DIR}/check.cmake" @ONLY)
