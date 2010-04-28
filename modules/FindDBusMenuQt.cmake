# - Try to find dbusmenu-qt
# Once done this will define
#
#  DBUSMENUQT_FOUND - system has dbusmenu-qt
#  DBUSMENUQT_INCLUDE_DIR - the dbusmenu-qt include directory
#  DBUSMENUQT_LIBRARIES - the libraries needed to use dbusmenu-qt
#  DBUSMENUQT_DEFINITIONS - Compiler switches required for using dbusmenu-qt
#
# use pkg-config to get the directories and then use these values
# in the FIND_PATH() and FIND_LIBRARY() calls

# Copyright (c) 2009, Canonical Ltd.
# - Author: Aurélien Gâteau <aurelien.gateau@canonical.com>
#
# Based on FindQCA2.cmake
# Copyright (c) 2006, Michael Larouche, <michael.larouche@kdemail.net>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

include(FindPackageHandleStandardArgs)

if (DBUSMENUQT_INCLUDE_DIR AND DBUSMENUQT_LIBRARIES)
    # in cache already
    set(DBUSMENUQT_FOUND TRUE)
else (DBUSMENUQT_INCLUDE_DIR AND DBUSMENUQT_LIBRARIES)
    if (NOT WIN32)
        find_package(PkgConfig)
        pkg_check_modules(PC_DBUSMENUQT QUIET dbusmenu-qt)
        set(DBUSMENUQT_DEFINITIONS ${PC_DBUSMENUQT_CFLAGS_OTHER})
    endif (NOT WIN32)

    find_library(DBUSMENUQT_LIBRARIES
        NAMES dbusmenu-qt dbusmenu-qtd
        HINTS ${PC_DBUSMENUQT_LIBDIR} ${PC_DBUSMENUQT_LIBRARY_DIRS}
        )

    find_path(DBUSMENUQT_INCLUDE_DIR dbusmenuexporter.h
        HINTS ${PC_DBUSMENUQT_INCLUDEDIR} ${PC_DBUSMENUQT_INCLUDE_DIRS}
        PATH_SUFFIXES dbusmenu-qt
        )

	if( WIN32 DBUSMENUQT_LIBRARIES AND DBUSMENUQT_INCLUDE_DIR )
		#we don't use pkgconfig on windows so we have to set DBUSMENUQT_FOUND by hand 
		set(DBUSMENUQT_FOUND TRUE)
	endif(  WIN32 DBUSMENUQT_LIBRARIES AND DBUSMENUQT_INCLUDE_DIR )
	
    find_package_handle_standard_args(dbusmenuqt DEFAULT_MSG DBUSMENUQT_LIBRARIES DBUSMENUQT_INCLUDE_DIR)

    mark_as_advanced(DBUSMENUQT_INCLUDE_DIR DBUSMENUQT_LIBRARIES)
endif (DBUSMENUQT_INCLUDE_DIR AND DBUSMENUQT_LIBRARIES)
