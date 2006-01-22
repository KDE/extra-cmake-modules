SET(CMAKE_INSTALL_PREFIX ${CMAKE_ROOT} )

FILE(GLOB cmakeFiles "${CMAKE_CURRENT_SOURCE_DIR}/*.cmake")

INSTALL_FILES(/Modules FILES 
kde3init_dummy.cpp.in 
kde4init_dummy.cpp.in
${cmakeFiles}
)

