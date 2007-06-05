# Once done this will define
#
#  KONTO_FOUND - system has the Nepomuk-KDE backbone lib Konto
#  KONTO_INCLUDES - the libKonto include directory
#  KONTO_LIBRARIES - Link these to use libKonto
#

if(KONTO_INCLUDES AND KONTO_LIBRARIES)
  # Already in cache, be silent
  set(Konto_FIND_QUIETLY TRUE)
endif(KONTO_INCLUDES AND KONTO_LIBRARIES


FIND_PATH(KONTO_INCLUDES 
  NAMES
  konto/class.h
  PATHS
  ${KDE4_INCLUDE_DIR}
  ${INCLUDE_INSTALL_DIR}
)

FIND_LIBRARY(KONTO_LIBRARIES 
  NAMES 
  konto
  PATHS
  ${KDE4_LIB_DIR}
  ${LIB_INSTALL_DIR}
)


if(KONTO_INCLUDES AND KONTO_LIBRARIES)
  set(KONTO_FOUND TRUE)
endif(KONTO_INCLUDES AND KONTO_LIBRARIES)

if(KONTO_FOUND)
   if (NOT Konto_FIND_QUIETLY)
      message(STATUS "Found Konto: ${KONTO_LIBRARIES}")
   endif (NOT Konto_FIND_QUIETLY)
else(KONTO_FOUND)
  if(Konto_FIND_REQUIRED)
    message(FATAL_ERROR "Could not find Konto library.")
  endif(Konto_FIND_REQUIRED)
endif(KONTO_FOUND)

