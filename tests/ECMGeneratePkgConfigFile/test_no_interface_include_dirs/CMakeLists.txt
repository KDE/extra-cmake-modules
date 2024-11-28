cmake_minimum_required(VERSION 3.16)
project(ECMGeneratePkgConfigFile_no_interface_include_directories VERSION 0.1)

set(ECM_MODULE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../../modules")
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../../../modules;${CMAKE_CURRENT_SOURCE_DIR}/../../../kde-modules")

enable_language(CXX)

include(ECMGeneratePkgConfigFile)
include(ECMSetupVersion)

# KDEInstallDirs can't be used
set(EGPF_KDE_INSTALL_INCLUDEDIR_KF "include/KF6")

set(InputFile "${CMAKE_CURRENT_SOURCE_DIR}/EGPF_no_interface_include_directories.pc")

set(CMAKE_INSTALL_PREFIX "/usr")
set(CMAKE_INSTALL_LIBDIR "lib")

ecm_setup_version(0.1 VARIABLE_PREFIX EGPF_lib_without_interface
                SOVERSION 0)

add_library(EGPF_lib_without_interface)
target_sources(EGPF_lib_without_interface PRIVATE main.cpp)
set_target_properties(EGPF_lib_without_interface PROPERTIES
    VERSION 0.1
    SOVERSION 0
)

ecm_generate_pkgconfig_file(BASE_NAME EGPF_lib_without_interface
                            DESCRIPTION "Testing generated pkgconfig file without interface_include_directories"
                            INCLUDE_INSTALL_DIR ${EGPF_KDE_INSTALL_INCLUDEDIR_KF}
                            FILENAME_VAR OutputFile
                            )

add_test(
    NAME ECMGeneratePkgConfigFileTest.no_interface_include_directories
    COMMAND ${CMAKE_COMMAND} -E compare_files --ignore-eol "${InputFile}" "${OutputFile}"
    )
