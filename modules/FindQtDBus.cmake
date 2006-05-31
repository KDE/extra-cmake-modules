# - Try to find the QtDBus module
# Once done this will define
#
#  QDBUS_FOUND - system has QtDBus
#  QDBUS_INCLUDE_DIR - the QtDBus include directory
#  QDBUS_LIBRARIES - Link these to use QtDBus
#  QDBUS_DEFINITIONS - Compiler switches required for using QtDBus
#


# use pkg-config to get the directories and then use these values
# in the FIND_PATH() and FIND_LIBRARY() calls
INCLUDE(UsePkgConfig)

PKGCONFIG("dbus-1" _dbusIncDir _dbusLinkDir _dbusLinkFlags _dbusCflags)
PKGCONFIG("dbus-qt4-1" _qdbusIncDir _qdbusLinkDir _qdbusLinkFlags _qdbusCflags)

set(QDBUS_DEFINITIONS ${_dbusCflags} ${_qdbusCflags})
set(QDBUS_INCLUDE_DIRS ${_dbusIncDir} ${_qdbusIncDir})

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
  message(FATAL_ERROR "Could NOT find QtDBus")
endif (QDBUS_FOUND)
