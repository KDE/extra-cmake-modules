#
# Find an installation of Soprano
#
# Sets the following variables:
#  Soprano_FOUND            - true is Soprano has been found
#  SOPRANO_INCLUDE_DIR      - The include directory
#  SOPRANO_LIBRARIES        - The Soprano core library to link to (libsoprano)
#  SOPRANO_INDEX_LIBRARIES  - The Soprano index library (libsopranoindex)
#  SOPRANO_CLIENT_LIBRARIES - The Soprano client library (libsopranoclient)
#  SOPRANO_SERVER_LIBRARIES - The Soprano server library (libsopranoserver)
#  SOPRANO_VERSION          - The Soprano version (string value)
#
# Options:
#  Set SOPRANO_MIN_VERSION to set the minimum required Soprano version (default: 1.99)
#

#if(SOPRANO_INCLUDE_DIR AND SOPRANO_LIBRARIES AND SOPRANO_INDEX_LIBRARIES AND SOPRANO_SERVER_LIBRARIES)

  # read from cache
#  set(Soprano_FOUND TRUE)
#  set(SopranoServer_FOUND TRUE)
#  set(SopranoClient_FOUND TRUE)
#  set(SopranoIndex_FOUND TRUE)

#else(SOPRANO_INCLUDE_DIR AND SOPRANO_LIBRARIES AND SOPRANO_INDEX_LIBRARIES AND SOPRANO_SERVER_LIBRARIES)
  INCLUDE(FindLibraryWithDebug)

  FIND_PATH(SOPRANO_INCLUDE_DIR 
    NAMES
    soprano/soprano.h
    PATHS
    ${KDE4_INCLUDE_DIR}
    ${INCLUDE_INSTALL_DIR}
    )

  FIND_LIBRARY_WITH_DEBUG(SOPRANO_INDEX_LIBRARIES 
    WIN32_DEBUG_POSTFIX d
    NAMES
    sopranoindex
    PATHS
    ${KDE4_LIB_DIR}
    ${LIB_INSTALL_DIR}
    )

  FIND_LIBRARY_WITH_DEBUG(SOPRANO_CLIENT_LIBRARIES 
    WIN32_DEBUG_POSTFIX d
    NAMES
    sopranoclient
    PATHS
    ${KDE4_LIB_DIR}
    ${LIB_INSTALL_DIR}
    )

  FIND_LIBRARY_WITH_DEBUG(SOPRANO_LIBRARIES
    WIN32_DEBUG_POSTFIX d
    NAMES soprano
    PATHS
    ${KDE4_LIB_DIR}
    ${LIB_INSTALL_DIR}
  )

  FIND_LIBRARY_WITH_DEBUG(SOPRANO_SERVER_LIBRARIES 
    WIN32_DEBUG_POSTFIX d
    NAMES
    sopranoserver
    PATHS
    ${KDE4_LIB_DIR}
    ${LIB_INSTALL_DIR}
    )

  # check for all the libs as required to make sure that we do not try to compile with an old version

  if(SOPRANO_INCLUDE_DIR AND SOPRANO_LIBRARIES)
    set(Soprano_FOUND TRUE)
  endif(SOPRANO_INCLUDE_DIR AND SOPRANO_LIBRARIES)

  if(Soprano_FOUND AND SOPRANO_INDEX_LIBRARIES)
    set(SopranoIndex_FOUND TRUE)
  endif(Soprano_FOUND AND SOPRANO_INDEX_LIBRARIES)

  if(Soprano_FOUND AND SOPRANO_CLIENT_LIBRARIES)
    set(SopranoClient_FOUND TRUE)
  endif(Soprano_FOUND AND SOPRANO_CLIENT_LIBRARIES)

  if(Soprano_FOUND AND SOPRANO_SERVER_LIBRARIES)
    set(SopranoServer_FOUND TRUE)
  endif(Soprano_FOUND AND SOPRANO_SERVER_LIBRARIES)
  
  # check Soprano version

  # We set a default for the minimum required version to be backwards compatible
  IF(NOT SOPRANO_MIN_VERSION)
    SET(SOPRANO_MIN_VERSION "1.99")
  ENDIF(NOT SOPRANO_MIN_VERSION)

  if(Soprano_FOUND)
    FILE(READ ${SOPRANO_INCLUDE_DIR}/soprano/version.h SOPRANO_VERSION_CONTENT)
    STRING(REGEX MATCH "SOPRANO_VERSION_STRING \".*\"\n" SOPRANO_VERSION_MATCH ${SOPRANO_VERSION_CONTENT})
    IF (SOPRANO_VERSION_MATCH)
      STRING(REGEX REPLACE "SOPRANO_VERSION_STRING \"(.*)\"\n" "\\1" SOPRANO_VERSION ${SOPRANO_VERSION_MATCH})
      if(SOPRANO_VERSION STRLESS "${SOPRANO_MIN_VERSION}")
        set(Soprano_FOUND FALSE)
        if(Soprano_FIND_REQUIRED)
          message(FATAL_ERROR "Soprano version ${SOPRANO_VERSION} is too old. Please install ${SOPRANO_MIN_VERSION} or newer")
        else(Soprano_FIND_REQUIRED)
          message(STATUS "Soprano version ${SOPRANO_VERSION} is too old. Please install ${SOPRANO_MIN_VERSION} or newer")
        endif(Soprano_FIND_REQUIRED)
      endif(SOPRANO_VERSION STRLESS "${SOPRANO_MIN_VERSION}")
    ENDIF (SOPRANO_VERSION_MATCH)
  endif(Soprano_FOUND)
  
  if(Soprano_FOUND)
    if(NOT Soprano_FIND_QUIETLY)
      message(STATUS "Found Soprano: ${SOPRANO_LIBRARIES}")
      message(STATUS "Found Soprano includes: ${SOPRANO_INCLUDE_DIR}")
      message(STATUS "Found Soprano Index: ${SOPRANO_INDEX_LIBRARIES}")
      message(STATUS "Found Soprano Client: ${SOPRANO_CLIENT_LIBRARIES}")
    endif(NOT Soprano_FIND_QUIETLY)
  else(Soprano_FOUND)
    if(Soprano_FIND_REQUIRED)
      if(NOT SOPRANO_INCLUDE_DIR)
	message(FATAL_ERROR "Could not find Soprano includes.")
      endif(NOT SOPRANO_INCLUDE_DIR)
      if(NOT SOPRANO_LIBRARIES)
	message(FATAL_ERROR "Could not find Soprano library.")
      endif(NOT SOPRANO_LIBRARIES)
    else(Soprano_FIND_REQUIRED)
      if(NOT SOPRANO_INCLUDE_DIR)
        message(STATUS "Could not find Soprano includes.")
      endif(NOT SOPRANO_INCLUDE_DIR)
      if(NOT SOPRANO_LIBRARIES)
        message(STATUS "Could not find Soprano library.")
      endif(NOT SOPRANO_LIBRARIES)
    endif(Soprano_FIND_REQUIRED)
  endif(Soprano_FOUND)

mark_as_advanced(SOPRANO_CLIENT_LIBRARIES SOPRANO_INDEX_LIBRARIES SOPRANO_LIBRARIES SOPRANO_SERVER_LIBRARIES SOPRANO_INCLUDE_DIR )

#endif(SOPRANO_INCLUDE_DIR AND SOPRANO_LIBRARIES AND SOPRANO_INDEX_LIBRARIES AND SOPRANO_SERVER_LIBRARIES)
