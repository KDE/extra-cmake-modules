cmake_minimum_required(VERSION 3.16)

project(with_public_and_private_dependencies VERSION 5.43)

include(../test-and-comparison-helpers.cmake)

include(ECMGeneratePkgConfigFile)
include(ECMSetupVersion)

ecm_setup_version(PROJECT VARIABLE_PREFIX KCOREADDONS
                VERSION_HEADER "${CMAKE_CURRENT_BINARY_DIR}/kcoreaddons_version.h"
                PACKAGE_VERSION_FILE "${CMAKE_CURRENT_BINARY_DIR}/KF5CoreAddonsConfigVersion.cmake"
                SOVERSION 5)

set(origfiles "${CMAKE_CURRENT_SOURCE_DIR}/../../../tests/ECMGeneratePkgConfigFile/KF5CoreAddons4.pc")

file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/../../../tests/ECMGeneratePkgConfigFile/metainfo_without_description.yaml
     DESTINATION ${CMAKE_CURRENT_SOURCE_DIR})
file(RENAME ${CMAKE_CURRENT_SOURCE_DIR}/metainfo_without_description.yaml ${CMAKE_CURRENT_SOURCE_DIR}/metainfo.yaml)

ecm_generate_pkgconfig_file(BASE_NAME KF5CoreAddons4
                            DEPS Public1 PRIVATE Private1 Private2 PUBLIC Public2
                            INCLUDE_INSTALL_DIR /usr/KCoreAddons
                            FILENAME_VAR OutputFile)

compare_files(GENERATED ${OutputFile}
              ORIGINALS ${origfiles})
file(REMOVE ${OutputFile})
file(REMOVE ${CMAKE_CURRENT_SOURCE_DIR}/metainfo.yaml)
