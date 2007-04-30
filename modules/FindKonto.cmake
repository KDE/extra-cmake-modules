# Once done this will define
#
#  KONTO_FOUND - system has the Nepomuk-KDE backbone lib Konto
#  KONTO_INCLUDES - the libKonto include directory
#  KONTO_LIBRARIES - Link these to use libKonto
#

FIND_PATH(KONTO_INCLUDES 
  NAMES
  konto/class.h
  PATHS
  /usr/include
  /usr/local/include
  ${KDE4_INCLUDE_DIR}
  ${INCLUDE_INSTALL_DIR}
)

FIND_LIBRARY(KONTO_LIBRARIES 
  NAMES 
  konto
  PATHS
  /usr/lib
  /usr/local/lib
  ${KDE4_LIB_DIR}
  ${LIB_INSTALL_DIR}
)

if(KONTO_INCLUDES AND KONTO_LIBRARIES)
   set(Konto_FOUND TRUE)
   message(STATUS "Found Konto: ${KONTO_LIBRARIES}")
else(KONTO_INCLUDES AND KONTO_LIBRARIES)
  if(Konto_FIND_REQUIRED)
    message(FATAL_ERROR "Could not find Konto library.")
  endif(Konto_FIND_REQUIRED)
endif(KONTO_INCLUDES AND KONTO_LIBRARIES)
