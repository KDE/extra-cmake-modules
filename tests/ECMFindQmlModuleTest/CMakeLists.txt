cmake_minimum_required(VERSION 3.5)
project(extra-cmake-modules)

set(ECM_FIND_MODULE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../../find-modules)
set(ECM_MODULE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../../modules)
set(CMAKE_MODULE_PATH "${ECM_FIND_MODULE_DIR}" "${ECM_MODULE_DIR}")

set(KDE_INSTALL_FULL_QMLDIR ${CMAKE_CURRENT_SOURCE_DIR}/qmlinstall)

include(QtVersionOption)
include(ECMFindQmlModule)

ecm_find_qmlmodule(${QML_MODULE_NAME} ${QML_MODULE_VERSION} ${QML_MODULE_FIND_ARGS})

if (EXPECTED_FOUND_VARAIBLE AND NOT org.kde.ecmtest-QMLModule_FOUND)
  message(WARNING "org.kde.ecmtest-QMLModule_FOUND: ${org.kde.ecmtest-QMLModule_FOUND}")
  message(FATAL_ERROR "Expected \"${QML_MODULE_NAME} ${QML_MODULE_VERSION} ${QML_MODULE_FIND_ARGS}\" to be found, but it is not found")
endif()
if (NOT EXPECTED_FOUND_VARAIBLE AND org.kde.ecmtest-QMLModule_FOUND)
  message(WARNING "org.kde.ecmtest-QMLModule_FOUND: ${org.kde.ecmtest-QMLModule_FOUND}")
  message(FATAL_ERROR "Expected \"${QML_MODULE_NAME} ${QML_MODULE_VERSION} ${QML_MODULE_FIND_ARGS}\" to be not found, but it is found")
endif()

if (QT_MAJOR_VERSION STREQUAL 6 AND org.kde.ecmtest-QMLModule_FOUND AND NOT "${org.kde.ecmtest-QMLModule_VERSION}" STREQUAL "2.0")
    message(FATAL_ERROR "Did not find correct version from qmldir")
endif()

add_executable(dummy main.c)
