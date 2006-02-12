# - Try to find DNSSD
# Once done this will define
#
#  DNSSD_FOUND - system has DNSSD
#  DNSSD_INCLUDE_DIR - the DNSSD include directory
#  DNSSD_LIBRARIES - Link these to use dnssd
#  DNSSD_DEFINITIONS - Compiler switches required for using DNSSD
#
# need more test: look at into dnssd/configure.in.in

FIND_PATH(DNSSD_INCLUDE_DIR dns_sd.h
  /usr/include
  /usr/local/include
  /usr/include/avahi-compat-libdns_sd/
)

FIND_LIBRARY(DNSSD_LIBRARIES NAMES dns_sd
  PATHS
  /usr/lib
  /usr/local/lib
)

IF(DNSSD_INCLUDE_DIR AND DNSSD_LIBRARIES)
   SET(DNSSD_FOUND TRUE)
ENDIF(DNSSD_INCLUDE_DIR AND DNSSD_LIBRARIES)

IF(DNSSD_FOUND)
  IF(NOT DNSSD_FIND_QUIETLY)
    MESSAGE(STATUS "Found DNSSD: ${DNSSD_LIBRARIES}")
  ENDIF(NOT DNSSD_FIND_QUIETLY)
ELSE(DNSSD_FOUND)
  IF(DNSSD_FIND_REQUIRED)
    MESSAGE(FATAL_ERROR "Could not find DNSSD")
  ENDIF(DNSSD_FIND_REQUIRED)
ENDIF(DNSSD_FOUND)

MARK_AS_ADVANCED(DNSSD_INCLUDE_DIR DNSSD_LIBRARIES)
