project(ECMPoQmToolsTest)
cmake_minimum_required(VERSION 2.8.12)
set(ECM_MODULE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../modules")

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../../modules)

# make sure the test install dir is clean
file(REMOVE_RECURSE "${CMAKE_INSTALL_PREFIX}")

include(ECMPoQmTools)

ecm_create_qm_loader(QMLOADER_PATH catalog)

ecm_process_po_files_as_qm(fr ALL
    INSTALL_DESTINATION share/locale
    PO_FILES test.po
)

ecm_install_po_files_as_qm(po)

# this will be run by CTest
configure_file(check_tree.cmake.in "${CMAKE_CURRENT_BINARY_DIR}/check_tree.cmake" @ONLY)
