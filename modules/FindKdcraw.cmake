# - Try to find the Kdcraw library using cmake pkg_check_modulesi otherwise fallback to standard search
# Once done this will define:
#
#  KDCRAW_FOUND - system has libkdcraw
#  KDCRAW_INCLUDEDIR - the libkdcraw include directory
#  KDCRAW_LIBRARIES - Link these to use libkdcraw
#  KDCRAW_DEFINITIONS - Compiler switches required for using libkdcraw


if (KDCRAW_INCLUDEDIR AND KDCRAW_LIBRARIES)
    # in cache already
    SET(KDCRAW_FOUND TRUE)
else (KDCRAW_INCLUDEDIR AND KDCRAW_LIBRARIES)
    if(NOT WIN32)
        find_package(PkgConfig)
        if(PKG_CONFIG_EXECUTABLE)
            pkg_check_modules(KDCRAW libkdcraw>=0.2.0)
        endif(PKG_CONFIG_EXECUTABLE)
    endif(NOT WIN32)

    if(NOT KDCRAW_FOUND)
        find_path(KDCRAW_INCLUDEDIR libkdcraw/version.h)
        find_library(KDCRAW_LIBRARIES NAMES kdcraw)
        if (KDCRAW_INCLUDEDIR AND KDCRAW_LIBRARIES)
            set(KDCRAW_FOUND TRUE)
        endif (KDCRAW_INCLUDEDIR AND KDCRAW_LIBRARIES)
    endif(NOT KDCRAW_FOUND)
    
    if(KDCRAW_FOUND)
        set(KDCRAW_DEFINITIONS ${KDCRAW_CFLAGS})
        if (NOT Kdcraw_FIND_QUIETLY)
            message(STATUS "Found libkdcraw: ${KDCRAW_LIBRARIES}")
        endif (NOT Kdcraw_FIND_QUIETLY)
        set(KDCRAW_INCLUDE_DIR ${KDCRAW_INCLUDEDIR})
        mark_as_advanced( KDCRAW_INCLUDE_DIR )
    else(KDCRAW_FOUND)
        if (Kdcraw_FIND_REQUIRED)
            message(FATAL_ERROR "Not found required libkdcraw")
        endif (Kdcraw_FIND_REQUIRED)
    endif (KDCRAW_FOUND)
endif (KDCRAW_INCLUDEDIR AND KDCRAW_LIBRARIES)
