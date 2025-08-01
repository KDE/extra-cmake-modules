cmake_minimum_required(VERSION 3.16)

project(with_an_URL_parameter VERSION 5.43)

include(../test-and-comparison-helpers.cmake)

include(ECMGeneratePkgConfigFile)
include(ECMSetupVersion)

ecm_setup_version(PROJECT VARIABLE_PREFIX KCOREADDONS
                VERSION_HEADER "${CMAKE_CURRENT_BINARY_DIR}/kcoreaddons_version.h"
                PACKAGE_VERSION_FILE "${CMAKE_CURRENT_BINARY_DIR}/KF5CoreAddonsConfigVersion.cmake"
                SOVERSION 5)

set(origfiles "${CMAKE_CURRENT_SOURCE_DIR}/../../../tests/ECMGeneratePkgConfigFile/KF5CoreAddons5.pc")

ecm_generate_pkgconfig_file(BASE_NAME KF5CoreAddons5
                            DESCRIPTION "KF5CoreAddons test"
                            URL "https://www.example.org/"
                            DEPS Qt5Core
                            INCLUDE_INSTALL_DIR /usr/KCoreAddons
                            FILENAME_VAR OutputFile)

compare_files(GENERATED ${OutputFile}
              ORIGINALS ${origfiles})
file(REMOVE ${OutputFile})
