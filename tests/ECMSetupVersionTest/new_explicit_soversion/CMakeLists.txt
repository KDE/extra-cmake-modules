cmake_minimum_required(VERSION 3.0.0)

project(new_explicit_soversion VERSION 1.5.6.7)

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../../../modules)
include(ECMSetupVersion)

ecm_setup_version(2.3.4
    VARIABLE_PREFIX Foo
    SOVERSION 1
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

strcheck(PROJECT_VERSION "1.5.6.7")
strcheck(PROJECT_VERSION_STRING "1.5.6.7")
numcheck(PROJECT_VERSION_MAJOR 1)
numcheck(PROJECT_VERSION_MINOR 5)
numcheck(PROJECT_VERSION_PATCH 6)

strcheck(Foo_VERSION "2.3.4")
strcheck(Foo_VERSION_STRING "2.3.4")
numcheck(Foo_VERSION_MAJOR 2)
numcheck(Foo_VERSION_MINOR 3)
numcheck(Foo_VERSION_PATCH 4)
numcheck(Foo_SOVERSION 1)

add_executable(dummy main.c)
