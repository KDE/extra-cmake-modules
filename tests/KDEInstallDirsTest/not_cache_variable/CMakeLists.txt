# Test KDEInstallDirs does not crash if a variable like CMAKE_INSTALL_LIBDIR is
# defined but is not a cache variable.
cmake_minimum_required(VERSION 2.8)

set(ECM_KDE_MODULE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../../../kde-modules)
set(ECM_MODULE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../../../modules)

set(CMAKE_INSTALL_LIBDIR "foo")
include(${ECM_KDE_MODULE_DIR}/KDEInstallDirs.cmake)

add_executable(dummy main.c)
set_target_properties(dummy PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})
