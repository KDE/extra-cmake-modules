# - Find the KDE4 include and library dirs, KDE preprocessors and define a some macros
#
# This module defines the following variables:
#
# KDE4_FOUND               - set to TRUE if everything required for building KDE software has been found
#
# KDE4_DEFINITIONS         - compiler definitions required for compiling KDE software
# KDE4_INCLUDE_DIR         - the KDE 4 include directory
# KDE4_INCLUDES            - all include directories required for KDE, i.e. 
#                            KDE4_INCLUDE_DIR, but also the Qt4 include directories 
#                            and other platform specific include directories
# KDE4_LIB_DIR             - the directory where the KDE libraries are installed,
#                            intended to be used with LINK_DIRECTORIES()
#
# The following variables are defined for the various tools required to
# compile KDE software:
#
# KDE4_DCOPIDL_EXECUTABLE  - the dcopidl executable
# KDE4_DCOPIDL2CPP_EXECUTABLE - the dcopidl2cpp executable
# KDE4_KCFGC_EXECUTABLE    - the kconfig_compiler executable
# KDE4_MEINPROC_EXECUTABLE - the meinproc executable
# KDE4_MAKEKDEWIDGETS_EXECUTABLE - the makekdewidgets executable
#
# The following variables point to the location of the KDE libraries,
# but shouldn't be used directly:
#
# KDE4_KDECORE_LIBRARY     - the kdecore library
# KDE4_KDEUI_LIBRARY       - the kdeui library
# KDE4_KIO_LIBRARY         - the kio library
# KDE4_KPARTS_LIBRARY      - the kparts library
# KDE4_KUTILS_LIBRARY      - the kutils library
# KDE4_KDE3SUPPORT_LIBRARY - the kde3support library
# KDE4_KXMLCORE_LIBRARY    - the kxmlcore library
# KDE4_KHTML_LIBRARY       - the khtml library
# KDE4_KJS_LIBRARY         - the kjs library
# KDE4_KNEWSTUFF_LIBRARY   - the knewstuff library
# KDE4_DCOP_LIBRARY        - the DCOP library
# KDE4_KDEPRINT_LIBRARY    - the kdeprint library
# KDE4_KSPELL2_LIBRARY     - the kspell2 library
# KDE4_KDNSSD_LIBRARY      - the kdnssd library 
#
# Compared to the variables above, the following variables
# also contain all of the depending libraries, so the variables below
# should be used instead of the ones above:
#
# KDE4_KDECORE_LIBS          - the kdecore library and all depending libraries
# KDE4_KDEUI_LIBS            - the kdeui library and all depending libraries
# KDE4_KIO_LIBS              - the kio library and all depending libraries
# KDE4_KPARTS_LIBS           - the kparts library and all depending libraries
# KDE4_KUTILS_LIBS           - the kutils library and all depending libraries
# KDE4_KDE3SUPPORT_LIBS      - the kde3support library and all depending libraries
# KDE4_KXMLCORE_LIBS         - the kxmlcore library and all depending libraries
# KDE4_KHTML_LIBS            - the khtml library and all depending libraries
# KDE4_KJS_LIBS              - the kjs library and all depending libraries
# KDE4_KNEWSTUFF_LIBS        - the knewstuff library and all depending libraries
# KDE4_DCOP_LIBS             - the DCOP library and all depending libraries
# KDE4_KDEPRINT_LIBS         - the kdeprint library and all depending libraries
# KDE4_KSPELL2_LIBS          - the kspell2 library and all depending libraries
# KDE4_KDNSSD_LIBS           - the kdnssd library and all depending libraries
# KDE4_KDESU_LIBS            - the kdesu library and all depending libraries
#
#
# This module defines a bunch of variables used as locations
# for install directories. They are all interpreted relative
# to CMAKE_INSTALL_PREFIX
#
# CONFIG_INSTALL_DIR       - the config file install dir
# DATA_INSTALL_DIR         - the parent directory where applications can install their data
# HTML_INSTALL_DIR         - the HTML install dir for documentation
# ICON_INSTALL_DIR         - the icon install dir (default prefix/share/icons/)
# INFO_INSTALL_DIR         - the kde info install dir (default prefix/info)
# KCFG_INSTALL_DIR         - the install dir for kconfig files
# LIB_INSTALL_DIR          - the subdirectory relative to the install prefix where libraries will be installed (default is /lib)
# LOCALE_INSTALL_DIR       - the install dir for translations
# MAN_INSTALL_DIR          - the kde man page install dir (default prefix/man/)
# MIME_INSTALL_DIR         - the install dir for the mimetype desktop files
# PLUGIN_INSTALL_DIR       - the subdirectory relative to the install prefix where plugins will be installed (default is ${KDE4_LIB_INSTALL_DIR}/kde4)
# SERVICES_INSTALL_DIR     - the install dir for service (desktop, protocol, ...) files
# SERVICETYPES_INSTALL_DIR - the install dir for servicestypes desktop files
# SOUND_INSTALL_DIR        - the install dir for sound files
# TEMPLATES_INSTALL_DIR    - the install dir for templates (Create new file...)
# WALLPAPER_INSTALL_DIR    - the install dir for wallpapers
# KCONF_UPDATE_INSTALL_DIR - the kconf_update install dir
# XDG_APPS_DIR             - the XDG apps dir
# XDG_DIRECTORY_DIR        - the XDG directory
#
# The following variables are provided, but are seem to be unused:
# LIBS_HTML_INSTALL_DIR    /share/doc/HTML            CACHE STRING "Is this still used ?")
# APPLNK_INSTALL_DIR       /share/applnk              CACHE STRING "Is this still used ?")
#
# The following user adjustable options are provided:
#
# RPATH_STYLE       - select the style in which RPATH is handled, one of "none", "install", "both" and "default"
# KDE4_ENABLE_FINAL - enable KDE-style enable-final all-in-one-compilation
# KDE4_BUILD_TESTS  - enable this to build the testcases
#
# It also adds the following macros (from KDE4Macros.cmake)
# KDE4_ADD_DCOP_SKELS (SRCS_VAR file1.h ... fileN.h)
#    Use this to generate DCOP skeletons from the listed headers.
#
# KDE4_ADD_DCOP_STUBS (SRCS_VAR file1.h ... fileN.h)
#    Use this to generate DCOP stubs from the listed headers.
#
# KDE4_ADD_UI_FILES (SRCS_VAR file1.ui ... fileN.ui)
#    Use this to add Qt designer ui files to your application/library.
#
# KDE4_ADD_UI3_FILES (SRCS_VAR file1.ui ... fileN.ui)
#    Use this to add Qt designer ui files from Qt version 3 to your application/library.
#
# KDE4_ADD_KCFG_FILES (SRCS_VAR file1.kcfgc ... fileN.kcfgc)
#    Use this to add KDE config compiler files to your application/library.
#
# KDE4_ADD_WIDGET_FILES (SRCS_VAR file1.widgets ... fileN.widgets)
#    Use this to add widget description files for the makekdewidgets code generator
#    for Qt Designer plugins.
#
# KDE4_AUTOMOC(file1 ... fileN)
#    Call this if you want to have automatic moc file handling.
#    This means if you include "foo.moc" in the source file foo.cpp
#    a moc file for the header foo.h will be created automatically.
#    You can set the property SKIP_AUTOMAKE using SET_SOURCE_FILES_PROPERTIES()
#    to exclude some files in the list from being processed.
#    If you don't want automoc, you can also use QT4_WRAP_CPP() or QT4_GENERATE_MOC()
#    from FindQt4.cmake to have the moc files generated. This will be faster
#    but require more manual work.
#
# KDE4_INSTALL_LIBTOOL_FILE ( subdir target )
#    This will create and install a simple libtool file for the 
#    given target. This might be required for other software.
#    The libtool file will be install in subdir, relative to CMAKE_INSTALL_PREFIX .
#
# KDE4_CREATE_FINAL_FILES (filename_CXX filename_C file1 ... fileN)
#    This macro is intended mainly for internal uses.
#    It is used for enable-final. It will generate two source files,
#    one for the C files and one for the C++ files.
#    These files will have the names given in filename_CXX and filename_C.
#
# KDE4_ADD_PLUGIN ( name [WITH_PREFIX] file1 ... fileN )
#    Create a KDE plugin (KPart, kioslave, etc.) from the given source files.
#    It supports KDE4_ENABLE_FINAL.
#    If WITH_PREFIX is given, the resulting plugin will have the prefix "lib", otherwise it won't.
#    It creates and installs an appropriate libtool la-file.
#
# KDE4_ADD_KDEINIT_EXECUTABLE (name [NOGUI] [RUN_UNINSTALLED] file1 ... fileN)
#    Create a KDE application in the form of a module loadable via kdeinit.
#    A library named kdeinit_<name> will be created and a small executable which links to it.
#    It supports KDE4_ENABLE_FINAL
#    If the executable has to be run from the buildtree (e.g. unit tests and code generators
#    used later on when compiling), set the option RUN_UNINSTALLED.
#    If the executable doesn't have a GUI, use the option NOGUI. By default on OS X
#    application bundles are created, with the NOGUI option no bundles but simple executables
#    are created. Currently it doesn't have any effect on other platforms.
#
# KDE4_ADD_EXECUTABLE (name [NOGUI] [RUN_UNINSTALLED] file1 ... fileN)
#    Equivalent to ADD_EXECUTABLE(), but additionally adds support for KDE4_ENABLE_FINAL.
#    If you don't need support for KDE4_ENABLE_FINAL, you can just use the 
#    normal ADD_EXECUTABLE().
#    If the executable has to be run from the buildtree (e.g. unit tests and code generators
#    used later on when compiling), set the option RUN_UNINSTALLED.
#    If the executable doesn't have a GUI, use the option NOGUI. By default on OS X
#    application bundles are created, with the NOGUI option no bundles but simple executables
#    are created. Currently it doesn't have any effect on other platforms.
#
# KDE4_ADD_LIBRARY (name [STATIC | SHARED | MODULE ] file1 ... fileN)
#    Equivalent to ADD_LIBRARY(), but additionally it supports KDE4_ENABLE_FINAL
#    and under Windows it adds a -DMAKE_<name>_LIB definition to the compilation.
#
# KDE4_INSTALL_ICONS( path theme)
#    Installs all png and svgz files in the current directory to the icon
#    directoy given in path, in the subdirectory for the given icon theme.
#
# _KDE4_PLATFORM_INCLUDE_DIRS is used only internally
# _KDE4_PLATFORM_DEFINITIONS is used only internally

