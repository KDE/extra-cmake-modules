# - Try to find Polkit-qt
# Once done this will define
#
#  POLKITQT_FOUND - system has Polkit-qt
#  POLKITQT_INCLUDE_DIR - the Polkit-qt include directory
#  POLKITQT_LIBRARIES - Link these to use all Polkit-qt libs
#  POLKITQT_CORE_LIBRARY - Link this to use the polkit-qt-core library only
#  POLKITQT_GUI_LIBRARY - Link this to use GUI elements in polkit-qt (polkit-qt-gui)
#  POLKITQT_DEFINITIONS - Compiler switches required for using Polkit-qt
#  POLKITQT_POLICY_FILES_INSTALL_DIR - The directory where policy files should be installed to.
#
# The minimum required version PolkitQt can be specified by setting the
# POLKITQT_MIN_VERSION variable.

# Copyright (c) 2009, Daniel Nicoletti, <dantti85-pk@yahoo.com.br>
# Copyright (c) 2009, Dario Freddi, <drf54321@gmail.com>
# Copyright (c) 2009, Michal Malek, <michalm@jabster.pl>
# Copyright (c) 2009, Alexander Neundorf, <neundorf@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

if (POLKITQT_INCLUDE_DIR AND POLKITQT_GUI_LIBRARY AND POLKITQT_CORE_LIBRARY)
    set(PolkitQt_FIND_QUIETLY TRUE)
endif (POLKITQT_INCLUDE_DIR AND POLKITQT_GUI_LIBRARY AND POLKITQT_CORE_LIBRARY)

if (NOT POLKITQT_MIN_VERSION)
  set(POLKITQT_MIN_VERSION "0.9.0")
endif (NOT POLKITQT_MIN_VERSION)

if (NOT WIN32)
   # use pkg-config to get the directories and then use these values
   # in the FIND_PATH() and FIND_LIBRARY() calls
   find_package(PkgConfig)
   pkg_check_modules(PC_POLKITQT QUIET polkit-qt)
   set(POLKITQT_DEFINITIONS ${PC_POLKITQT_CFLAGS_OTHER})
endif (NOT WIN32)

find_path( POLKITQT_INCLUDE_DIR
     NAMES polkit-qt/auth.h
     PATH_SUFFIXES PolicyKit
)
find_library( POLKITQT_CORE_LIBRARY 
    NAMES polkit-qt-core 
    HINTS ${PC_POLKITQT_LIBDIR}
)
find_library( POLKITQT_GUI_LIBRARY 
    NAMES polkit-qt-gui 
    HINTS ${PC_POLKITQT_LIBDIR}
)
set(POLKITQT_LIBRARIES ${POLKITQT_GUI_LIBRARY} ${POLKITQT_CORE_LIBRARY})

include(FindPackageHandleStandardArgs)

# handle the QUIETLY and REQUIRED arguments and set POLKITQT_FOUND to TRUE if 
# all listed variables are TRUE
find_package_handle_standard_args(PolkitQt  DEFAULT_MSG  POLKITQT_INCLUDE_DIR POLKITQT_GUI_LIBRARY POLKITQT_CORE_LIBRARY)

mark_as_advanced(POLKITQT_INCLUDE_DIR POLKITQT_CORE_LIBRARY POLKITQT_GUI_LIBRARY POLKITQT_LIBRARIES)

if (POLKITQT_FOUND)
    if (PC_POLKITQT_VERSION VERSION_LESS POLKITQT_MIN_VERSION)
        if(PolkitQt_FIND_REQUIRED)
            message(FATAL_ERROR "Found Polkit-Qt release ${PC_POLKITQT_VERSION}, but at least ${POLKITQT_MIN_VERSION} is required.")
        else(PolkitQt_FIND_REQUIRED)
            message(STATUS "Found Polkit-Qt release ${PC_POLKITQT_VERSION}, but at least ${POLKITQT_MIN_VERSION} is required.")
        endif(PolkitQt_FIND_REQUIRED)
        set(POLKITQT_FOUND FALSE)
    endif (PC_POLKITQT_VERSION VERSION_LESS POLKITQT_MIN_VERSION)
endif (POLKITQT_FOUND)


if(POLKITQT_FOUND)
    get_filename_component(_POLKITQT_INSTALL_PREFIX "${POLKITQT_CORE_LIBRARY}"  PATH)
    get_filename_component(_POLKITQT_INSTALL_PREFIX "${_POLKITQT_INSTALL_PREFIX}"  PATH)
    if ( NOT _POLKITQT_INSTALL_PREFIX STREQUAL CMAKE_INSTALL_PREFIX )
        message("WARNING: Installation prefix does not match PolicyKit install prefixes. You probably will need to move files installed "
                "in ${CMAKE_INSTALL_PREFIX}/${POLKITQT_POLICY_FILES_INSTALL_DIR} and by dbus_add_activation_system_service to the ${_POLKITQT_INSTALL_PREFIX}/${POLKITQT_POLICY_FILES_INSTALL_DIR} prefix")
    endif (NOT _POLKITQT_INSTALL_PREFIX STREQUAL CMAKE_INSTALL_PREFIX)
endif(POLKITQT_FOUND)

set(POLKITQT_POLICY_FILES_INSTALL_DIR share/PolicyKit/policy/)
