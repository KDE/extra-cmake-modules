cmake_minimum_required(VERSION 3.16)

# keep version in sync with the one used in consumer/CMakeLists.txt for the library
# ideally would be send over by an exported target property,
# but exporting custom properties via EXPORT_PROPERTIES only was added in CMake 3.12
project(library VERSION 2.40.0)

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../../../modules)
include(ECMGenerateExportHeader)

set(_public_includedir "include/library")

add_library(library library.cpp)
target_include_directories(library
    PUBLIC
        "$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>"
        "$<INSTALL_INTERFACE:${_public_includedir}>"
)

if(SET_GROUP)
    set(_group_args GROUP_BASE_NAME LIBGROUP)
endif()

# adapt macro used for enum deprecation
if(${DEPRECATED_ATTRIBUTE_TYPE} STREQUAL "STANDARD")
    set(ENUM_DEPRECATION_MACRO_NAME "LIBRARY_DEPRECATED_VERSION")
else()
    set(ENUM_DEPRECATION_MACRO_NAME "LIBRARY_ENUMERATOR_DEPRECATED_VERSION")
endif()
configure_file(library.hpp.in "${CMAKE_CURRENT_BINARY_DIR}/library.hpp" @ONLY)

ecm_generate_export_header(library
    ${_group_args}
    DEPRECATED_ATTRIBUTE_TYPE ${DEPRECATED_ATTRIBUTE_TYPE}
    VERSION ${library_VERSION}
    DEPRECATION_VERSIONS 2.0 2.12
    EXCLUDE_DEPRECATED_BEFORE_AND_AT ${EXCLUDE_DEPRECATED_BEFORE_AND_AT}
)

install(TARGETS library DESTINATION lib EXPORT library_targets)

install(EXPORT library_targets FILE LibraryTargets.cmake DESTINATION lib/library)
install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/library.hpp"
    "${CMAKE_CURRENT_BINARY_DIR}/library_export.h"
    DESTINATION ${_public_includedir}
)

add_executable(dummy main.cpp)
