# - Find the KDE4 include and library dirs, KDE preprocessors and define a some macros
#
# KDE4_DEFINITIONS
# KDE4_INCLUDE_DIR
# KDE4_INCLUDE_DIRS
# KDE4_LIB_DIR
# KDE4_SERVICETYPES_DIR
# KDE4_DCOPIDL_EXECUTABLE
# KDE4_DCOPIDL2CPP_EXECUTABLE
# KDE4_KCFGC_EXECUTABLE
# KDE4_FOUND
# it also adds the following macros (from KDE4Macros.cmake)
# ADD_FILE_DEPENDANCY
# KDE4_ADD_DCOP_SKELS
# KDE4_ADD_DCOP_STUBS
# KDE4_ADD_MOC_FILES
# KDE4_ADD_UI_FILES
# KDE4_ADD_KCFG_FILES
# KDE4_AUTOMOC
# KDE4_PLACEHOLDER
# KDE4_INSTALL_LIBTOOL_FILE
# KDE4_CREATE_FINAL_FILE
# KDE4_ADD_KPART
# KDE4_ADD_KLM
# KDE4_ADD_EXECUTABLE
#
# _KDE4_PLATFORM_INCLUDE_DIRS is used only internally
# _KDE4_PLATFORM_DEFINITIONS is used only internally


CMAKE_MINIMUM_REQUIRED(VERSION 2.3.3)

#this line includes FindQt.cmake, which searches the Qt library and headers
FIND_PACKAGE(Qt4 REQUIRED)

set(QT_AND_KDECORE_LIBS ${QT_QTCORE_LIBRARY} kdecore)

INCLUDE (MacroLibrary)

#add some KDE specific stuff


set(KDE4_DIR               ${CMAKE_INSTALL_PREFIX})
set(KDE4_APPS_DIR          /share/applnk)
set(KDE4_CONFIG_DIR        /share/config)
set(KDE4_DATA_DIR          /share/apps)
set(KDE4_HTML_DIR          /share/doc/HTML)
set(KDE4_ICON_DIR          /share/icons)
set(KDE4_KCFG_DIR          /share/config.kcfg)
set(KDE4_LIBS_HTML_DIR     /share/doc/HTML)
set(KDE4_LOCALE_DIR        /share/locale)
set(KDE4_MIME_DIR          /share/mimelnk)
set(KDE4_SERVICES_DIR      /share/services)
set(KDE4_SERVICETYPES_DIR  /share/servicetypes)
set(KDE4_SOUND_DIR         /share/sounds)
set(KDE4_TEMPLATES_DIR     /share/templates)
set(KDE4_WALLPAPER_DIR     /share/wallpapers)
set(KDE4_KCONF_UPDATE_DIR	/share/apps/kconf_update/ )
set(XDG_APPS_DIR           /share/applications/kde)
set(XDG_DIRECTORY_DIR      /share/desktop-directories)


# the following are directories where stuff will be installed to
#set(KDE4_SYSCONF_INSTALL_DIR "/etc" CACHE STRING "The kde sysconfig install dir (default /etc)")
set(KDE4_MAN_INSTALL_DIR     "/man"      CACHE STRING "The kde man install dir (default prefix/man/)")
set(KDE4_INFO_INSTALL_DIR    "/info"     CACHE STRING "The kde info install dir (default prefix/info)")
set(KDE4_LIB_INSTALL_DIR     "/lib"      CACHE STRING "The subdirectory relative to the install prefix where libraries will be installed (default is /lib)")
set(KDE4_PLUGIN_INSTALL_DIR  "${KDE4_LIB_INSTALL_DIR}/kde4" CACHE STRING "The subdirectory relative to the install prefix where plugins will be installed (default is ${KDE4_LIB_INSTALL_DIR}/kde4)")




#now try to find some kde stuff

