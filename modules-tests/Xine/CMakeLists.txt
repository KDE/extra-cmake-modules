cmake_minimum_required(VERSION 2.6.2)

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../../modules" )
find_package(Xine)

message(STATUS "XINE_FOUND: \"${XINE_FOUND}\"")
message(STATUS "XINE_VERSION: \"${XINE_VERSION}\"")
message(STATUS "XINE_BUGFIX_VERSION: \"${XINE_BUGFIX_VERSION}\"")
message(STATUS "XINE_INCLUDE_DIR: \"${XINE_INCLUDE_DIR}\"")
message(STATUS "XINE_LIBRARY: \"${XINE_LIBRARY}\"")
message(STATUS "XINE_XCB_FOUND: \"${XINE_XCB_FOUND}\"")

