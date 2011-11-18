cmake_minimum_required(VERSION 2.8.4 FATAL_ERROR) # this will be upgraded to 2.8.6

project(extra-cmake-modules)

set(ECM_MAJOR_VERSION 0)
set(ECM_MINOR_VERSION 0)
set(ECM_PATCH_VERSION 1)

set(ECM_VERSION ${ECM_MAJOR_VERSION}.${ECM_MINOR_VERSION}.${ECM_PATCH_VERSION})

set(SHARE_INSTALL_DIR share/extra-cmake-modules-${ECM_VERSION})
set(MODULES_INSTALL_DIR ${SHARE_INSTALL_DIR}/modules/)
set(CMAKECONFIG_INSTALL_DIR ${SHARE_INSTALL_DIR}/cmake/)
set(DOC_INSTALL_DIR ${SHARE_INSTALL_DIR}/doc/)

# create and install docs
add_custom_target(
  ManPage ALL
  COMMAND ${CMAKE_COMMAND} -DCMAKE_MODULE_PATH=${CMAKE_SOURCE_DIR}/modules --help-custom-modules "${CMAKE_BINARY_DIR}/extra-cmake-modules.1"
  COMMAND ${CMAKE_COMMAND} -DCMAKE_MODULE_PATH=${CMAKE_SOURCE_DIR}/modules --help-custom-modules "${CMAKE_BINARY_DIR}/extra-cmake-modules.html"
  COMMAND ${CMAKE_COMMAND} -DCMAKE_MODULE_PATH=${CMAKE_SOURCE_DIR}/modules --help-custom-modules "${CMAKE_BINARY_DIR}/extra-cmake-modules.txt"
)

install(FILES "${CMAKE_BINARY_DIR}/extra-cmake-modules.1" DESTINATION man/man1/)

install(FILES "${CMAKE_BINARY_DIR}/extra-cmake-modules.txt" "${CMAKE_BINARY_DIR}/extra-cmake-modules.html"
        DESTINATION ${DOC_INSTALL_DIR})


file(GLOB installFiles ${CMAKE_SOURCE_DIR}/modules/*[^~])

install(FILES ${installFiles} DESTINATION ${MODULES_INSTALL_DIR})

# figure out the relative path from the installed Config.cmake file to the install prefix (which may be at
# runtime different from the chosen CMAKE_INSTALL_PREFIX if under Windows the package was installed anywhere)
# This relative path will be configured into the BarConfig.cmake
file(RELATIVE_PATH relInstallDir ${CMAKE_INSTALL_PREFIX}/${CMAKECONFIG_INSTALL_DIR} ${CMAKE_INSTALL_PREFIX})

configure_file(extra-cmake-modules-config.cmake.in ${CMAKE_CURRENT_BINARY_DIR}/extra-cmake-modules-config.cmake @ONLY)
configure_file(extra-cmake-modules-config-version.cmake.in ${CMAKE_CURRENT_BINARY_DIR}/extra-cmake-modules-config-version.cmake @ONLY)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/extra-cmake-modules-config.cmake
              ${CMAKE_CURRENT_BINARY_DIR}/extra-cmake-modules-config-version.cmake
        DESTINATION ${CMAKECONFIG_INSTALL_DIR})

# need to install a Config.cmake file

# set up packaging
set(CPACK_PACKAGE_NAME extra-cmake-modules)
set(CPACK_PACKAGE_VERSION ${ECM_VERSION})
set(CPACK_SYSTEM_NAME "generic")
set(CPACK_GENERATOR "TGZ")
set(CPACK_SET_DESTDIR FALSE)

include(CPack)
