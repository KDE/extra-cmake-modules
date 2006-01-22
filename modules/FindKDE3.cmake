# - Find the KDE3 include and library dirs, KDE preprocessors and define a some macros
#
# KDE3_DEFINITIONS
# KDE3_INCLUDE_DIR
# KDE3_INCLUDE_DIRS
# KDE3_LIB_DIR
# KDE3_SERVICETYPES_DIR
# KDE3_DCOPIDL_EXECUTABLE
# KDE3_DCOPIDL2CPP_EXECUTABLE
# KDE3_KCFGC_EXECUTABLE
# KDE3_FOUND
# it also adds the following macros (from KDE3Macros.cmake)
# ADD_FILE_DEPENDANCY
# KDE3_ADD_DCOP_SKELS
# KDE3_ADD_DCOP_STUBS
# KDE3_ADD_MOC_FILES
# KDE3_ADD_UI_FILES
# KDE3_ADD_KCFG_FILES
# KDE3_AUTOMOC
# KDE3_PLACEHOLDER
# KDE3_CREATE_LIBTOOL_FILE
# KDE3_CREATE_FINAL_FILE
# KDE3_ADD_KPART
# KDE3_ADD_KLM
# KDE3_ADD_EXECUTABLE


CMAKE_MINIMUM_REQUIRED(VERSION 2.2)

SET(QT_MT_REQUIRED TRUE)
#SET(QT_MIN_VERSION "3.0.0")

#this line includes FindQt.cmake, which searches the Qt library and headers
INCLUDE(FindQt3)

#add the definitions found by FindQt to the current definitions
#ADD_DEFINITIONS(${QT_DEFINITIONS} -DQT_CLEAN_NAMESPACE)

SET(QT_AND_KDECORE_LIBS ${QT_LIBRARIES} kdecore)

#add some KDE specific stuff
SET(KDE3_DEFINITIONS -DQT_CLEAN_NAMESPACE -Wnon-virtual-dtor -Wno-long-long -Wundef -ansi -Wcast-align -Wconversion -Wchar-subscripts -Wall -W -Wpointer-arith -Wwrite-strings -O2 -Wformat-security -Wmissing-format-attribute -fno-exceptions -fno-check-new -fno-common)

