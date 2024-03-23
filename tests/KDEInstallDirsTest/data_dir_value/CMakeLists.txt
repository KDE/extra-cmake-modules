cmake_minimum_required(VERSION 3.5)
project(KDEInstallDirs.data_dir_value)

set(ECM_KDE_MODULE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../../../kde-modules)
set(ECM_MODULE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../../../modules)
set(CMAKE_MODULE_PATH "${ECM_KDE_MODULE_DIR}")
if(NOT ECMTEST_NO_GNU_DIR_INCLUDE)
    include(GNUInstallDirs)
endif()
include(KDEInstallDirs)

include(../../test_helpers.cmake)

if(WIN32)
    assert_var_contains_str_value(KDE_INSTALL_DATADIR "bin/data")
else()
    assert_var_contains_str_value(KDE_INSTALL_DATADIR "share")
endif()

add_executable(dummy main.c)
set_target_properties(dummy PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})
