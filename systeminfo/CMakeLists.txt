message(STATUS "-----------------------------------")
message(STATUS "Printing system information: ")
message(STATUS "-----------------------------------")
message(STATUS "C compiler: ${CMAKE_C_COMPILER}")
message(STATUS "CXX compiler: ${CMAKE_CXX_COMPILER}")
message(STATUS "C compiler is gcc: ${CMAKE_COMPILER_IS_GNUCC}")
message(STATUS "CXX compiler is g++: ${CMAKE_COMPILER_IS_GNUCXX}")
message(STATUS "System: ${CMAKE_SYSTEM}")
message(STATUS "System name: ${CMAKE_SYSTEM_NAME}")
message(STATUS "System version: ${CMAKE_SYSTEM_VERSION}")

if(UNIX)
   message(STATUS "This is some kind of UNIX environment")
endif(UNIX)

if(WIN32)
   message(STATUS "This is Windows")
endif(WIN32)

if(APPLE)
   message(STATUS "This is an Apple")
endif(APPLE)

if(MINGW)
   message(STATUS "This is MinGW")
endif(MINGW)

if(CYGWIN)
   message(STATUS "This is Cygwin")
endif(CYGWIN)


message(STATUS "-----------------------------------")

