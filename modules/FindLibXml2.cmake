# - Try to find LibXml2
# Once done this will define
#
#  LIBXML2_FOUND - system has LibXml2
#  LIBXML2_INCLUDE_DIR - the LibXml2 include directory
#  LIBXML2_LIBRARIES - the libraries needed to use LibXml2
#  LIBXML2_DEFINITIONS - Compiler switches required for using LibXml2

if (LIBXML2_INCLUDE_DIR AND LIBXML2_LIBRARIES)

    # in cache already
    SET(LIBXML2_FOUND TRUE)

else (LIBXML2_INCLUDE_DIR AND LIBXML2_LIBRARIES)

    IF (NOT WIN32)
        # use pkg-config to get the directories and then use these values
        # in the FIND_PATH() and FIND_LIBRARY() calls
        INCLUDE(UsePkgConfig)
        PKGCONFIG(libxml-2.0 _LibXml2IncDir _LibXml2LinkDir _LibXml2LinkFlags _LibXml2Cflags)
        set(LIBXML2_DEFINITIONS ${_LibXml2Cflags})
    ENDIF (NOT WIN32)

    FIND_PATH(LIBXML2_INCLUDE_DIR libxml/xpath.h
      PATHS
     ${_LibXml2IncDir}
      PATH_SUFFIXES libxml2
    )

    FIND_LIBRARY(LIBXML2_LIBRARIES NAMES xml2 libxml2
      PATHS
      ${_LibXml2LinkDir}
    )

    if (LIBXML2_INCLUDE_DIR AND LIBXML2_LIBRARIES)
       set(LIBXML2_FOUND TRUE)
    endif (LIBXML2_INCLUDE_DIR AND LIBXML2_LIBRARIES)

    if (LIBXML2_FOUND)
      if (NOT LibXml2_FIND_QUIETLY)
        message(STATUS "Found LibXml2: ${LIBXML2_LIBRARIES}")
      endif (NOT LibXml2_FIND_QUIETLY)
    else (LIBXML2_FOUND)
      if (LibXml2_FIND_REQUIRED)
        message(SEND_ERROR "Could NOT find LibXml2")
      endif (LibXml2_FIND_REQUIRED)
    endif (LIBXML2_FOUND)

    MARK_AS_ADVANCED(LIBXML2_INCLUDE_DIR LIBXML2_LIBRARIES)

endif (LIBXML2_INCLUDE_DIR AND LIBXML2_LIBRARIES)