INCLUDE (MacroEnsureVersion)

cmake_minimum_required(VERSION 2.4.1 FATAL_ERROR)

set(QT_MIN_VERSION "4.1.1")
#this line includes FindQt.cmake, which searches the Qt library and headers
find_package(Qt4 REQUIRED)                                      

# Perl is required for building KDE software, e.g. for dcopidl
find_package(Perl REQUIRED)

include (MacroLibrary)
include (CheckCXXCompilerFlag)

#add some KDE specific stuff

# the following are directories where stuff will be installed to
set(CONFIG_INSTALL_DIR       /share/config              CACHE STRING "The config file install dir")
set(DATA_INSTALL_DIR         /share/apps                CACHE STRING "The parent directory where applications can install their data")
set(HTML_INSTALL_DIR         /share/doc/HTML            CACHE STRING "The HTML install dir for documentation")
set(ICON_INSTALL_DIR         /share/icons               CACHE STRING "The icon install dir (default prefix/share/icons/)")
set(INFO_INSTALL_DIR         /info                      CACHE STRING "The kde info install dir (default prefix/info)")
set(KCFG_INSTALL_DIR         /share/config.kcfg         CACHE STRING "The install dir for kconfig files")
set(LIB_INSTALL_DIR          /lib                       CACHE STRING "The subdirectory relative to the install prefix where libraries will be installed (default is /lib)")
set(LOCALE_INSTALL_DIR       /share/locale              CACHE STRING "The install dir for translations")
set(MAN_INSTALL_DIR          /man                       CACHE STRING "The kde man install dir (default prefix/man/)")
set(MIME_INSTALL_DIR         /share/mimelnk             CACHE STRING "The install dir for the mimetype desktop files")
set(PLUGIN_INSTALL_DIR       "${LIB_INSTALL_DIR}/kde4"  CACHE STRING "The subdirectory relative to the install prefix where plugins will be installed (default is ${KDE4_LIB_INSTALL_DIR}/kde4)")
set(SERVICES_INSTALL_DIR     /share/services            CACHE STRING "The install dir for service (desktop, protocol, ...) files")
set(SERVICETYPES_INSTALL_DIR /share/servicetypes        CACHE STRING "The install dir for servicestypes desktop files")
set(SOUND_INSTALL_DIR        /share/sounds              CACHE STRING "The install dir for sound files")
set(TEMPLATES_INSTALL_DIR    /share/templates           CACHE STRING "The install dir for templates (Create new file...)")
set(WALLPAPER_INSTALL_DIR    /share/wallpapers          CACHE STRING "The install dir for wallpapers")
set(KCONF_UPDATE_INSTALL_DIR /share/apps/kconf_update/  CACHE STRING "The kconf_update install dir")
set(XDG_APPS_DIR             /share/applications/kde    CACHE STRING "The XDG apps dir")
set(XDG_DIRECTORY_DIR        /share/desktop-directories CACHE STRING "The XDG directory")
set(SYSCONF_INSTALL_DIR      "/etc"                     CACHE STRING "The kde sysconfig install dir (default /etc)")

