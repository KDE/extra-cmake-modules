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

if(DNSSD_INCLUDE_DIR AND DNSSD_LIBRARIES)
   set(DNSSD_FOUND TRUE)
endif(DNSSD_INCLUDE_DIR AND DNSSD_LIBRARIES)

if(DNSSD_FOUND)
  if(NOT DNSSD_FIND_QUIETLY)
    message(STATUS "Found DNSSD: ${DNSSD_LIBRARIES}")
  endif(NOT DNSSD_FIND_QUIETLY)
else(DNSSD_FOUND)
  if(DNSSD_FIND_REQUIRED)
    message(FATAL_ERROR "Could NOT find DNSSD")
  endif(DNSSD_FIND_REQUIRED)
endif(DNSSD_FOUND)

MARK_AS_ADVANCED(DNSSD_INCLUDE_DIR DNSSD_LIBRARIES)
