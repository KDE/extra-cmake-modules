# - Try to find the OpenSSL encryption library
# Once done this will define
#
#  OPENSSL_FOUND - system has the OpenSSL library
#  OPENSSL_INCLUDE_DIR - the OpenSSL include directory
#  OPENSSL_LIBRARIES - The libraries needed to use OpenSSL

FIND_PATH(OPENSSL_INCLUDE_DIR openssl/ssl.h
   /usr/include/
   /usr/local/include/
   ${GNUWIN32_DIR}/include
)

FIND_LIBRARY(OPENSSL_LIBRARIES NAMES ssl ssleay32
   PATHS
   /usr/lib
   /usr/local/lib
   ${GNUWIN32_DIR}/lib
)

if(OPENSSL_INCLUDE_DIR AND OPENSSL_LIBRARIES)
   set(OPENSSL_FOUND TRUE)
endif(OPENSSL_INCLUDE_DIR AND OPENSSL_LIBRARIES)


if(OPENSSL_FOUND)
   if(NOT OpenSSL_FIND_QUIETLY)
      message(STATUS "Found OpenSSL: ${OPENSSL_LIBRARIES}")
   endif(NOT OpenSSL_FIND_QUIETLY)
else(OPENSSL_FOUND)
   if(OpenSSL_FIND_REQUIRED)
      message(FATAL_ERROR "Could NOT find OpenSSL")
   endif(OpenSSL_FIND_REQUIRED)
endif(OPENSSL_FOUND)

MARK_AS_ADVANCED(OPENSSL_INCLUDE_DIR OPENSSL_LIBRARIES)