# seem to be unused:
set(LIBS_HTML_INSTALL_DIR    /share/doc/HTML            CACHE STRING "Is this still used ?")
set(APPLNK_INSTALL_DIR       /share/applnk              CACHE STRING "Is this still used ?")


option(KDE4_ENABLE_FINAL "Enable final all-in-one compilation")
option(KDE4_BUILD_TESTS  "Build the tests")
option(KDE4_USE_QT_EMB   "link to Qt-embedded, don't use X")


#now try to find some kde stuff

#are we trying to compile kdelibs ?
#then enter bootstrap mode
if(EXISTS ${CMAKE_SOURCE_DIR}/kdecore/kglobal.h)

   message(STATUS "Building kdelibs...")

   set(KDE4_INCLUDE_DIR ${CMAKE_SOURCE_DIR})
   set(KDE4_KDECORE_LIBS ${QT_QTCORE_LIBRARY} kdecore)
   set(KDE4_KDEUI_LIBS ${KDE4_KDECORE_LIBS} kdeui)
   set(KDE4_KIO_LIBS ${KDE4_KDEUI_LIBS} kio)
   set(KDE4_KPARTS_LIBS ${KDE4_KIO_LIBS} kparts)
   set(KDE4_KUTILS_LIBS ${KDE4_KIO_LIBS} kutils)


   set(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR}/bin )
  
   # adjust dcopidl and the library output path depending on the platform
   if (WIN32)
      # under windows dcopidl.bat has to be used, except when using MSYS, then the perl script has to be used, Alex
      if ("${CMAKE_GENERATOR}" MATCHES "MSYS")
         set(KDE4_DCOPIDL_EXECUTABLE         ${CMAKE_SOURCE_DIR}/dcop/dcopidlng/dcopidl )
         set(KDE4_DCOPIDL_EXECUTABLE_INSTALL ${CMAKE_SOURCE_DIR}/dcop/dcopidlng/dcopidl )
      else ("${CMAKE_GENERATOR}" MATCHES "MSYS")
         set(KDE4_DCOPIDL_EXECUTABLE         call ${CMAKE_SOURCE_DIR}/dcop/dcopidlng/dcopidl.bat )
         set(KDE4_DCOPIDL_EXECUTABLE_INSTALL      ${CMAKE_SOURCE_DIR}/dcop/dcopidlng/dcopidl.bat )
      endif ("${CMAKE_GENERATOR}" MATCHES "MSYS")
  
      set(LIBRARY_OUTPUT_PATH  ${EXECUTABLE_OUTPUT_PATH} )
      # CMAKE_CFG_INTDIR is the output subdirectory created e.g. by XCode and MSVC
      set(KDE4_DCOPIDL2CPP_EXECUTABLE ${EXECUTABLE_OUTPUT_PATH}/${CMAKE_CFG_INTDIR}/dcopidl2cpp )
      set(KDE4_KCFGC_EXECUTABLE       ${EXECUTABLE_OUTPUT_PATH}/${CMAKE_CFG_INTDIR}/kconfig_compiler )
      set(KDE4_MEINPROC_EXECUTABLE    ${EXECUTABLE_OUTPUT_PATH}/${CMAKE_CFG_INTDIR}/meinproc )
      set(KDE4_MAKEKDEWIDGETS_EXECUTABLE    ${EXECUTABLE_OUTPUT_PATH}/${CMAKE_CFG_INTDIR}/makekdewidgets )
   else (WIN32)
      set(KDE4_DCOPIDL_EXECUTABLE         ${CMAKE_SOURCE_DIR}/dcop/dcopidlng/dcopidl )
      set(KDE4_DCOPIDL_EXECUTABLE_INSTALL ${CMAKE_SOURCE_DIR}/dcop/dcopidlng/dcopidl )
      set(LIBRARY_OUTPUT_PATH  ${CMAKE_BINARY_DIR}/lib ) 
      set(KDE4_DCOPIDL2CPP_EXECUTABLE ${EXECUTABLE_OUTPUT_PATH}/${CMAKE_CFG_INTDIR}/dcopidl2cpp.sh )
      set(KDE4_KCFGC_EXECUTABLE       ${EXECUTABLE_OUTPUT_PATH}/${CMAKE_CFG_INTDIR}/kconfig_compiler.sh )
      set(KDE4_MEINPROC_EXECUTABLE    ${EXECUTABLE_OUTPUT_PATH}/${CMAKE_CFG_INTDIR}/meinproc.sh )
      set(KDE4_MAKEKDEWIDGETS_EXECUTABLE    ${EXECUTABLE_OUTPUT_PATH}/${CMAKE_CFG_INTDIR}/makekdewidgets.sh )
   endif (WIN32)

   set(KDE4_LIB_DIR ${LIBRARY_OUTPUT_PATH}/${CMAKE_CFG_INTDIR})
   set(KDE4_KALYPTUS_DIR ${CMAKE_SOURCE_DIR}/dcop/dcopidlng/ )
  
   # when building kdelibs, make the dcop and kcfg rules depend on the binaries...
   set( _KDE4_DCOPIDL2CPP_DEP dcopidl2cpp)
   set( _KDE4_KCONFIG_COMPILER_DEP kconfig_compiler)
   set( _KDE4_MAKEKDEWIDGETS_DEP makekdewidgets)
  
