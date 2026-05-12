cmake_minimum_required(VERSION 3.16)

project(consumer)

include(CheckCXXSourceCompiles)

include(../../test_helpers.cmake)

include("${CMAKE_CURRENT_BINARY_DIR}/../installation/${LIBRARY}/lib/library/LibraryTargets.cmake")

# map any "CURRENT" value to library version string
# keep version in sync with the one used in library/CMakeLists.txt
set(library_version 2.40.0)
if(LIBRARY_DISABLE_DEPRECATED_BEFORE_AND_AT STREQUAL "CURRENT")
    set(LIBRARY_DISABLE_DEPRECATED_BEFORE_AND_AT ${library_version})
endif()
if(DEPRECATED_EXCLUDED_BEFORE_AND_AT STREQUAL "CURRENT")
    set(DEPRECATED_EXCLUDED_BEFORE_AND_AT ${library_version})
endif()
# skip the tests for enumerators against C++11 for standard-type attributes
if(${DEPRECATED_ATTRIBUTE_TYPE} STREQUAL "COMPILER")
    set(_test_enumerator_with_cxx11 TRUE)
else()
    set(_test_enumerator_with_cxx11 FALSE)
endif()

# load the test variant specific testAPI method
include(testAPI_${TEST_VARIANT}.cmake)

# for each API element test their visibility to the compiler and if a warning is emitted
if(_test_enumerator_with_cxx11)
    set(_code "Enum enumerator = Enumerator_deprecatedAt2_0;")
    testAPI(_code DEPRECATED_AT 2.0 CXX_STANDARD 11 BUILD_TIME_ONLY_DISABLABLE NO_WARNING)
endif()

set(_code "Enum enumerator = Enumerator_deprecatedAt2_0;")
# no support for enumerator warnings with MSVC and compiler-specific attributes
if(MSVC AND ${DEPRECATED_ATTRIBUTE_TYPE} STREQUAL "COMPILER")
    testAPI(_code DEPRECATED_AT 2.0 CXX_STANDARD 17 BUILD_TIME_ONLY_DISABLABLE NO_WARNING)
else()
    testAPI(_code DEPRECATED_AT 2.0 CXX_STANDARD 17 BUILD_TIME_ONLY_DISABLABLE)
endif()

if(_test_enumerator_with_cxx11)
    set(_code "Enum enumerator = Enumerator_deprecatedAt2_12;")
    testAPI(_code DEPRECATED_AT 2.12 CXX_STANDARD 11 NO_WARNING)
endif()

set(_code "Enum enumerator = Enumerator_deprecatedAt2_12;")
# no support for enumerator warnings with MSVC and compiler-specific attributes
if(MSVC AND ${DEPRECATED_ATTRIBUTE_TYPE} STREQUAL "COMPILER")
    testAPI(_code DEPRECATED_AT 2.12 CXX_STANDARD 17 NO_WARNING)
else()
    testAPI(_code DEPRECATED_AT 2.12 CXX_STANDARD 17)
endif()

set(_code "Enum enumerator = Enumerator_not_deprecated;")
testAPI(_code)

set(_code "function_deprecatedAt2_0();")
testAPI(_code DEPRECATED_AT 2.0)

set(_code "function_deprecatedAt2_12();")
testAPI(_code DEPRECATED_AT 2.12)

set(_code "function_not_deprecated();")
testAPI(_code)

set(_code "Class().method_deprecatedAt2_0();")
testAPI(_code DEPRECATED_AT 2.0 BUILD_TIME_ONLY_DISABLABLE)

set(_code "Class().method_deprecatedAt2_12();")
testAPI(_code DEPRECATED_AT 2.12 BUILD_TIME_ONLY_DISABLABLE)

set(_code "Class().method_not_deprecated();")
testAPI(_code)

add_executable(dummy main.cpp)
