# Install script for directory: /home/alex/src/kde4-svn/kdesdk/cmake/kde3

# Set the install prefix
IF(NOT CMAKE_INSTALL_PREFIX)
  SET(CMAKE_INSTALL_PREFIX "/usr/local/share/CMake")
ENDIF(NOT CMAKE_INSTALL_PREFIX)

MESSAGE(STATUS "Installing ${CMAKE_INSTALL_PREFIX}/Modules/FindKDE3.cmake")
FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/Modules" TYPE FILE FILES "/home/alex/src/kde4-svn/kdesdk/cmake/kde3/FindKDE3.cmake")
MESSAGE(STATUS "Installing ${CMAKE_INSTALL_PREFIX}/Modules/KDE3Macros.cmake")
FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/Modules" TYPE FILE FILES "/home/alex/src/kde4-svn/kdesdk/cmake/kde3/KDE3Macros.cmake")
MESSAGE(STATUS "Installing ${CMAKE_INSTALL_PREFIX}/Modules/kde3init_dummy.cpp.in")
FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/Modules" TYPE FILE FILES "/home/alex/src/kde4-svn/kdesdk/cmake/kde3/kde3init_dummy.cpp.in")
MESSAGE(STATUS "Installing ${CMAKE_INSTALL_PREFIX}/Modules/kde3uic.cmake")
FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/Modules" TYPE FILE FILES "/home/alex/src/kde4-svn/kdesdk/cmake/kde3/kde3uic.cmake")
FILE(WRITE "/home/alex/src/kde4-svn/kdesdk/cmake/kde3/install_manifest.txt" "")
FOREACH(file ${CMAKE_INSTALL_MANIFEST_FILES})
  FILE(APPEND "/home/alex/src/kde4-svn/kdesdk/cmake/kde3/install_manifest.txt" "${file}\n")
ENDFOREACH(file)
