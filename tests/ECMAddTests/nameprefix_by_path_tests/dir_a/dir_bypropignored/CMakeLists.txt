# SPDX-FileCopyrightText: None
# SPDX-License-Identifier: CC0-1.0

ecm_test_set_dir_properties(PREFIX_NAME_IGNORE)

# prefix preset by path-derived value
ecm_add_test(
    TEST_NAME "main_bypropignored1"
    ${main_cpp}
)

# override of path-derived value by explicit arg
ecm_add_test(
    NAME_PREFIX "override_by_arg-"
    TEST_NAME "main_bypropignored2"
    ${main_cpp}
)

# override of path-derived value by explicit NO_NAME_PREFIX
ecm_add_test(
    NO_NAME_PREFIX
    TEST_NAME "main_bypropignored3"
    ${main_cpp}
)

# check
assert_test_name_prefix("dir_a-")

assert_test_name("dir_a-" "main_bypropignored1")
assert_test_name("override_by_arg-" "main_bypropignored2")
assert_test_name("" "main_bypropignored3")
