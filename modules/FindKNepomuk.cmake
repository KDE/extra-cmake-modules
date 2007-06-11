# Once done this will define
#
#  KNEPOMUK_FOUND - system has the Nepomuk-KDE backbone lib KNep
#  KNEPOMUK_INCLUDES - the libKNep include directory
#  KNEPOMUK_LIBRARIES - Link these to use libKNep
#

FIND_PATH(KNEPOMUK_INCLUDES 
  NAMES
  knepomuk/knepomuk.h
  PATHS
  /usr/include
  /usr/local/include
  ${KDE4_INCLUDE_DIR}
  ${INCLUDE_INSTALL_DIR}
)

FIND_LIBRARY(KNEPOMUK_LIBRARIES 
  NAMES 
  knepomuk
  PATHS
  /usr/lib
  /usr/local/lib
  ${KDE4_LIB_DIR}
  ${LIB_INSTALL_DIR}
)

if(KNEPOMUK_INCLUDES AND KNEPOMUK_LIBRARIES)
   set(KNEPOMUK_FOUND TRUE)
   message(STATUS "Found KNepomuk: ${KNEPOMUK_LIBRARIES}")
else(KNEPOMUK_INCLUDES AND KNEPOMUK_LIBRARIES)
  if(KNepomuk_FIND_REQUIRED)
    message(FATAL_ERROR "Could not find KNepomuk library.")
  endif(KNepomuk_FIND_REQUIRED)
endif(KNEPOMUK_INCLUDES AND KNEPOMUK_LIBRARIES)
