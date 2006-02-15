# - Find QT 4
# This module can be used to find Qt4.
# This module defines a number of key variables and macros. First is
# QT_USE_FILE which is the path to a CMake file that can be included to compile
# Qt 4 applications and libraries.  By default, the QtCore and QtGui
# libraries are loaded. This behavior can be changed by setting one or more
# of the following variables to true:
#                    QT_DONT_USE_QTCORE
#                    QT_DONT_USE_QTGUI
#                    QT_USE_QT3SUPPORT
#                    QT_USE_QTASSISTANT
#                    QT_USE_QTDESIGNER
#                    QT_USE_QTMOTIF
#                    QT_USE_QTNETWORK
#                    QT_USE_QTNSPLUGIN
#                    QT_USE_QTOPENGL
#                    QT_USE_QTSQL
#                    QT_USE_QTXML
# All the libraries required are stored in a variable called QT_LIBRARIES.
# Add this variable to your TARGET_LINK_LIBRARIES.
#
#  macro QT4_WRAP_CPP(outfiles inputfile ... )
#  macro QT4_WRAP_UI(outfiles inputfile ... )
#  macro QT4_ADD_RESOURCE(outfiles inputfile ... )
#
#  QT_FOUND         If false, don't try to use Qt.
#  QT4_FOUND        If false, don't try to use Qt 4.
#
#  QT_QTCORE_FOUND        True if QtCore was found.
#  QT_QTGUI_FOUND         True if QtGui was found.
#  QT_QT3SUPPORT_FOUND    True if Qt3Support was found.
#  QT_QTASSISTANT_FOUND   True if QtAssistant was found.
#  QT_QTDESIGNER_FOUND    True if QtDesigner was found.
#  QT_QTMOTIF_FOUND       True if QtMotif was found.
#  QT_QTNETWORK_FOUND     True if QtNetwork was found.
#  QT_QTNSPLUGIN_FOUND    True if QtNsPlugin was found.
#  QT_QTOPENGL_FOUND      True if QtOpenGL was found.
#  QT_QTSQL_FOUND         True if QtSql was found.
#  QT_QTXML_FOUND         True if QtXml was found.
#  QT_QTSVG_FOUND         True if QtSvg was found.
#  QT_QTTEST_FOUND        True if QtTest was found.
#
#  QT_DEFINITIONS   Definitions to use when compiling code that
#                   uses Qt.
#
#  QT_INCLUDES      List of paths to all include directories of
#                   Qt4 QT_INCLUDE_DIR and QT_QTCORE_INCLUDE_DIR are
#                   always in this variable even if NOTFOUND,
#                   all other INCLUDE_DIRS are
#                   only added if they are found.
#
#  QT_INCLUDE_DIR              Path to "include" of Qt4
#  QT_QT_INCLUDE_DIR           Path to "include/Qt"
#  QT_QT3SUPPORT_INCLUDE_DIR   Path to "include/Qt3Support"
#  QT_QTASSISTANT_INCLUDE_DIR  Path to "include/QtAssistant"
#  QT_QTCORE_INCLUDE_DIR       Path to "include/QtCore"
#  QT_QTDESIGNER_INCLUDE_DIR   Path to "include/QtDesigner"
#  QT_QTGUI_INCLUDE_DIR        Path to "include/QtGui"
#  QT_QTMOTIF_INCLUDE_DIR      Path to "include/QtMotif"
#  QT_QTNETWORK_INCLUDE_DIR    Path to "include/QtNetwork"
#  QT_QTNSPLUGIN_INCLUDE_DIR   Path to "include/QtNsPlugin"
#  QT_QTOPENGL_INCLUDE_DIR     Path to "include/QtOpenGL"
#  QT_QTSQL_INCLUDE_DIR        Path to "include/QtSql"
#  QT_QTXML_INCLUDE_DIR        Path to "include/QtXml"
#  QT_QTSVG_INCLUDE_DIR        Path to "include/QtSvg"
#  QT_QTTEST_INCLUDE_DIR       Path to "include/QtTest"
#
#  QT_LIBRARY_DIR              Path to "lib" of Qt4
#
#  QT_QT3SUPPORT_LIBRARY       Fullpath to Qt3Support library
#  QT_QTASSISTANT_LIBRARY      Fullpath to QtAssistant library
#  QT_QTCORE_LIBRARY           Fullpath to QtCore library
#  QT_QTDESIGNER_LIBRARY       Fullpath to QtDesigner library
#  QT_QTGUI_LIBRARY            Fullpath to QtGui library
#  QT_QTMOTIF_LIBRARY          Fullpath to QtMotif library
#  QT_QTNETWORK_LIBRARY        Fullpath to QtNetwork library
#  QT_QTNSPLUGIN_LIBRARY       Fullpath to QtNsPlugin library
#  QT_QTOPENGL_LIBRARY         Fullpath to QtOpenGL library
#  QT_QTSQL_LIBRARY            Fullpath to QtSql library
#  QT_QTXML_LIBRARY            Fullpath to QtXml library
#  QT_QTSVG_LIBRARY            Fullpath to QtSvg library
#  QT_QTTEST_LIBRARY           Fullpath to QtTest library
#
#  QT_QT3SUPPORT_LIBRARY_DEBUG  Fullpath to Qt3Support_debug library
#  QT_QTASSISTANT_LIBRARY_DEBUG Fullpath to QtAssistant_debug library
#  QT_QTCORE_LIBRARY_DEBUG      Fullpath to QtCore_debug
#  QT_QTDESIGNER_LIBRARY_DEBUG  Fullpath to QtDesigner_debug
#  QT_QTGUI_LIBRARY_DEBUG       Fullpath to QtGui_debug
#  QT_QTMOTIF_LIBRARY_DEBUG     Fullpath to QtMotif_debug
#  QT_QTNETWORK_LIBRARY_DEBUG   Fullpath to QtNetwork_debug
#  QT_QTNSPLUGIN_LIBRARY_DEBUG  Fullpath to QtNsPlugin_debug
#  QT_QTOPENGL_LIBRARY_DEBUG    Fullpath to QtOpenGL_debug
#  QT_QTSQL_LIBRARY_DEBUG       Fullpath to QtSql_debug
#  QT_QTXML_LIBRARY_DEBUG       Fullpath to QtXml_debug
#  QT_QTSVG_LIBRARY_DEBUG       Fullpath to QtSvg_debug
#  QT_QTTEST_LIBRARY_DEBUG      Fullpath to QtTest_debug
#
# also defined, but NOT for general use are
#  QT_MOC_EXECUTABLE          Where to find the moc tool.
#  QT_UIC_EXECUTABLE          Where to find the uic tool.
#  QT_UIC3_EXECUTABLE         Where to find the uic3 tool.
#  QT_RCC_EXECUTABLE          Where to find the rcc tool
#
#  QT_DOC_DIR                 Path to "doc" of Qt4
#
#
# These are around for backwards compatibility
# they will be set
#  QT_WRAP_CPP  Set true if QT_MOC_EXECUTABLE is found
#  QT_WRAP_UI   Set true if QT_UIC_EXECUTABLE is found
#
# These variables do _NOT_ have any effect anymore (compared to FindQt.cmake)
#  QT_MT_REQUIRED         Qt4 is now always multithreaded
#
# These variables are set to "" Because Qt structure changed
# (They make no sense in Qt4)
#  QT_QT_LIBRARY        Qt-Library is now splitt
#  QT_QTMAIN_LIBRARY    Qt-Library is now splitt

