# Once done this will define
#
#  NEPOMUK_FOUND - system has Nepomuk
#  NEPOMUK_INCLUDE_DIR - the Nepomuk include directory
#  NEPOMUK_LIBRARIES - Link these to use Nepomuk
#  NEPOMUK_DEFINITIONS - Compiler switches required for using Nepomuk
#

FIND_PATH(NEPOMUK_INCLUDE_DIR
  NAMES
  nepomuk/resource.h
  PATHS
  ${KDE4_INCLUDE_DIR}
  ${INCLUDE_INSTALL_DIR}
  )

FIND_LIBRARY(NEPOMUK_LIBRARY
  NAMES
  nepomuk
  PATHS
  ${KDE4_LIB_DIR}
  ${LIB_INSTALL_DIR}
  )

set(NEPOMUK_LIBRARIES ${NEPOMUK_LIBRARY})

if(NEPOMUK_INCLUDE_DIR AND NEPOMUK_LIBRARIES)
  set(Nepomuk_FOUND TRUE)
endif(NEPOMUK_INCLUDE_DIR AND NEPOMUK_LIBRARIES)

if(Nepomuk_FOUND)
  if(NOT Nepomuk_FIND_QUIETLY)
    message(STATUS "Found Nepomuk: ${NEPOMUK_LIBRARIES}")
  endif(NOT Nepomuk_FIND_QUIETLY)
else(Nepomuk_FOUND)
  if(Nepomuk_FIND_REQUIRED)
    if(NOT NEPOMUK_INCLUDE_DIR)
      message(FATAL_ERROR "Could not find Nepomuk includes.")
    endif(NOT NEPOMUK_INCLUDE_DIR)
    if(NOT NEPOMUK_LIBRARIES)
      message(FATAL_ERROR "Could not find Nepomuk library.")
    endif(NOT NEPOMUK_LIBRARIES)
  endif(Nepomuk_FIND_REQUIRED)
endif(Nepomuk_FOUND)
