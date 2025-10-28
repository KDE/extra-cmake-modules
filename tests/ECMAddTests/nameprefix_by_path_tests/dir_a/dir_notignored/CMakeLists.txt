# SPDX-FileCopyrightText: None
# SPDX-License-Identifier: CC0-1.0

list(APPEND ECM_TEST_NAME_PREFIX_IGNORE_DIRS "dir_notignored")
ecm_test_set_dir_properties(PREFIX_NAME_NOT_IGNORE)

# prefix preset by path-derived value
ecm_add_test(
    TEST_NAME "main_notignored1"
    ${main_cpp}
)

# override of path-derived value by explicit arg
ecm_add_test(
    NAME_PREFIX "override_by_arg-"
    TEST_NAME "main_notignored2"
    ${main_cpp}
)

# override of path-derived value by explicit NO_NAME_PREFIX
ecm_add_test(
    NO_NAME_PREFIX
    TEST_NAME "main_notignored3"
    ${main_cpp}
)

# check
assert_test_name_prefix("dir_a-dir_notignored-")

assert_test_name("dir_a-dir_notignored-" "main_notignored1")
assert_test_name("override_by_arg-" "main_notignored2")
assert_test_name("" "main_notignored3")