set(QT_USE_FILE ${CMAKE_ROOT}/Modules/UseQt4.cmake)

set( QT_DEFINITIONS "")

if (WIN32)
  set(QT_DEFINITIONS -DQT_DLL)
endif(WIN32)

FILE(GLOB GLOB_TEMP_VAR /usr/local/Trolltech/Qt-4*/)
set(GLOB_TEMP_VAR)
if (GLOB_TEMP_VAR)
  set(QT4_PATHS ${QT4_PATHS} ${GLOB_TEMP_VAR})
endif (GLOB_TEMP_VAR)
set(GLOB_TEMP_VAR)
FILE(GLOB GLOB_TEMP_VAR /usr/local/qt-x11-commercial-4*/bin/)
if (GLOB_TEMP_VAR)
   set(QT4_PATHS ${QT4_PATHS} ${GLOB_TEMP_VAR})
endif (GLOB_TEMP_VAR)

# check for qmake
FIND_PROGRAM(QT_QMAKE_EXECUTABLE NAMES qmake PATHS
  "[HKEY_CURRENT_USER\\Software\\Trolltech\\Qt3Versions\\4.0.0;InstallDir]/bin"
  "[HKEY_CURRENT_USER\\Software\\Trolltech\\Versions\\4.0.0;InstallDir]/bin"
  $ENV{QTDIR}/bin
  ${QT4_PATHS}
  NO_SYSTEM_PATH
)

if (NOT QT_QMAKE_EXECUTABLE)
   FIND_PROGRAM(QT_QMAKE_EXECUTABLE NAMES qmake)
endif (NOT QT_QMAKE_EXECUTABLE)

if (QT_QMAKE_EXECUTABLE)
   EXEC_PROGRAM(${QT_QMAKE_EXECUTABLE} ARGS "-query QT_VERSION"
      OUTPUT_VARIABLE QTVERSION)
   if(QTVERSION MATCHES "4.*")
      set(QT4_QMAKE_FOUND TRUE)
   endif(QTVERSION MATCHES "4.*")
endif (QT_QMAKE_EXECUTABLE)

