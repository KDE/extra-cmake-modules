# SPDX-FileCopyrightText: None
# SPDX-License-Identifier: CC0-1.0

macro(assert_test_name expected_prefix_name expected_base_name)
    if(NOT TARGET ${expected_base_name})
        message(SEND_ERROR "No target defined with name '${expected_base_name}'.")
    endif()
    set(_test_name "${expected_prefix_name}${expected_base_name}")
    if(NOT TEST ${_test_name})
        message(SEND_ERROR "No test defined with name '${_test_name}'.")
    endif()
endmacro()

macro(assert_test_name_prefix expected_name_prefix)
    ecm_test_get_name_prefix(name_prefix)
    if(NOT ${name_prefix} STREQUAL ${expected_name_prefix})
        message(SEND_ERROR "Path-derived name prefix is '${name_prefix}', expecting '${expected_name_prefix}'.")
    endif()
endmacro()
