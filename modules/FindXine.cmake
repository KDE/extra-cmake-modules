# - Try to find the XINE  library using standard cmake tool PKG_CHECK_MODULES

# Copyright (c) 2008 Helio Chissini de Castro, <helio@kde.org>
# Copyright (c) 2006,2007 Laurent Montel, <montel@kde.org>
# Copyright (c) 2006, Matthias Kretz, <kretz@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

if (XINE_INCLUDEDIR AND XINE_LIBRARIES)
    # Already in cache, be silent
    set(Xine_FIND_QUIETLY TRUE)
endif (XINE_INCLUDEDIR AND XINE_LIBRARIES)

IF (NOT WIN32)
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(XINE libxine>=1.1.9)
ENDIF (NOT WIN32)

if( XINE_FOUND )
    SET(CMAKE_REQUIRED_INCLUDES ${XINE_INCLUDEDIR})
    SET(CMAKE_REQUIRED_LIBRARIES ${XINE_LIBRARIES})
    if (NOT Xine_FIND_QUIETLY)
        message(STATUS "Found XINE: ${XINE_LIBRARIES}")
    endif (NOT Xine_FIND_QUIETLY)
endif(XINE_FOUND)


