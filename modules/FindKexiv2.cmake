# - Try to find the Kexiv2 library using cmake pkg_check_modulesi otherwise fallback to standard search
# Once done this will define:
#
#  KEXIV2_FOUND - system has libkexiv2
#  KEXIV2_INCLUDEDIR - the libkexiv2 include directory
#  KEXIV2_LIBRARIES - Link these to use libkexiv2
#  KEXIV2_DEFINITIONS - Compiler switches required for using libkexiv2


if (KEXIV2_INCLUDEDIR AND KEXIV2_LIBRARIES)
    # in cache already
    SET(KEXIV2_FOUND TRUE)
else (KEXIV2_INCLUDEDIR AND KEXIV2_LIBRARIES)
    if(NOT WIN32)
        find_package(PkgConfig)
        if(PKG_CONFIG_EXECUTABLE)
            pkg_check_modules(KEXIV2 libkexiv2>=0.2.0)
        endif(PKG_CONFIG_EXECUTABLE)
    endif(NOT WIN32)

    if(NOT KEXIV2_FOUND)
        find_path(KEXIV2_INCLUDEDIR libkexiv2/version.h)
        find_library(KEXIV2_LIBRARIES NAMES kexiv2)
        if (KEXIV2_INCLUDEDIR AND KEXIV2_LIBRARIES)
            set(KEXIV2_FOUND TRUE)
        endif (KEXIV2_INCLUDEDIR AND KEXIV2_LIBRARIES)
    endif(NOT KEXIV2_FOUND)
    
    if(KEXIV2_FOUND)
        set(KEXIV2_DEFINITIONS ${KEXIV2_CFLAGS})
        if (NOT Kexiv2_FIND_QUIETLY)
            message(STATUS "Found libkexiv2: ${KEXIV2_LIBRARIES}")
        endif (NOT Kexiv2_FIND_QUIETLY)
        set(KEXIV2_INCLUDE_DIR ${KEXIV2_INCLUDEDIR})
        mark_as_advanced( KEXIV2_INCLUDE_DIR )
    else(KEXIV2_FOUND)
        if (Kexiv2_FIND_REQUIRED)
            message(FATAL_ERROR "Not found required libkexiv2")
        endif (Kexiv2_FIND_REQUIRED)
    endif (KEXIV2_FOUND)
endif (KEXIV2_INCLUDEDIR AND KEXIV2_LIBRARIES)
