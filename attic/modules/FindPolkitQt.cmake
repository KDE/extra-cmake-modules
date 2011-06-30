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
# The minimum required version of PolkitQt can be specified using the
# standard syntax, e.g. find_package(PolkitQt 1.0)
# For compatiblity, this can also be done by setting the POLKITQT_MIN_VERSION variable.

# Copyright (c) 2009, Daniel Nicoletti, <dantti85-pk@yahoo.com.br>
# Copyright (c) 2009, Dario Freddi, <drf54321@gmail.com>
# Copyright (c) 2009, Michal Malek, <michalm@jabster.pl>
# Copyright (c) 2009, Alexander Neundorf, <neundorf@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.


# Support POLKITQT_MIN_VERSION for compatibility:
if(NOT PolkitQt_FIND_VERSION)
  set(PolkitQt_FIND_VERSION "${POLKITQT_MIN_VERSION}")
endif(NOT PolkitQt_FIND_VERSION)

# the minimum version of PolkitQt we require
if(NOT PolkitQt_FIND_VERSION)
  set(PolkitQt_FIND_VERSION "0.9.3")
endif(NOT PolkitQt_FIND_VERSION)

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

find_file( POLKITQT_VERSION_FILE
     polkit-qt/polkitqtversion.h
     HINTS ${POLKITQT_INCLUDE_DIR}
)

if(POLKITQT_VERSION_FILE  AND NOT  POLKITQT_VERSION)
  file(READ ${POLKITQT_VERSION_FILE} POLKITQT_VERSION_CONTENT)
  string (REGEX MATCH "POLKITQT_VERSION_STRING \".*\"\n" POLKITQT_VERSION_MATCH "${POLKITQT_VERSION_CONTENT}")

  if(POLKITQT_VERSION_MATCH)
    string(REGEX REPLACE "POLKITQT_VERSION_STRING \"(.*)\"\n" "\\1" _POLKITQT_VERSION ${POLKITQT_VERSION_MATCH})
  endif(POLKITQT_VERSION_MATCH)
  set(POLKITQT_VERSION "${_POLKITQT_VERSION}" CACHE STRING "Version number of PolkitQt" FORCE)
endif(POLKITQT_VERSION_FILE  AND NOT  POLKITQT_VERSION)

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
# Use the extended (new) syntax for FPHSA():
find_package_handle_standard_args(PolkitQt  REQUIRED_VARS POLKITQT_GUI_LIBRARY POLKITQT_CORE_LIBRARY POLKITQT_INCLUDE_DIR
                                            VERSION_VAR  POLKITQT_VERSION)

mark_as_advanced(POLKITQT_INCLUDE_DIR
                 POLKITQT_CORE_LIBRARY
                 POLKITQT_GUI_LIBRARY
                 POLKITQT_VERSION_FILE
                )

set(POLKITQT_POLICY_FILES_INSTALL_DIR share/PolicyKit/policy/)

if(POLKITQT_FOUND)
    get_filename_component(_POLKITQT_INSTALL_PREFIX "${POLKITQT_CORE_LIBRARY}"  PATH)
    get_filename_component(_POLKITQT_INSTALL_PREFIX "${_POLKITQT_INSTALL_PREFIX}"  PATH)
    if ( NOT _POLKITQT_INSTALL_PREFIX STREQUAL CMAKE_INSTALL_PREFIX )
        message("WARNING: Installation prefix does not match PolicyKit install prefixes. You probably will need to move files installed "
                "in ${CMAKE_INSTALL_PREFIX}/${POLKITQT_POLICY_FILES_INSTALL_DIR} and by dbus_add_activation_system_service to the ${_POLKITQT_INSTALL_PREFIX}/${POLKITQT_POLICY_FILES_INSTALL_DIR} prefix")
    endif (NOT _POLKITQT_INSTALL_PREFIX STREQUAL CMAKE_INSTALL_PREFIX)
endif(POLKITQT_FOUND)

