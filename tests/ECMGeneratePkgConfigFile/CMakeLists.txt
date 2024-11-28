set(MODULES_DIR "${ECM_SOURCE_DIR}/modules")
configure_file(run_test.cmake.config "${CMAKE_CURRENT_BINARY_DIR}/run_test.cmake" @ONLY)

add_test(
    NAME ECMGeneratePkgConfigFile
    COMMAND ${CMAKE_COMMAND} -P "${CMAKE_CURRENT_BINARY_DIR}/run_test.cmake")

add_subdirectory(test_imported_targets)
add_subdirectory(test_no_interface_include_dirs)
