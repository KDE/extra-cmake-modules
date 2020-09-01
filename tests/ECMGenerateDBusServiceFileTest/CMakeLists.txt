cmake_minimum_required(VERSION 3.5)
project(ECMGenerateDBusServiceFileTest)
set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../../modules)

# make sure the test install dir is clean
file(REMOVE_RECURSE "${CMAKE_INSTALL_PREFIX}")
include(ECMGenerateDBusServiceFile)

# run test

ecm_generate_dbus_service_file(
   NAME org.kde.kded5
   EXECUTABLE /usr/bin/kded5
   DESTINATION ${CMAKE_INSTALL_PREFIX}/test
)

ecm_generate_dbus_service_file(
   NAME org.kde.kded5.withSystemD
   EXECUTABLE /usr/bin/kded5
   SYSTEMD_SERVICE plasma-kded.service
   DESTINATION ${CMAKE_INSTALL_PREFIX}/test
   RENAME org.kde.kded5.withSystemD.renamed.service
)

# this will be run by CTest
configure_file(check_tree.cmake.in "${CMAKE_CURRENT_BINARY_DIR}/check_tree.cmake" @ONLY)
