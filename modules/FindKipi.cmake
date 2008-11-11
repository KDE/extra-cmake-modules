# - Try to find the Kipi library using cmake pkg_check_modules
# Once done this will define

if (KIPI_INCLUDEDIR AND KIPI_LIBRARIES)
    # in cache already
    SET(KIPI_FOUND TRUE)
else (KIPI_INCLUDEDIR AND KIPI_LIBRARIES)
    if(NOT WIN32)
        find_package(PkgConfig REQUIRED)
        if (Kipi_FIND_REQUIRED)
            pkg_check_modules(KIPI REQUIRED libkipi>=0.2.0)
        else (Kipi_FIND_REQUIRED)
            pkg_check_modules(KIPI libkipi>=0.2.0)
        endif (Kipi_FIND_REQUIRED)
    else(NOT WIN32)
        set(KIPI_FOUND TRUE)
    endif(NOT WIN32)
    if(KIPI_FOUND)
        set(KIPI_DEFINITIONS ${KIPI_CFLAGS})
        if (NOT Kipi_FIND_QUIETLY)
            message(STATUS "Found libkipi: ${KIPI_LIBRARIES}")
        endif (NOT Kipi_FIND_QUIETLY)
    endif (KIPI_FOUND)
endif (KIPI_INCLUDEDIR AND KIPI_LIBRARIES)
