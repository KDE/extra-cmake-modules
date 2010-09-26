# - Try to find PolkitQt-1
# Once done this will define
#
#  POLKITQT-1_FOUND - system has Polkit-qt
#  POLKITQT-1_INCLUDE_DIR - the Polkit-qt include directory
#  POLKITQT-1_LIBRARIES - Link these to use all Polkit-qt libs
#  POLKITQT-1_CORE_LIBRARY - Link this to use the polkit-qt-core library only
#  POLKITQT-1_GUI_LIBRARY - Link this to use GUI elements in polkit-qt (polkit-qt-gui)
#  POLKITQT-1_AGENT_LIBRARY - Link this to use the agent wrapper in polkit-qt
#  POLKITQT-1_DEFINITIONS - Compiler switches required for using Polkit-qt
#
# The minimum required version of PolkitQt-1 can be specified using the
# standard syntax, e.g. find_package(PolkitQt-1 1.0)

# Copyright (c) 2009, Dario Freddi, <drf@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

# Support POLKITQT-1_MIN_VERSION for compatibility:
if(NOT PolkitQt-1_FIND_VERSION)
  set(PolkitQt-1_FIND_VERSION "${POLKITQT-1_MIN_VERSION}")
endif(NOT PolkitQt-1_FIND_VERSION)

# the minimum version of PolkitQt-1 we require
if(NOT PolkitQt-1_FIND_VERSION)
  set(PolkitQt-1_FIND_VERSION "0.95.1")
endif(NOT PolkitQt-1_FIND_VERSION)

if (NOT WIN32)
   # use pkg-config to get the directories and then use these values
   # in the FIND_PATH() and FIND_LIBRARY() calls
   find_package(PkgConfig)
   pkg_check_modules(PC_POLKITQT-1 QUIET polkit-qt-1)
   set(POLKITQT-1_DEFINITIONS ${PC_POLKITQT-1_CFLAGS_OTHER})
endif (NOT WIN32)

find_path( POLKITQT-1_INCLUDE_DIR
     NAMES polkitqt1-authority.h
     PATH_SUFFIXES polkit-qt-1
)

find_file( POLKITQT-1_VERSION_FILE
     NAMES polkit-qt-1/polkitqt1-version.h
     PATHS ${POLKITQT-1_INCLUDE_DIR}
)

# Search the version and store it in the cache so we don't have to do this everytime
if(POLKITQT-1_VERSION_FILE  AND NOT  POLKITQT-1_VERSION)
  file(READ ${POLKITQT-1_VERSION_FILE} POLKITQT-1_VERSION_CONTENT)
  string (REGEX MATCH "POLKITQT1_VERSION_STRING \".*\"\n" POLKITQT-1_VERSION_MATCH "${POLKITQT-1_VERSION_CONTENT}")

  if(POLKITQT-1_VERSION_MATCH)
    string(REGEX REPLACE "POLKITQT1_VERSION_STRING \"(.*)\"\n" "\\1" _POLKITQT-1_VERSION ${POLKITQT-1_VERSION_MATCH})
  endif(POLKITQT-1_VERSION_MATCH)
  set(POLKITQT-1_VERSION "${_POLKITQT-1_VERSION}" CACHE STRING "Version number of PolkitQt-1" FORCE)
endif(POLKITQT-1_VERSION_FILE  AND NOT  POLKITQT-1_VERSION)

find_library( POLKITQT-1_CORE_LIBRARY
    NAMES polkit-qt-core-1
    HINTS ${PC_POLKITQT-1_LIBDIR}
)
find_library( POLKITQT-1_GUI_LIBRARY
    NAMES polkit-qt-gui-1
    HINTS ${PC_POLKITQT-1_LIBDIR}
)
find_library( POLKITQT-1_AGENT_LIBRARY
    NAMES polkit-qt-agent-1
    HINTS ${PC_POLKITQT-1_LIBDIR}
)

set(POLKITQT-1_LIBRARIES ${POLKITQT-1_GUI_LIBRARY} ${POLKITQT-1_CORE_LIBRARY} ${POLKITQT-1_AGENT_LIBRARY})

include(FindPackageHandleStandardArgs)

# handle the QUIETLY and REQUIRED arguments and set POLKITQT-1_FOUND to TRUE if
# all listed variables are TRUE
find_package_handle_standard_args(PolkitQt-1  REQUIRED_VARS  POLKITQT-1_GUI_LIBRARY POLKITQT-1_CORE_LIBRARY
                                                             POLKITQT-1_AGENT_LIBRARY POLKITQT-1_INCLUDE_DIR
                                              VERSION_VAR POLKITQT-1_VERSION )

mark_as_advanced(POLKITQT-1_INCLUDE_DIR
                 POLKITQT-1_CORE_LIBRARY
                 POLKITQT-1_GUI_LIBRARY
                 POLKITQT-1_AGENT_LIBRARY
                 POLKITQT-1_VERSION_FILE
                )

if (POLKITQT-1_FOUND)
    if (NOT PC_POLKITQT-1_PREFIX STREQUAL CMAKE_INSTALL_PREFIX)
        message("WARNING: Installation prefix does not match PolicyKit install prefixes. You probably will need to move files installed "
                "in POLICY_FILES_INSTALL_DIR and by dbus_add_activation_system_service to the ${PC_POLKITQT-1_PREFIX} prefix")
    endif (NOT PC_POLKITQT-1_PREFIX STREQUAL CMAKE_INSTALL_PREFIX)
endif (POLKITQT-1_FOUND)

set(POLKITQT-1_POLICY_FILES_INSTALL_DIR ${CMAKE_INSTALL_PREFIX}/share/polkit-1/actions)