else(EXISTS ${CMAKE_SOURCE_DIR}/kdecore/kglobal.h)

  # ... but NOT otherwise
   set( _KDE4_DCOPIDL2CPP_DEP )
   set( _KDE4_KCONFIG_COMPILER_DEP)
   set( _KDE4_MAKEKDEWIDGETS_DEP)

   # Check the version of kde. KDE4_KDECONFIG_EXECUTABLE was set by FindKDE4
   EXEC_PROGRAM(${KDE4_KDECONFIG_EXECUTABLE} ARGS "--version" OUTPUT_VARIABLE kdeconfig_output )

   STRING(REGEX MATCH "KDE: [0-9]+\\.[0-9]+\\.[0-9]+" KDEVERSION "${kdeconfig_output}")
   IF (KDEVERSION)

      # avoid porting against kdelibs trunk
      string(REGEX MATCH "DONTPORT" _match "${kdeconfig_output}")
      if (_match)
         message ( FATAL_ERROR "ERROR: don't port against this version of kdelibs! Use /branches/work/kdelibs4_snapshot instead!!" )
      endif (_match)

      STRING(REGEX REPLACE "^KDE: " "" KDEVERSION "${KDEVERSION}")

      # we need at least this version:
      IF (NOT KDE_MIN_VERSION)
         SET(KDE_MIN_VERSION "3.9.0")
      ENDIF (NOT KDE_MIN_VERSION)
   
      #message(STATUS "KDE_MIN_VERSION=${KDE_MIN_VERSION}  found ${KDEVERSION}")

      MACRO_ENSURE_VERSION( ${KDE_MIN_VERSION} ${KDEVERSION} KDE4_INSTALLED_VERSION_TOO_OLD )
   
   ELSE (KDEVERSION)
      message(FATAL_ERROR "Couldn't parse KDE version string from the kde-config output:\n${kdeconfig_output}")
   ENDIF (KDEVERSION)


   set(LIBRARY_OUTPUT_PATH  ${CMAKE_BINARY_DIR}/lib )

   get_filename_component( kde_cmake_module_dir  ${CMAKE_CURRENT_LIST_FILE} PATH)
   # this file contains all dependencies of all libraries of kdelibs, Alex
   include(${kde_cmake_module_dir}/KDELibsDependencies.cmake)

   find_library(KDE4_KDECORE_LIBRARY NAMES kdecore PATHS ${KDE4_LIB_INSTALL_DIR} NO_DEFAULT_PATH )
   set(KDE4_KDECORE_LIBS ${kdecore_LIB_DEPENDS} ${KDE4_KDECORE_LIBRARY} )

   find_library(KDE4_KDEUI_LIBRARY NAMES kdeui PATHS ${KDE4_LIB_INSTALL_DIR} NO_DEFAULT_PATH )
   set(KDE4_KDEUI_LIBS ${kdeui_LIB_DEPENDS} ${KDE4_KDEUI_LIBRARY} )

   find_library(KDE4_KIO_LIBRARY NAMES kio PATHS ${KDE4_LIB_INSTALL_DIR} NO_DEFAULT_PATH )
   set(KDE4_KIO_LIBS ${kio_LIB_DEPENDS} ${KDE4_KIO_LIBRARY} )

   find_library(KDE4_KPARTS_LIBRARY NAMES kparts PATHS ${KDE4_LIB_INSTALL_DIR} NO_DEFAULT_PATH )
   set(KDE4_KPARTS_LIBS ${kparts_LIB_DEPENDS} ${KDE4_KPARTS_LIBRARY} )

   find_library(KDE4_KUTILS_LIBRARY NAMES kutils PATHS ${KDE4_LIB_INSTALL_DIR} NO_DEFAULT_PATH )
   set(KDE4_KUTILS_LIBS ${kutils_LIB_DEPENDS} ${KDE4_KUTILS_LIBRARY} )

   find_library(KDE4_KDE3SUPPORT_LIBRARY NAMES kde3support PATHS ${KDE4_LIB_INSTALL_DIR} NO_DEFAULT_PATH )
   set(KDE4_KDE3SUPPORT_LIBS ${kde3support_LIB_DEPENDS} ${KDE4_KDE3SUPPORT_LIBRARY} )

   find_library(KDE4_KHTML_LIBRARY NAMES khtml PATHS ${KDE4_LIB_INSTALL_DIR} NO_DEFAULT_PATH )
   set(KDE4_KHTML_LIBS ${khtml_LIB_DEPENDS} ${KDE4_KHTML_LIBRARY} )

   find_library(KDE4_KJS_LIBRARY NAMES kjs PATHS ${KDE4_LIB_INSTALL_DIR} NO_DEFAULT_PATH )
   set(KDE4_KJS_LIBS ${kjs_LIB_DEPENDS} ${KDE4_KJS_LIBRARY} )

   find_library(KDE4_KNEWSTUFF_LIBRARY NAMES knewstuff PATHS ${KDE4_LIB_INSTALL_DIR} NO_DEFAULT_PATH )
   set(KDE4_KNEWSTUFF_LIBS ${knewstuff_LIB_DEPENDS} ${KDE4_KNEWSTUFF_LIBRARY} )

   find_library(KDE4_DCOP_LIBRARY NAMES DCOP PATHS ${KDE4_LIB_INSTALL_DIR} NO_DEFAULT_PATH )
   set(KDE4_DCOP_LIBS ${DCOP_LIB_DEPENDS} ${KDE4_DCOP_LIBRARY} )

   find_library(KDE4_KDEPRINT_LIBRARY NAMES kdeprint PATHS ${KDE4_LIB_INSTALL_DIR} NO_DEFAULT_PATH )
   set(KDE4_KDEPRINT_LIBS ${kdeprint_LIB_DEPENDS} ${KDE4_KDEPRINT_LIBRARY} )

   find_library(KDE4_KSPELL2_LIBRARY NAMES kspell2 PATHS ${KDE4_LIB_INSTALL_DIR} NO_DEFAULT_PATH )
   set(KDE4_KSPELL2_LIBS ${kspell2_LIB_DEPENDS} ${KDE4_KSPELL2_LIBRARY} )

   if (UNIX)
   find_library(KDE4_KDESU_LIBRARY NAMES kdesu PATHS ${KDE4_LIB_INSTALL_DIR} NO_DEFAULT_PATH )
   set(KDE4_KDESU_LIBS ${kdesu_LIB_DEPENDS} ${KDE4_KDESU_LIBRARY} )
   endif (UNIX)

   find_library(KDE4_KDNSSD_LIBRARY NAMES kdnssd PATHS ${KDE4_LIB_INSTALL_DIR} NO_DEFAULT_PATH )
   set(KDE4_KDNSSD_LIBS ${kdnssd_LIB_DEPENDS} ${KDE4_KDNSSD_LIBRARY} )

   # now the KDE library directory, kxmlcore is new with KDE4
   find_library(KDE4_KXMLCORE_LIBRARY NAMES kxmlcore PATHS ${KDE4_LIB_INSTALL_DIR} )
   set(KDE4_KXMLCORE_LIBRARIES ${kxmlcore_LIB_DEPENDS} ${KDE4_KXMLCORE_LIBRARY} )

   get_filename_component(KDE4_LIB_DIR ${KDE4_KDECORE_LIBRARY} PATH )


   # at first the KDE include direcory
   # kpassworddialog.h is new with KDE4
   find_path(KDE4_INCLUDE_DIR kpassworddialog.h
      ${KDE4_INCLUDE_INSTALL_DIR}
      $ENV{KDEDIR}/include
      /opt/kde/include
      /opt/kde4/include
      /usr/local/include
      /usr/include/
      /usr/include/kde
      /usr/local/include/kde
    )

   #now search for the dcop utilities
   find_program(KDE4_DCOPIDL_EXECUTABLE NAMES dcopidl dcopidl.bat PATHS
      ${KDE4_BIN_INSTALL_DIR}
      $ENV{KDEDIR}/bin
      /opt/kde/bin
      /opt/kde4/bin
      NO_DEFAULT_PATH
   )

   if (NOT KDE4_DCOPIDL_EXECUTABLE)
      find_program(KDE4_DCOPIDL_EXECUTABLE NAMES dcopidl dcopidl.bat )
   endif (NOT KDE4_DCOPIDL_EXECUTABLE)


   find_path(KDE4_KALYPTUS_DIR kalyptus
     ${KDE4_DATA_INSTALL_DIR}/dcopidl
     $ENV{KDEDIR}/share/apps/dcopidl
     /opt/kde/share/apps/dcopidl
     /opt/kde4/share/apps/dcopidl
   )

   find_program(KDE4_DCOPIDL2CPP_EXECUTABLE NAME dcopidl2cpp PATHS
     ${KDE4_BIN_INSTALL_DIR}
     $ENV{KDEDIR}/bin
     /opt/kde/bin
     /opt/kde4/bin
      NO_DEFAULT_PATH
   )

   if (NOT KDE4_DCOPIDL2CPP_EXECUTABLE)
      find_program(KDE4_DCOPIDL2CPP_EXECUTABLE NAME dcopidl2cpp )
   endif (NOT KDE4_DCOPIDL2CPP_EXECUTABLE)

   find_program(KDE4_KCFGC_EXECUTABLE NAME kconfig_compiler PATHS
     ${KDE4_BIN_INSTALL_DIR}
     $ENV{KDEDIR}/bin
     /opt/kde/bin
     /opt/kde4/bin
      NO_DEFAULT_PATH
   )

   if (NOT KDE4_KCFGC_EXECUTABLE)
      find_program(KDE4_KCFGC_EXECUTABLE NAME kconfig_compiler )
   endif (NOT KDE4_KCFGC_EXECUTABLE)

   find_program(KDE4_MEINPROC_EXECUTABLE NAME meinproc PATHS
     ${KDE4_BIN_INSTALL_DIR}
     $ENV{KDEDIR}/bin
     /opt/kde/bin
     /opt/kde4/bin
      NO_DEFAULT_PATH
   )

   if (NOT KDE4_MEINPROC_EXECUTABLE)
      find_program(KDE4_MEINPROC_EXECUTABLE NAME meinproc )
   endif (NOT KDE4_MEINPROC_EXECUTABLE)

   find_program(KDE4_MAKEKDEWIDGETS_EXECUTABLE NAME makekdewidgets PATHS
     ${KDE4_BIN_INSTALL_DIR}
     $ENV{KDEDIR}/bin
     /opt/kde/bin
     /opt/kde4/bin
      NO_DEFAULT_PATH
   )

   if (NOT KDE4_MAKEKDEWIDGETS_EXECUTABLE)
      find_program(KDE4_MAKEKDEWIDGETS_EXECUTABLE NAME makekdewidgets )
   endif (NOT KDE4_MAKEKDEWIDGETS_EXECUTABLE)

