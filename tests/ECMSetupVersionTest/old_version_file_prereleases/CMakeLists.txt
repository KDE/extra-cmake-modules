cmake_minimum_required(VERSION 2.8.12)

project(old_version_file_prereleases)

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../../../modules)
include(ECMSetupVersion)

ecm_setup_version(2.3.4
    VARIABLE_PREFIX Foo
    PACKAGE_VERSION_FILE FooVersion.cmake
        COMPATIBILITY SameMajorVersionWithPrereleases
        FIRST_PRERELEASE_VERSION 90
)

include(../../test_helpers.cmake)
include(../version_helpers.cmake)

macro(find_foo version)
    test_version_file("${CMAKE_CURRENT_BINARY_DIR}/FooVersion.cmake" "${version}")
    assert_var_str_value(PACKAGE_VERSION "2.3.4")
endmacro()

standard_version_var_checks(Foo 2.3.4)

# too old - fails
find_foo("3.1.1")
assert_var_bool_value(PACKAGE_VERSION_COMPATIBLE FALSE ALLOW_UNDEFINED)
assert_var_bool_value(PACKAGE_VERSION_EXACT FALSE ALLOW_UNDEFINED)

# wrong major version - fails
find_foo("1.1.1")
assert_var_bool_value(PACKAGE_VERSION_COMPATIBLE FALSE ALLOW_UNDEFINED)
assert_var_bool_value(PACKAGE_VERSION_EXACT FALSE ALLOW_UNDEFINED)

# wrong major version - fails
find_foo("1")
assert_var_bool_value(PACKAGE_VERSION_COMPATIBLE FALSE ALLOW_UNDEFINED)
assert_var_bool_value(PACKAGE_VERSION_EXACT FALSE ALLOW_UNDEFINED)

# prerelease for wrong major version - fails
find_foo("2.90.0")
assert_var_bool_value(PACKAGE_VERSION_COMPATIBLE FALSE ALLOW_UNDEFINED)
assert_var_bool_value(PACKAGE_VERSION_EXACT FALSE ALLOW_UNDEFINED)

# prerelease for correct major version - succeeds
find_foo("1.90")
assert_var_bool_value(PACKAGE_VERSION_COMPATIBLE TRUE)
assert_var_bool_value(PACKAGE_VERSION_EXACT FALSE ALLOW_UNDEFINED)

# prerelease for correct major version - succeeds
find_foo("1.90.1")
assert_var_bool_value(PACKAGE_VERSION_COMPATIBLE TRUE)
assert_var_bool_value(PACKAGE_VERSION_EXACT FALSE ALLOW_UNDEFINED)

# prerelease for correct major version - succeeds
find_foo("1.95.0")
assert_var_bool_value(PACKAGE_VERSION_COMPATIBLE TRUE)
assert_var_bool_value(PACKAGE_VERSION_EXACT FALSE ALLOW_UNDEFINED)

# correct major version, more recent - succeeds
find_foo("2.1.1")
assert_var_bool_value(PACKAGE_VERSION_COMPATIBLE TRUE)
assert_var_bool_value(PACKAGE_VERSION_EXACT FALSE ALLOW_UNDEFINED)

# correct major version - succeeds
find_foo("2")
assert_var_bool_value(PACKAGE_VERSION_COMPATIBLE TRUE)
assert_var_bool_value(PACKAGE_VERSION_EXACT FALSE ALLOW_UNDEFINED)

# correct major version, but too old - fails
find_foo("2.4.4")
assert_var_bool_value(PACKAGE_VERSION_COMPATIBLE FALSE ALLOW_UNDEFINED)
assert_var_bool_value(PACKAGE_VERSION_EXACT FALSE ALLOW_UNDEFINED)

# exact - succeeds
find_foo("2.3.4")
assert_var_bool_value(PACKAGE_VERSION_COMPATIBLE TRUE)
assert_var_bool_value(PACKAGE_VERSION_EXACT TRUE)




ecm_setup_version(2.90.0
    VARIABLE_PREFIX Foo3Prerelease
    PACKAGE_VERSION_FILE Foo3PrereleaseVersion.cmake
        COMPATIBILITY SameMajorVersionWithPrereleases
        FIRST_PRERELEASE_VERSION 90
)

macro(find_foo version)
    test_version_file("${CMAKE_CURRENT_BINARY_DIR}/Foo3PrereleaseVersion.cmake" "${version}")
    assert_var_str_value(PACKAGE_VERSION "2.90.0")
endmacro()

standard_version_var_checks(Foo3Prerelease 2.90.0)

