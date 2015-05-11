project(ECMAddTests)
cmake_minimum_required(VERSION 2.8.12)

set(ECM_MODULE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../../../modules)
set(CMAKE_MODULE_PATH "${ECM_MODULE_DIR}")

add_library(testhelper STATIC ../testhelper.cpp)
target_include_directories(testhelper PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}/..")

enable_testing()

include(ECMAddTests)

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
    "${CMAKE_CURRENT_BINARY_DIR}/test10.txt"
    "${CMAKE_CURRENT_BINARY_DIR}/test11.txt"
    )

ecm_add_tests(
    test1.cpp
    test2.cpp
    test3.cpp
    LINK_LIBRARIES testhelper
    )
get_property(_is_win32 TARGET test1 PROPERTY WIN32_EXECUTABLE)
if (_is_win32)
    message(FATAL_ERROR "test1 is a WIN32 executable when it should not be")
endif()
get_property(_is_bundle TARGET test1 PROPERTY MACOSX_BUNDLE)
if (_is_bundle)
    message(FATAL_ERROR "test1 is an OS/X bundle when it should not be")
endif()
# existence check
get_property(_dummy TEST test1 PROPERTY TIMEOUT)

get_property(_is_win32 TARGET test2 PROPERTY WIN32_EXECUTABLE)
if (_is_win32)
    message(FATAL_ERROR "test2 is a WIN32 executable when it should not be")
endif()
get_property(_is_bundle TARGET test2 PROPERTY MACOSX_BUNDLE)
if (_is_bundle)
    message(FATAL_ERROR "test2 is an OS/X bundle when it should not be")
endif()
get_property(_dummy TEST test2 PROPERTY TIMEOUT)

get_property(_is_win32 TARGET test3 PROPERTY WIN32_EXECUTABLE)
if (_is_win32)
    message(FATAL_ERROR "test3 is a WIN32 executable when it should not be")
endif()
get_property(_is_bundle TARGET test3 PROPERTY MACOSX_BUNDLE)
if (_is_bundle)
    message(FATAL_ERROR "test3 is an OS/X bundle when it should not be")
endif()
get_property(_dummy TEST test3 PROPERTY TIMEOUT)


ecm_add_tests(
    test4.cpp
    test5.cpp
    LINK_LIBRARIES testhelper
    NAME_PREFIX pref_
    )
get_property(_is_win32 TARGET test4 PROPERTY WIN32_EXECUTABLE)
if (_is_win32)
    message(FATAL_ERROR "test4 is a WIN32 executable when it should not be")
endif()
get_property(_is_bundle TARGET test4 PROPERTY MACOSX_BUNDLE)
if (_is_bundle)
    message(FATAL_ERROR "test4 is an OS/X bundle when it should not be")
endif()
get_property(_dummy TEST pref_test4 PROPERTY TIMEOUT)

get_property(_is_win32 TARGET test5 PROPERTY WIN32_EXECUTABLE)
if (_is_win32)
    message(FATAL_ERROR "test5 is a WIN32 executable when it should not be")
endif()
get_property(_is_bundle TARGET test5 PROPERTY MACOSX_BUNDLE)
if (_is_bundle)
    message(FATAL_ERROR "test5 is an OS/X bundle when it should not be")
endif()
get_property(_dummy TEST pref_test5 PROPERTY TIMEOUT)


ecm_add_tests(
    test6.cpp
    test7.cpp
    LINK_LIBRARIES testhelper
    GUI
    )
get_property(_is_win32 TARGET test6 PROPERTY WIN32_EXECUTABLE)
if (NOT _is_win32)
    message(FATAL_ERROR "test6 is not a WIN32 executable when it should be")
endif()
get_property(_is_bundle TARGET test6 PROPERTY MACOSX_BUNDLE)
if (NOT _is_bundle)
    message(FATAL_ERROR "test6 is not an OS/X bundle when it should be")
endif()
get_property(_dummy TEST test6 PROPERTY TIMEOUT)

