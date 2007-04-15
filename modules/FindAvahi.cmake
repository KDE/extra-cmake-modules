# Find Avahi. Only avahi-common/defs.h is really needed
#
# Copyright (c) 2007, Jakub Stachowski, <qbast@go2.pl>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.


if (AVAHI_INCLUDE_DIR)
  # Already in cache, be silent
  set(Avahi_FIND_QUIETLY TRUE)
endif (AVAHI_INCLUDE_DIR)


FIND_PATH(AVAHI_INCLUDE_DIR avahi-common/defs.h
	/usr/include
	/usr/local/include
	)

if(AVAHI_INCLUDE_DIR)
   set(AVAHI_FOUND TRUE)
endif(AVAHI_INCLUDE_DIR)


if(AVAHI_FOUND)
   if(NOT Avahi_FIND_QUIETLY)
   	MESSAGE( STATUS "Avahi common includes found in ${AVAHI_INCLUDE_DIR}")
   endif(NOT Avahi_FIND_QUIETLY)
else(AVAHI_FOUND)
   if(Avahi_FIND_REQUIRED)
        MESSAGE( FATAL_ERROR "Avahi not found")
   endif(Avahi_FIND_REQUIRED)
endif(AVAHI_FOUND)

MARK_AS_ADVANCED(AVAHI_INCLUDE_DIR)

