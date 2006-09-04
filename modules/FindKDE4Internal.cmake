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
# KDE4_KDEPRINT_LIBRARY    - the kdeprint library
# KDE4_KSPELL2_LIBRARY     - the kspell2 library
# KDE4_KDNSSD_LIBRARY      - the kdnssd library 
# KDE4_PHONONCORE_LIBRARY  - the phononcore library
# KDE4_PHONONUI_LIBRARY    - the phononui library
# KDE4_KDEFX_LIBRARY       - the kdefx library
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
# KDE4_KDEPRINT_LIBS         - the kdeprint library and all depending libraries
# KDE4_KSPELL2_LIBS          - the kspell2 library and all depending libraries
# KDE4_KDNSSD_LIBS           - the kdnssd library and all depending libraries
# KDE4_KDESU_LIBS            - the kdesu library and all depending libraries
# KDE4_PHONONCORE_LIBS       - the phononcore library and all depending librairies
# KDE4_PHONONUI_LIBS         - the phononui library and all depending librairies
# KDE4_KDEFX_LIBS            - the kdefx library and all depending librairies
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
# KDE4_ENABLE_FINAL - enable KDE-style enable-final all-in-one-compilation
# KDE4_BUILD_TESTS  - enable this to build the testcases
# KDE4_ENABLE_FPIE  - enable it to use gcc Position Independent Executables feature 
#
# It also adds the following macros (from KDE4Macros.cmake)
# KDE4_ADD_UI_FILES (SRCS_VAR file1.ui ... fileN.ui)
#    Use this to add Qt designer ui files to your application/library.
#
# KDE4_ADD_UI3_FILES (SRCS_VAR file1.ui ... fileN.ui)
#    Use this to add Qt designer ui files from Qt version 3 to your application/library.
#
# KDE4_ADD_KCFG_FILES (SRCS_VAR [GENERATE_MOC] file1.kcfgc ... fileN.kcfgc)
#    Use this to add KDE config compiler files to your application/library.
#    Use optional GENERATE_MOC to generate moc if you use signals in your kcfg files.
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


################################################################################
#
# Copyright (c) 2006, Alexander Neundorf <neundorf@kde.org>
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# * Redistributions of source code must retain the above copyright
#   notice, this list of conditions and the following disclaimer.
# * Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in the
#   documentation and/or other materials provided with the distribution.
# * The name of the author may not be used to endorse or promote products 
#   derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
# ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#
################################################################################


INCLUDE (MacroEnsureVersion)

cmake_minimum_required(VERSION 2.4.1 FATAL_ERROR)

set(QT_MIN_VERSION "4.2.0")
#this line includes FindQt4.cmake, which searches the Qt library and headers
find_package(Qt4 REQUIRED)                                      

if (NOT QT_DBUSXML2CPP_EXECUTABLE)
   message(FATAL_ERROR "Qt4 dbusxml2cpp was not found. Make sure it has been built and installed by Qt")
endif (NOT QT_DBUSXML2CPP_EXECUTABLE)


# Perl is required for building KDE software,
find_package(Perl REQUIRED)

include (MacroLibrary)
include (CheckCXXCompilerFlag)




#add some KDE specific stuff


