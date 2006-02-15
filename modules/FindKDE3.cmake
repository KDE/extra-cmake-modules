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

set(QT_MT_REQUIRED TRUE)
#set(QT_MIN_VERSION "3.0.0")

#this line includes FindQt.cmake, which searches the Qt library and headers
FIND_PACKAGE(Qt3 REQUIRED)
FIND_PACKAGE(X11 REQUIRED)

#add the definitions found by FindQt to the current definitions
#ADD_DEFINITIONS(${QT_DEFINITIONS} -DQT_CLEAN_NAMESPACE)

set(QT_AND_KDECORE_LIBS ${QT_LIBRARIES} kdecore)

#add some KDE specific stuff
set(KDE3_DEFINITIONS -DQT_CLEAN_NAMESPACE -Wnon-virtual-dtor -Wno-long-long -Wundef -ansi -Wcast-align -Wconversion -Wchar-subscripts -Wall -W -Wpointer-arith -Wwrite-strings -O2 -Wformat-security -Wmissing-format-attribute -fno-exceptions -fno-check-new -fno-common)

#only on linux, but NOT e.g. on FreeBSD:
if(CMAKE_SYSTEM_NAME MATCHES "Linux")
  set(KDE3_DEFINITIONS ${KDE3_DEFINITIONS} -D_XOPEN_SOURCE=500 -D_BSD_SOURCE -D_GNU_SOURCE)
endif(CMAKE_SYSTEM_NAME MATCHES "Linux")


#set(CMAKE_SHARED_LINKER_FLAGS "-avoid-version -module -Wl,--no-undefined -Wl,--allow-shlib-undefined")
#set(CMAKE_SHARED_LINKER_FLAGS "-Wl,--fatal-warnings -avoid-version -Wl,--no-undefined -lc")
#set(CMAKE_MODULE_LINKER_FLAGS "-Wl,--fatal-warnings -avoid-version -Wl,--no-undefined -lc")

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
FIND_LIBRARY(KDE3_LIB_DIR NAMES kdecore
  PATHS
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
if (KDE3_INCLUDE_DIR AND KDE3_LIB_DIR AND KDE3_SERVICETYPES_DIR AND KDE3_DCOPIDL_EXECUTABLE AND KDE3_DCOPIDL2CPP_EXECUTABLE AND KDE3_KCFGC_EXECUTABLE)
   set(KDE3_FOUND TRUE)
else (KDE3_INCLUDE_DIR AND KDE3_LIB_DIR AND KDE3_SERVICETYPES_DIR AND KDE3_DCOPIDL_EXECUTABLE AND KDE3_DCOPIDL2CPP_EXECUTABLE AND KDE3_KCFGC_EXECUTABLE)
   set(KDE3_FOUND FALSE)
endif (KDE3_INCLUDE_DIR AND KDE3_LIB_DIR AND KDE3_SERVICETYPES_DIR AND KDE3_DCOPIDL_EXECUTABLE AND KDE3_DCOPIDL2CPP_EXECUTABLE AND KDE3_KCFGC_EXECUTABLE)


MACRO (KDE3_PRINT_RESULTS)
   if(KDE3_INCLUDE_DIR)
      message(STATUS "Found KDE3 include dir: ${KDE3_INCLUDE_DIR}")
   else(KDE3_INCLUDE_DIR)
      message(STATUS "Didn't find KDE3 headers")
   endif(KDE3_INCLUDE_DIR)

   if(KDE3_LIB_DIR)
      message(STATUS "Found KDE3 library dir: ${KDE3_LIB_DIR}")
   else(KDE3_LIB_DIR)
      message(STATUS "Didn't find KDE3 core library")
   endif(KDE3_LIB_DIR)

   if(KDE3_DCOPIDL_EXECUTABLE)
      message(STATUS "Found KDE3 dcopidl preprocessor: ${KDE3_DCOPIDL_EXECUTABLE}")
   else(KDE3_DCOPIDL_EXECUTABLE)
      message(STATUS "Didn't find the KDE3 dcopidl preprocessor")
   endif(KDE3_DCOPIDL_EXECUTABLE)

   if(KDE3_DCOPIDL2CPP_EXECUTABLE)
      message(STATUS "Found KDE3 dcopidl2cpp preprocessor: ${KDE3_DCOPIDL2CPP_EXECUTABLE}")
   else(KDE3_DCOPIDL2CPP_EXECUTABLE)
      message(STATUS "Didn't find the KDE3 dcopidl2cpp preprocessor")
   endif(KDE3_DCOPIDL2CPP_EXECUTABLE)

   if(KDE3_KCFGC_EXECUTABLE)
      message(STATUS "Found KDE3 kconfig_compiler preprocessor: ${KDE3_KCFGC_EXECUTABLE}")
   else(KDE3_KCFGC_EXECUTABLE)
      message(STATUS "Didn't find the KDE3 kconfig_compiler preprocessor")
   endif(KDE3_KCFGC_EXECUTABLE)

ENDMACRO (KDE3_PRINT_RESULTS)

if (KDE3_FIND_REQUIRED AND NOT KDE3_FOUND)
   #bail out if something wasn't found
   KDE3_PRINT_RESULTS()
   message(FATAL_ERROR "Could NOT find everything required for compiling KDE 3 programs")

endif (KDE3_FIND_REQUIRED AND NOT KDE3_FOUND)

if (NOT KDE3_FIND_QUIETLY)
   KDE3_PRINT_RESULTS()
endif (NOT KDE3_FIND_QUIETLY)

#add the found Qt and KDE include directories to the current include path
set(KDE3_INCLUDE_DIRS ${QT_INCLUDE_DIR} ${KDE3_INCLUDE_DIR})
#INCLUDE_DIRECTORIES(${QT_INCLUDE_DIR} ${KDE3_INCLUDE_DIR} .)
#LINK_DIRECTORIES(${KDE3_LIB_DIR})

