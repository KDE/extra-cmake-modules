# SPDX-FileCopyrightText: None
# SPDX-License-Identifier: CC0-1.0

cmake_minimum_required(VERSION 3.16)

project(ECMAddTests)

set(ECM_MODULE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../../../modules)
set(CMAKE_MODULE_PATH "${ECM_MODULE_DIR}")

enable_testing()

include(ECMAddTests)
include(../../test_helpers.cmake)
include(../nameprefix_test_helpers.cmake)

set(main_cpp ${CMAKE_CURRENT_SOURCE_DIR}/main.cpp)

set(ECM_TEST_NAME_PREFIX_STRATEGY "PATH")

add_subdirectory(dir_a)
