cmake_minimum_required(VERSION 2.8.0 FATAL_ERROR ) # this will be upgraded to 2.8.6

project(extra-cmake-modules)

set(ECM_MAJOR_VERSION 0 )
set(ECM_MINOR_VERSION 0 )
set(ECM_PATCH_VERSION 1 )

set(ECM_VERSION ${ECM_MAJOR_VERSION}.${ECM_MINOR_VERSION}.${ECM_PATCH_VERSION} )

# need to add a target to create the documentation via cmake --help...

file(GLOB installFiles ${CMAKE_SOURCE_DIR}/modules/*cmake )

install(FILES ${installFiles} DESTINATION share/extra-cmake-modules-${ECM_VERSION}/modules/ )

# need to install a Config.cmake file

# need to add cpack setup stuff for creating a package