endif(EXISTS ${CMAKE_SOURCE_DIR}/kdecore/kglobal.h)


#####################  and now the platform specific stuff  ############################

# Set a default build type for single-configuration
# CMake generators if no build type is set.
if (NOT CMAKE_CONFIGURATION_TYPES AND NOT CMAKE_BUILD_TYPE)
   set(CMAKE_BUILD_TYPE RelWithDebInfo)
endif (NOT CMAKE_CONFIGURATION_TYPES AND NOT CMAKE_BUILD_TYPE)


if (WIN32)

   if(CYGWIN)
      message(FATAL_ERROR "Support for Cygwin NOT yet implemented, please edit FindKDE4.cmake to enable it")
   endif(CYGWIN)

   find_package(KDEWIN32 REQUIRED)
   
   set( _KDE4_PLATFORM_INCLUDE_DIRS ${KDEWIN32_INCLUDES})

   # if we are compiling kdelibs, add KDEWIN32_LIBRARIES explicitely, 
   # otherwise they come from KDELibsDependencies.cmake, Alex
   if(EXISTS ${CMAKE_SOURCE_DIR}/kdecore/kglobal.h)
      set( KDE4_KDECORE_LIBS ${KDE4_KDECORE_LIBS} ${KDEWIN32_LIBRARIES} )
   endif(EXISTS ${CMAKE_SOURCE_DIR}/kdecore/kglobal.h)
     
   # windows, mingw
   if(MINGW)
   #hmmm, something special to do here ?
   endif(MINGW)
   
   # windows, microsoft compiler
   if(MSVC)
      set( _KDE4_PLATFORM_DEFINITIONS -DKDE_FULL_TEMPLATE_EXPORT_INSTANTIATION -DWIN32_LEAN_AND_MEAN -DUNICODE )
      if(CMAKE_COMPILER_2005)
         add_definitions( -D_CRT_SECURE_NO_DEPRECATE -D_CRT_NONSTDC_NO_DEPRECATE )
         set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -wd4661" )
      endif(CMAKE_COMPILER_2005)
   endif(MSVC)

