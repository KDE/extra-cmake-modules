cmake_minimum_required(VERSION 2.8.12 FATAL_ERROR)

project(extra-cmake-modules NONE)

set(ECM_MAJOR_VERSION 5)
set(ECM_MINOR_VERSION 11)
set(ECM_PATCH_VERSION 0)

set(ECM_VERSION ${ECM_MAJOR_VERSION}.${ECM_MINOR_VERSION}.${ECM_PATCH_VERSION})

option(BUILD_TESTING "Build automated tests." ON)
if(BUILD_TESTING)
    enable_testing()
    add_subdirectory(tests)
endif()

set(SHARE_INSTALL_DIR share CACHE PATH "read-only architecture-independent data")
set(TOOLCHAIN_MODULES_INSTALL_DIR ${SHARE_INSTALL_DIR}/ECM/toolchain/)
set(MODULES_INSTALL_DIR ${SHARE_INSTALL_DIR}/ECM/modules/)
set(KDE_MODULES_INSTALL_DIR ${SHARE_INSTALL_DIR}/ECM/kde-modules/)
set(FIND_MODULES_INSTALL_DIR ${SHARE_INSTALL_DIR}/ECM/find-modules/)
set(CMAKECONFIG_INSTALL_DIR ${SHARE_INSTALL_DIR}/ECM/cmake/)
set(DOC_INSTALL_DIR ${SHARE_INSTALL_DIR}/doc/ECM)
set(MAN_INSTALL_DIR ${SHARE_INSTALL_DIR}/man)

add_subdirectory(docs)

file(GLOB installModuleFiles ${CMAKE_SOURCE_DIR}/modules/*[^~])
install(FILES ${installModuleFiles} DESTINATION ${MODULES_INSTALL_DIR})

file(GLOB installKdeModuleFiles ${CMAKE_SOURCE_DIR}/kde-modules/*[^~])
install(FILES ${installKdeModuleFiles} DESTINATION ${KDE_MODULES_INSTALL_DIR})

file(GLOB installFindModuleFiles ${CMAKE_SOURCE_DIR}/find-modules/*[^~])
install(FILES ${installFindModuleFiles} DESTINATION ${FIND_MODULES_INSTALL_DIR})

file(GLOB installToolchainModuleFiles ${CMAKE_SOURCE_DIR}/toolchain/*[^~])
install(FILES ${installToolchainModuleFiles} DESTINATION ${TOOLCHAIN_MODULES_INSTALL_DIR})


include(CMakePackageConfigHelpers)

configure_package_config_file(ECMConfig.cmake.in ${CMAKE_CURRENT_BINARY_DIR}/ECMConfig.cmake
                              INSTALL_DESTINATION  ${CMAKECONFIG_INSTALL_DIR}
                              PATH_VARS  FIND_MODULES_INSTALL_DIR KDE_MODULES_INSTALL_DIR MODULES_INSTALL_DIR )


write_basic_package_version_file( ${CMAKE_CURRENT_BINARY_DIR}/ECMConfigVersion.cmake
                                 VERSION ${ECM_MAJOR_VERSION}.${ECM_MINOR_VERSION}.${ECM_PATCH_VERSION}
                                 COMPATIBILITY AnyNewerVersion )

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/ECMConfig.cmake
              ${CMAKE_CURRENT_BINARY_DIR}/ECMConfigVersion.cmake
        DESTINATION ${CMAKECONFIG_INSTALL_DIR})

# need to install a Config.cmake file

# set up packaging
set(CPACK_PACKAGE_NAME extra-cmake-modules)
set(CPACK_PACKAGE_VERSION ${ECM_VERSION})
set(CPACK_SYSTEM_NAME "generic")
set(CPACK_GENERATOR "TGZ")
set(CPACK_SET_DESTDIR FALSE)

include(CPack)