# the following are directories where stuff will be installed to
 set(LIB_SUFFIX "" CACHE STRING "Define suffix of directory name (32/64)" )
 set(SHARE_INSTALL_PREFIX ${CMAKE_INSTALL_PREFIX}/share CACHE PATH "Base directory for files which go to share/")
 set(EXEC_INSTALL_PREFIX  ${CMAKE_INSTALL_PREFIX}       CACHE PATH  "Base directory for executables and libraries")

 set(BIN_INSTALL_DIR          "${EXEC_INSTALL_PREFIX}/bin"                  CACHE PATH "The install dir for executables (default prefix/bin)")
 set(SBIN_INSTALL_DIR         "${EXEC_INSTALL_PREFIX}/sbin"                 CACHE PATH "The install dir for system executables (default prefix/sbin)")
 set(LIB_INSTALL_DIR          "${EXEC_INSTALL_PREFIX}/lib${LIB_SUFFIX}"     CACHE PATH "The subdirectory relative to the install prefix where libraries will be installed (default is /lib${LIB_SUFFIX})")

 set(LIBEXEC_INSTALL_DIR      "${LIB_INSTALL_DIR}/kde4/libexec"             CACHE PATH "The subdirectory relative to the install prefix where libraries will be installed (default is /lib/kde4/libexec)")
 set(PLUGIN_INSTALL_DIR       "${LIB_INSTALL_DIR}/kde4"                     CACHE PATH "The subdirectory relative to the install prefix where plugins will be installed (default is ${KDE4_LIB_INSTALL_DIR}/kde4)")

 set(INCLUDE_INSTALL_DIR      "${CMAKE_INSTALL_PREFIX}/include"             CACHE PATH "The subdirectory to the header prefix")
 set(CONFIG_INSTALL_DIR       "${SHARE_INSTALL_PREFIX}/config"              CACHE PATH "The config file install dir")
 set(DATA_INSTALL_DIR         "${SHARE_INSTALL_PREFIX}/apps"                CACHE PATH "The parent directory where applications can install their data")
 set(HTML_INSTALL_DIR         "${SHARE_INSTALL_PREFIX}/doc/HTML"            CACHE PATH "The HTML install dir for documentation")
 set(ICON_INSTALL_DIR         "${SHARE_INSTALL_PREFIX}/icons"               CACHE PATH "The icon install dir (default prefix/share/icons/)")
 set(KCFG_INSTALL_DIR         "${SHARE_INSTALL_PREFIX}/config.kcfg"         CACHE PATH "The install dir for kconfig files")
 set(LOCALE_INSTALL_DIR       "${SHARE_INSTALL_PREFIX}/locale"              CACHE PATH "The install dir for translations")
 set(MIME_INSTALL_DIR         "${SHARE_INSTALL_PREFIX}/mimelnk"             CACHE PATH "The install dir for the mimetype desktop files")
 set(SERVICES_INSTALL_DIR     "${SHARE_INSTALL_PREFIX}/services"            CACHE PATH "The install dir for service (desktop, protocol, ...) files")
 set(SERVICETYPES_INSTALL_DIR "${SHARE_INSTALL_PREFIX}/servicetypes"        CACHE PATH "The install dir for servicestypes desktop files")
 set(SOUND_INSTALL_DIR        "${SHARE_INSTALL_PREFIX}/sounds"              CACHE PATH "The install dir for sound files")
 set(TEMPLATES_INSTALL_DIR    "${SHARE_INSTALL_PREFIX}/templates"           CACHE PATH "The install dir for templates (Create new file...)") 
 set(WALLPAPER_INSTALL_DIR    "${SHARE_INSTALL_PREFIX}/wallpapers"          CACHE PATH "The install dir for wallpapers")
 set(KCONF_UPDATE_INSTALL_DIR "${DATA_INSTALL_DIR}/kconf_update"            CACHE PATH "The kconf_update install dir")
 # this one shouldn't be used anymore
 set(APPLNK_INSTALL_DIR       "${SHARE_INSTALL_PREFIX}/applnk"              CACHE PATH "Is this still used ?")
 set(AUTOSTART_INSTALL_DIR    "${SHARE_INSTALL_PREFIX}/autostart"           CACHE PATH "The install dir for autostart files")
 
 set(XDG_APPS_DIR             "${SHARE_INSTALL_PREFIX}/applications/kde"    CACHE PATH "The XDG apps dir")
 set(XDG_DIRECTORY_DIR        "${SHARE_INSTALL_PREFIX}/desktop-directories" CACHE PATH "The XDG directory")
 
 set(SYSCONF_INSTALL_DIR      "${CMAKE_INSTALL_PREFIX}/etc"                 CACHE PATH "The kde sysconfig install dir (default /etc)")
 set(MAN_INSTALL_DIR          "${CMAKE_INSTALL_PREFIX}/man"                 CACHE PATH "The kde man install dir (default prefix/man/)")
 set(INFO_INSTALL_DIR         "${CMAKE_INSTALL_PREFIX}/info"                CACHE PATH "The kde info install dir (default prefix/info)")
