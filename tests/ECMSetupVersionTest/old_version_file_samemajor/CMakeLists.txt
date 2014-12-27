cmake_minimum_required(VERSION 2.8.12)

project(old_version_file_samemajor)

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../../../modules)
include(ECMSetupVersion)

ecm_setup_version(2.3.4
    VARIABLE_PREFIX Foo
    PACKAGE_VERSION_FILE FooVersion.cmake COMPATIBILITY SameMajorVersion
)

macro(strcheck var val)
    if(NOT ${var} STREQUAL "${val}")
        message(FATAL_ERROR "${var} was ${${var}} instead of ${val}")
    endif()
endmacro()
macro(numcheck var val)
    if(NOT ${var} EQUAL "${val}")
        message(FATAL_ERROR "${var} was ${${var}} instead of ${val}")
    endif()
endmacro()
macro(boolcheck var val)
    if(${val} AND NOT ${var})
        message(FATAL_ERROR "${var} was FALSE")
    elseif(${var} AND NOT ${val})
        message(FATAL_ERROR "${var} was TRUE")
    endif()
endmacro()

macro(find_foo major minor patch)
    unset(PACKAGE_VERSION)
    unset(PACKAGE_VERSION_COMPATIBLE)
    unset(PACKAGE_VERSION_EXACT)
    set(PACKAGE_FIND_VERSION "${major}.${minor}.${patch}")
    set(PACKAGE_FIND_VERSION_MAJOR "${major}")
    set(PACKAGE_FIND_VERSION_MINOR "${minor}")
    set(PACKAGE_FIND_VERSION_PATCH "${patch}")
    set(PACKAGE_FIND_VERSION_TWEAK)
    include("${CMAKE_CURRENT_BINARY_DIR}/FooVersion.cmake")
    strcheck(PACKAGE_VERSION "2.3.4")
endmacro()

strcheck(PROJECT_VERSION "2.3.4")
strcheck(PROJECT_VERSION_STRING "2.3.4")
numcheck(PROJECT_VERSION_MAJOR 2)
numcheck(PROJECT_VERSION_MINOR 3)
numcheck(PROJECT_VERSION_PATCH 4)

strcheck(Foo_VERSION "2.3.4")
strcheck(Foo_VERSION_STRING "2.3.4")
numcheck(Foo_VERSION_MAJOR 2)
numcheck(Foo_VERSION_MINOR 3)
numcheck(Foo_VERSION_PATCH 4)
numcheck(Foo_SOVERSION 2)

# too old - fails
find_foo(3 1 1)
boolcheck(PACKAGE_VERSION_COMPATIBLE FALSE)
boolcheck(PACKAGE_VERSION_EXACT FALSE)

# wrong major version - fails
find_foo(1 1 1)
boolcheck(PACKAGE_VERSION_COMPATIBLE FALSE)
boolcheck(PACKAGE_VERSION_EXACT FALSE)

# correct major version, more recent - succeeds
find_foo(2 1 1)
boolcheck(PACKAGE_VERSION_COMPATIBLE TRUE)
boolcheck(PACKAGE_VERSION_EXACT FALSE)

# exact - succeeds
find_foo(2 3 4)
boolcheck(PACKAGE_VERSION_COMPATIBLE TRUE)
boolcheck(PACKAGE_VERSION_EXACT TRUE)

add_executable(dummy main.c)
