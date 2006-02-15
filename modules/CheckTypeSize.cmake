# - Check sizeof a type
#  CHECK_TYPE_SIZE(TYPE VARIABLE)
# Check if the type exists and determine size of type.  if the type
# exists, the size will be stored to the variable.
#
#  VARIABLE - variable to store size if the type exists.
#  HAVE_${VARIABLE} - does the variable exists or NOT

MACRO(CHECK_TYPE_SIZE TYPE VARIABLE)
  set(CMAKE_ALLOW_UNKNOWN_VARIABLE_READ_ACCESS 1)
  if("HAVE_${VARIABLE}" MATCHES "^HAVE_${VARIABLE}$")
    set(CHECK_TYPE_SIZE_TYPE "${TYPE}")
    set(MACRO_CHECK_TYPE_SIZE_FLAGS 
      "${CMAKE_REQUIRED_FLAGS}")
    foreach(def HAVE_SYS_TYPES_H HAVE_STDINT_H HAVE_STDDEF_H)
      if("${def}")
        set(MACRO_CHECK_TYPE_SIZE_FLAGS 
          "${MACRO_CHECK_TYPE_SIZE_FLAGS} -D${def}")
      endif("${def}")
    endforeach(def)
    set(CHECK_TYPE_SIZE_PREINCLUDE)
    set(CHECK_TYPE_SIZE_PREMAIN)
    foreach(def ${CMAKE_EXTRA_INCLUDE_FILES})
      set(CHECK_TYPE_SIZE_PREMAIN "${CHECK_TYPE_SIZE_PREMAIN}#include \"${def}\"\n")
    endforeach(def)
    CONFIGURE_FILE("${CMAKE_ROOT}/Modules/CheckTypeSize.c.in"
      "${CMAKE_BINARY_DIR}/CMakeFiles/CMakeTmp/CheckTypeSize.c" IMMEDIATE @ONLY)
    FILE(READ "${CMAKE_BINARY_DIR}/CMakeFiles/CMakeTmp/CheckTypeSize.c"
      CHECK_TYPE_SIZE_FILE_CONTENT)
    message(STATUS "Check size of ${TYPE}")
    if(CMAKE_REQUIRED_LIBRARIES)
      set(CHECK_TYPE_SIZE_ADD_LIBRARIES 
        "-DLINK_LIBRARIES:STRING=${CMAKE_REQUIRED_LIBRARIES}")
    endif(CMAKE_REQUIRED_LIBRARIES)
    
    if(CMAKE_REQUIRED_INCLUDES)
      set(CHECK_TYPE_SIZE_ADD_INCLUDES
        "-DINCLUDE_DIRECTORIES:STRING=${CMAKE_REQUIRED_INCLUDES}") 
    endif(CMAKE_REQUIRED_INCLUDES)
    
    TRY_RUN(${VARIABLE} HAVE_${VARIABLE}
      ${CMAKE_BINARY_DIR}
      "${CMAKE_BINARY_DIR}/CMakeFiles/CMakeTmp/CheckTypeSize.c"
      CMAKE_FLAGS -DCOMPILE_DEFINITIONS:STRING=${MACRO_CHECK_TYPE_SIZE_FLAGS}
      "${CHECK_TYPE_SIZE_ADD_INCLUDES}"
      "${CHECK_TYPE_SIZE_ADD_LIBRARIES}"
      OUTPUT_VARIABLE OUTPUT)
    if(HAVE_${VARIABLE})
      message(STATUS "Check size of ${TYPE} - done")
      FILE(APPEND ${CMAKE_BINARY_DIR}/CMakeFiles/CMakeOutput.log 
        "Determining size of ${TYPE} passed with the following output:\n${OUTPUT}\n\n")
    else(HAVE_${VARIABLE})
      message(STATUS "Check size of ${TYPE} - failed")
      FILE(APPEND ${CMAKE_BINARY_DIR}/CMakeFiles/CMakeError.log 
        "Determining size of ${TYPE} failed with the following output:\n${OUTPUT}\nCheckTypeSize.c:\n${CHECK_TYPE_SIZE_FILE_CONTENT}\n\n")
    endif(HAVE_${VARIABLE})
  endif("HAVE_${VARIABLE}" MATCHES "^HAVE_${VARIABLE}$")
  set(CMAKE_ALLOW_UNKNOWN_VARIABLE_READ_ACCESS )
ENDMACRO(CHECK_TYPE_SIZE)
