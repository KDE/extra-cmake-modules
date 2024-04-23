#
# SPDX-FileCopyrightText: 2021 Arjen Hiemstra <ahiemstra@heimr.nl>
#
# SPDX-License-Identifier: BSD-3-Clause

cmake_minimum_required(VERSION 3.16)
project(extra-cmake-modules)

set(ECM_MODULE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../../modules)
set(CMAKE_MODULE_PATH "${ECM_FIND_MODULE_DIR}" "${ECM_MODULE_DIR}")
include(QtVersionOption)

find_package(Qt${QT_MAJOR_VERSION} REQUIRED COMPONENTS Qml)
include(ECMQmlModule)

set(CMAKE_AUTOMOC ON)

if(QML_ONLY)
    ecm_add_qml_module(TestModule URI Test NO_PLUGIN)
else()
    if (QT_MAJOR_VERSION LESS 6 OR NOT DEPENDS)
        ecm_add_qml_module(TestModule URI Test)
    else ()
        ecm_add_qml_module(TestModule URI Test DEPENDENCIES OtherTest)
    endif()
    target_sources(TestModule PRIVATE qmlmodule.cpp)
    target_link_libraries(TestModule PRIVATE Qt${QT_MAJOR_VERSION}::Qml)
endif()

if (QT_MAJOR_VERSION LESS 6 AND DEPENDS)
    ecm_add_qml_module_dependencies(TestModule DEPENDS OtherTest)
endif()

ecm_target_qml_sources(TestModule SOURCES QmlModule.qml)
ecm_target_qml_sources(TestModule VERSION 2.0 SOURCES QmlModule2.qml)

ecm_finalize_qml_module(TestModule DESTINATION "test")

# this will be run by CTest
if (BUILD_SHARED_LIBS)
    get_target_property(MODULE_OUTPUT_PATH TestModule LIBRARY_OUTPUT_DIRECTORY)
else()
    get_target_property(MODULE_OUTPUT_PATH TestModule ARCHIVE_OUTPUT_DIRECTORY)
endif()
configure_file(check.cmake.in "${CMAKE_CURRENT_BINARY_DIR}/check.cmake" @ONLY)
