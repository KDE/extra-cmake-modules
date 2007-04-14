# Find Avahi. Only avahi-common/defs.h is really needed
#
# Copyright (c) 2007, Jakub Stachowski, <qbast@go2.pl>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.


FIND_PATH(AVAHI_INCLUDE_DIR avahi-common/defs.h
	/usr/include
	/usr/local/include
	)

if(AVAHI_INCLUDE_DIR)
   set(AVAHI_FOUND TRUE)
   MESSAGE( STATUS "Avahi common includes found in ${AVAHI_INCLUDE_DIR}")
else(AVAHI_INCLUDE_DIR)
   MESSAGE( STATUS "Avahi not found")
endif(AVAHI_INCLUDE_DIR)

MARK_AS_ADVANCED(AVAHI_INCLUDE_DIR)

