# Test KDEInstallDirs does not crash if a variable like CMAKE_INSTALL_LIBDIR is
# defined but is not a cache variable.
cmake_minimum_required(VERSION 2.8)
set(kde_modules_dir ${CMAKE_SOURCE_DIR}/../../../kde-modules)

set(CMAKE_INSTALL_LIBDIR "foo")
include(${kde_modules_dir}/KDEInstallDirs.cmake)
