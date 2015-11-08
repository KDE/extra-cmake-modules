project(ECMPoQmToolsTest)
cmake_minimum_required(VERSION 2.8.12)
set(ECM_MODULE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../modules")

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../../modules)

# make sure the test install dir is clean
file(REMOVE_RECURSE "${CMAKE_INSTALL_PREFIX}")

include(ECMPoQmTools)

# Should create ${CMAKE_CURRENT_BINARY_DIR}/qmloader.cpp and set QMLOADER_PATH
# to its path
ecm_create_qm_loader(QMLOADER_PATH catalog)

# Should create a process-and-install.qm file and install it
ecm_process_po_files_as_qm(fr ALL
    INSTALL_DESTINATION share/locale
    PO_FILES process-and-install.po
)

# Should create a only-process.qm file, without installing it
ecm_process_po_files_as_qm(fr ALL
    PO_FILES only-process.po
)

# Should create a bunch of .qm files and install them in share/locale.
# Should ignore files directly under po/ as well as directories under po/ which
# do not contain any .po files.
ecm_install_po_files_as_qm(po)

# Should create a bunch of .qm files and install them in
# ${CMAKE_INSTALL_LOCALEDIR}
set(CMAKE_INSTALL_LOCALEDIR custom-dir1)
ecm_install_po_files_as_qm(po-custom-dir1)

# Should create a bunch of .qm files and install them in
# ${LOCALE_INSTALL_DIR}
set(LOCALE_INSTALL_DIR custom-dir2)
ecm_install_po_files_as_qm(po-custom-dir2)

# this will be run by CTest
configure_file(check_tree.cmake.in "${CMAKE_CURRENT_BINARY_DIR}/check_tree.cmake" @ONLY)
