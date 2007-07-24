# cmake macro to see if we have Plasma from KDE workspace

# PLASMA_INCLUDE_DIR
# PLASMA_FOUND
# Copyright (C) 2007 Brad Hards <bradh@frogmouth.net>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.


if (PLASMA_INCLUDE_DIR AND PLASMA_LIBS)
    # Already in cache, be silent
    set(Plasma_FIND_QUIETLY TRUE)
endif (PLASMA_INCLUDE_DIR AND PLASMA_LIBS)


find_path(PLASMA_INCLUDE_DIR NAMES plasma/plasma.h
        PATHS
        ${INCLUDE_INSTALL_DIR}
)

find_library(PLASMA_LIBS NAMES plasma
        PATHS
        ${LIB_INSTALL_DIR}
)
if (PLASMA_LIBS AND PLASMA_INCLUDE_DIR)
    set(PLASMA_FOUND TRUE)
endif (PLASMA_LIBS AND PLASMA_INCLUDE_DIR)

if (PLASMA_FOUND)
    if (NOT Plasma_FIND_QUIETLY)
    message(STATUS "Found Plasma: ${PLASMA_LIBS}")
    endif (NOT Plasma_FIND_QUIETLY)
else (PLASMA_FOUND)
    if (Plasma_FIND_REQUIRED)
    message(FATAL_ERROR "Could NOT find Plasma")
    endif (Plasma_FIND_REQUIRED)
endif (PLASMA_FOUND)

mark_as_advanced(PLASMA_INCLUDE_DIR PLASMA_LIBS)
