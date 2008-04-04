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
	${KDE4_INCLUDE_DIR}
        ${INCLUDE_INSTALL_DIR}
)

find_library(PLASMA_LIBS NAMES plasma
        PATHS
	${KDE4_LIB_DIR}
        ${LIB_INSTALL_DIR}
)

include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(Plasma DEFAULT_MSG PLASMA_LIBS PLASMA_INCLUDE_DIR )

if (PLASMA_FOUND)
    find_file(PLASMA_OPENGL_FOUND plasma/glapplet.h
              PATHS ${PLASMA_INCLUDE_DIR}
              NO_DEFAULT_PATH)
endif (PLASMA_FOUND)

mark_as_advanced(PLASMA_INCLUDE_DIR PLASMA_LIBS)
