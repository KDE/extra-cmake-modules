cmake_minimum_required(VERSION 3.16)

project(custom_defines VERSION 6.7.0)

include(../test-and-comparison-helpers.cmake)

include(ECMGeneratePkgConfigFile)
include(ECMSetupVersion)

ecm_setup_version(PROJECT VARIABLE_PREFIX ATTICA
                VERSION_HEADER "${CMAKE_CURRENT_BINARY_DIR}/attica_version.h"
                PACKAGE_VERSION_FILE "${CMAKE_CURRENT_BINARY_DIR}/KF6AtticaConfigVersion.cmake"
                SOVERSION 6)

set(origfiles "${CMAKE_CURRENT_SOURCE_DIR}/../../../tests/ECMGeneratePkgConfigFile/KF6Attica.pc")

ecm_generate_pkgconfig_file(BASE_NAME KF6Attica
                            DESCRIPTION "Qt library to access Open Collaboration Services"
                            LIB_NAME KF6Attica
                            INCLUDE_INSTALL_DIR /usr/include/Attica
                            DEFINES -I\${prefix}/include/foo -I\${prefix}/include/bar
                            DEPS Qt6Core Qt6Network
                            FILENAME_VAR OutputFile
                            )

compare_files(GENERATED ${OutputFile}
              ORIGINALS ${origfiles})
file(REMOVE ${OutputFile})
