macro(LOG line)
   message(STATUS ${line})
   file(APPEND ${CMAKE_CURRENT_BINARY_DIR}/SystemInfo.txt "${line}\n")
endmacro(LOG line)

file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/SystemInfo.txt "CMake system information: \n")
message(STATUS "-----------------------------------")
message(STATUS "Printing system information: ")
message(STATUS "-----------------------------------")

log("C compiler: ${CMAKE_C_COMPILER}")
log("CXX compiler: ${CMAKE_CXX_COMPILER}")
log("C compiler is gcc: ${CMAKE_COMPILER_IS_GNUCC}")
log("CXX compiler is g++: ${CMAKE_COMPILER_IS_GNUCXX}")
log("System: ${CMAKE_SYSTEM}")
log("System name: ${CMAKE_SYSTEM_NAME}")
log("System version: ${CMAKE_SYSTEM_VERSION}")

if(UNIX)
   log("This is some kind of UNIX environment")
endif(UNIX)

if(WIN32)
   log("This is Windows")
endif(WIN32)

if(APPLE)
   log("This is an Apple")
endif(APPLE)

if(MINGW)
   log("This is MinGW")
endif(MINGW)

if(CYGWIN)
   log("This is Cygwin")
endif(CYGWIN)

message(STATUS "-----------------------------------")

