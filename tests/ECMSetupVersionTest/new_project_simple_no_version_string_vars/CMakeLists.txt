cmake_minimum_required(VERSION 3.16)

project(new_project_simple VERSION 2.3.4)

# trigger *_VERSION_STRING vars no longer being set
set(ECM_GLOBAL_FIND_VERSION 5.83)
set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../../../modules)
include(ECMSetupVersion)

ecm_setup_version(PROJECT)

include(../version_helpers.cmake)
# NB: name comes from project() command
standard_version_var_checks(new_project_simple 2.3.4)

add_executable(dummy main.c)
