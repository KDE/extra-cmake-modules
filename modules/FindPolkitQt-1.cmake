# - Try to find Polkit-qt-1
# Once done this will define
#
#  POLKITQT_1_FOUND - system has Polkit-qt
#  POLKITQT_1_INCLUDE_DIR - the Polkit-qt include directory
#  POLKITQT_1_LIBRARIES - Link these to use all Polkit-qt libs
#  POLKITQT_1_CORE_LIBRARY - Link this to use the polkit-qt-core library only
#  POLKITQT_1_GUI_LIBRARY - Link this to use GUI elements in polkit-qt (polkit-qt-gui)
#  POLKITQT_1_AGENT_LIBRARY - Link this to use the agent wrapper in polkit-qt
#  POLKITQT_1_DEFINITIONS - Compiler switches required for using Polkit-qt

# Copyright (c) 2009, Dario Freddi, <drf@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

if (POLKITQT_1_INCLUDE_DIR AND POLKITQT_1_LIB)
    set(POLKITQT_1_FIND_QUIETLY TRUE)
endif (POLKITQT_1_INCLUDE_DIR AND POLKITQT_1_LIB)

if (NOT POLKITQT_1_MIN_VERSION)
  set(POLKITQT_1_MIN_VERSION "0.95.0")
endif (NOT POLKITQT_1_MIN_VERSION)

if (NOT WIN32)
   # use pkg-config to get the directories and then use these values
   # in the FIND_PATH() and FIND_LIBRARY() calls
   find_package(PkgConfig)
   pkg_check_modules(PC_POLKITQT_1 QUIET polkit-qt-1)
   set(POLKITQT_1_DEFINITIONS ${PC_POLKITQT_1_CFLAGS_OTHER})
endif (NOT WIN32)

find_path( POLKITQT_1_INCLUDE_DIR
     NAMES PolkitQt/authority.h
     PATH_SUFFIXES polkit-qt-1
)
find_library( POLKITQT_1_CORE_LIBRARY 
    NAMES polkit-qt-core-1
    HINTS ${PC_POLKITQT_1_LIBDIR}
)
find_library( POLKITQT_1_GUI_LIBRARY 
    NAMES polkit-qt-gui-1
    HINTS ${PC_POLKITQT_1_LIBDIR}
)
find_library( POLKITQT_1_AGENT_LIBRARY 
    NAMES polkit-qt-agent-1
    HINTS ${PC_POLKITQT_1_LIBDIR}
)

set(POLKITQT_1_LIBRARIES ${POLKITQT_1_GUI_LIBRARY} ${POLKITQT_1_CORE_LIBRARY} ${POLKITQT_1_AGENT_LIBRARY})

include(FindPackageHandleStandardArgs)

# handle the QUIETLY and REQUIRED arguments and set POLKITQT_1_FOUND to TRUE if 
# all listed variables are TRUE
find_package_handle_standard_args(PolkitQt-1 DEFAULT_MSG POLKITQT_1_LIBRARIES POLKITQT_1_INCLUDE_DIR)

mark_as_advanced(POLKITQT_1_INCLUDE_DIR POLKITQT_1_CORE_LIBRARY POLKITQT_1_GUI_LIBRARY POLKITQT_1_LIBRARIES)

if (POLKITQT_1_FOUND)
    if (PC_POLKITQT_1_VERSION VERSION_LESS POLKITQT_1_MIN_VERSION)
        message(STATUS "Found Polkit-Qt-1 release < ${POLKITQT_1_MIN_VERSION}")
        message(STATUS "You need Polkit-Qt-1 version ${POLKITQT_1_MIN_VERSION} or newer to compile this component")
        set(POLKITQT_1_FOUND FALSE)
        return()
    else (PC_POLKITQT_1_VERSION VERSION_LESS POLKITQT_1_MIN_VERSION)
        if ( NOT PC_POLKITQT_1_PREFIX STREQUAL CMAKE_INSTALL_PREFIX )
            message("WARNING: Installation prefix does not match PolicyKit install prefixes. You probably will need to move files installed "
                    "in POLICY_FILES_INSTALL_DIR and by dbus_add_activation_system_service to the ${PC_POLKITQT_1_PREFIX} prefix")
        endif (NOT PC_POLKITQT_1_PREFIX STREQUAL CMAKE_INSTALL_PREFIX)
    endif (PC_POLKITQT_1_VERSION VERSION_LESS POLKITQT_1_MIN_VERSION)
endif (POLKITQT_1_FOUND)

set(POLKITQT_1_POLICY_FILES_INSTALL_DIR ${CMAKE_INSTALL_PREFIX}/share/polkit-1/actions)
