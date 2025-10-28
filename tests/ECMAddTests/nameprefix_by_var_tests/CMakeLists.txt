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

# default from source name
ecm_add_test(
    ${main_cpp}
)

# by explicit arg
ecm_add_test(
    NAME_PREFIX "by_arg-"
    TEST_NAME "main2"
    ${main_cpp}
)

# preset by scope variable
set(ECM_TEST_NAME_PREFIX "by_var-")

assert_test_name_prefix("by_var-")

ecm_add_test(
    TEST_NAME "main3"
    ${main_cpp}
)

# override of scope variable by explicit arg
ecm_add_test(
    NAME_PREFIX "override_by_arg-"
    TEST_NAME "main4"
    ${main_cpp}
)

# override of scope variable by explicit NO_NAME_PREFIX
ecm_add_test(
    NO_NAME_PREFIX
    TEST_NAME "main5"
    ${main_cpp}
)

# preset by reset scope variable
set(ECM_TEST_NAME_PREFIX "by_var2-")

assert_test_name_prefix("by_var2-")

ecm_add_test(
    TEST_NAME "main6"
    ${main_cpp}
)

# check
assert_test_name("" "main")
assert_test_name("by_arg-" "main2")
assert_test_name("by_var-" "main3")
assert_test_name("override_by_arg-" "main4")
assert_test_name("" "main5")
assert_test_name("by_var2-" "main6")
