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

if (QDBUS_INCLUDE_DIRS AND QDBUS_LIBRARIES)

   # already in cache
   set(QDBUS_FOUND TRUE)

else (QDBUS_INCLUDE_DIRS AND QDBUS_LIBRARIES)

   if (WIN32)
       find_file(QDBUS_DIR qt-dbus
          ${_progFiles}
          "C:/"
       )
       set(QDBUS_DEFINITIONS CACHE INTERNAL "Definitions for Qt DBUS")
       set(QDBUS_INCLUDE_DIRS "${QDBUS_DIR}/include/dbus-1.0" CACHE INTERNAL "Include dirs for Qt DBUS")

       FIND_LIBRARY(QDBUS_LIBRARIES NAMES dbus-qt4-1
         PATHS "${QDBUS_DIR}/lib"
       )           
       # how to add specific pathes to find_program, using PATHS seems not to work on win32
       # find_program(QDBUS_IDL2CPP_EXECUTABLE NAME dbusidl2cpp PATHS "${QDBUS_DIR}/bin")
       find_file(QDBUS_IDL2CPP_EXECUTABLE dbusidl2cpp.exe "${QDBUS_DIR}/bin")
       find_file(QDBUS_CPP2XML_EXECUTABLE dbuscpp2xml.exe "${QDBUS_DIR}/bin")
      
   else (WIN32)
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

   endif (WIN32)

   if (QDBUS_INCLUDE_DIRS AND QDBUS_LIBRARIES)
      set(QDBUS_FOUND TRUE)
   endif (QDBUS_INCLUDE_DIRS AND QDBUS_LIBRARIES)

   message(STATUS "QtDBus Results: ${QDBUS_LIBRARIES} ${QDBUS_INCLUDE_DIRS} ${QDBUS_DEFINITIONS}")
   if (QDBUS_FOUND)
     if (NOT QDBUS_FIND_QUIETLY)
       message(STATUS "Found QtDBus: ${QDBUS_LIBRARIES}")
     endif (NOT QDBUS_FIND_QUIETLY)
   else (QDBUS_FOUND)
     message(STATUS "You need D-BUS 0.62 or newer with Qt4 bindings enabled.")
     message(STATUS "See also the PORTING-TO-DBUS.txt file in kdelibs/")
     message(FATAL_ERROR "Could NOT find QtDBus")
   endif (QDBUS_FOUND)

endif(QDBUS_INCLUDE_DIRS AND QDBUS_LIBRARIES)

if (NOT WIN32)
    find_program(QDBUS_IDL2CPP_EXECUTABLE NAME dbusidl2cpp PATHS )
    find_program(QDBUS_CPP2XML_EXECUTABLE NAME dbuscpp2xml PATHS )
endif (NOT WIN32)
include( QtDBusMacros )
