cmake_minimum_required(VERSION 3.5)
project(ExecuteKDEModules)

# order is important (install dirs before cmake settings)!
set(all_kde_modules
    KDEInstallDirs
    KDECMakeSettings
    KDECompilerSettings
    KDEFrameworkCompilerSettings

    KDEClangFormat
    KDEGitCommitHooks
    KDEMetaInfoPlatformCheck
    KDEPackageAppTemplates
)

set(ECM_KDE_MODULE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../../kde-modules)
set(ECM_MODULE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../../modules)
set(CMAKE_MODULE_PATH "${ECM_KDE_MODULE_DIR}")

foreach(module ${all_kde_modules})
    message(STATUS "module: ${module}")
    include("${module}")
endforeach()

add_executable(dummy main.c)

# tune test for Apple, no bundle expected there
list(APPEND CMAKE_MODULE_PATH "${ECM_MODULE_DIR}")
include(ECMMarkNonGuiExecutable)
ecm_mark_nongui_executable(dummy)

set_target_properties(dummy PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})
