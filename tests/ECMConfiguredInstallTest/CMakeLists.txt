cmake_minimum_required(VERSION 3.5)
project(ECMConfiguredInstallTest)
set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../../modules)

# make sure the test install dir is clean
file(REMOVE_RECURSE "${CMAKE_INSTALL_PREFIX}")
include(ECMConfiguredInstall)

# run test

set(FOO myFoo)
set(BAR myBar)

ecm_install_configured_files(INPUT configured.txt DESTINATION ${CMAKE_INSTALL_PREFIX}/test)

ecm_install_configured_files(INPUT configured_atOnly.txt.in DESTINATION ${CMAKE_INSTALL_PREFIX}/test @ONLY ESCAPE_QUOTES)

ecm_install_configured_files(INPUT multi1.txt.in ${CMAKE_CURRENT_SOURCE_DIR}/multi2.txt.in DESTINATION ${CMAKE_INSTALL_PREFIX}/test)

# this will be run by CTest
configure_file(check_tree.cmake.in "${CMAKE_CURRENT_BINARY_DIR}/check_tree.cmake" @ONLY)
