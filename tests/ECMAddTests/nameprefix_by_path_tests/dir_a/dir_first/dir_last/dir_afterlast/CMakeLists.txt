# SPDX-FileCopyrightText: None
# SPDX-License-Identifier: CC0-1.0

# prefix preset by path-derived value
ecm_add_test(
    TEST_NAME "main_afterlast"
    ${main_cpp}
)

# override of path-derived value by explicit arg
ecm_add_test(
    NAME_PREFIX "override_by_arg-"
    TEST_NAME "main_afterlast2"
    ${main_cpp}
)

# check
assert_test_name_prefix("dir_first-dir_last-")

assert_test_name("dir_first-dir_last-" "main_afterlast")
assert_test_name("override_by_arg-" "main_afterlast2")
