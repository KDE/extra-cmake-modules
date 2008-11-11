# - Try to find the Kipi library using cmake pkg_check_modulesi otherwise fallback to standard search
# Once done this will define:
#
#  KIPI_FOUND - system has libkipi
#  KIPI_INCLUDEDIR - the libkipi include directory
#  KIPI_LIBRARIES - Link these to use libkipi
#  KIPI_DEFINITIONS - Compiler switches required for using libkipi


if (KIPI_INCLUDEDIR AND KIPI_LIBRARIES)
    # in cache already
    SET(KIPI_FOUND TRUE)
else (KIPI_INCLUDEDIR AND KIPI_LIBRARIES)
    if(NOT WIN32)
        find_package(PkgConfig)
        if(PKG_CONFIG_EXECUTABLE)
            pkg_check_modules(KIPI libkipi>=0.2.0)
        endif(PKG_CONFIG_EXECUTABLE)
    endif(NOT WIN32)

    if(NOT KIPI_FOUND)
        find_path(KIPI_INCLUDEDIR libkipi/version.h)
        find_library(KIPI_LIBRARIES NAMES kipi)
        if (KIPI_INCLUDEDIR AND KIPI_LIBRARIES)
            set(KIPI_FOUND TRUE)
        endif (KIPI_INCLUDEDIR AND KIPI_LIBRARIES)
    endif(NOT KIPI_FOUND)
    
    if(KIPI_FOUND)
        set(KIPI_DEFINITIONS ${KIPI_CFLAGS})
        if (NOT Kipi_FIND_QUIETLY)
            message(STATUS "Found libkipi: ${KIPI_LIBRARIES}")
        endif (NOT Kipi_FIND_QUIETLY)
        set(KIPI_INCLUDE_DIR ${KIPI_INCLUDEDIR})
        mark_as_advanced( KIPI_INCLUDE_DIR )
    else(KIPI_FOUND)
        if (Kipi_FIND_REQUIRED)
            message(FATAL_ERROR "Not found required libkipi")
        endif (Kipi_FIND_REQUIRED)
    endif (KIPI_FOUND)
endif (KIPI_INCLUDEDIR AND KIPI_LIBRARIES)
