project(ECMQtDeclareLoggingCategoryTest)
cmake_minimum_required(VERSION 2.8.12)
set(ECM_MODULE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../modules")

set(CMAKE_MODULE_PATH ${ECM_MODULE_DIR})

include(ECMQtDeclareLoggingCategory)

ecm_qt_declare_logging_category(
    sources
    HEADER "log1.h"
    IDENTIFIER "log1"
    CATEGORY_NAME "log.one"
)

ecm_qt_declare_logging_category(
    sources
    HEADER "log2.h"
    IDENTIFIER "foo::bar::log2"
    CATEGORY_NAME "log.two"
)

ecm_qt_declare_logging_category(
    sources
    HEADER "${CMAKE_CURRENT_BINARY_DIR}/log3.h"
    IDENTIFIER "log3"
    CATEGORY_NAME "three"
    DEFAULT_SEVERITY Critical
)

find_package(Qt5Core REQUIRED)

add_executable(testmain testmain.cpp ${sources})
target_include_directories(testmain
    PRIVATE
        "${CMAKE_CURRENT_BINARY_DIR}"
)
target_link_libraries(testmain
    PRIVATE
        Qt5::Core
)

