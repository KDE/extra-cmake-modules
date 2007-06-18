# - Try to find the Kipi library
# Once done this will define
#
#  KIPI_FOUND - system has libkipi
#  KIPI_INCLUDE_DIR - the libkipi include directory
#  KIPI_LIBRARIES - Link these to use libkipi
#  KIPI_DEFINITIONS - Compiler switches required for using libkipi
#

if (KIPI_INCLUDE_DIR AND KIPI_LIBRARIES)

  message(STATUS "Found Kipi library in cache: ${KIPI_LIBRARIES}")

  # in cache already
  SET(KIPI_FOUND TRUE)

else (KIPI_INCLUDE_DIR AND KIPI_LIBRARIES)

  message(STATUS "Check Kipi library in local sub-folder...")

  # Check if library is not in local sub-folder
  
  FIND_FILE(KIPI_LOCAL_FOUND libkipi/version.h ${CMAKE_SOURCE_DIR}/libkipi NO_DEFAULT_PATH)

  if (KIPI_LOCAL_FOUND)

    set(KIPI_INCLUDE_DIR ${CMAKE_SOURCE_DIR}/libkipi)
    set(KIPI_DEFINITIONS -I${KIPI_INCLUDE_DIR})
    set(KIPI_LIBRARIES ${CMAKE_BINARY_DIR}/lib/libkipi.so)
    message(STATUS "Found Kipi library in local sub-folder: ${KIPI_LIBRARIES}")
    set(KIPI_FOUND TRUE)
    MARK_AS_ADVANCED(KIPI_INCLUDE_DIR KIPI_LIBRARIES)

  else(KIPI_LOCAL_FOUND)

    message(STATUS "Check Kipi library using pkg-config...")

    # use pkg-config to get the directories and then use these values
    # in the FIND_PATH() and FIND_LIBRARY() calls
    INCLUDE(UsePkgConfig)
    
    PKGCONFIG(libkipi _KIPIIncDir _KIPILinkDir _KIPILinkFlags _KIPICflags)
    
    if(_KIPILinkFlags)
        # query pkg-config asking for a libkipi >= 0.2.0
        EXEC_PROGRAM(${PKGCONFIG_EXECUTABLE} ARGS --atleast-version=0.2.0 libkipi RETURN_VALUE _return_VALUE OUTPUT_VARIABLE _pkgconfigDevNull )
        if(_return_VALUE STREQUAL "0")
            message(STATUS "Found libkipi release >= 0.2.0")
            set(KIPI_VERSION_GOOD_FOUND TRUE)
        else(_return_VALUE STREQUAL "0")
            message(FATAL_ERROR "Found libkipi release < 0.2.0")
        endif(_return_VALUE STREQUAL "0")
    else(_KIPILinkFlags)
        set(KIPI_VERSION_GOOD_FOUND FALSE)
        set(KIPI_FOUND FALSE)
        message(FATAL_ERROR "Could NOT find libkipi library!")
    endif(_KIPILinkFlags)
    
    if(KIPI_VERSION_GOOD_FOUND)
        set(KIPI_DEFINITIONS ${_KIPICflags})
    
        FIND_PATH(KIPI_INCLUDE_DIR libkipi/version.h
        ${_KIPIIncDir}
        /usr/include
        /usr/local/include
        )
    
        FIND_LIBRARY(KIPI_LIBRARIES NAMES kipi
        PATHS
        ${_KIPILinkDir}
        /usr/lib
        /usr/local/lib
        )
    
        if (KIPI_INCLUDE_DIR AND KIPI_LIBRARIES)
            set(KIPI_FOUND TRUE)
        endif (KIPI_INCLUDE_DIR AND KIPI_LIBRARIES)
    
        if (KIPI_FOUND)
            if (NOT Kipi_FIND_QUIETLY)
                message(STATUS "Found libkipi: ${KIPI_LIBRARIES}")
            endif (NOT Kipi_FIND_QUIETLY)
        else (KIPI_FOUND)
            if (Kipi_FIND_REQUIRED)
                if (NOT KIPI_INCLUDE_DIR)
                    message(FATAL_ERROR "Could NOT find libkipi header files")
                endif (NOT KIPI_INCLUDE_DIR)
                if (NOT KIPI_LIBRARIES)
                    message(FATAL_ERROR "Could NOT find libkipi library")
                endif (NOT KIPI_LIBRARIES)
            endif (Kipi_FIND_REQUIRED)
        endif (KIPI_FOUND)
    endif(KIPI_VERSION_GOOD_FOUND)
    
    MARK_AS_ADVANCED(KIPI_INCLUDE_DIR KIPI_LIBRARIES)

  endif(KIPI_LOCAL_FOUND)
  
endif (KIPI_INCLUDE_DIR AND KIPI_LIBRARIES)
