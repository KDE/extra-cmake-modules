# SPDX-FileCopyrightText: None
# SPDX-License-Identifier: CC0-1.0

add_subdirectory(dir_b)
add_subdirectory(dir_ignored)
add_subdirectory(dir_notignored)
add_subdirectory(dir_bypropignored)
add_subdirectory(dir_first)
add_subdirectory(dir_renamed)
add_subdirectory(dir_nodirs)

# default from source name., prefix preset by path-derived value
ecm_add_test(
    ${main_cpp}
)

# prefix preset by path-derived value
ecm_add_test(
    TEST_NAME "main_a2"
    ${main_cpp}
)

# override of path-derived value by explicit arg
ecm_add_test(
    NAME_PREFIX "override_by_arg-"
    TEST_NAME "main_a3"
    ${main_cpp}
)

# check
assert_test_name_prefix("dir_a-")

assert_test_name("dir_a-" "main")
assert_test_name("dir_a-" "main_a2")
assert_test_name("override_by_arg-" "main_a3")
