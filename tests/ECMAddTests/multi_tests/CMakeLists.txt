cmake_minimum_required(VERSION 3.5)
project(ECMAddTests)

set(ECM_MODULE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../../../modules)
set(CMAKE_MODULE_PATH "${ECM_MODULE_DIR}")

add_library(testhelper STATIC ../testhelper.cpp)
target_include_directories(testhelper PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}/..")

# Link to QtCore for WinMain on Windows
include(QtVersionOption)
find_package(Qt${QT_MAJOR_VERSION}Core REQUIRED)
target_link_libraries(testhelper PUBLIC Qt${QT_MAJOR_VERSION}::Core)

enable_testing()

include(ECMAddTests)
include(../../test_helpers.cmake)

# clean up to avoid false-positives from check_files.cmake
file(REMOVE
    "${CMAKE_CURRENT_BINARY_DIR}/test1.txt"
    "${CMAKE_CURRENT_BINARY_DIR}/test2.txt"
    "${CMAKE_CURRENT_BINARY_DIR}/test3.txt"
    "${CMAKE_CURRENT_BINARY_DIR}/test4.txt"
    "${CMAKE_CURRENT_BINARY_DIR}/test5.txt"
    "${CMAKE_CURRENT_BINARY_DIR}/test6.txt"
    "${CMAKE_CURRENT_BINARY_DIR}/test7.txt"
    "${CMAKE_CURRENT_BINARY_DIR}/test8.txt"
    "${CMAKE_CURRENT_BINARY_DIR}/test9.txt"
    )
file(REMOVE_RECURSE
    "${CMAKE_CURRENT_BINARY_DIR}/test1011_dir"
    )

set(exp_target_names "test1;test2;test3")
set(exp_test_names "test1;test2;test3")
ecm_add_tests(
    test1.cpp
    test2.cpp
    test3.cpp
    LINK_LIBRARIES testhelper
    TARGET_NAMES_VAR target_names
    TEST_NAMES_VAR test_names
    )
assert_vars_setequal(target_names exp_target_names)
assert_vars_setequal(test_names exp_test_names)
# check targets exist
get_property(_dummy TARGET test1 PROPERTY TYPE)
get_property(_dummy TARGET test2 PROPERTY TYPE)
get_property(_dummy TARGET test3 PROPERTY TYPE)
# check tests exists
get_property(_dummy TEST test1 PROPERTY TIMEOUT)
get_property(_dummy TEST test2 PROPERTY TIMEOUT)
get_property(_dummy TEST test3 PROPERTY TIMEOUT)
get_property(_is_win32 TARGET test1 PROPERTY WIN32_EXECUTABLE)
if (_is_win32)
    message(FATAL_ERROR "test1 is a WIN32 executable when it should not be")
endif()
get_property(_is_bundle TARGET test1 PROPERTY MACOSX_BUNDLE)
if (_is_bundle)
    message(FATAL_ERROR "test1 is an OS/X bundle when it should not be")
endif()
get_property(_is_win32 TARGET test2 PROPERTY WIN32_EXECUTABLE)
if (_is_win32)
    message(FATAL_ERROR "test2 is a WIN32 executable when it should not be")
endif()
get_property(_is_bundle TARGET test2 PROPERTY MACOSX_BUNDLE)
if (_is_bundle)
    message(FATAL_ERROR "test2 is an OS/X bundle when it should not be")
endif()


ecm_add_tests(
    test4.cpp
    test5.cpp
    LINK_LIBRARIES testhelper
    NAME_PREFIX pref_
    )
get_property(_dummy TARGET test4 PROPERTY TYPE)
get_property(_dummy TARGET test5 PROPERTY TYPE)
get_property(_dummy TEST pref_test4 PROPERTY TIMEOUT)
get_property(_dummy TEST pref_test5 PROPERTY TIMEOUT)
get_property(_is_win32 TARGET test4 PROPERTY WIN32_EXECUTABLE)
if (_is_win32)
    message(FATAL_ERROR "test4 is a WIN32 executable when it should not be")
endif()
get_property(_is_bundle TARGET test4 PROPERTY MACOSX_BUNDLE)
if (_is_bundle)
    message(FATAL_ERROR "test4 is an OS/X bundle when it should not be")
endif()
get_property(_is_win32 TARGET test5 PROPERTY WIN32_EXECUTABLE)
if (_is_win32)
    message(FATAL_ERROR "test5 is a WIN32 executable when it should not be")
endif()
get_property(_is_bundle TARGET test5 PROPERTY MACOSX_BUNDLE)
if (_is_bundle)
    message(FATAL_ERROR "test5 is an OS/X bundle when it should not be")
endif()