# set(LIBEXEC_INSTALL_DIR      "${LIB_INSTALL_DIR}/kde4/libexec"             CACHE PATH "The subdirectory relative to the install prefix where libraries will be installed (default is /lib)")
# set(PLUGIN_INSTALL_DIR       "${LIB_INSTALL_DIR}/kde4/modules"             CACHE PATH "The subdirectory relative to the install prefix where plugins will be installed (default is ${KDE4_LIB_INSTALL_DIR}/kde4)")
# 

#################################


# get the directory of the current file, used later on in the file
get_filename_component( kde_cmake_module_dir  ${CMAKE_CURRENT_LIST_FILE} PATH)

# the following are directories where stuff will be installed to


option(KDE4_ENABLE_FINAL "Enable final all-in-one compilation")
option(KDE4_BUILD_TESTS  "Build the tests")

#Position-Independent-Executable is a feature of Binutils, Libc, and GCC that creates an executable 
#which is something between a shared library and a normal executable. 
#Programs compiled with these features appear as ?shared object? with the file command.
#info from "http://www.linuxfromscratch.org/hlfs/view/unstable/glibc/chapter02/pie.html"
option(KDE4_ENABLE_FPIE  "Enable platform supports PIE linking")

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
   set(KDE4_KDEFX_LIBS ${KDE4_KDEFX_LIBS} kdefx)


   set(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR}/bin )
  
   if (WIN32)
      set(LIBRARY_OUTPUT_PATH  ${EXECUTABLE_OUTPUT_PATH} )
      # CMAKE_CFG_INTDIR is the output subdirectory created e.g. by XCode and MSVC
      set(KDE4_KCFGC_EXECUTABLE       ${EXECUTABLE_OUTPUT_PATH}/${CMAKE_CFG_INTDIR}/kconfig_compiler )
      set(KDE4_MEINPROC_EXECUTABLE    ${EXECUTABLE_OUTPUT_PATH}/${CMAKE_CFG_INTDIR}/meinproc )
      set(KDE4_MAKEKDEWIDGETS_EXECUTABLE    ${EXECUTABLE_OUTPUT_PATH}/${CMAKE_CFG_INTDIR}/makekdewidgets )
   else (WIN32)
      set(LIBRARY_OUTPUT_PATH  ${CMAKE_BINARY_DIR}/lib ) 
      set(KDE4_KCFGC_EXECUTABLE       ${EXECUTABLE_OUTPUT_PATH}/${CMAKE_CFG_INTDIR}/kconfig_compiler.sh )
      set(KDE4_MEINPROC_EXECUTABLE    ${EXECUTABLE_OUTPUT_PATH}/${CMAKE_CFG_INTDIR}/meinproc.sh )
      set(KDE4_MAKEKDEWIDGETS_EXECUTABLE    ${EXECUTABLE_OUTPUT_PATH}/${CMAKE_CFG_INTDIR}/makekdewidgets.sh )
   endif (WIN32)

   set(KDE4_LIB_DIR ${LIBRARY_OUTPUT_PATH}/${CMAKE_CFG_INTDIR})
  
   # when building kdelibs, make the kcfg rules depend on the binaries...
   set( _KDE4_KCONFIG_COMPILER_DEP kconfig_compiler)
   set( _KDE4_MAKEKDEWIDGETS_DEP makekdewidgets)
  
   set(KDE4_INSTALLED_VERSION_OK TRUE)
  
