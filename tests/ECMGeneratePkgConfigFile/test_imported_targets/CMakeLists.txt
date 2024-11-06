cmake_minimum_required(VERSION 3.16)
project(ECMGeneratePkgConfigFile_imported_vars VERSION 0.1)

set(ECM_MODULE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../../modules")
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../../../modules;${CMAKE_CURRENT_SOURCE_DIR}/../../../kde-modules")

enable_language(CXX)

include(ECMGeneratePkgConfigFile)
include(ECMSetupVersion)

# KDEInstallDirs can't be used
set(EGPF_KDE_INSTALL_INCLUDEDIR_KF "include/KF6")

set(InputFile "${CMAKE_CURRENT_SOURCE_DIR}/EGPF_imported_include_dirs_control.pc")

set(CMAKE_INSTALL_PREFIX "/usr")
set(CMAKE_INSTALL_LIBDIR "lib")

ecm_setup_version(0.1 VARIABLE_PREFIX EGPF_lib
                SOVERSION 0)

add_library(EGPF_lib)
target_sources(EGPF_lib PRIVATE main.cpp)
set_target_properties(EGPF_lib PROPERTIES
    VERSION 0.1
    SOVERSION 0
    EXPORT_NAME "EGPF_lib"
)

target_include_directories(EGPF_lib INTERFACE "$<INSTALL_INTERFACE:${EGPF_KDE_INSTALL_INCLUDEDIR_KF}/Attica;${EGPF_KDE_INSTALL_INCLUDEDIR_KF}/EGPF_lib;${EGPF_KDE_INSTALL_INCLUDEDIR_KF}/other_dir>"
    PUBLIC
    "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../:${CMAKE_CURRENT_BINARY_DIR}/..>"
)

ecm_generate_pkgconfig_file(BASE_NAME EGPF_lib
                            DESCRIPTION "Testing additional include dirs in Cflags"
                            INCLUDE_INSTALL_DIR ${EGPF_KDE_INSTALL_INCLUDEDIR_KF}/Attica/
                            FILENAME_VAR OutputFile
                            )

add_test(
    NAME ECMGeneratePkgConfigFileTest.imported_include_dirs
    COMMAND ${CMAKE_COMMAND} -E compare_files --ignore-eol "${InputFile}" "${OutputFile}"
    )