ecm_add_tests(
    test6.cpp
    test7.cpp
    LINK_LIBRARIES testhelper
    GUI
    )
get_property(_dummy TARGET test6 PROPERTY TYPE)
get_property(_dummy TARGET test7 PROPERTY TYPE)
get_property(_dummy TEST test6 PROPERTY TIMEOUT)
get_property(_dummy TEST test7 PROPERTY TIMEOUT)
get_property(_is_win32 TARGET test6 PROPERTY WIN32_EXECUTABLE)
if (NOT _is_win32)
    message(FATAL_ERROR "test6 is not a WIN32 executable when it should be")
endif()
get_property(_is_bundle TARGET test6 PROPERTY MACOSX_BUNDLE)
if (NOT _is_bundle)
    message(FATAL_ERROR "test6 is not an OS/X bundle when it should be")
endif()
get_property(_is_win32 TARGET test7 PROPERTY WIN32_EXECUTABLE)
if (NOT _is_win32)
    message(FATAL_ERROR "test7 is not a WIN32 executable when it should be")
endif()
get_property(_is_bundle TARGET test7 PROPERTY MACOSX_BUNDLE)
if (NOT _is_bundle)
    message(FATAL_ERROR "test7 is not an OS/X bundle when it should be")
endif()


set(exp_target_names "test8;test9")
set(exp_test_names "p_test8;p_test9")
ecm_add_tests(
    test8.cpp
    test9.cpp
    LINK_LIBRARIES testhelper
    NAME_PREFIX p_
    GUI
    TARGET_NAMES_VAR target_names
    TEST_NAMES_VAR test_names
    )
assert_vars_setequal(target_names exp_target_names)
assert_vars_setequal(test_names exp_test_names)
get_property(_dummy TARGET test8 PROPERTY TYPE)
get_property(_dummy TARGET test9 PROPERTY TYPE)
get_property(_dummy TEST p_test8 PROPERTY TIMEOUT)
get_property(_dummy TEST p_test9 PROPERTY TIMEOUT)
get_property(_is_win32 TARGET test8 PROPERTY WIN32_EXECUTABLE)
if (NOT _is_win32)
    message(FATAL_ERROR "test8 is not a WIN32 executable when it should be")
endif()
get_property(_is_bundle TARGET test8 PROPERTY MACOSX_BUNDLE)
if (NOT _is_bundle)
    message(FATAL_ERROR "test8 is not an OS/X bundle when it should be")
endif()
get_property(_is_win32 TARGET test9 PROPERTY WIN32_EXECUTABLE)
if (NOT _is_win32)
    message(FATAL_ERROR "test9 is not a WIN32 executable when it should be")
endif()
get_property(_is_bundle TARGET test9 PROPERTY MACOSX_BUNDLE)
if (NOT _is_bundle)
    message(FATAL_ERROR "test9 is not an OS/X bundle when it should be")
endif()


set(exp_workingdir "${CMAKE_CURRENT_BINARY_DIR}/test1011_dir")
file(MAKE_DIRECTORY "${exp_workingdir}") # cmake does not create that for us, will complain otherwise
ecm_add_tests(
    test10.cpp
    test11.cpp
    LINK_LIBRARIES testhelper
    WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/test1011_dir"
    )
get_property(_dummy TARGET test10 PROPERTY TYPE)
get_property(_dummy TARGET test11 PROPERTY TYPE)
get_property(_dummy TEST test10 PROPERTY TIMEOUT)
get_property(_dummy TEST test11 PROPERTY TIMEOUT)
get_property(_working_dir TEST test10 PROPERTY WORKING_DIRECTORY)
assert_vars_setequal(_working_dir exp_workingdir)
get_property(_working_dir TEST test11 PROPERTY WORKING_DIRECTORY)
assert_vars_setequal(_working_dir exp_workingdir)
get_property(_is_win32 TARGET test10 PROPERTY WIN32_EXECUTABLE)
if (_is_win32)
    message(FATAL_ERROR "test10 is a WIN32 executable when it should not be")
endif()
get_property(_is_bundle TARGET test10 PROPERTY MACOSX_BUNDLE)
if (_is_bundle)
    message(FATAL_ERROR "test10 is an OS/X bundle when it should not be")
endif()
get_property(_is_win32 TARGET test11 PROPERTY WIN32_EXECUTABLE)
if (_is_win32)
    message(FATAL_ERROR "test11 is a WIN32 executable when it should not be")
endif()
get_property(_is_bundle TARGET test11 PROPERTY MACOSX_BUNDLE)
if (_is_bundle)
    message(FATAL_ERROR "test11 is an OS/X bundle when it should not be")
endif()
