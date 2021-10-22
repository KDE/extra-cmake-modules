set(MODULES_DIR "${ECM_SOURCE_DIR}/modules")
configure_file(run_test.cmake.config "${CMAKE_CURRENT_BINARY_DIR}/test/CMakeLists.txt" @ONLY)
file(GLOB sources "*.h" "*.hpp")
file(COPY ${sources} CommonHeader DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/test)
file(COPY headsubdir DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/test/)

add_test(
    NAME ECMGenerateHeaders
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/test
    COMMAND ${CMAKE_COMMAND} .)
