cmake_minimum_required(VERSION 3.0.0)

project(new_project_version_file VERSION 2.3.4)

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../../../modules)
include(ECMSetupVersion)

ecm_setup_version(PROJECT
    PACKAGE_VERSION_FILE FooVersion.cmake
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

strcheck(PROJECT_VERSION "2.3.4")
strcheck(PROJECT_VERSION_STRING "2.3.4")
numcheck(PROJECT_VERSION_MAJOR 2)
numcheck(PROJECT_VERSION_MINOR 3)
numcheck(PROJECT_VERSION_PATCH 4)

strcheck(new_project_version_file_VERSION "2.3.4")
strcheck(new_project_version_file_VERSION_STRING "2.3.4")
numcheck(new_project_version_file_VERSION_MAJOR 2)
numcheck(new_project_version_file_VERSION_MINOR 3)
numcheck(new_project_version_file_VERSION_PATCH 4)
numcheck(new_project_version_file_SOVERSION 2)

set(PACKAGE_FIND_VERSION "2.3.4")
include("${CMAKE_CURRENT_BINARY_DIR}/FooVersion.cmake")
strcheck(PACKAGE_VERSION "2.3.4")
if(NOT PACKAGE_VERSION_COMPATIBLE)
    message(FATAL_ERROR "PACKAGE_VERSION_COMPATIBLE not TRUE")
endif()
if(NOT PACKAGE_VERSION_EXACT)
    message(FATAL_ERROR "PACKAGE_VERSION_EXACT not TRUE")
endif()

add_executable(dummy main.c)
