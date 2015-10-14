project(ECMPoQmToolsTest)
cmake_minimum_required(VERSION 2.8.12)
set(ECM_MODULE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../modules")

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../../modules)

# make sure the test install dir is clean
file(REMOVE_RECURSE "${CMAKE_INSTALL_PREFIX}")

include(ECMPoQmTools)

include(../test_helpers.cmake)


#
# ecm_process_po_files_as_qm
#


# Should create a process-and-install.qm file and install it
ecm_process_po_files_as_qm(fr ALL
    INSTALL_DESTINATION share/locale
    PO_FILES process-and-install.po
)

# Should create a only-process.qm file, without installing it
ecm_process_po_files_as_qm(fr ALL
    PO_FILES only-process.po
)



#
# ecm_install_po_files_as_qm
#

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

unset(CMAKE_INSTALL_LOCALEDIR)
unset(LOCALE_INSTALL_DIR)



#
# ecm_create_qm_loader
#

find_package(Qt5Core CONFIG REQUIRED)
ecm_install_po_files_as_qm(tr_test-po)


set(tr_test_SRCS
    tr_test.cpp
)
ecm_create_qm_loader(tr_test_SRCS catalog)
add_executable(tr_test ${tr_test_SRCS})
target_link_libraries(tr_test PRIVATE Qt5::Core)


# This is not something we want people to do (putting the ecm_create_qm_loader
# call in one CMakeLists.txt file and the target it is used for in another),
# but it's unfortunately something projects have done and we need to keep them
# building
unset(QMLOADER_FILES)
ecm_create_qm_loader(QMLOADER_FILES catalog)
assert_var_defined(QMLOADER_FILES)
add_subdirectory(subdir)



file(GENERATE
    OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/check_conf.cmake"
    INPUT "${CMAKE_CURRENT_SOURCE_DIR}/check_conf.cmake.in"
)
configure_file(check.cmake.in "${CMAKE_CURRENT_BINARY_DIR}/check.cmake" @ONLY)
