

if(SOPRANO_INCLUDE_DIR AND SOPRANO_LIBRARIES AND SOPRANO_INDEX_LIBRARIES)

  # read from cache
  set(Soprano_FOUND TRUE)

else(SOPRANO_INCLUDE_DIR AND SOPRANO_LIBRARIES AND SOPRANO_INDEX_LIBRARIES)

  FIND_PATH(SOPRANO_INCLUDE_DIR 
    NAMES
    soprano/soprano.h
    PATHS 
    ${KDE4_INCLUDE_DIR}
    ${INCLUDE_INSTALL_DIR}
    )

  FIND_LIBRARY_EX(SOPRANO_LIBRARIES
    WIN32_DEBUG_POSTFIX d
    NAMES soprano
    PATHS
    ${KDE4_LIB_DIR}
    ${LIB_INSTALL_DIR}
  )


  FIND_LIBRARY(SOPRANO_INDEX_LIBRARIES 
    NAMES
    sopranoindex
    PATHS
    ${KDE4_LIB_DIR}
    ${LIB_INSTALL_DIR}
    )

  FIND_LIBRARY(SOPRANO_CLIENT_LIBRARIES 
    NAMES
    sopranoclient
    PATHS
    ${KDE4_LIB_DIR}
    ${LIB_INSTALL_DIR}
    )

  if(SOPRANO_INCLUDE_DIR AND SOPRANO_LIBRARIES)
    set(Soprano_FOUND TRUE)
    if(SOPRANO_INDEX_LIBRARIES)
      set(SopranoIndex_FOUND TRUE)
    endif(SOPRANO_INDEX_LIBRARIES)
    if(SOPRANO_CLIENT_LIBRARIES)
      set(SopranoClient_FOUND TRUE)
    endif(SOPRANO_CLIENT_LIBRARIES)
  endif(SOPRANO_INCLUDE_DIR AND SOPRANO_LIBRARIES)
  
  if(Soprano_FOUND)
    if(NOT Soprano_FIND_QUIETLY)
      message(STATUS "Found Soprano: ${SOPRANO_LIBRARIES}")
      if(SopranoIndex_FOUND)
        message(STATUS "Found Soprano Index: ${SOPRANO_INDEX_LIBRARIES}")
      endif(SopranoIndex_FOUND)
      if(SopranoClient_FOUND)
        message(STATUS "Found Soprano Client: ${SOPRANO_INDEX_LIBRARIES}")
      endif(SopranoClient_FOUND)
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

endif(SOPRANO_INCLUDE_DIR AND SOPRANO_LIBRARIES AND SOPRANO_INDEX_LIBRARIES)
