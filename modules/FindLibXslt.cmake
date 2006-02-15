# - Try to find LibXslt
# Once done this will define
#
#  LIBXSLT_FOUND - system has LibXslt
#  LIBXSLT_INCLUDE_DIR - the LibXslt include directory
#  LIBXSLT_LIBRARIES - Link these to LibXslt
#  LIBXSLT_DEFINITIONS - Compiler switches required for using LibXslt
#


# use pkg-config to get the directories and then use these values
# in the FIND_PATH() and FIND_LIBRARY() calls
INCLUDE(UsePkgConfig)

PKGCONFIG(libxslt _LibXsltIncDir _LibXsltLinkDir _LibXsltLinkFlags _LibXsltCflags)

set(LIBXSLT_DEFINITIONS ${_LibXsltCflags})

FIND_PATH(LIBXSLT_INCLUDE_DIR libxslt/xslt.h
  ${_LibXsltIncDir}
  /usr/include
  /usr/local/include
)

FIND_LIBRARY(LIBXSLT_LIBRARIES NAMES xslt libxslt
  PATHS
  ${_LibXsltLinkDir}
  /usr/lib
  /usr/local/lib
)

if(LIBXSLT_INCLUDE_DIR AND LIBXSLT_LIBRARIES)
   set(LIBXSLT_FOUND TRUE)
endif(LIBXSLT_INCLUDE_DIR AND LIBXSLT_LIBRARIES)

if(LIBXSLT_FOUND)
  if(NOT LibXslt_FIND_QUIETLY)
    message(STATUS "Found LibXslt: ${LIBXSLT_LIBRARIES}")
  endif(NOT LibXslt_FIND_QUIETLY)
else(LIBXSLT_FOUND)
  if(LibXslt_FIND_REQUIRED)
    message(FATAL_ERROR "Could NOT find LibXslt")
  endif(LibXslt_FIND_REQUIRED)
endif(LIBXSLT_FOUND)

MARK_AS_ADVANCED(LIBXSLT_INCLUDE_DIR LIBXSLT_LIBRARIES)

