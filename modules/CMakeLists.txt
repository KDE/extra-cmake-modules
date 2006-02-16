# install the cmake files

file(GLOB cmakeFiles "${CMAKE_CURRENT_SOURCE_DIR}/*.cmake")

install_files(/share/apps/cmake/modules FILES  kde3init_dummy.cpp.in  kde4init_dummy.cpp.in ${cmakeFiles} )

