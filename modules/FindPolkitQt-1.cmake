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

# Copyright (c) 2009, Dario Freddi, <drf@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

if (POLKITQT-1_INCLUDE_DIR AND POLKITQT-1_LIB)
    set(POLKITQT-1_FIND_QUIETLY TRUE)
endif (POLKITQT-1_INCLUDE_DIR AND POLKITQT-1_LIB)

if (NOT POLKITQT-1_MIN_VERSION)
  set(POLKITQT-1_MIN_VERSION "0.95.1")
endif (NOT POLKITQT-1_MIN_VERSION)

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

find_path( POLKITQT-1_VERSION_FILE
     NAMES polkitqt1-version.h
     PATH_SUFFIXES polkit-qt-1
)

set(POLKITQT-1_VERSION_OK TRUE)
if(POLKITQT-1_VERSION_FILE)
  file(READ ${POLKITQT-1_INCLUDE_DIR}/polkitqt1-version.h POLKITQT-1_VERSION_CONTENT)
  string (REGEX MATCH "POLKITQT1_VERSION_STRING \".*\"\n" POLKITQT-1_VERSION_MATCH "${POLKITQT-1_VERSION_CONTENT}")
  
  if(POLKITQT-1_VERSION_MATCH)
    string(REGEX REPLACE "POLKITQT1_VERSION_STRING \"(.*)\"\n" "\\1" POLKITQT-1_VERSION ${POLKITQT-1_VERSION_MATCH})
    if(POLKITQT-1_VERSION STRLESS "${POLKITQT-1_MIN_VERSION}")
      set(POLKITQT-1_VERSION_OK FALSE)
      if(PolkitQt-1_FIND_REQUIRED)
        message(FATAL_ERROR "PolkitQt-1 version ${POLKITQT-1_VERSION} was found, but it is too old. Please install ${POLKITQT-1_MIN_VERSION} or newer.")
      else(PolkitQt-1_FIND_REQUIRED)
        message(STATUS "PolkitQt-1 version ${POLKITQT-1_VERSION} is too old. Please install ${POLKITQT-1_MIN_VERSION} or newer.")
      endif(PolkitQt-1_FIND_REQUIRED)
    endif(POLKITQT-1_VERSION STRLESS "${POLKITQT-1_MIN_VERSION}")
  endif(POLKITQT-1_VERSION_MATCH)
elseif(POLKITQT-1_INCLUDE_DIR)
  # The version is so old that it does not even have the file
  set(POLKITQT-1_VERSION_OK FALSE)
  if(PolkitQt_FIND_REQUIRED)
    message(FATAL_ERROR "It looks like PolkitQt-1 is too old. Please install PolkitQt-1 version ${POLKITQT-1_MIN_VERSION} or newer.")
  else(PolkitQt_FIND_REQUIRED)
    message(STATUS "It looks like PolkitQt-1 is too old. Please install PolkitQt-1 version ${POLKITQT-1_MIN_VERSION} or newer.")
  endif(PolkitQt_FIND_REQUIRED)
endif(POLKITQT-1_VERSION_FILE)

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
find_package_handle_standard_args(PolkitQt-1 DEFAULT_MSG POLKITQT-1_LIBRARIES POLKITQT-1_INCLUDE_DIR POLKITQT-1_VERSION_OK)

mark_as_advanced(POLKITQT-1_INCLUDE_DIR POLKITQT-1_CORE_LIBRARY POLKITQT-1_GUI_LIBRARY POLKITQT-1_LIBRARIES POLKITQT-1_VERSION_OK)

if (POLKITQT-1_FOUND)
    if (NOT PC_POLKITQT-1_PREFIX STREQUAL CMAKE_INSTALL_PREFIX)
        message("WARNING: Installation prefix does not match PolicyKit install prefixes. You probably will need to move files installed "
                "in POLICY_FILES_INSTALL_DIR and by dbus_add_activation_system_service to the ${PC_POLKITQT-1_PREFIX} prefix")
    endif (NOT PC_POLKITQT-1_PREFIX STREQUAL CMAKE_INSTALL_PREFIX)
endif (POLKITQT-1_FOUND)

set(POLKITQT-1_POLICY_FILES_INSTALL_DIR ${CMAKE_INSTALL_PREFIX}/share/polkit-1/actions)
