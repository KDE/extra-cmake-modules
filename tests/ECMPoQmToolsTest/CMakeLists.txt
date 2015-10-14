project(ECMPoQmToolsTest)
cmake_minimum_required(VERSION 2.8.12)
set(ECM_MODULE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../modules")

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../../modules)

# make sure the test install dir is clean
file(REMOVE_RECURSE "${CMAKE_INSTALL_PREFIX}")

include(ECMPoQmTools)

include(../test_helpers.cmake)

unset(QMLOADER_FILES)
ecm_create_qm_loader(QMLOADER_FILES catalog)
assert_var_defined(QMLOADER_FILES)

# These will be used to test the above-generated loader
ecm_install_po_files_as_qm(tr_test-po)

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

find_package(Qt5Core CONFIG REQUIRED)

add_executable(tr_test tr_test.cpp ${QMLOADER_FILES})
target_link_libraries(tr_test PRIVATE Qt5::Core)

add_library(tr_thread_module MODULE tr_thread_test_module.cpp ${QMLOADER_FILES})
target_link_libraries(tr_thread_module PRIVATE Qt5::Core)

add_executable(tr_thread_test tr_thread_test.cpp)
set_target_properties(tr_thread_test PROPERTIES AUTOMOC ON)
target_include_directories(tr_thread_test PRIVATE "${CMAKE_CURRENT_BINARY_DIR}")
target_compile_definitions(tr_thread_test PRIVATE "MODULE_PATH=\"$<TARGET_FILE:tr_thread_module>\"")
target_link_libraries(tr_thread_test PRIVATE Qt5::Core)

file(GENERATE
    OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/check_conf.cmake"
    INPUT "${CMAKE_CURRENT_SOURCE_DIR}/check_conf.cmake.in"
)
configure_file(check.cmake.in "${CMAKE_CURRENT_BINARY_DIR}/check.cmake" @ONLY)