endif (WIN32)


# also use /usr/local by default under UNIX, including Mac OS X
if (UNIX)
   link_directories(/usr/local/lib)
   set( _KDE4_PLATFORM_INCLUDE_DIRS /usr/local/include )

   # the rest is RPATH handling

   if (APPLE)
      set(CMAKE_INSTALL_NAME_DIR ${CMAKE_INSTALL_PREFIX}${LIB_INSTALL_DIR})
   else (APPLE)
      set(CMAKE_INSTALL_RPATH ${CMAKE_INSTALL_PREFIX}${LIB_INSTALL_DIR} ${QT_LIBRARY_DIR} )
      # building something else than kdelibs/ ?
      # then add the dir where the kde libraries are installed
      if (NOT EXISTS ${CMAKE_SOURCE_DIR}/kdecore/kglobal.h)
         set(CMAKE_INSTALL_RPATH  ${KDE4_LIB_DIR} ${CMAKE_INSTALL_RPATH} )
      endif (NOT EXISTS ${CMAKE_SOURCE_DIR}/kdecore/kglobal.h)

      set(CMAKE_SKIP_BUILD_RPATH TRUE)
      set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
   endif (APPLE)
endif (UNIX)


# UNIX, except OS X
if (UNIX AND NOT APPLE)
   find_package(X11 REQUIRED)
   # UNIX has already set _KDE4_PLATFORM_INCLUDE_DIRS, so append
   set(_KDE4_PLATFORM_INCLUDE_DIRS ${_KDE4_PLATFORM_INCLUDE_DIRS} ${X11_INCLUDE_DIR} )
