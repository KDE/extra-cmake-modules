# cmake macro to see if we have kdepim installed

# KDEPIM_INCLUDE_DIR
# KDEPIM_FOUND
# Copyright (C) 2007 Laurent Montel <montel@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.


if (KDEPIM_INCLUDE_DIR)
    # Already in cache, be silent
    set(KDEPIM_FOUND TRUE)
endif (KDEPIM_INCLUDE_DIR)


FIND_PATH(KDEPIM_INCLUDE_DIR NAMES kdepimprotocols.h
	PATHS
	${INCLUDE_INSTALL_DIR}
	/usr/include
	/usr/local/include
)

FIND_LIBRARY(KDEPIM_LIBRARIES NAMES kdepim
	PATHS
	${LIB_INSTALL_DIR}
	/usr/lib
	/usr/local/lib
)

if (KDEPIM_LIBRARIES AND KDEPIM_INCLUDE_DIR)
    set(KDEPIM_FOUND TRUE)
endif (KDEPIM_LIBRARIES AND KDEPIM_INCLUDE_DIR)

if (KDEPIM_FOUND)
    if (NOT Kdepim_FIND_QUIETLY)
    message(STATUS "Found Kdepim: ${KDEPIM_LIBRARIES}")
    endif (NOT Kdepim_FIND_QUIETLY)
else (KDEPIM_FOUND)
    if (Kdepim_FIND_REQUIRED)
    message(FATAL_ERROR "Could NOT find Kdepim")
    endif (Kdepim_FIND_REQUIRED)
endif (KDEPIM_FOUND)

MARK_AS_ADVANCED(KDEPIM_INCLUDE_DIR KDEPIM_LIBRARIES)

