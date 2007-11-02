

if(SOPRANO_INCLUDE_DIR AND SOPRANO_LIBRARIES AND SOPRANO_INDEX_LIBRARIES AND SOPRANO_SERVER_LIBRARIES)

  # read from cache
  set(Soprano_FOUND TRUE)
  set(SopranoServer_FOUND TRUE)
  set(SopranoClient_FOUND TRUE)
  set(SopranoIndex_FOUND TRUE)

else(SOPRANO_INCLUDE_DIR AND SOPRANO_LIBRARIES AND SOPRANO_INDEX_LIBRARIES AND SOPRANO_SERVER_LIBRARIES)
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
  # FIXME: introduce a Soprano version check

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

endif(SOPRANO_INCLUDE_DIR AND SOPRANO_LIBRARIES AND SOPRANO_INDEX_LIBRARIES AND SOPRANO_SERVER_LIBRARIES)