endif (UNIX AND NOT APPLE)


# This will need to be modified later to support either Qt/X11 or Qt/Mac builds
if (APPLE)

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

  # removed -Os, was there a special reason for using -Os instead of -O2 ?, Alex
  # optimization flags are set below for the various build types
  set (CMAKE_C_FLAGS     "${CMAKE_C_FLAGS} -fno-common")
  set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-common")
endif (APPLE)


if (CMAKE_SYSTEM_NAME MATCHES Linux)
   if (CMAKE_COMPILER_IS_GNUCXX)
      set ( _KDE4_PLATFORM_DEFINITIONS -D_XOPEN_SOURCE=500 -D_BSD_SOURCE -D_GNU_SOURCE)
      set ( CMAKE_SHARED_LINKER_FLAGS "-Wl,--fatal-warnings -Wl,--no-undefined -lc")
      set ( CMAKE_MODULE_LINKER_FLAGS "-Wl,--fatal-warnings -Wl,--no-undefined -lc")
   endif (CMAKE_COMPILER_IS_GNUCXX)
   if (CMAKE_C_COMPILER MATCHES "icc")
      set ( _KDE4_PLATFORM_DEFINITIONS -D_XOPEN_SOURCE=500 -D_BSD_SOURCE -D_GNU_SOURCE)
      set ( CMAKE_SHARED_LINKER_FLAGS "-Wl,--fatal-warnings -Wl,--no-undefined -lc")
      set ( CMAKE_MODULE_LINKER_FLAGS "-Wl,--fatal-warnings -Wl,--no-undefined -lc")
   endif (CMAKE_C_COMPILER MATCHES "icc")
endif (CMAKE_SYSTEM_NAME MATCHES Linux)

if (CMAKE_SYSTEM_NAME MATCHES BSD)
   set ( _KDE4_PLATFORM_DEFINITIONS -D_GNU_SOURCE )
   set ( CMAKE_SHARED_LINKER_FLAGS "-lc")
   set ( CMAKE_MODULE_LINKER_FLAGS "-lc")
endif (CMAKE_SYSTEM_NAME MATCHES BSD)

# compiler specific stuff, maybe this should be done differently, Alex

if (MSVC)
   set (KDE4_ENABLE_EXCEPTIONS -EHsc)
endif(MSVC)

