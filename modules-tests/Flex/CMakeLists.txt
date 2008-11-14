cmake_minimum_required(VERSION 2.6.2)

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../../modules" )
find_package(Flex)

message(STATUS "FLEX_FOUND: \"${FLEX_FOUND}\"")
message(STATUS "FLEX_VERSION: \"${FLEX_VERSION}\"")
message(STATUS "FLEX_EXECUTABLE: \"${FLEX_EXECUTABLE}\"")

