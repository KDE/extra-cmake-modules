# install the cmake files

file(GLOB cmakeFiles "${CMAKE_CURRENT_SOURCE_DIR}/*.cmake")

install_files(/share/apps/cmake/modules FILES  kde3init_dummy.cpp.in  kde4init_dummy.cpp.in ${cmakeFiles} )

# the files listed here will be removed by remove_obsoleted_cmake_files.cmake, Alex
set (FILES_TO_REMOVE
   ${CMAKE_INSTALL_PREFIX}/share/apps/cmake/modules/FindKDE4.cmake
   )

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/remove_files.cmake.in ${CMAKE_CURRENT_BINARY_DIR}/remove_files.cmake)

install(SCRIPT ${CMAKE_CURRENT_BINARY_DIR}/remove_files.cmake )

