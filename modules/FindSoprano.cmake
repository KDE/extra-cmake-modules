

if(SOPRANO_INCLUDE_DIR AND SOPRANO_LIBRARIES)

  # read from cache
  set(Soprano_FOUND TRUE)

else(SOPRANO_INCLUDE_DIR AND SOPRANO_LIBRARIES)

  FIND_PATH(SOPRANO_INCLUDE_DIR 
    NAMES
    soprano/soprano.h
    PATHS 
    /usr/include
    /usr/local/include
    ${KDE4_INCLUDE_DIR}
    ${INCLUDE_INSTALL_DIR}
    )
  
  FIND_LIBRARY(SOPRANO_LIBRARIES 
    NAMES
    soprano
    PATHS
    /usr/lib
    /usr/local/lib
    ${KDE4_LIB_DIR}
    ${LIB_INSTALL_DIR}
    )

  if(SOPRANO_INCLUDE_DIR AND SOPRANO_LIBRARIES)
    set(Soprano_FOUND TRUE)
  endif(SOPRANO_INCLUDE_DIR AND SOPRANO_LIBRARIES)

  if(Soprano_FOUND)
    if(NOT Soprano_FIND_QUIETLY)
      message(STATUS "Found Soprano: ${SOPRANO_LIBRARIES}")
    endif(NOT Soprano_FIND_QUIETLY)
  else(Soprano_FOUND)
    if(Soprano_FIND_REQUIRED)
      if(NOT SOPRANO_INCLUDE_DIR)
	message(FATAL_ERROR "Could not find Soprano includes.")
      endif(NOT SOPRANO_INCLUDE_DIR)
      if(NOT SOPRANO_LIBRARIES)
	message(FATAL_ERROR "Could not find Soprano library.")
      endif(NOT SOPRANO_LIBRARIES)
    endif(Soprano_FIND_REQUIRED)
  endif(Soprano_FOUND)

endif(SOPRANO_INCLUDE_DIR AND SOPRANO_LIBRARIES)