else(EXISTS ${CMAKE_SOURCE_DIR}/kdecore/kglobal.h)

  # ... but NOT otherwise
   set( _KDE4_KCONFIG_COMPILER_DEP)
   set( _KDE4_MAKEKDEWIDGETS_DEP)

   # Check the version of kde. KDE4_KDECONFIG_EXECUTABLE was set by FindKDE4
   exec_program(${KDE4_KDECONFIG_EXECUTABLE} ARGS "--version" OUTPUT_VARIABLE kdeconfig_output )

   string(REGEX MATCH "KDE: [0-9]+\\.[0-9]+\\.[0-9]+" KDEVERSION "${kdeconfig_output}")
   if (KDEVERSION)

      string(REGEX REPLACE "^KDE: " "" KDEVERSION "${KDEVERSION}")

      # we need at least this version:
      if (NOT KDE_MIN_VERSION)
         set(KDE_MIN_VERSION "3.9.0")
      endif (NOT KDE_MIN_VERSION)
   
      #message(STATUS "KDE_MIN_VERSION=${KDE_MIN_VERSION}  found ${KDEVERSION}")

      macro_ensure_version( ${KDE_MIN_VERSION} ${KDEVERSION} KDE4_INSTALLED_VERSION_OK )
   
   else (KDEVERSION)
      message(FATAL_ERROR "Couldn't parse KDE version string from the kde-config output:\n${kdeconfig_output}")
   endif (KDEVERSION)


   set(LIBRARY_OUTPUT_PATH  ${CMAKE_BINARY_DIR}/lib )

   # this file contains all dependencies of all libraries of kdelibs, Alex
   include(${kde_cmake_module_dir}/KDELibsDependencies.cmake)

   find_library(KDE4_KDECORE_LIBRARY NAMES kdecore PATHS ${KDE4_LIB_INSTALL_DIR} NO_DEFAULT_PATH )
   set(KDE4_KDECORE_LIBS ${kdecore_LIB_DEPENDS} ${KDE4_KDECORE_LIBRARY} )
   
   find_library(KDE4_KDEFX_LIBRARY NAMES kdefx PATHS ${KDE4_LIB_INSTALL_DIR} NO_DEFAULT_PATH )
   set(KDE4_KDEFX_LIBS ${kdefx_LIB_DEPENDS} ${KDE4_KDEFX_LIBRARY} )

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

   find_library(KDE4_PHONONCORE_LIBRARY NAMES phononcore PATHS ${KDE4_LIB_INSTALL_DIR} )
   set(KDE4_PHONONCORE_LIBRARIES ${phononcore_LIB_DEPENDS} ${KDE4_PHONONCORE_LIBRARY} )

   find_library(KDE4_PHONONUI_LIBRARY NAMES phononui PATHS ${KDE4_LIB_INSTALL_DIR} )
   set(KDE4_PHONONUI_LIBRARIES ${phononui_LIB_DEPENDS} ${KDE4_PHONONUI_LIBRARY} )


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
   
   find_package(GNUWIN32)
   
   set( _KDE4_PLATFORM_INCLUDE_DIRS ${KDEWIN32_INCLUDES} ${GNUWIN32_INCLUDE_DIR})

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
      # C4250: 'class1' : inherits 'class2::member' via dominance
      set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -wd4250" )
      # C4251: 'identifier' : class 'type' needs to have dll-interface to be used by clients of class 'type2'
      set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -wd4251" )
      if(CMAKE_COMPILER_2005)
         # to avoid a lot of deprecated warnings
         add_definitions( -D_CRT_SECURE_NO_DEPRECATE -D_CRT_NONSTDC_NO_DEPRECATE )
         # 'identifier' : no suitable definition provided for explicit template instantiation request
         set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -wd4661" )
      endif(CMAKE_COMPILER_2005)
   endif(MSVC)


   # for visual studio IDE set the path correctly for custom commands
   # maybe under windows bat-files should be generated for running apps during the build
   if(MSVC_IDE)
     get_filename_component(PERL_LOCATION "${PERL_EXECUTABLE}" PATH)
     file(TO_NATIVE_PATH "${PERL_LOCATION}" PERL_PATH_WINDOWS)
     file(TO_NATIVE_PATH "${QT_BINARY_DIR}" QT_BIN_DIR_WINDOWS)
     set(CMAKE_MSVCIDE_RUN_PATH "${PERL_PATH_WINDOWS}\;${QT_BIN_DIR_WINDOWS}"
       CACHE STATIC "MSVC IDE Run path" FORCE)
   endif(MSVC_IDE)

endif (WIN32)


