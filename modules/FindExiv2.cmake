# - Try to find the Exiv2 library
#
#  EXIV2_MIN_VERSION - You can set this variable to the minimum version you need 
#                      before doing FIND_PACKAGE(Exiv2). The default is 0.12.
#
# All definitions come with new cmake macro PKG_CHECK_MODULES

if (EXIV2_INCLUDEDIR AND EXIV2_LIBRARIES)

  # in cache already
  set(EXIV2_FOUND TRUE)

else (EXIV2_INCLUDEDIR AND EXIV2_LIBRARIES)
    if (NOT WIN32)
        find_package(PkgConfig REQUIRED)
        
        if(NOT EXIV2_MIN_VERSION)
            set(EXIV2_MIN_VERSION "0.12")
        endif(NOT EXIV2_MIN_VERSION)

        if (Exiv2_FIND_REQUIRED)
            PKG_CHECK_MODULES(EXIV2 REQUIRED exiv2>=${EXIV2_MIN_VERSION})
        else (Exiv2_FIND_REQUIRED)
            PKG_CHECK_MODULES(EXIV2 exiv2>=${EXIV2_MIN_VERSION})
        endif (Exiv2_FIND_REQUIRED)

        if(EXIV2_FOUND)
            message(STATUS "Found Exiv2 release ${EXIV2_VERSION}")
        else(EXIV2_FOUND)
            message(STATUS "Cannot find Exiv2 library!")
        endif(EXIV2_FOUND)
    else(NOT WIN32)
        #Better check
        set(EXIV2_FOUND TRUE)
    endif (NOT WIN32)

    if(EXIV2_FOUND)
        set(EXIV2_DEFINITIONS ${EXIV2_CFLAGS})
        if (NOT Exiv2_FIND_QUIETLY)
            message(STATUS "Found Exiv2: ${EXIV2_LIBRARIES}")
        endif (NOT Exiv2_FIND_QUIETLY)
   endif (EXIV2_FOUND)

endif (EXIV2_INCLUDEDIR AND EXIV2_LIBRARIES)