#only on linux, but not e.g. on FreeBSD:
IF(${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
  SET(KDE3_DEFINITIONS ${KDE3_DEFINITIONS} -D_XOPEN_SOURCE=500 -D_BSD_SOURCE -D_GNU_SOURCE)
ENDIF(${CMAKE_SYSTEM_NAME} STREQUAL "Linux")


#SET(CMAKE_SHARED_LINKER_FLAGS "-avoid-version -module -Wl,--no-undefined -Wl,--allow-shlib-undefined")
#SET(CMAKE_SHARED_LINKER_FLAGS "-Wl,--fatal-warnings -avoid-version -Wl,--no-undefined -lc")
#SET(CMAKE_MODULE_LINKER_FLAGS "-Wl,--fatal-warnings -avoid-version -Wl,--no-undefined -lc")

#now try to find some kde stuff

#at first the KDE include direcory
FIND_PATH(KDE3_INCLUDE_DIR kurl.h
  $ENV{KDEDIR}/include
  /opt/kde/include
  /opt/kde3/include
  /usr/local/include
  /usr/include/
  /usr/include/kde
  /usr/local/include/kde
)

#now the KDE library directory
FIND_PATH(KDE3_LIB_DIR libkdecore.so
  $ENV{KDEDIR}/lib
  /opt/kde/lib
  /opt/kde3/lib
  /usr/lib
  /usr/local/lib
)

#now the KDE service types directory
FIND_PATH(KDE3_SERVICETYPES_DIR ktexteditor.desktop
  $ENV{KDEDIR}/share/servicetypes/
  /opt/kde/share/servicetypes/
  /opt/kde3/share/servicetypes/
)

#now search for the dcop utilities
FIND_PROGRAM(KDE3_DCOPIDL_EXECUTABLE NAME dcopidl PATHS
  $ENV{KDEDIR}/bin
  /opt/kde/bin
  /opt/kde3/bin
  )

FIND_PROGRAM(KDE3_DCOPIDL2CPP_EXECUTABLE NAME dcopidl2cpp PATHS
  $ENV{KDEDIR}/bin
  /opt/kde/bin
  /opt/kde3/bin)

FIND_PROGRAM(KDE3_KCFGC_EXECUTABLE NAME kconfig_compiler PATHS
  $ENV{KDEDIR}/bin
  /opt/kde/bin
  /opt/kde3/bin)

# KDE3Macros.cmake contains all the KDE specific macros
INCLUDE(KDE3Macros)

#set KDE3_FOUND
IF (KDE3_INCLUDE_DIR AND KDE3_LIB_DIR AND KDE3_SERVICETYPES_DIR AND KDE3_DCOPIDL_EXECUTABLE AND KDE3_DCOPIDL2CPP_EXECUTABLE AND KDE3_KCFGC_EXECUTABLE)
   SET(KDE3_FOUND TRUE)
ELSE (KDE3_INCLUDE_DIR AND KDE3_LIB_DIR AND KDE3_SERVICETYPES_DIR AND KDE3_DCOPIDL_EXECUTABLE AND KDE3_DCOPIDL2CPP_EXECUTABLE AND KDE3_KCFGC_EXECUTABLE)
   SET(KDE3_FOUND FALSE)
ENDIF (KDE3_INCLUDE_DIR AND KDE3_LIB_DIR AND KDE3_SERVICETYPES_DIR AND KDE3_DCOPIDL_EXECUTABLE AND KDE3_DCOPIDL2CPP_EXECUTABLE AND KDE3_KCFGC_EXECUTABLE)


MACRO (KDE3_PRINT_RESULTS)
   IF(KDE3_INCLUDE_DIR)
      MESSAGE(STATUS "Found KDE3 include dir: ${KDE3_INCLUDE_DIR}")
   ELSE(KDE3_INCLUDE_DIR)
      MESSAGE(STATUS "Didn't find KDE3 headers")
   ENDIF(KDE3_INCLUDE_DIR)

   IF(KDE3_LIB_DIR)
      MESSAGE(STATUS "Found KDE3 library dir: ${KDE3_LIB_DIR}")
   ELSE(KDE3_LIB_DIR)
      MESSAGE(STATUS "Didn't find KDE3 core library")
   ENDIF(KDE3_LIB_DIR)

   IF(KDE3_DCOPIDL_EXECUTABLE)
      MESSAGE(STATUS "Found KDE3 dcopidl preprocessor: ${KDE3_DCOPIDL_EXECUTABLE}")
   ELSE(KDE3_DCOPIDL_EXECUTABLE)
      MESSAGE(STATUS "Didn't find the KDE3 dcopidl preprocessor")
   ENDIF(KDE3_DCOPIDL_EXECUTABLE)

   IF(KDE3_DCOPIDL2CPP_EXECUTABLE)
      MESSAGE(STATUS "Found KDE3 dcopidl2cpp preprocessor: ${KDE3_DCOPIDL2CPP_EXECUTABLE}")
   ELSE(KDE3_DCOPIDL2CPP_EXECUTABLE)
      MESSAGE(STATUS "Didn't find the KDE3 dcopidl2cpp preprocessor")
   ENDIF(KDE3_DCOPIDL2CPP_EXECUTABLE)

   IF(KDE3_KCFGC_EXECUTABLE)
      MESSAGE(STATUS "Found KDE3 kconfig_compiler preprocessor: ${KDE3_KCFGC_EXECUTABLE}")
   ELSE(KDE3_KCFGC_EXECUTABLE)
      MESSAGE(STATUS "Didn't find the KDE3 kconfig_compiler preprocessor")
   ENDIF(KDE3_KCFGC_EXECUTABLE)

ENDMACRO (KDE3_PRINT_RESULTS)

IF (KDE3_FIND_REQUIRED AND NOT KDE3_FOUND)
   #bail out if something wasn't found
   KDE3_PRINT_RESULTS()
   MESSAGE(FATAL_ERROR "Could not find everything required for compiling KDE 3 programs")

ENDIF (KDE3_FIND_REQUIRED AND NOT KDE3_FOUND)

IF (NOT KDE3_FIND_QUIETLY)
   KDE3_PRINT_RESULTS()
ENDIF (NOT KDE3_FIND_QUIETLY)

#add the found Qt and KDE include directories to the current include path
SET(KDE3_INCLUDE_DIRS ${QT_INCLUDE_DIR} ${KDE3_INCLUDE_DIR})
#INCLUDE_DIRECTORIES(${QT_INCLUDE_DIR} ${KDE3_INCLUDE_DIR} .)
#LINK_DIRECTORIES(${KDE3_LIB_DIR})

