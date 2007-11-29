# - pkg-config module for CMake
#
# Defines the following macros:
#
# PKGCONFIG(package includedir libdir linkflags cflags)
#
# Calling PKGCONFIG will fill the desired information into the 4 given arguments,
# e.g. PKGCONFIG(libart-2.0 LIBART_INCLUDE_DIR LIBART_LINK_DIR LIBART_LINK_FLAGS LIBART_CFLAGS)
# if pkg-config was NOT found or the specified software package doesn't exist, the
# variable will be empty when the function returns, otherwise they will contain the respective information
#



FIND_PROGRAM(PKGCONFIG_EXECUTABLE NAMES pkg-config )

MACRO(PKGCONFIG _package _include_DIR _link_DIR _link_FLAGS _cflags)
# reset the variables at the beginning
  SET(${_include_DIR})
  SET(${_link_DIR})
  SET(${_link_FLAGS})
  SET(${_cflags})
  # if pkg-config has been found
  IF(PKGCONFIG_EXECUTABLE)

    EXEC_PROGRAM(${PKGCONFIG_EXECUTABLE} ARGS ${_package} --exists RETURN_VALUE _return_VALUE OUTPUT_VARIABLE _pkgconfigDevNull )

    # and if the package of interest also exists for pkg-config, then get the information
    IF(NOT _return_VALUE)

      EXEC_PROGRAM(${PKGCONFIG_EXECUTABLE} ARGS ${_package} --variable=includedir OUTPUT_VARIABLE ${_include_DIR} )

      EXEC_PROGRAM(${PKGCONFIG_EXECUTABLE} ARGS ${_package} --variable=libdir OUTPUT_VARIABLE ${_link_DIR} )

      EXEC_PROGRAM(${PKGCONFIG_EXECUTABLE} ARGS ${_package} --libs OUTPUT_VARIABLE ${_link_FLAGS} )

      EXEC_PROGRAM(${PKGCONFIG_EXECUTABLE} ARGS ${_package} --cflags OUTPUT_VARIABLE ${_cflags} )

    ELSE( NOT _return_VALUE)

      MESSAGE(STATUS "KDE CMake PKGCONFIG macro indicates that ${_package} is not installed on your computer.")
      MESSAGE(STATUS "Install the package which contains ${_package}.pc if you want to support this feature.")	    

    ENDIF(NOT _return_VALUE)

  ENDIF(PKGCONFIG_EXECUTABLE)

ENDMACRO(PKGCONFIG _include_DIR _link_DIR _link_FLAGS _cflags)

MACRO(PKGCONFIG_VERSION _package _include_DIR _link_DIR _link_FLAGS _cflags _found_version)
   #reset variable
   SET(${_found_version})
   IF(PKGCONFIG_EXECUTABLE)
      #call PKGCONFIG
      PKGCONFIG(${_package} ${_include_DIR} ${_link_DIR} ${_link_FLAGS} ${_cflags})
      IF(${_include_DIR})
         EXEC_PROGRAM(${PKGCONFIG_EXECUTABLE} ARGS ${_package} --modversion OUTPUT_VARIABLE ${_found_version})
         IF(NOT ${_found_version})
            MESSAGE(FATAL_ERROR "UsePkgConfig.cmake: No version found for ${_package}")
         ENDIF(NOT ${_found_version})
      ENDIF(${_include_DIR})
   ENDIF(PKGCONFIG_EXECUTABLE)
ENDMACRO(PKGCONFIG_VERSION _package _include_DIR _link_DIR _link_FLAGS _cflags _found_version)

MARK_AS_ADVANCED(PKGCONFIG_EXECUTABLE)
