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
SET(QDBUS_FOUND)
SET(QDBUS_INCLUDE_DIRS ${QT_DBUS_INCLUDE_DIR})
SET(QDBUS_LIBRARIES ${QT_QTDBUS_LIBRARY_DEBUG})
SET(QDBUS_DEFINITIONS -I${QDBUS_INCLUDE_DIRS})
SET(QDBUS_IDL2CPP_EXECUTABLE)
SET(QDBUS_CPP2XML_EXECUTABLE)