# also use /usr/local by default under UNIX, including Mac OS X
if (UNIX)
   link_directories(/usr/local/lib)
   set( _KDE4_PLATFORM_INCLUDE_DIRS /usr/local/include )

   # the rest is RPATH handling

   if (APPLE)
      set(CMAKE_INSTALL_NAME_DIR ${LIB_INSTALL_DIR})
   else (APPLE)
      if (CMAKE_PATCH_VERSION) # at least cmake 2.4.3, in earlier version CMAKE_PATCH_VERSION is empty
         # add our LIB_INSTALL_DIR to the RPATH and use the RPATH figured out cmake when compiling
         set(CMAKE_INSTALL_RPATH ${LIB_INSTALL_DIR} )
         set(CMAKE_SKIP_BUILD_RPATH ON)
         set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
         set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
      else (CMAKE_PATCH_VERSION) # at least cmake 2.4.3
   
         set(CMAKE_INSTALL_RPATH ${LIB_INSTALL_DIR} ${QT_LIBRARY_DIR} )
         # building something else than kdelibs/ ?
         # then add the dir where the kde libraries are installed
         if (NOT EXISTS ${CMAKE_SOURCE_DIR}/kdecore/kglobal.h)
            set(CMAKE_INSTALL_RPATH  ${KDE4_LIB_DIR} ${CMAKE_INSTALL_RPATH} )
         endif (NOT EXISTS ${CMAKE_SOURCE_DIR}/kdecore/kglobal.h)

         set(CMAKE_SKIP_BUILD_RPATH TRUE)
         set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
      
      endif (CMAKE_PATCH_VERSION) # at least cmake 2.4.3
      
   endif (APPLE)
endif (UNIX)


# UNIX, except OS X
if (UNIX AND NOT APPLE)
   # Done by FindQt4.cmake already
   #find_package(X11 REQUIRED)
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


   check_cxx_compiler_flag(-fPIE HAVE_FPIE_SUPPORT)
   if(KDE4_ENABLE_FPIE)
       if(HAVE_FPIE_SUPPORT)
        set (KDE4_CXX_FPIE_FLAGS "-fPIE")
        set (KDE4_PIE_LDFLAGS "-pie")
       else(HAVE_FPIE_SUPPORT)
        MESSAGE(STATUS "Your compiler doesn't support PIE flag")
       endif(HAVE_FPIE_SUPPORT)
   endif(KDE4_ENABLE_FPIE)
   # visibility support
   check_cxx_compiler_flag(-fvisibility=hidden __KDE_HAVE_GCC_VISIBILITY)
   
   # get the gcc version
   exec_program(${CMAKE_C_COMPILER} ARGS --version OUTPUT_VARIABLE _gcc_version_info)
   
   string (REGEX MATCH " [34]\\.[0-9]\\.[0-9]" _gcc_version "${_gcc_version_info}")
   # gcc on mac just reports: "gcc (GCC) 3.3 20030304 ..." without the patch level, handle this here:
   if (NOT _gcc_version)
      string (REGEX REPLACE ".*\\(GCC\\).* ([34]\\.[0-9]) .*" "\\1.0" _gcc_version "${_gcc_version_info}")
   endif (NOT _gcc_version)

   macro_ensure_version("4.1.0" "${_gcc_version}" GCC_IS_NEWER_THAN_4_1)
   
   if (GCC_IS_NEWER_THAN_4_1)  
      exec_program(${CMAKE_C_COMPILER} ARGS -v OUTPUT_VARIABLE _gcc_alloc_info)
      string(REGEX MATCH "(--enable-libstdcxx-allocator=mt)" _GCC_COMPILED_WITH_BAD_ALLOCATOR "${_gcc_alloc_info}")
   else (GCC_IS_NEWER_THAN_4_1)  
      set(_GCC_COMPILED_WITH_BAD_ALLOCATOR FALSE)
   endif (GCC_IS_NEWER_THAN_4_1)  

   if (__KDE_HAVE_GCC_VISIBILITY AND GCC_IS_AT_LEAST_4_1 AND NOT _GCC_COMPILED_WITH_BAD_ALLOCATOR)
      set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fvisibility=hidden")
   endif (__KDE_HAVE_GCC_VISIBILITY AND GCC_IS_AT_LEAST_4_1 AND NOT _GCC_COMPILED_WITH_BAD_ALLOCATOR)

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

   set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS}   -ansi -Wpointer-arith -fno-common")
   set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -ansi -Wpointer-arith -fno-exceptions -fno-common")

   # visibility support
   set(__KDE_HAVE_ICC_VISIBILITY)
