# - pkg-config module for CMake
# Defines the following macros:
#   PKGCONFIG(package includedir libdir linkflags cflags)
#     - Calling PKGCONFIG will fill the desired information into the 4 given arguments,
#       e.g. PKGCONFIG(libart-2.0 LIBART_INCLUDE_DIR LIBART_LINK_DIR LIBART_LINK_FLAGS LIBART_CFLAGS)
#      if pkg-config was NOT found or the specified software package doesn't exist, the
#      variable will be empty when the function returns, otherwise they will contain the respective information

FIND_PROGRAM(PKGCONFIG_EXECUTABLE NAMES pkg-config PATHS /usr/local/bin )

MACRO(PKGCONFIG _package _include_DIR _link_DIR _link_FLAGS _cflags)
# reset the variables at the beginning
  set(${_include_DIR})
  set(${_link_DIR})
  set(${_link_FLAGS})
  set(${_cflags})

# if pkg-config has been found
  if(PKGCONFIG_EXECUTABLE)

    EXEC_PROGRAM(${PKGCONFIG_EXECUTABLE} ARGS ${_package} --exists RETURN_VALUE _return_VALUE OUTPUT_VARIABLE _pkgconfigDevNull )

# and if the package of interest also exists for pkg-config, then get the information
    if(NOT _return_VALUE)

      EXEC_PROGRAM(${PKGCONFIG_EXECUTABLE} ARGS ${_package} --variable=includedir OUTPUT_VARIABLE ${_include_DIR} )

      EXEC_PROGRAM(${PKGCONFIG_EXECUTABLE} ARGS ${_package} --variable=libdir OUTPUT_VARIABLE ${_link_DIR} )

      EXEC_PROGRAM(${PKGCONFIG_EXECUTABLE} ARGS ${_package} --libs OUTPUT_VARIABLE ${_link_FLAGS} )

      EXEC_PROGRAM(${PKGCONFIG_EXECUTABLE} ARGS ${_package} --cflags OUTPUT_VARIABLE ${_cflags} )

    endif(NOT _return_VALUE)

  endif(PKGCONFIG_EXECUTABLE)

ENDMACRO(PKGCONFIG _include_DIR _link_DIR _link_FLAGS _cflags)

MARK_AS_ADVANCED(PKGCONFIG_EXECUTABLE)
