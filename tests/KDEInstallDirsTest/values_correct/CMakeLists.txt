cmake_minimum_required(VERSION 3.5)
project(KDEInstallDirs.values_correct)

set(ECM_KDE_MODULE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../../../kde-modules)
set(ECM_MODULE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../../../modules)
set(CMAKE_MODULE_PATH "${ECM_KDE_MODULE_DIR}")
if(NOT ECMTEST_NO_GNU_DIR_INCLUDE)
    include(GNUInstallDirs)
endif()

set(KDE_INSTALL_EXECROOTDIR "testexedir")

include(KDEInstallDirs)

include(../../test_helpers.cmake)

# DATADIR is one of the paths that is should be different on Windows and Linux
if(WIN32)
    assert_var_contains_str_value(KDE_INSTALL_DATADIR "bin/data")
else()
    assert_var_contains_str_value(KDE_INSTALL_DATADIR "share")
endif()

# BINDIR is documented as "EXECROOTDIR/bin" hence it should contain EXECROOTDIR
assert_var_contains_str_value(KDE_INSTALL_BINDIR KDE_INSTALL_EXECROOTDIR)

add_executable(dummy main.c)
set_target_properties(dummy PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})
