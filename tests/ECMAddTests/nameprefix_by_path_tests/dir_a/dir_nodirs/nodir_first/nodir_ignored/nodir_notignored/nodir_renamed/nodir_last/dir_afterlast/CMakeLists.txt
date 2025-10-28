# SPDX-FileCopyrightText: None
# SPDX-License-Identifier: CC0-1.0

# prefix preset by path-derived value
ecm_add_test(
    TEST_NAME "main_nodir"
    ${main_cpp}
)

# override of path-derived value by explicit arg
ecm_add_test(
    NAME_PREFIX "override_by_arg-"
    TEST_NAME "main_nodir2"
    ${main_cpp}
)

# override of path-derived value by explicit NO_NAME_PREFIX
ecm_add_test(
    NO_NAME_PREFIX
    TEST_NAME "main_nodir3"
    ${main_cpp}
)

# check
assert_test_name_prefix("nodir_first-nodir_notignored-new_name-nodir_last-")

assert_test_name("nodir_first-nodir_notignored-new_name-nodir_last-" "main_nodir")
assert_test_name("override_by_arg-" "main_nodir2")
assert_test_name("" "main_nodir3")
