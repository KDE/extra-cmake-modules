# SPDX-FileCopyrightText: None
# SPDX-License-Identifier: CC0-1.0

list(APPEND ECM_TEST_NAME_PREFIX_IGNORE_DIRS "dir_ignored")

# prefix preset by path-derived value
ecm_add_test(
    TEST_NAME "main_ignored1"
    ${main_cpp}
)

# override of path-derived value by explicit arg
ecm_add_test(
    NAME_PREFIX "override_by_arg-"
    TEST_NAME "main_ignored2"
    ${main_cpp}
)

# override of path-derived value by explicit NO_NAME_PREFIX
ecm_add_test(
    NO_NAME_PREFIX
    TEST_NAME "main_ignored3"
    ${main_cpp}
)

# check
assert_test_name_prefix("dir_a-")

assert_test_name("dir_a-" "main_ignored1")
assert_test_name("override_by_arg-" "main_ignored2")
assert_test_name("" "main_ignored3")