# too old - fails
find_foo("3.1.1")
assert_var_bool_value(PACKAGE_VERSION_COMPATIBLE FALSE ALLOW_UNDEFINED)
assert_var_bool_value(PACKAGE_VERSION_EXACT FALSE ALLOW_UNDEFINED)

# too old - fails
find_foo("2.90.1")
assert_var_bool_value(PACKAGE_VERSION_COMPATIBLE FALSE ALLOW_UNDEFINED)
assert_var_bool_value(PACKAGE_VERSION_EXACT FALSE ALLOW_UNDEFINED)

# wrong major version - fails
find_foo("1")
assert_var_bool_value(PACKAGE_VERSION_COMPATIBLE FALSE ALLOW_UNDEFINED)
assert_var_bool_value(PACKAGE_VERSION_EXACT FALSE ALLOW_UNDEFINED)

# wrong major version - fails
find_foo("2")
assert_var_bool_value(PACKAGE_VERSION_COMPATIBLE FALSE ALLOW_UNDEFINED)
assert_var_bool_value(PACKAGE_VERSION_EXACT FALSE ALLOW_UNDEFINED)

# correct major version, but don't want a prerelease - fails
find_foo("3")
assert_var_bool_value(PACKAGE_VERSION_COMPATIBLE FALSE ALLOW_UNDEFINED)
assert_var_bool_value(PACKAGE_VERSION_EXACT FALSE ALLOW_UNDEFINED)

# wrong major version - fails
find_foo("2.89.9")
assert_var_bool_value(PACKAGE_VERSION_COMPATIBLE FALSE ALLOW_UNDEFINED)
assert_var_bool_value(PACKAGE_VERSION_EXACT FALSE ALLOW_UNDEFINED)

# exact version - succeeds
find_foo("2.90.0")
assert_var_bool_value(PACKAGE_VERSION_COMPATIBLE TRUE)
assert_var_bool_value(PACKAGE_VERSION_EXACT TRUE)




ecm_setup_version(2.93.4
    VARIABLE_PREFIX Foo3Prerelease2
    PACKAGE_VERSION_FILE Foo3Prerelease2Version.cmake
        COMPATIBILITY SameMajorVersionWithPrereleases
        FIRST_PRERELEASE_VERSION 90
)

macro(find_foo version)
    test_version_file("${CMAKE_CURRENT_BINARY_DIR}/Foo3Prerelease2Version.cmake" "${version}")
    assert_var_str_value(PACKAGE_VERSION "2.93.4")
endmacro()

standard_version_var_checks(Foo3Prerelease2 2.93.4)

# too old - fails
find_foo("3.1.1")
assert_var_bool_value(PACKAGE_VERSION_COMPATIBLE FALSE ALLOW_UNDEFINED)
assert_var_bool_value(PACKAGE_VERSION_EXACT FALSE ALLOW_UNDEFINED)

# too old - fails
find_foo("2.94.0")
assert_var_bool_value(PACKAGE_VERSION_COMPATIBLE FALSE ALLOW_UNDEFINED)
assert_var_bool_value(PACKAGE_VERSION_EXACT FALSE ALLOW_UNDEFINED)

# wrong major version - fails
find_foo("1")
assert_var_bool_value(PACKAGE_VERSION_COMPATIBLE FALSE ALLOW_UNDEFINED)
assert_var_bool_value(PACKAGE_VERSION_EXACT FALSE ALLOW_UNDEFINED)

# wrong major version - fails
find_foo("2")
assert_var_bool_value(PACKAGE_VERSION_COMPATIBLE FALSE ALLOW_UNDEFINED)
assert_var_bool_value(PACKAGE_VERSION_EXACT FALSE ALLOW_UNDEFINED)

# correct major version, but don't want a prerelease - fails
find_foo("3")
assert_var_bool_value(PACKAGE_VERSION_COMPATIBLE FALSE ALLOW_UNDEFINED)
assert_var_bool_value(PACKAGE_VERSION_EXACT FALSE ALLOW_UNDEFINED)

# wrong major version - fails
find_foo("2.89.9")
assert_var_bool_value(PACKAGE_VERSION_COMPATIBLE FALSE ALLOW_UNDEFINED)
assert_var_bool_value(PACKAGE_VERSION_EXACT FALSE ALLOW_UNDEFINED)

# correct major version - succeeds
find_foo("2.90.0")
assert_var_bool_value(PACKAGE_VERSION_COMPATIBLE TRUE)
assert_var_bool_value(PACKAGE_VERSION_EXACT FALSE ALLOW_UNDEFINED)

# exact version - succeeds
find_foo("2.93.4")
assert_var_bool_value(PACKAGE_VERSION_COMPATIBLE TRUE)
assert_var_bool_value(PACKAGE_VERSION_EXACT TRUE)

add_executable(dummy main.c)
