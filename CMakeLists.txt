cmake_minimum_required(VERSION 2.8.4 FATAL_ERROR ) # this will be upgraded to 2.8.6

project(extra-cmake-modules)

set(ECM_MAJOR_VERSION 0 )
set(ECM_MINOR_VERSION 0 )
set(ECM_PATCH_VERSION 1 )

set(ECM_VERSION ${ECM_MAJOR_VERSION}.${ECM_MINOR_VERSION}.${ECM_PATCH_VERSION} )

# create and install docs
add_custom_target(ManPage ALL
                  COMMAND ${CMAKE_COMMAND} -DCMAKE_MODULE_PATH=${CMAKE_SOURCE_DIR}/modules --help-custom-modules "${CMAKE_BINARY_DIR}/extra-cmake-modules.1"
                  COMMAND ${CMAKE_COMMAND} -DCMAKE_MODULE_PATH=${CMAKE_SOURCE_DIR}/modules --help-custom-modules "${CMAKE_BINARY_DIR}/extra-cmake-modules.html"
                  COMMAND ${CMAKE_COMMAND} -DCMAKE_MODULE_PATH=${CMAKE_SOURCE_DIR}/modules --help-custom-modules "${CMAKE_BINARY_DIR}/extra-cmake-modules.txt"
                 )

install(FILES "${CMAKE_BINARY_DIR}/extra-cmake-modules.1" DESTINATION man/man1/ )

install(FILES "${CMAKE_BINARY_DIR}/extra-cmake-modules.txt" "${CMAKE_BINARY_DIR}/extra-cmake-modules.html"
        DESTINATION share/extra-cmake-modules-${ECM_VERSION}/doc/ )


file(GLOB installFiles ${CMAKE_SOURCE_DIR}/modules/*cmake )

install(FILES ${installFiles} DESTINATION share/extra-cmake-modules-${ECM_VERSION}/modules/ )

# need to install a Config.cmake file

# set up packaging
set(CPACK_PACKAGE_NAME extra-cmake-modules )
set(CPACK_PACKAGE_VERSION ${ECM_VERSION})
set(CPACK_SYSTEM_NAME "generic")
set(CPACK_GENERATOR "TGZ")
set(CPACK_SET_DESTDIR FALSE)

include(CPack)