if(QT4_QMAKE_FOUND)
  # Set QT_LIBRARY_DIR
  if(NOT QT_LIBRARY_DIR)
    EXEC_PROGRAM( ${QT_QMAKE_EXECUTABLE}
       ARGS "-query QT_INSTALL_LIBS"
       OUTPUT_VARIABLE QT_LIBRARY_DIR_TMP )
    if(EXISTS "${QT_LIBRARY_DIR_TMP}")
       set(QT_LIBRARY_DIR ${QT_LIBRARY_DIR_TMP} CACHE PATH "Qt library dir")
    else(EXISTS "${QT_LIBRARY_DIR_TMP}")
       message("Warning: QT_QMAKE_EXECUTABLE reported QT_INSTALL_LIBS as ${QT_LIBRARY_DIR_TMP}")
       message("Warning: ${QT_LIBRARY_DIR_TMP} does NOT exist, Qt must NOT be installed correctly.")
    endif(EXISTS "${QT_LIBRARY_DIR_TMP}")
  endif(NOT QT_LIBRARY_DIR)

  if (APPLE)
    if (EXISTS ${QT_LIBRARY_DIR}/QtCore.framework)
      set(QT_USE_FRAMEWORKS ON
         CACHE BOOL "Set to ON if Qt build uses frameworks.")
    else (EXISTS ${QT_LIBRARY_DIR}/QtCore.framework)
       set(QT_USE_FRAMEWORKS OFF
         CACHE BOOL "Set to ON if Qt build uses frameworks.")
    endif (EXISTS ${QT_LIBRARY_DIR}/QtCore.framework)

    MARK_AS_ADVANCED(QT_USE_FRAMEWORKS)
  endif (APPLE)

  ########################################
  #
  #       Setting the INCLUDE-Variables
  #
  ########################################
  if (NOT QT_HEADERS_DIR)
    # Set QT_QTCORE_INCLUDE_DIR by searching for the QtGlobal header
    if(QT_QMAKE_EXECUTABLE)
      EXEC_PROGRAM( ${QT_QMAKE_EXECUTABLE}
        ARGS "-query QT_INSTALL_HEADERS"
        OUTPUT_VARIABLE qt_headers )
      set(QT_HEADERS_DIR ${qt_headers} CACHE INTERNAL "")
    endif(QT_QMAKE_EXECUTABLE)
  endif (NOT QT_HEADERS_DIR)
  
  FILE(GLOB GLOB_TEMP_VAR /usr/local/qt-x11-commercial-3*/include/Qt/)
  set(QT_PATH_INCLUDE ${GLOB_TEMP_VAR})
  FILE(GLOB GLOB_TEMP_VAR /usr/local/Trolltech/Qt-4*/include/Qt/)
  set(QT_PATH_INCLUDE ${GLOB_TEMP_VAR})
  
  FIND_PATH( QT_QTCORE_INCLUDE_DIR QtGlobal
    "[HKEY_CURRENT_USER\\Software\\Trolltech\\Qt3Versions\\4.0.0;InstallDir]/include/QtCore"
    ${QT_PATH_INCLUDE}
    ${QT_HEADERS_DIR}/QtCore
    ${QT_LIBRARY_DIR}/QtCore.framework/Headers
    $ENV{QTDIR}/include/QtCore
    /usr/local/qt/include/QtCore
    /usr/local/include/QtCore
    /usr/lib/qt/include/QtCore
    /usr/include/QtCore
    /usr/share/qt4/include/QtCore
    "C:/Program Files/qt/include/QtCore"
    /usr/include/qt4/QtCore)

  # Set QT_INCLUDE_DIR by removine "/QtCore" in the string ${QT_QTCORE_INCLUDE_DIR}
  if( QT_QTCORE_INCLUDE_DIR AND NOT QT_INCLUDE_DIR)
    if (QT_USE_FRAMEWORKS)
      set(QT_INCLUDE_DIR ${QT_HEADERS_DIR})
    else (QT_USE_FRAMEWORKS)
      STRING( REGEX REPLACE "/QtCore$" "" qt4_include_dir ${QT_QTCORE_INCLUDE_DIR})
      set( QT_INCLUDE_DIR ${qt4_include_dir} CACHE PATH "")
    endif (QT_USE_FRAMEWORKS)
  endif( QT_QTCORE_INCLUDE_DIR AND NOT QT_INCLUDE_DIR)
  
  if( NOT QT_INCLUDE_DIR)
    if( NOT Qt4_FIND_QUIETLY AND Qt4_FIND_REQUIRED)
      message( FATAL_ERROR "Could NOT find QtGlobal header")
    endif( NOT Qt4_FIND_QUIETLY AND Qt4_FIND_REQUIRED)
  endif( NOT QT_INCLUDE_DIR)


  FIND_PATH( QT_DOC_DIR /html/qcoreapplication.html
    ${QT_PATH_INCLUDE}
    $ENV{QTDIR}/doc
    /usr/local/qt/doc
    /usr/lib/qt/doc
    /usr/share/qt4/doc
    "C:/Program Files/qt/doc"
  )

  if (QT_USE_FRAMEWORKS)
    set(QT_DEFINITIONS ${QT_DEFINITIONS} -F${QT_LIBRARY_DIR} -L${QT_LIBRARY_DIR} )
  endif (QT_USE_FRAMEWORKS)

  # Set QT_QT3SUPPORT_INCLUDE_DIR
  FIND_PATH( QT_QT3SUPPORT_INCLUDE_DIR Qt3Support
    ${QT_INCLUDE_DIR}/Qt3Support
    ${QT_LIBRARY_DIR}/Qt3Support.framework/Headers
    )

  # Set QT_QT_INCLUDE_DIR
  FIND_PATH( QT_QT_INCLUDE_DIR qglobal.h
    ${QT_INCLUDE_DIR}/Qt
    ${QT_LIBRARY_DIR}/QtCore.framework/Headers
    )

  # Set QT_QTGUI_INCLUDE_DIR
  FIND_PATH( QT_QTGUI_INCLUDE_DIR QtGui
    ${QT_INCLUDE_DIR}/QtGui
    ${QT_LIBRARY_DIR}/QtGui.framework/Headers
    )

  # Set QT_QTSVG_INCLUDE_DIR
  FIND_PATH( QT_QTSVG_INCLUDE_DIR QtSvg
    ${QT_INCLUDE_DIR}/QtSvg
    ${QT_LIBRARY_DIR}/QtSvg.framework/Headers
    )

  # Set QT_QTTEST_INCLUDE_DIR
  FIND_PATH( QT_QTTEST_INCLUDE_DIR QtTest
    ${QT_INCLUDE_DIR}/QtTest
    ${QT_LIBRARY_DIR}/QtTest.framework/Headers
    )


  # Set QT_QTMOTIF_INCLUDE_DIR
  FIND_PATH( QT_QTMOTIF_INCLUDE_DIR QtMotif ${QT_INCLUDE_DIR}/QtMotif)

  # Set QT_QTNETWORK_INCLUDE_DIR
  FIND_PATH( QT_QTNETWORK_INCLUDE_DIR QtNetwork
    ${QT_INCLUDE_DIR}/QtNetwork
    ${QT_LIBRARY_DIR}/QtNetwork.framework/Headers
    )

  # Set QT_QTNSPLUGIN_INCLUDE_DIR
  FIND_PATH( QT_QTNSPLUGIN_INCLUDE_DIR QtNsPlugin
    ${QT_INCLUDE_DIR}/QtNsPlugin
    ${QT_LIBRARY_DIR}/QtNsPlugin.framework/Headers
    )

  # Set QT_QTOPENGL_INCLUDE_DIR
  FIND_PATH( QT_QTOPENGL_INCLUDE_DIR QtOpenGL
    ${QT_INCLUDE_DIR}/QtOpenGL
    ${QT_LIBRARY_DIR}/QtOpenGL.framework/Headers
    )

  # Set QT_QTSQL_INCLUDE_DIR
  FIND_PATH( QT_QTSQL_INCLUDE_DIR QtSql
    ${QT_INCLUDE_DIR}/QtSql
    ${QT_LIBRARY_DIR}/QtSql.framework/Headers
    )

  # Set QT_QTXML_INCLUDE_DIR
  FIND_PATH( QT_QTXML_INCLUDE_DIR QtXml
    ${QT_INCLUDE_DIR}/QtXml
    ${QT_LIBRARY_DIR}/QtXml.framework/Headers
    )

  # Set QT_QTASSISTANT_INCLUDE_DIR
  FIND_PATH( QT_QTASSISTANT_INCLUDE_DIR QtAssistant
    ${QT_INCLUDE_DIR}/QtAssistant
    ${QT_HEADERS_DIR}/QtAssistant
    )

  # Set QT_QTDESIGNER_INCLUDE_DIR
  FIND_PATH( QT_QTDESIGNER_INCLUDE_DIR QDesignerComponents
    ${QT_INCLUDE_DIR}/QtDesigner
    ${QT_HEADERS_DIR}/QtDesigner
    )

  # Make variables changeble to the advanced user
  MARK_AS_ADVANCED( QT_LIBRARY_DIR QT_INCLUDE_DIR QT_QT_INCLUDE_DIR )

  # Set QT_INCLUDES
  set( QT_INCLUDES ${QT_INCLUDE_DIR} ${QT_QT_INCLUDE_DIR} )


  ########################################
  #
  #       Setting the LIBRARY-Variables
  #
  ########################################

  if (QT_USE_FRAMEWORKS)
    # If FIND_LIBRARY found libraries in Apple frameworks, we would NOT have
    # to jump through these hoops.
    set(QT_QTCORE_LIBRARY "-F${QT_LIBRARY_DIR} -framework QtCore"
       CACHE STRING "The QtCore library.")
    set(QT_QTCORE_LIBRARY_DEBUG "-F${QT_LIBRARY_DIR} -framework QtCore"
       CACHE STRING "The QtCore library.")
    set(QT_QT3SUPPORT_LIBRARY "-framework Qt3Support"
       CACHE STRING "The Qt3Support library.")
    set(QT_QT3SUPPORT_LIBRARY_DEBUG "-framework Qt3Support"
       CACHE STRING "The Qt3Support library.")
    set(QT_QTGUI_LIBRARY "-framework QtGui"
       CACHE STRING "The QtGui library.")
    set(QT_QTGUI_LIBRARY_DEBUG "-framework QtGui"
       CACHE STRING "The QtGui library.")
    set(QT_QTNETWORK_LIBRARY "-framework QtNetwork"
       CACHE STRING "The QtNetwork library.")
    set(QT_QTNETWORK_LIBRARY_DEBUG "-framework QtNetwork"
       CACHE STRING "The QtNetwork library.")
    set(QT_QTOPENGL_LIBRARY "-framework QtOpenGL"
       CACHE STRING "The QtOpenGL library.")
    set(QT_QTOPENGL_LIBRARY_DEBUG "-framework QtOpenGL"
       CACHE STRING "The QtOpenGL library.")
    set(QT_QTSQL_LIBRARY "-framework QtSql"
       CACHE STRING "The QtSql library.")
    set(QT_QTSQL_LIBRARY_DEBUG "-framework QtSql"
       CACHE STRING "The QtSql library.")
    set(QT_QTXML_LIBRARY "-framework QtXml"
       CACHE STRING "The QtXml library.")
    set(QT_QTXML_LIBRARY_DEBUG "-framework QtXml"
       CACHE STRING "The QtXml library.")
    set(QT_QTSVG_LIBRARY "-framework QtSvg"
       CACHE STRING "The QtSvg library.")
    set(QT_QTSVG_LIBRARY_DEBUG "-framework QtSvg"
       CACHE STRING "The QtSvg library.")

    # WTF?  why don't we have frameworks?  :P
    set(QT_QTTEST_LIBRARY "-L${QT_LIBRARY_DIR} -lQtTest"
       CACHE STRING "The QtTest library.")
    set(QT_QTTEST_LIBRARY_DEBUG "-L${QT_LIBRARY_DIR} -lQtTest"
       CACHE STRING "The QtTest library.")

  else (QT_USE_FRAMEWORKS)

    # Set QT_QTCORE_LIBRARY by searching for a lib with "QtCore."  as part of
    # the filename
    FIND_LIBRARY(  QT_QTCORE_LIBRARY
      NAMES QtCore QtCore4
      PATHS
      ${QT_LIBRARY_DIR}
      $ENV{QTDIR}/lib
      /usr/local/qt/lib
      /usr/local/lib
      /usr/lib/qt/lib
      /usr/lib
      /usr/share/qt4/lib
      C:/Progra~1/qt/lib
      /usr/lib/qt4 )

    # Set QT_QTCORE_LIBRARY_DEBUG by searching for a lib with "QtCore_debug"
    # as part of the filename
    FIND_LIBRARY(  QT_QTCORE_LIBRARY_DEBUG
      NAMES QtCore_debug QtCored4
      PATHS
      ${QT_LIBRARY_DIR}
      $ENV{QTDIR}/lib
      /usr/local/qt/lib
      /usr/local/lib
      /usr/lib/qt/lib
      /usr/lib
      /usr/share/qt4/lib
      C:/Progra~1/qt/lib
      /usr/lib/qt4 )

    # Set QT_QT3SUPPORT_LIBRARY
    FIND_LIBRARY(QT_QT3SUPPORT_LIBRARY  NAMES Qt3Support Qt3Support4 PATHS ${QT_LIBRARY_DIR})
    FIND_LIBRARY(QT_QT3SUPPORT_LIBRARY_DEBUG NAMES Qt3Support_debug Qt3Supportd4 PATHS ${QT_LIBRARY_DIR})

    # Set QT_QTGUI_LIBRARY
    FIND_LIBRARY(QT_QTGUI_LIBRARY NAMES QtGui QtGui4 PATHS ${QT_LIBRARY_DIR})
    FIND_LIBRARY(QT_QTGUI_LIBRARY_DEBUG NAMES QtGui_debug QtGuid4 PATHS ${QT_LIBRARY_DIR})

    # Set QT_QTMOTIF_LIBRARY
    FIND_LIBRARY(QT_QTMOTIF_LIBRARY NAMES QtMotif PATHS ${QT_LIBRARY_DIR})
    FIND_LIBRARY(QT_QTMOTIF_LIBRARY_DEBUG NAMES QtMotif_debug PATHS ${QT_LIBRARY_DIR})

    # Set QT_QTNETWORK_LIBRARY
    FIND_LIBRARY(QT_QTNETWORK_LIBRARY NAMES QtNetwork QtNetwork4 PATHS ${QT_LIBRARY_DIR})
    FIND_LIBRARY(QT_QTNETWORK_LIBRARY_DEBUG NAMES QtNetwork_debug QtNetworkd4 PATHS ${QT_LIBRARY_DIR})

    # Set QT_QTNSPLUGIN_LIBRARY
    FIND_LIBRARY(QT_QTNSPLUGIN_LIBRARY NAMES QtNsPlugin PATHS ${QT_LIBRARY_DIR})
    FIND_LIBRARY(QT_QTNSPLUGIN_LIBRARY_DEBUG NAMES QtNsPlugin_debug PATHS ${QT_LIBRARY_DIR})

    # Set QT_QTOPENGL_LIBRARY
    FIND_LIBRARY(QT_QTOPENGL_LIBRARY NAMES QtOpenGL QtOpenGL4 PATHS ${QT_LIBRARY_DIR})
    FIND_LIBRARY(QT_QTOPENGL_LIBRARY_DEBUG NAMES QtOpenGL_debug QtOpenGLd4 PATHS ${QT_LIBRARY_DIR})

    # Set QT_QTSQL_LIBRARY
    FIND_LIBRARY(QT_QTSQL_LIBRARY NAMES QtSql QtSql4 PATHS ${QT_LIBRARY_DIR})
    FIND_LIBRARY(QT_QTSQL_LIBRARY_DEBUG NAMES QtSql_debug QtSqld4 PATHS ${QT_LIBRARY_DIR})

    # Set QT_QTXML_LIBRARY
    FIND_LIBRARY(QT_QTXML_LIBRARY NAMES QtXml QtXml4 PATHS ${QT_LIBRARY_DIR})
    FIND_LIBRARY(QT_QTXML_LIBRARY_DEBUG NAMES QtXml_debug QtXmld4 PATHS ${QT_LIBRARY_DIR})

    # Set QT_QTSVG_LIBRARY
    FIND_LIBRARY(QT_QTSVG_LIBRARY NAMES QtSvg QtSvg4 PATHS ${QT_LIBRARY_DIR})
    FIND_LIBRARY(QT_QTSVG_LIBRARY_DEBUG NAMES QtSvg_debug QtSvgd4 PATHS ${QT_LIBRARY_DIR})

    # Set QT_QTTEST_LIBRARY
    FIND_LIBRARY(QT_QTTEST_LIBRARY NAMES QtTest QtTest4 PATHS ${QT_LIBRARY_DIR})
    FIND_LIBRARY(QT_QTTEST_LIBRARY_DEBUG NAMES QtTest_debug QtTest_debug4 QtTestd4 PATHS ${QT_LIBRARY_DIR})

  endif (QT_USE_FRAMEWORKS)

  # Set QT_QTASSISTANT_LIBRARY
  FIND_LIBRARY(QT_QTASSISTANT_LIBRARY  NAMES QtAssistantClient QtAssistant QtAssistant4 PATHS ${QT_LIBRARY_DIR})
  FIND_LIBRARY(QT_QTASSISTANT_LIBRARY_DEBUG NAMES QtAssistantClientd QtAssistantClient_debug QtAssistant_debug QtAssistantd4 PATHS ${QT_LIBRARY_DIR})

  # Set QT_QTDESIGNER_LIBRARY
  FIND_LIBRARY(QT_QTDESIGNER_LIBRARY NAMES QtDesigner QtDesigner4 PATHS ${QT_LIBRARY_DIR})
  FIND_LIBRARY(QT_QTDESIGNER_LIBRARY_DEBUG NAMES QtDesigner_debug QtDesignerd4 PATHS ${QT_LIBRARY_DIR})

  ############################################
  #
  # Check the existence of the libraries.
  #
  ############################################

  MACRO(_QT4_ADJUST_LIB_VARS basename)
    if (QT_${basename}_INCLUDE_DIR)

      # if only the release version was found, set the debug variable also to the release version
      if (QT_${basename}_LIBRARY AND NOT QT_${basename}_LIBRARY_DEBUG)
        set(QT_${basename}_LIBRARY_DEBUG ${QT_${basename}_LIBRARY})
      endif (QT_${basename}_LIBRARY AND NOT QT_${basename}_LIBRARY_DEBUG)

      # if only the debug version was found, set the release variable also to the debug version
      if (QT_${basename}_LIBRARY_DEBUG AND NOT QT_${basename}_LIBRARY)
        set(QT_${basename}_LIBRARY ${QT_${basename}_LIBRARY_DEBUG})
      endif (QT_${basename}_LIBRARY_DEBUG AND NOT QT_${basename}_LIBRARY)

      if (QT_${basename}_LIBRARY)
        set(QT_${basename}_FOUND 1)
      endif (QT_${basename}_LIBRARY)

      #add the include directory to QT_INCLUDES
      set(QT_INCLUDES ${QT_INCLUDES} "${QT_${basename}_INCLUDE_DIR}")
    endif (QT_${basename}_INCLUDE_DIR )

    # Make variables changeble to the advanced user
    MARK_AS_ADVANCED(QT_${basename}_LIBRARY QT_${basename}_LIBRARY_DEBUG QT_${basename}_INCLUDE_DIR)
  ENDMACRO(_QT4_ADJUST_LIB_VARS)

  _QT4_ADJUST_LIB_VARS(QTCORE)
  _QT4_ADJUST_LIB_VARS(QTGUI)
  _QT4_ADJUST_LIB_VARS(QT3SUPPORT)
  _QT4_ADJUST_LIB_VARS(QTASSISTANT)
  _QT4_ADJUST_LIB_VARS(QTDESIGNER)
  _QT4_ADJUST_LIB_VARS(QTMOTIF)
  _QT4_ADJUST_LIB_VARS(QTNETWORK)
  _QT4_ADJUST_LIB_VARS(QTNSPLUGIN)
  _QT4_ADJUST_LIB_VARS(QTOPENGL)
  _QT4_ADJUST_LIB_VARS(QTSQL)
  _QT4_ADJUST_LIB_VARS(QTXML)
  _QT4_ADJUST_LIB_VARS(QTSVG)
  _QT4_ADJUST_LIB_VARS(QTTEST)

  #######################################
  #
  #       Check the executables of Qt
  #          ( moc, uic, rcc )
  #
  #######################################
  if (NOT QT_BINARY_DIR)
     EXEC_PROGRAM( ${QT_QMAKE_EXECUTABLE}
        ARGS "-query QT_INSTALL_BINS"
        OUTPUT_VARIABLE qt_bins )
     set(QT_BINARY_DIR ${qt_bins} CACHE INTERNAL "")
  endif (NOT QT_BINARY_DIR)

  # at first without the system paths, in order to prefer e.g. ${QTDIR}/bin/qmake over /usr/bin/qmake,
  # which might be a Qt3 qmake
  FIND_PROGRAM(QT_MOC_EXECUTABLE
    NAMES moc
    PATHS
    ${QT_BINARY_DIR}
    $ENV{QTDIR}/bin
    /usr/local/qt/bin
    /usr/local/bin
    /usr/lib/qt/bin
    /usr/bin
    /usr/share/qt4/bin
    C:/Progra~1/qt/bin
    /usr/bin/qt4
    NO_SYSTEM_PATH
    )

  # if qmake wasn't found in the specific dirs, now check the system path
  if (NOT QT_MOC_EXECUTABLE)
     FIND_PROGRAM(QT_MOC_EXECUTABLE NAMES moc )
  endif (NOT QT_MOC_EXECUTABLE)

  if (QT_MOC_EXECUTABLE)
     set ( QT_WRAP_CPP "YES")
  endif (QT_MOC_EXECUTABLE)

  FIND_PROGRAM(QT_UIC3_EXECUTABLE
    NAMES uic3
    PATHS
    ${QT_BINARY_DIR}
    $ENV{QTDIR}/bin
    /usr/local/qt/bin
    /usr/local/bin
    /usr/lib/qt/bin
    /usr/bin
    /usr/share/qt4/bin
    C:/Progra~1/qt/bin
    /usr/bin/qt4
    )

  # first the specific paths, then the system path, same as with qmake
  FIND_PROGRAM(QT_UIC_EXECUTABLE
    NAMES uic
    PATHS
    ${QT_BINARY_DIR}
    $ENV{QTDIR}/bin
    /usr/local/qt/bin
    /usr/local/bin
    /usr/lib/qt/bin
    /usr/bin
    /usr/share/qt4/bin
    C:/Progra~1/qt/bin
    /usr/bin/qt4
    NO_SYSTEM_PATH
    )

  if (NOT QT_UIC_EXECUTABLE)
     FIND_PROGRAM(QT_UIC_EXECUTABLE NAMES uic )
  endif (NOT QT_UIC_EXECUTABLE)

  if (QT_UIC_EXECUTABLE)
     set ( QT_WRAP_UI "YES")
  endif (QT_UIC_EXECUTABLE)

  FIND_PROGRAM(QT_RCC_EXECUTABLE
    NAMES rcc
    PATHS
    ${QT_BINARY_DIR}
    $ENV{QTDIR}/bin
    /usr/local/qt/bin
    /usr/local/bin
    /usr/lib/qt/bin
    /usr/bin
    /usr/share/qt4/bin
    C:/Progra~1/qt/bin
    /usr/bin/qt4
    )

  MARK_AS_ADVANCED(
    QT_UIC_EXECUTABLE
    QT_UIC3_EXECUTABLE
    QT_MOC_EXECUTABLE
    QT_RCC_EXECUTABLE )

  ######################################
  #
  #       Macros for building Qt files
  #
  ######################################

  MACRO(QT4_GET_MOC_INC_DIRS _moc_INC_DIRS)
     set(${_moc_INC_DIRS})
     GET_DIRECTORY_PROPERTY(_inc_DIRS INCLUDE_DIRECTORIES)

     foreach(_current ${_inc_DIRS})
        set(${_moc_INC_DIRS} ${${_moc_INC_DIRS}} "-I" ${_current})
     endforeach(_current ${_inc_DIRS})
  ENDMACRO(QT4_GET_MOC_INC_DIRS)

  MACRO(QT4_GENERATE_MOC infile outfile )
  # get include dirs
     QT4_GET_MOC_INC_DIRS(moc_includes)

     GET_FILENAME_COMPONENT(infile ${infile} ABSOLUTE)
    
     ADD_CUSTOM_COMMAND(OUTPUT ${outfile}
        COMMAND ${QT_MOC_EXECUTABLE}
        ARGS ${moc_includes} -o ${outfile} ${infile}
        MAIN_DEPENDENCY ${infile})
  ENDMACRO(QT4_GENERATE_MOC)


  # QT4_WRAP_CPP(outfiles inputfile ... )
  # TODO  perhaps add support for -D, -U and other minor options

  MACRO(QT4_WRAP_CPP outfiles )
    # get include dirs
    QT4_GET_MOC_INC_DIRS(moc_includes)

    foreach(it ${ARGN})
      GET_FILENAME_COMPONENT(it ${it} ABSOLUTE)
      GET_FILENAME_COMPONENT(outfile ${it} NAME_WE)

      set(outfile ${CMAKE_CURRENT_BINARY_DIR}/moc_${outfile}.cxx)
      ADD_CUSTOM_COMMAND(OUTPUT ${outfile}
        COMMAND ${QT_MOC_EXECUTABLE}
        ARGS ${moc_includes} -o ${outfile} ${it}
        MAIN_DEPENDENCY ${it})
      set(${outfiles} ${${outfiles}} ${outfile})
    endforeach(it)

  ENDMACRO(QT4_WRAP_CPP)


  # QT4_WRAP_UI(outfiles inputfile ... )

  MACRO(QT4_WRAP_UI outfiles )

    foreach(it ${ARGN})
      GET_FILENAME_COMPONENT(outfile ${it} NAME_WE)
      set(infile ${CMAKE_CURRENT_SOURCE_DIR}/${it})
      set(outfile ${CMAKE_CURRENT_BINARY_DIR}/ui_${outfile}.h)
      ADD_CUSTOM_COMMAND(OUTPUT ${outfile}
        COMMAND ${QT_UIC_EXECUTABLE}
        ARGS -o ${outfile} ${infile}
        MAIN_DEPENDENCY ${infile})
      set(${outfiles} ${${outfiles}} ${outfile})
    endforeach(it)

  ENDMACRO(QT4_WRAP_UI)

  # QT4_ADD_RESOURCE(outfiles inputfile ... )
  # TODO  perhaps consider adding support for compression and root options to rcc

  MACRO(QT4_ADD_RESOURCES outfiles )

    foreach(it ${ARGN})
      GET_FILENAME_COMPONENT(outfilename ${it} NAME_WE)
      set(infile ${CMAKE_CURRENT_SOURCE_DIR}/${it})
      set(outfile ${CMAKE_CURRENT_BINARY_DIR}/qrc_${outfilename}.cxx)
      ADD_CUSTOM_COMMAND(OUTPUT ${outfile}
        COMMAND ${QT_RCC_EXECUTABLE}
        ARGS -name ${outfilename} -o ${outfile} ${infile}
        MAIN_DEPENDENCY ${infile} )
      set(${outfiles} ${${outfiles}} ${outfile})
    endforeach(it)

  ENDMACRO(QT4_ADD_RESOURCES)



  ######################################
  #
  #       decide if Qt got found
  #
  ######################################
  # if the includes,libraries,moc,uic and rcc are found then we have it
  if( QT_LIBRARY_DIR AND QT_INCLUDE_DIR AND QT_MOC_EXECUTABLE AND QT_UIC_EXECUTABLE AND QT_RCC_EXECUTABLE)
    set( QT4_FOUND "YES" )
    if( NOT Qt4_FIND_QUIETLY)
      message(STATUS "Found Qt-Version ${QTVERSION}")