#are we trying to compile kdelibs ?
#then enter bootstrap mode
if(EXISTS ${CMAKE_SOURCE_DIR}/kdecore/kglobal.h)

  message(STATUS "Building kdelibs...")

  set(KDE4_INCLUDE_DIR ${CMAKE_SOURCE_DIR})

  set(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR}/bin )
  
  # adjust dcopidl and the library output path depending on the platform
  if (WIN32)
     # under windows dcopidl.bat has to be used, except when using MSYS, then the perl script has to be used, Alex
     if ("${CMAKE_GENERATOR}" MATCHES "MSYS")
        set(KDE4_DCOPIDL_EXECUTABLE ${CMAKE_SOURCE_DIR}/dcop/dcopidlng/dcopidl )
     else ("${CMAKE_GENERATOR}" MATCHES "MSYS")
        set(KDE4_DCOPIDL_EXECUTABLE call ${CMAKE_SOURCE_DIR}/dcop/dcopidlng/dcopidl.bat )
     endif ("${CMAKE_GENERATOR}" MATCHES "MSYS")
  
     set(LIBRARY_OUTPUT_PATH  ${EXECUTABLE_OUTPUT_PATH} )
  else (WIN32)
     set(KDE4_DCOPIDL_EXECUTABLE ${CMAKE_SOURCE_DIR}/dcop/dcopidlng/dcopidl )
     set(LIBRARY_OUTPUT_PATH  ${CMAKE_BINARY_DIR}/lib )
  endif (WIN32)

  set(KDE4_LIB_DIR ${LIBRARY_OUTPUT_PATH})
  set(KDE4_KALYPTUS_DIR ${CMAKE_SOURCE_DIR}/dcop/dcopidlng/ )
  
  # CMAKE_CFG_INTDIR is the output subdirectory created e.g. by XCode and MSVC
  set(KDE4_DCOPIDL2CPP_EXECUTABLE ${EXECUTABLE_OUTPUT_PATH}/${CMAKE_CFG_INTDIR}/dcopidl2cpp )
  set(KDE4_KCFGC_EXECUTABLE ${EXECUTABLE_OUTPUT_PATH}/${CMAKE_CFG_INTDIR}/kconfig_compiler )

  # when building kdelibs, make the dcop and kcfg rules depend on the binaries...
  set( _KDE4_DCOPIDL2CPP_DEP dcopidl2cpp)
  set( _KDE4_KCONFIG_COMPILER_DEP kconfig_compiler)
  

else(EXISTS ${CMAKE_SOURCE_DIR}/kdecore/kglobal.h)

  # ... but NOT otherwise
  set( _KDE4_DCOPIDL2CPP_DEP )
  set( _KDE4_KCONFIG_COMPILER_DEP)

  # at first the KDE include direcory
  # this should better check for a header which didn't exist in KDE < 4
  FIND_PATH(KDE4_INCLUDE_DIR kurl.h
    $ENV{KDEDIR}/include
    /opt/kde/include
    /opt/kde4/include
    /usr/local/include
    /usr/include/
    /usr/include/kde
    /usr/local/include/kde
  )

  # now the KDE library directory, kxmlcore is new with KDE4
  FIND_LIBRARY(KDE4_XMLCORE_LIBRARY NAMES kxmlcore
  PATHS
    $ENV{KDEDIR}/lib
    /opt/kde/lib
    /opt/kde4/lib
    /usr/lib
    /usr/local/lib
  )

  GET_FILENAME_COMPONENT(KDE4_LIB_DIR ${KDE4_XMLCORE_LIBRARY} PATH )

  #now search for the dcop utilities
  FIND_PROGRAM(KDE4_DCOPIDL_EXECUTABLE NAME dcopidl PATHS
    $ENV{KDEDIR}/bin
    /opt/kde/bin
    /opt/kde4/bin
  )

  FIND_PATH(KDE4_KALYPTUS_DIR kalyptus
    $ENV{KDEDIR}/share/apps/dcopidl
    /opt/kde/share/apps/dcopidl
    /opt/kde4/share/apps/dcopidl
  )

  FIND_PROGRAM(KDE4_DCOPIDL2CPP_EXECUTABLE NAME dcopidl2cpp PATHS
    $ENV{KDEDIR}/bin
    /opt/kde/bin
    /opt/kde4/bin
  )

  FIND_PROGRAM(KDE4_KCFGC_EXECUTABLE NAME kconfig_compiler PATHS
    $ENV{KDEDIR}/bin
    /opt/kde/bin
    /opt/kde4/bin
  )

endif(EXISTS ${CMAKE_SOURCE_DIR}/kdecore/kglobal.h)


# this is  already in cmake cvs and can be removed once we require it
if (WIN32)
   GET_FILENAME_COMPONENT(_tmp_COMPILER_NAME ${CMAKE_CXX_COMPILER} NAME_WE)
   if ( _tmp_COMPILER_NAME MATCHES cl )
      set(MSVC TRUE)
   endif ( _tmp_COMPILER_NAME MATCHES cl )
endif (WIN32)

#####################  and now the platform specific stuff  ############################


if(UNIX AND NOT APPLE)
   FIND_PACKAGE(X11 REQUIRED)
   set(_KDE4_PLATFORM_INCLUDE_DIRS ${X11_INCLUDE_DIR} )
