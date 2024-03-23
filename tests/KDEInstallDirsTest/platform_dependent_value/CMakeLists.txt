cmake_minimum_required(VERSION 3.5)
project(KDEInstallDirs.platform_dependent_value)

set(ECM_KDE_MODULE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../../../kde-modules)
set(ECM_MODULE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../../../modules)
set(CMAKE_MODULE_PATH "${ECM_KDE_MODULE_DIR}")

include(KDEInstallDirs)

include(../../test_helpers.cmake)

# DATAROOTDIR which DATADIR inherits, is an example of a platform dependent variable
if(WIN32)
    assert_var_contains_str_value(KDE_INSTALL_DATADIR "bin/data")
else()
    assert_var_contains_str_value(KDE_INSTALL_DATADIR "share")
endif()

add_executable(dummy main.c)
set_target_properties(dummy PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})