#   check_cxx_compiler_flag(-fvisibility=hidden __KDE_HAVE_ICC_VISIBILITY)
#   if (__KDE_HAVE_ICC_VISIBILITY)
#      set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fvisibility=hidden")
#   endif (__KDE_HAVE_ICC_VISIBILITY)

endif (CMAKE_C_COMPILER MATCHES "icc")

# it seems we prefer not to use a different postfix for debug libs, Alex
# SET(CMAKE_DEBUG_POSTFIX "_debug")

###########    end of platform specific stuff  ##########################


# KDE4Macros.cmake contains all the KDE specific macros
include(${kde_cmake_module_dir}/KDE4Macros.cmake)


# decide whether KDE4 has been found
set(KDE4_FOUND FALSE)
if (KDE4_INCLUDE_DIR AND KDE4_LIB_DIR AND KDE4_KCFGC_EXECUTABLE AND KDE4_INSTALLED_VERSION_OK)
   set(KDE4_FOUND TRUE)
endif (KDE4_INCLUDE_DIR AND KDE4_LIB_DIR AND KDE4_KCFGC_EXECUTABLE AND KDE4_INSTALLED_VERSION_OK)


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
  
   if(KDE4_KCFGC_EXECUTABLE)
      message(STATUS "Found KDE4 kconfig_compiler preprocessor: ${KDE4_KCFGC_EXECUTABLE}")
   else(KDE4_KCFGC_EXECUTABLE)
      message(STATUS "Didn't find the KDE4 kconfig_compiler preprocessor")
   endif(KDE4_KCFGC_EXECUTABLE)
endmacro (KDE4_PRINT_RESULTS)


if (KDE4Internal_FIND_REQUIRED AND NOT KDE4_FOUND)
   #bail out if something wasn't found
   kde4_print_results()
   if (NOT KDE4_INSTALLED_VERSION_OK)
     message(FATAL_ERROR "ERROR: the installed kdelibs version ${KDEVERSION} is too old, at least version ${KDE_MIN_VERSION} is required")
   else (NOT KDE4_INSTALLED_VERSION_OK)
     message(FATAL_ERROR "ERROR: could NOT find everything required for compiling KDE 4 programs")
   endif (NOT KDE4_INSTALLED_VERSION_OK)
endif (KDE4Internal_FIND_REQUIRED AND NOT KDE4_FOUND)


if (NOT KDE4Internal_FIND_QUIETLY)
   kde4_print_results()
endif (NOT KDE4Internal_FIND_QUIETLY)

#add the found Qt and KDE include directories to the current include path
set(KDE4_INCLUDES ${QT_INCLUDES} ${KDE4_INCLUDE_DIR} ${_KDE4_PLATFORM_INCLUDE_DIRS} )

# NOT used in Qt4: QT_NO_COMPAT, QT_CLEAN_NAMESPACE, QT_THREAD_SUPPORT
set(KDE4_DEFINITIONS ${_KDE4_PLATFORM_DEFINITIONS} -DQT3_SUPPORT -DQT_NO_STL -DQT_NO_CAST_TO_ASCII -D_REENTRANT -DQT3_SUPPORT_WARNINGS -DKDE_DEPRECATED_WARNINGS )

set( KDELIBSUFF ${LIB_SUFFIX} )


if (NOT _kde4_uninstall_rule_created)
   set(_kde4_uninstall_rule_created TRUE)

   configure_file("${kde_cmake_module_dir}/kde4_cmake_uninstall.cmake.in" "${CMAKE_BINARY_DIR}/cmake_uninstall.cmake" @ONLY)

   add_custom_target(uninstall "${CMAKE_COMMAND}" -P "${CMAKE_BINARY_DIR}/cmake_uninstall.cmake")

endif (NOT _kde4_uninstall_rule_created)
