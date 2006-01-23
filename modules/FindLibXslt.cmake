# - Try to find LibXslt
# Once done this will define
#
#  LIBXSLT_FOUND - system has LibXslt
#  LIBXSLT_INCLUDE_DIR - the LibXslt include directory
#  LIBXSLT_LIBRARY - Link these to use OpenGL and GLU
#  LIBXSLT_DEFINITIONS - Compiler switches required for using LibXslt
#


# use pkg-config to get the directories and then use these values
# in the FIND_PATH() and FIND_LIBRARY() calls
INCLUDE(UsePkgConfig)

PKGCONFIG(libxslt _LibXsltIncDir _LibXsltLinkDir _LibXsltLinkFlags _LibXsltCflags)

SET(LIBXSLT_DEFINITIONS ${_LibXsltCflags})

FIND_PATH(LIBXSLT_INCLUDE_DIR libxslt/xslt.h
  ${_LibXsltIncDir}
  /usr/include
  /usr/local/include
)

FIND_LIBRARY(LIBXSLT_LIBRARY NAMES xslt
  PATHS
  ${_LibXsltLinkDir}
  /usr/lib
  /usr/local/lib
)

IF(LIBXSLT_INCLUDE_DIR AND LIBXSLT_LIBRARY)
   SET(LIBXSLT_FOUND TRUE)
ENDIF(LIBXSLT_INCLUDE_DIR AND LIBXSLT_LIBRARY)

IF(LIBXSLT_FOUND)
  IF(NOT LibXslt_FIND_QUIETLY)
    MESSAGE(STATUS "Found LibXslt: ${LIBXSLT_LIBRARY}")
  ENDIF(NOT LibXslt_FIND_QUIETLY)
ELSE(LIBXSLT_FOUND)
  IF(LibXslt_FIND_REQUIRED)
    MESSAGE(SEND_ERROR "Could not find LibXslt")
  ENDIF(LibXslt_FIND_REQUIRED)
ENDIF(LIBXSLT_FOUND)

