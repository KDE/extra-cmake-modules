cmake_minimum_required(VERSION 3.5)
project(ECMQtDeclareLoggingCategoryTest)
set(ECM_MODULE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../modules")

set(CMAKE_MODULE_PATH ${ECM_MODULE_DIR})

include(QtVersionOption)
include(ECMQtDeclareLoggingCategory)

ecm_qt_declare_logging_category(
    sources
    HEADER "log1.h"
    IDENTIFIER "log1"
    CATEGORY_NAME "log.one"
    OLD_CATEGORY_NAMES "log1old"
    DESCRIPTION "log 1"
    EXPORT LOG
)

ecm_qt_declare_logging_category(
    sources
    HEADER "log2.h"
    IDENTIFIER "foo::bar::log2"
    CATEGORY_NAME "log.two"
    DEFAULT_SEVERITY Info
    DESCRIPTION "log 2"
    EXPORT LOG
)

ecm_qt_declare_logging_category(
    sources
    HEADER "${CMAKE_CURRENT_BINARY_DIR}/log3.h"
    IDENTIFIER "log3"
    CATEGORY_NAME "three"
    DEFAULT_SEVERITY Critical
)

ecm_qt_export_logging_category(
    IDENTIFIER "log4"
    CATEGORY_NAME "log.four"
    OLD_CATEGORY_NAMES "logfouroldest" "log4old"
    DEFAULT_SEVERITY Warning
    EXPORT LOG
    DESCRIPTION "log 4"
)

find_package(Qt${QT_MAJOR_VERSION}Core REQUIRED)

add_executable(testmain testmain.cpp ${sources})
target_include_directories(testmain
    PRIVATE
        "${CMAKE_CURRENT_BINARY_DIR}"
)
target_link_libraries(testmain
    PRIVATE
        Qt${QT_MAJOR_VERSION}::Core
)

ecm_qt_install_logging_categories(
    EXPORT LOG
    FILE log.categories
    DESTINATION "${CMAKE_INSTALL_PREFIX}/share/qlogging-categories5"
)

# this will be run by CTest
configure_file(check.cmake.in "${CMAKE_CURRENT_BINARY_DIR}/check.cmake" @ONLY)
