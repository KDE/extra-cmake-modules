# - Try to find LibXml2
# Once done this will define
#
#  LIBXML2_FOUND - system has LibXml2
#  LIBXML2_INCLUDE_DIR - the LibXml2 include directory
#  LIBXML2_LIBRARY - Link these to use OpenGL and GLU
#  LIBXML2_DEFINITIONS - Compiler switches required for using LibXml2
#
# use pkg-config to get the directories and then use these values
# in the FIND_PATH() and FIND_LIBRARY() calls


INCLUDE(UsePkgConfig)

PKGCONFIG(libxml-2.0 _LibXml2IncDir _LibXml2LinkDir _LibXml2LinkFlags _LibXml2Cflags)

SET(LIBXML2_DEFINITIONS ${_LibXml2Cflags})

FIND_PATH(LIBXML2_ROOT_INCLUDE_DIR libxml2/libxml/xpath.h
  ${_LibXml2IncDir}
  /usr/include
  /usr/local/include
)

SET(LIBXML2_INCLUDE_DIR ${LIBXML2_ROOT_INCLUDE_DIR}/libxml2 CACHE PATH "LibXml2 include directory")

MARK_AS_ADVANCED(LIBXML2_ROOT_INCLUDE_DIR)

FIND_LIBRARY(LIBXML2_LIBRARY NAMES xml2 libxml2
  PATHS
  ${_LibXml2LinkDir}
  /usr/lib
  /usr/local/lib
)

IF(LIBXML2_INCLUDE_DIR AND LIBXML2_LIBRARY)
   SET(LIBXML2_FOUND TRUE)
ENDIF(LIBXML2_INCLUDE_DIR AND LIBXML2_LIBRARY)

IF(LIBXML2_FOUND)
  IF(NOT LibXml2_FIND_QUIETLY)
    MESSAGE(STATUS "Found LibXml2: ${LIBXML2_LIBRARY}")
  ENDIF(NOT LibXml2_FIND_QUIETLY)
ELSE(LIBXML2_FOUND)
  IF(LibXml2_FIND_REQUIRED)
    MESSAGE(SEND_ERROR "Could not find LibXml2")
  ENDIF(LibXml2_FIND_REQUIRED)
ENDIF(LIBXML2_FOUND)