get_property(_is_win32 TARGET test7 PROPERTY WIN32_EXECUTABLE)
if (NOT _is_win32)
    message(FATAL_ERROR "test7 is not a WIN32 executable when it should be")
endif()
get_property(_is_bundle TARGET test7 PROPERTY MACOSX_BUNDLE)
if (NOT _is_bundle)
    message(FATAL_ERROR "test7 is not an OS/X bundle when it should be")
endif()
get_property(_dummy TEST test7 PROPERTY TIMEOUT)


ecm_add_tests(
    test8.cpp
    test9.cpp
    LINK_LIBRARIES testhelper
    NAME_PREFIX p_
    GUI
    PROPERTIES
        LABELS "somelabel"
    )
get_property(_is_win32 TARGET test8 PROPERTY WIN32_EXECUTABLE)
if (NOT _is_win32)
    message(FATAL_ERROR "test8 is not a WIN32 executable when it should be")
endif()
get_property(_is_bundle TARGET test8 PROPERTY MACOSX_BUNDLE)
if (NOT _is_bundle)
    message(FATAL_ERROR "test8 is not an OS/X bundle when it should be")
endif()
get_property(_labels TEST p_test8 PROPERTY LABELS)
if (NOT _labels STREQUAL "somelabel")
    message(FATAL_ERROR "p_test8 LABELS property was \"${_labels}\", expected \"somelabel\"")
endif()

get_property(_is_win32 TARGET test9 PROPERTY WIN32_EXECUTABLE)
if (NOT _is_win32)
    message(FATAL_ERROR "test9 is not a WIN32 executable when it should be")
endif()
get_property(_is_bundle TARGET test9 PROPERTY MACOSX_BUNDLE)
if (NOT _is_bundle)
    message(FATAL_ERROR "test9 is not an OS/X bundle when it should be")
endif()
get_property(_labels TEST p_test9 PROPERTY LABELS)
if (NOT _labels STREQUAL "somelabel")
    message(FATAL_ERROR "p_test9 LABELS property was \"${_labels}\", expected \"somelabel\"")
endif()


ecm_add_tests(
    test10.cpp
    test11.cpp
    LINK_LIBRARIES testhelper
    PROPERTIES
        LABELS "somelabel"
        RUN_SERIAL TRUE
    )
get_property(_is_win32 TARGET test10 PROPERTY WIN32_EXECUTABLE)
if (_is_win32)
    message(FATAL_ERROR "test10 is a WIN32 executable when it should not be")
endif()
get_property(_is_bundle TARGET test10 PROPERTY MACOSX_BUNDLE)
if (_is_bundle)
    message(FATAL_ERROR "test10 is an OS/X bundle when it should not be")
endif()
get_property(_labels TEST test10 PROPERTY LABELS)
if (NOT _labels STREQUAL "somelabel")
    message(FATAL_ERROR "test10 LABELS property was \"${_labels}\", expected \"somelabel\"")
endif()
get_property(_run_serial TEST test10 PROPERTY RUN_SERIAL)
if (NOT _run_serial)
    message(FATAL_ERROR "test10 LABELS property was \"${_run_serial}\", expected TRUE")
endif()

get_property(_is_win32 TARGET test11 PROPERTY WIN32_EXECUTABLE)
if (_is_win32)
    message(FATAL_ERROR "test11 is a WIN32 executable when it should not be")
endif()
get_property(_is_bundle TARGET test11 PROPERTY MACOSX_BUNDLE)
if (_is_bundle)
    message(FATAL_ERROR "test11 is an OS/X bundle when it should not be")
endif()
get_property(_labels TEST test11 PROPERTY LABELS)
if (NOT _labels STREQUAL "somelabel")
    message(FATAL_ERROR "test11 LABELS property was \"${_labels}\", expected \"somelabel\"")
endif()
get_property(_run_serial TEST test11 PROPERTY RUN_SERIAL)
if (NOT _run_serial)
    message(FATAL_ERROR "test11 LABELS property was \"${_run_serial}\", expected TRUE")
endif()