if (CMAKE_COMPILER_IS_GNUCXX)
   set (KDE4_ENABLE_EXCEPTIONS -fexceptions)
   # Select flags.
   set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-O2 -g")
   set(CMAKE_CXX_FLAGS_RELEASE        "-O2")
   set(CMAKE_CXX_FLAGS_DEBUG          "-g -O2 -fno-reorder-blocks -fno-schedule-insns -fno-inline")
   set(CMAKE_CXX_FLAGS_DEBUGFULL      "-g3 -fno-inline")
   set(CMAKE_C_FLAGS_RELWITHDEBINFO   "-O2 -g")
   set(CMAKE_C_FLAGS_RELEASE          "-O2")
   set(CMAKE_C_FLAGS_DEBUG            "-g -O2 -fno-reorder-blocks -fno-schedule-insns -fno-inline")
   set(CMAKE_C_FLAGS_DEBUGFULL        "-g3 -fno-inline")

   if (CMAKE_SYSTEM_NAME MATCHES Linux)
     set ( CMAKE_C_FLAGS     "${CMAKE_C_FLAGS} -Wno-long-long -ansi -Wundef -Wcast-align -Werror-implicit-function-declaration -Wchar-subscripts -Wall -W -Wpointer-arith -Wwrite-strings -Wformat-security -Wmissing-format-attribute -fno-common")
     set ( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wnon-virtual-dtor -Wno-long-long -ansi -Wundef -Wcast-align -Wchar-subscripts -Wall -W -Wpointer-arith -Wwrite-strings -Wformat-security -fno-exceptions -fno-check-new -fno-common")
   endif (CMAKE_SYSTEM_NAME MATCHES Linux)

   # visibility support
   check_cxx_compiler_flag(-fvisibility=hidden __KDE_HAVE_GCC_VISIBILITY)
   if (__KDE_HAVE_GCC_VISIBILITY)
      set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fvisibility=hidden")
   endif (__KDE_HAVE_GCC_VISIBILITY)

endif (CMAKE_COMPILER_IS_GNUCXX)

if (CMAKE_C_COMPILER MATCHES "icc")
   set (KDE4_ENABLE_EXCEPTIONS -fexceptions)
   # Select flags.
   set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-O2 -g")
   set(CMAKE_CXX_FLAGS_RELEASE        "-O2")
   set(CMAKE_CXX_FLAGS_DEBUG          "-O2 -g -0b0 -noalign")
   set(CMAKE_CXX_FLAGS_DEBUGFULL      "-g -Ob0 -noalign")
   set(CMAKE_C_FLAGS_RELWITHDEBINFO   "-O2 -g")
   set(CMAKE_C_FLAGS_RELEASE          "-O2")
   set(CMAKE_C_FLAGS_DEBUG            "-O2 -g -Ob0 -noalign")
   set(CMAKE_C_FLAGS_DEBUGFULL        "-g -Ob0 -noalign")

   set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS}   -ansi -no-gcc -Wpointer-arith -fno-common")
   set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -ansi -no-gcc -Wpointer-arith -fno-exceptions -fno-common")

   # visibility support
#   check_cxx_compiler_flag(-fvisibility=hidden __KDE_HAVE_ICC_VISIBILITY)
#   if (__KDE_HAVE_ICC_VISIBILITY)
#      set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fvisibility=hidden")
#   endif (__KDE_HAVE_ICC_VISIBILITY)

endif (CMAKE_C_COMPILER MATCHES "icc")

# it seems we prefer not to use a different postfix for debug libs, Alex
# SET(CMAKE_DEBUG_POSTFIX "_debug")

###########    end of platform specific stuff  ##########################


# KDE4Macros.cmake contains all the KDE specific macros
include(KDE4Macros)


# decide whether KDE4 has been found
set(KDE4_FOUND FALSE)
if (KDE4_INCLUDE_DIR AND KDE4_LIB_DIR AND KDE4_DCOPIDL_EXECUTABLE AND KDE4_DCOPIDL2CPP_EXECUTABLE AND KDE4_KCFGC_EXECUTABLE AND NOT KDE4_INSTALLED_VERSION_TOO_OLD)
   set(KDE4_FOUND TRUE)
endif (KDE4_INCLUDE_DIR AND KDE4_LIB_DIR AND KDE4_DCOPIDL_EXECUTABLE AND KDE4_DCOPIDL2CPP_EXECUTABLE AND KDE4_KCFGC_EXECUTABLE AND NOT KDE4_INSTALLED_VERSION_TOO_OLD)


macro (KDE4_PRINT_RESULTS)

   # inside kdelibs the include dir and lib dir are internal, not "found"
   if(NOT EXISTS ${CMAKE_SOURCE_DIR}/kdecore/kglobal.h)
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
   endif(NOT EXISTS ${CMAKE_SOURCE_DIR}/kdecore/kglobal.h)
  
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
endmacro (KDE4_PRINT_RESULTS)


if (KDE4Internal_FIND_REQUIRED AND NOT KDE4_FOUND)
   #bail out if something wasn't found
   kde4_print_results()
   if (KDE4_INSTALLED_VERSION_TOO_OLD)
     message(FATAL_ERROR "ERROR: the installed kdelibs version ${KDEVERSION} is too old, at least version ${KDE_MIN_VERSION} is required")
   else (KDE4_INSTALLED_VERSION_TOO_OLD)
     message(FATAL_ERROR "ERROR: could NOT find everything required for compiling KDE 4 programs")
   endif (KDE4_INSTALLED_VERSION_TOO_OLD)
endif (KDE4Internal_FIND_REQUIRED AND NOT KDE4_FOUND)


if (NOT KDE4Internal_FIND_QUIETLY)
   kde4_print_results()
endif (NOT KDE4Internal_FIND_QUIETLY)

#add the found Qt and KDE include directories to the current include path
set(KDE4_INCLUDES ${QT_INCLUDES} ${KDE4_INCLUDE_DIR} ${_KDE4_PLATFORM_INCLUDE_DIRS} )

# NOT used in Qt4: QT_NO_COMPAT, QT_CLEAN_NAMESPACE, QT_THREAD_SUPPORT
set(KDE4_DEFINITIONS ${_KDE4_PLATFORM_DEFINITIONS} -DQT3_SUPPORT -DQT_NO_STL -DQT_NO_CAST_TO_ASCII -D_REENTRANT -DQT3_SUPPORT_WARNINGS -DKDE_DEPRECATED_WARNINGS )

