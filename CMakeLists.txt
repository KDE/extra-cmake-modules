cmake_minimum_required(VERSION 2.8.10.1 FATAL_ERROR)

project(extra-cmake-modules)

set(ECM_MAJOR_VERSION 0)
set(ECM_MINOR_VERSION 0)
set(ECM_PATCH_VERSION 8)

set(ECM_VERSION ${ECM_MAJOR_VERSION}.${ECM_MINOR_VERSION}.${ECM_PATCH_VERSION})

enable_testing()
add_subdirectory(tests)

set(SHARE_INSTALL_DIR share/ECM-${ECM_VERSION})
set(MODULES_INSTALL_DIR ${SHARE_INSTALL_DIR}/modules/)
set(KDE_MODULES_INSTALL_DIR ${SHARE_INSTALL_DIR}/kde-modules/)
set(FIND_MODULES_INSTALL_DIR ${SHARE_INSTALL_DIR}/find-modules/)
set(CMAKECONFIG_INSTALL_DIR ${SHARE_INSTALL_DIR}/cmake/)
set(DOC_INSTALL_DIR ${SHARE_INSTALL_DIR}/doc/)

# create and install docs
add_custom_target(ManPage ALL
                    COMMAND ${CMAKE_COMMAND} -DCMAKE_MODULE_PATH=${CMAKE_SOURCE_DIR}/modules\;${CMAKE_SOURCE_DIR}/find-modules\;${CMAKE_SOURCE_DIR}/kde-modules --help-custom-modules "${CMAKE_BINARY_DIR}/extra-cmake-modules.7"
                    COMMAND ${CMAKE_COMMAND} -DCMAKE_MODULE_PATH=${CMAKE_SOURCE_DIR}/modules\;${CMAKE_SOURCE_DIR}/find-modules\;${CMAKE_SOURCE_DIR}/kde-modules --help-custom-modules "${CMAKE_BINARY_DIR}/extra-cmake-modules.html"
                    COMMAND ${CMAKE_COMMAND} -DCMAKE_MODULE_PATH=${CMAKE_SOURCE_DIR}/modules\;${CMAKE_SOURCE_DIR}/find-modules\;${CMAKE_SOURCE_DIR}/kde-modules --help-custom-modules "${CMAKE_BINARY_DIR}/extra-cmake-modules.txt"
                    VERBATIM
                 )

install(FILES "${CMAKE_BINARY_DIR}/extra-cmake-modules.7" DESTINATION man/man7/)

install(FILES "${CMAKE_BINARY_DIR}/extra-cmake-modules.txt" "${CMAKE_BINARY_DIR}/extra-cmake-modules.html"
        DESTINATION ${DOC_INSTALL_DIR})


file(GLOB installModuleFiles ${CMAKE_SOURCE_DIR}/modules/*[^~])
install(FILES ${installModuleFiles} DESTINATION ${MODULES_INSTALL_DIR})

file(GLOB installKdeModuleFiles ${CMAKE_SOURCE_DIR}/kde-modules/*[^~])
install(FILES ${installKdeModuleFiles} DESTINATION ${KDE_MODULES_INSTALL_DIR})

file(GLOB installFindModuleFiles ${CMAKE_SOURCE_DIR}/find-modules/*[^~])
install(FILES ${installFindModuleFiles} DESTINATION ${FIND_MODULES_INSTALL_DIR})


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
