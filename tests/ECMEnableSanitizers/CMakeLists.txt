# SPDX-FileCopyrightText: 2026 Nicolas Fella <nicolas.fella@gmx.de>
# SPDX-License-Identifier: BSD-3-Clause

cmake_minimum_required(VERSION 3.30)
project(testsanitizers)

set(ECM_ENABLE_SANITIZERS address)

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../../modules)
include(ECMEnableSanitizers)

add_executable(dummy main.cpp)