#      message(STATUS "Found Qt-Version ${QT_INST_MAJOR_VERSION}.${QT_INST_MINOR_VERSION}.${QT_INST_PATCH_VERSION}")
    endif( NOT Qt4_FIND_QUIETLY)
  else( QT_LIBRARY_DIR AND QT_INCLUDE_DIR AND QT_MOC_EXECUTABLE AND QT_UIC_EXECUTABLE AND QT_RCC_EXECUTABLE)
    set( QT4_FOUND "NO")
    if( Qt4_FIND_REQUIRED)
      message( FATAL_ERROR "Qt libraries, includes, moc, uic or/and rcc NOT found!")
    endif( Qt4_FIND_REQUIRED)
  endif( QT_LIBRARY_DIR AND QT_INCLUDE_DIR AND QT_MOC_EXECUTABLE AND QT_UIC_EXECUTABLE AND  QT_RCC_EXECUTABLE)
  set(QT_FOUND ${QT4_FOUND})


  #######################################
  #
  #       System dependent settings
  #
  #######################################
  # for unix add X11 stuff
  if(UNIX)
    FIND_PACKAGE(X11)
    FIND_PACKAGE(Threads)
    set(QT_QTCORE_LIBRARY ${QT_QTCORE_LIBRARY} ${CMAKE_THREAD_LIBS_INIT})
  endif(UNIX)


  #######################################
  #
  #       compatibility settings
  #
  #######################################
  # Backwards compatibility for CMake1.4 and 1.2
  set (QT_MOC_EXE ${QT_MOC_EXECUTABLE} )
  set (QT_UIC_EXE ${QT_UIC_EXECUTABLE} )

  set( QT_QT_LIBRARY "")
  set( QT_QTMAIN_LIBRARY "")
else(QT4_QMAKE_FOUND)
  if(QT_QMAKE_EXECUTABLE)
    message("QT_QMAKE_EXECUTABLE set to qmake version: QTVERSION = ${QTVERSION}\nQT_QMAKE_EXECUTABLE = ${QT_QMAKE_EXECUTABLE}, please set to path to qmake from qt4.")
  endif(QT_QMAKE_EXECUTABLE)
  if( Qt4_FIND_REQUIRED)
     message( FATAL_ERROR "Qt qmake NOT found!")
  endif( Qt4_FIND_REQUIRED)

endif(QT4_QMAKE_FOUND)
