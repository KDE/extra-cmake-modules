# SPDX-FileCopyrightText: None
# SPDX-License-Identifier: CC0-1.0

ecm_test_set_dir_properties(
    DIR nodir_first/nodir_ignored
    PREFIX_NAME_IGNORE
)
list(APPEND ECM_TEST_NAME_PREFIX_IGNORE_DIRS "nodir_notignored")
ecm_test_set_dir_properties(
    DIR nodir_first/nodir_ignored/nodir_notignored
    PREFIX_NAME_NOT_IGNORE
)
ecm_test_set_dir_properties(
    DIR nodir_first/nodir_ignored/nodir_notignored/nodir_renamed
    PREFIX_NAME "new_name"
)
ecm_test_set_dir_properties(
    DIR nodir_first
    FIRST_PREFIX_NAME
)
ecm_test_set_dir_properties(
    DIR nodir_first/nodir_ignored/nodir_notignored/nodir_renamed/nodir_last
    LAST_PREFIX_NAME
)

add_subdirectory(nodir_first/nodir_ignored/nodir_notignored/nodir_renamed/nodir_last/dir_afterlast)