# - Try to find the QtDBus module
# Once done this will define
#
#  QDBUS_FOUND - system has QtDBus
#  QDBUS_INCLUDE_DIRS - the QtDBus include directories
#  QDBUS_LIBRARIES - Link these to use QtDBus
#  QDBUS_DEFINITIONS - Compiler switches required for using QtDBus
#
#  QDBUS_IDL2CPP_EXECUTABLE - The adaptor/interface code generator
#  QDBUS_CPP2XML_EXECUTABLE - The interface parser
#
# Macros (from QtDBusMacros.cmake):
#  QDBUS_ADD_INTERFACES(SRC_VAR file1.xml ... fileN.xml)
#    Generates interface code from the given XML files.
#
#  QDBUS_GENERATE_INTERFACE(file.h)
#    Generates the XML interface description from the given header file.
#
#  QDBUS_ADD_ADAPTORS(SRC_VAR file1.xml ... fileN.xml)
#    Generates adaptor code from the given XML files.
#

# use pkg-config to get the directories and then use these values
# in the FIND_PATH() and FIND_LIBRARY() calls
INCLUDE(UsePkgConfig)

PKGCONFIG("dbus-1" _dbusIncDir _dbusLinkDir _dbusLinkFlags _dbusCflags)
PKGCONFIG("dbus-qt4-1" _qdbusIncDir _qdbusLinkDir _qdbusLinkFlags _qdbusCflags)

set(QDBUS_DEFINITIONS ${_dbusCflags} ${_qdbusCflags} CACHE INTERNAL "Definitions for Qt DBUS")
set(QDBUS_INCLUDE_DIRS ${_dbusIncDir} ${_qdbusIncDir} CACHE INTERNAL "Include dirs for Qt DBUS")

FIND_LIBRARY(QDBUS_LIBRARIES NAMES dbus-qt4-1
  PATHS ${_qdbusLinkDir}
)

if (QDBUS_INCLUDE_DIRS AND QDBUS_LIBRARIES)
   set(QDBUS_FOUND TRUE)
endif (QDBUS_INCLUDE_DIRS AND QDBUS_LIBRARIES)

message(STATUS "QtDBus Results: ${QDBUS_LIBRARIES} ${QDBUS_INCLUDE_DIRS} ${QDBUS_DEFINITIONS}")
if (QDBUS_FOUND)
  if (NOT QDBUS_FIND_QUIETLY)
    message(STATUS "Found QtDBus: ${QDBUS_LIBRARIES}")
  endif (NOT QDBUS_FIND_QUIETLY)
else (QDBUS_FOUND)
  message(STATUS "You need the CVS version of D-BUS library. The one that your distribution installed, even if it's 0.61, probably won't be enough to compile QtDBus.")
  message(STATUS "You need the Subversion or CVS version of QtDBus. It's official home is now in trunk/kdesupport/")
  message(STATUS "See also the PORTING-TO-DBUS.txt file in kdelibs/")
  message(FATAL_ERROR "Could NOT find QtDBus")
endif (QDBUS_FOUND)

find_program(QDBUS_IDL2CPP_EXECUTABLE NAME dbusidl2cpp PATHS)
find_program(QDBUS_CPP2XML_EXECUTABLE NAME dbuscpp2xml PATHS)

include( QtDBusMacros )
