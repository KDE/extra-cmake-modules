# SPDX-FileCopyrightText: None
# SPDX-License-Identifier: CC0-1.0

ecm_test_set_dir_properties(LAST_PREFIX_NAME)

add_subdirectory(dir_afterlast)

# prefix preset by path-derived value
ecm_add_test(
    TEST_NAME "main_last"
    ${main_cpp}
)

# override of path-derived value by explicit arg
ecm_add_test(
    NAME_PREFIX "override_by_arg-"
    TEST_NAME "main_last2"
    ${main_cpp}
)

# override of path-derived value by explicit NO_NAME_PREFIX
ecm_add_test(
    NO_NAME_PREFIX
    TEST_NAME "main_last3"
    ${main_cpp}
)

# check
assert_test_name_prefix("dir_first-dir_last-")

assert_test_name("dir_first-dir_last-" "main_last")
assert_test_name("override_by_arg-" "main_last2")
assert_test_name("" "main_last3")