endif(UNIX AND NOT APPLE)



if (WIN32)



   if(CYGWIN)
      message(FATAL_ERROR "Support for Cygwin NOT yet implemented, please edit FindKDE4.cmake to enable it")
   endif(CYGWIN)

   FIND_PACKAGE(KDEWIN32 REQUIRED)
   
   set( _KDE4_PLATFORM_INCLUDE_DIRS ${KDEWIN32_INCLUDES})
   set( QT_AND_KDECORE_LIBS ${QT_AND_KDECORE_LIBS} ${KDEWIN32_LIBRARIES} )
     
   # windows, mingw
   if(MINGW)
   #hmmm, something special to do here ?
   endif(MINGW)
   
   # windows, microsoft compiler
   if(MSVC)
      set( _KDE4_PLATFORM_DEFINITIONS -DKDE_FULL_TEMPLATE_EXPORT_INSTANTIATION -DWIN32_LEAN_AND_MEAN -DUNICODE )
   endif(MSVC)

endif (WIN32)


# only on linux, but NOT e.g. on FreeBSD:
if(CMAKE_SYSTEM_NAME MATCHES Linux)
  set ( _KDE4_PLATFORM_DEFINITIONS -D_XOPEN_SOURCE=500 -D_BSD_SOURCE -D_GNU_SOURCE)
  set ( CMAKE_SHARED_LINKER_FLAGS "-Wl,--fatal-warnings -avoid-version -Wl,--no-undefined -lc")
  set ( CMAKE_MODULE_LINKER_FLAGS "-Wl,--fatal-warnings -avoid-version -Wl,--no-undefined -lc")
  set ( CMAKE_C_FLAGS     "${CMAKE_C_FLAGS} -Wno-long-long -ansi -Wundef -Wcast-align -Wconversion -Wchar-subscripts -Wall -W -Wpointer-arith -Wwrite-strings -O2 -Wformat-security -Wmissing-format-attribute -fno-common")
  set ( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wnon-virtual-dtor -Wno-long-long -ansi -Wundef -Wcast-align -Wconversion -Wchar-subscripts -Wall -W -Wpointer-arith -Wwrite-strings -O2 -Wformat-security -fno-exceptions -fno-check-new -fno-common")
endif(CMAKE_SYSTEM_NAME MATCHES Linux)


# works on FreeBSD, NOT tested on NetBSD and OpenBSD
if(CMAKE_SYSTEM_NAME MATCHES BSD)
  set ( _KDE4_PLATFORM_DEFINITIONS -D_GNU_SOURCE )
  set ( CMAKE_SHARED_LINKER_FLAGS "-avoid-version -lc")
  set ( CMAKE_MODULE_LINKER_FLAGS "-avoid-version -lc")
  set ( CMAKE_C_FLAGS     "${CMAKE_C_FLAGS} -Wno-long-long -ansi -Wundef -Wcast-align -Wconversion -Wchar-subscripts -Wall -W -Wpointer-arith -Wwrite-strings -O2 -Wformat-security -Wmissing-format-attribute -fno-common")
  set ( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wnon-virtual-dtor -Wno-long-long -Wundef -Wcast-align -Wconversion -Wchar-subscripts -Wall -W -Wpointer-arith -Wwrite-strings -O2 -Wformat-security -Wmissing-format-attribute -fno-exceptions -fno-check-new -fno-common")
endif(CMAKE_SYSTEM_NAME MATCHES BSD)


# This will need to be modified later to support either Qt/X11 or Qt/Mac builds
if(APPLE)

  set ( _KDE4_PLATFORM_DEFINITIONS -D__APPLE_KDE__ )

  # we need to set MACOSX_DEPLOYMENT_TARGET to (I believe) at least 10.2 or maybe 10.3 to allow
  # -undefined dynamic_lookup; in the future we should do this programmatically
  # hmm... why doesn't this work?
  set (ENV{MACOSX_DEPLOYMENT_TARGET} 10.3)

  # "-undefined dynamic_lookup" means we don't care about missing symbols at link-time by default
  # this is bad, but unavoidable until there is the equivalent of libtool -no-undefined implemented
  # or perhaps it already is, and I just don't know where to look  ;)

  set (CMAKE_SHARED_LINKER_FLAGS "-single_module -multiply_defined suppress")
  set (CMAKE_MODULE_LINKER_FLAGS "-multiply_defined suppress")
  #set(CMAKE_SHARED_LINKER_FLAGS "-single_module -undefined dynamic_lookup -multiply_defined suppress")
  #set(CMAKE_MODULE_LINKER_FLAGS "-undefined dynamic_lookup -multiply_defined suppress")

  set (CMAKE_C_FLAGS     "${CMAKE_C_FLAGS} -fno-common -Os")
  set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-common -Os")
endif(APPLE)

###########    end of platform specific stuff  ##########################


# KDE4Macros.cmake contains all the KDE specific macros
INCLUDE(KDE4Macros)


# decide whether KDE4 has been found
if (KDE4_INCLUDE_DIR AND KDE4_LIB_DIR AND KDE4_SERVICETYPES_DIR AND KDE4_DCOPIDL_EXECUTABLE AND KDE4_DCOPIDL2CPP_EXECUTABLE AND KDE4_KCFGC_EXECUTABLE)
   set(KDE4_FOUND TRUE)
else (KDE4_INCLUDE_DIR AND KDE4_LIB_DIR AND KDE4_SERVICETYPES_DIR AND KDE4_DCOPIDL_EXECUTABLE AND KDE4_DCOPIDL2CPP_EXECUTABLE AND KDE4_KCFGC_EXECUTABLE)
   set(KDE4_FOUND FALSE)
endif (KDE4_INCLUDE_DIR AND KDE4_LIB_DIR AND KDE4_SERVICETYPES_DIR AND KDE4_DCOPIDL_EXECUTABLE AND KDE4_DCOPIDL2CPP_EXECUTABLE AND KDE4_KCFGC_EXECUTABLE)


MACRO (KDE4_PRINT_RESULTS)
   if(KDE4_INCLUDE_DIR)
      message(STATUS "Found KDE4 include dir: ${KDE4_INCLUDE_DIR}")
   else(KDE4_INCLUDE_DIR)
      message(STATUS "Didn't find KDE4 headers")
   endif(KDE4_INCLUDE_DIR)

   if(KDE4_LIB_DIR)
      message(STATUS "Found KDE4 library dir: ${KDE4_LIB_DIR}")
   else(KDE4_LIB_DIR)
      message(STATUS "Didn't find KDE4 core library")
   endif(KDE4_LIB_DIR)

   if(KDE4_DCOPIDL_EXECUTABLE)
      message(STATUS "Found KDE4 dcopidl preprocessor: ${KDE4_DCOPIDL_EXECUTABLE}")
   else(KDE4_DCOPIDL_EXECUTABLE)
      message(STATUS "Didn't find the KDE4 dcopidl preprocessor")
   endif(KDE4_DCOPIDL_EXECUTABLE)

   if(KDE4_DCOPIDL2CPP_EXECUTABLE)
      message(STATUS "Found KDE4 dcopidl2cpp preprocessor: ${KDE4_DCOPIDL2CPP_EXECUTABLE}")
   else(KDE4_DCOPIDL2CPP_EXECUTABLE)
      message(STATUS "Didn't find the KDE4 dcopidl2cpp preprocessor")
   endif(KDE4_DCOPIDL2CPP_EXECUTABLE)

   if(KDE4_KCFGC_EXECUTABLE)
      message(STATUS "Found KDE4 kconfig_compiler preprocessor: ${KDE4_KCFGC_EXECUTABLE}")
   else(KDE4_KCFGC_EXECUTABLE)
      message(STATUS "Didn't find the KDE4 kconfig_compiler preprocessor")
   endif(KDE4_KCFGC_EXECUTABLE)
ENDMACRO (KDE4_PRINT_RESULTS)


if (KDE4_FIND_REQUIRED AND NOT KDE4_FOUND)
   #bail out if something wasn't found
   KDE4_PRINT_RESULTS()
   message(FATAL_ERROR "Could NOT find everything required for compiling KDE 4 programs")
endif (KDE4_FIND_REQUIRED AND NOT KDE4_FOUND)


if (NOT KDE4_FIND_QUIETLY)
   KDE4_PRINT_RESULTS()
endif (NOT KDE4_FIND_QUIETLY)

#add the found Qt and KDE include directories to the current include path
set(KDE4_INCLUDE_DIRS ${QT_INCLUDES} ${KDE4_INCLUDE_DIR} ${_KDE4_PLATFORM_INCLUDE_DIRS} )

# NOT used in Qt4: QT_NO_COMPAT, QT_CLEAN_NAMESPACE, QT_THREAD_SUPPORT
set(KDE4_DEFINITIONS ${_KDE4_PLATFORM_DEFINITIONS} -DQT3_SUPPORT -DQT_NO_STL -DQT_NO_CAST_TO_ASCII -D_REENTRANT -DQT3_SUPPORT_WARNINGS )
