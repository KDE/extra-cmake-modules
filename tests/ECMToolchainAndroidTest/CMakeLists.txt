project(AndroidToolchainTest)
cmake_minimum_required(VERSION 2.8.12)

set(CMAKE_MODULE_PATH
    ${CMAKE_CURRENT_SOURCE_DIR}/../../modules
    ${CMAKE_CURRENT_SOURCE_DIR}/../../toolchain
)

set(TARGET_DIR "${CMAKE_CURRENT_SOURCE_DIR}/testlinkfile")
set(TARGET_NAME "testtarget")
set(OUTPUT_FILE "${CMAKE_CURRENT_BINARY_DIR}/androidtest_output.txt")
set(INPUT_FILE "${CMAKE_CURRENT_SOURCE_DIR}/testlinkfile/outputfake.json")

# test correct include resolution
include(specifydependencies)

file(READ "${OUTPUT_FILE}" TEST_RESULT)
string(FIND ${TEST_RESULT} "libKF5Attica.so" CMP_RESULT)
if (${CMP_RESULT} EQUAL -1)
    message(SEND_ERROR "Could not find relative library libKF5Attica.so")
endif()

add_executable(dummy main.c)
