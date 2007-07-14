

if(LIBKLEO_INCLUDE_DIR AND LIBKLEO_LIBRARIES)

  # read from cache
  set(LIBKLEO_FOUND TRUE)

else(LIBKLEO_INCLUDE_DIR AND LIBKLEO_LIBRARIES)

  FIND_PATH(LIBKLEO_INCLUDE_DIR 
    NAMES
    libkleo/libkleo_export.h
    libkleo/ui/keyrequester.h
    libklep/kleo/decryptjob.h
    PATHS 
    /usr/include
    /usr/local/include
    ${KDE4_INCLUDE_DIR}
    ${INCLUDE_INSTALL_DIR}
    )
  
  FIND_LIBRARY(LIBKLEO_LIBRARIES 
    NAMES
    kleo-gpl
    PATHS
    /usr/lib
    /usr/local/lib
    ${KDE4_LIB_DIR}
    ${LIB_INSTALL_DIR}
    )
  if(LIBKLEO_INCLUDE_DIR AND LIBKLEO_LIBRARIES)
    set(LIBKLEO_FOUND TRUE)
  endif(LIBKLEO_INCLUDE_DIR AND LIBKLEO_LIBRARIES)

  if(LIBKLEO_FOUND)
    if(NOT LIBKLEO_FIND_QUIETLY)
      message(STATUS "Found LIBKLEO: ${LIBKLEO_LIBRARIES}")
    endif(NOT LIBKLEO_FIND_QUIETLY)
  else(LIBKLEO_FOUND)
    if(LIBKLEO_FIND_REQUIRED)
      if(NOT LIBKLEO_INCLUDE_DIR)
        message(STATUS "Could not find LIBKLEO includes.")
      endif(NOT LIBKLEO_INCLUDE_DIR)
      if(NOT LIBKLEO_LIBRARIES)
        message(STATUS "Could not find LIBKLEO library.")
      endif(NOT LIBKLEO_LIBRARIES)
    endif(LIBKLEO_FIND_REQUIRED)
  endif(LIBKLEO_FOUND)

endif(LIBKLEO_INCLUDE_DIR AND LIBKLEO_LIBRARIES)

mark_as_advanced(LIBKLEO_INCLUDE_DIR LIBKLEO_LIBRARIES)
