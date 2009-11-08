# - Find QT 4
# This module can be used to find Qt4.
# The most important issue is that the Qt4 qmake is available via the system path.
# This qmake is then used to detect basically everything else.
# This module defines a number of key variables and macros. 
# The variable QT_USE_FILE is set which is the path to a CMake file that can be included 
# to compile Qt 4 applications and libraries.  It sets up the compilation
# environment for include directories, preprocessor defines and populates a
# QT_LIBRARIES variable.
#
# Typical usage could be something like:
#   find_package(Qt4 4.4.3 COMPONENTS QtCore QtGui QtXml REQUIRED )
#   include(${QT_USE_FILE})
#   add_executable(myexe main.cpp)
#   target_link_libraries(myexe ${QT_LIBRARIES})
#
# The minimum required version can be specified using the standard find_package()-syntax
# (see example above). 
# For compatibility with older versions of FindQt4.cmake it is also possible to
# set the variable QT_MIN_VERSION to the minimum required version of Qt4 before the 
# find_package(Qt4) command. 
# If both are used, the version used in the find_package() command overrides the
# one from QT_MIN_VERSION.
#
# When using the components argument, QT_USE_QT* variables are automatically set
# for the QT_USE_FILE to pick up.  If one wishes to manually set them, the
# available ones to set include:
#                    QT_DONT_USE_QTCORE
#                    QT_DONT_USE_QTGUI
#                    QT_USE_QT3SUPPORT
#                    QT_USE_QTASSISTANT
#                    QT_USE_QAXCONTAINER
#                    QT_USE_QAXSERVER
#                    QT_USE_QTDESIGNER
#                    QT_USE_QTMOTIF
#                    QT_USE_QTMAIN
#                    QT_USE_QTNETWORK
#                    QT_USE_QTNSPLUGIN
#                    QT_USE_QTOPENGL
#                    QT_USE_QTSQL
#                    QT_USE_QTXML
#                    QT_USE_QTSVG
#                    QT_USE_QTTEST
#                    QT_USE_QTUITOOLS
#                    QT_USE_QTDBUS
#                    QT_USE_QTSCRIPT
#                    QT_USE_QTASSISTANTCLIENT
#                    QT_USE_QTHELP
#                    QT_USE_QTWEBKIT
#                    QT_USE_QTXMLPATTERNS
#                    QT_USE_PHONON
#                    QT_USE_QTSCRIPTTOOLS
#
# There are also some files that need processing by some Qt tools such as moc
# and uic.  Listed below are macros that may be used to process those files.
#  
#  macro QT4_WRAP_CPP(outfiles inputfile ... OPTIONS ...)
#        create moc code from a list of files containing Qt class with
#        the Q_OBJECT declaration.  Per-direcotry preprocessor definitions 
#        are also added.  Options may be given to moc, such as those found
#        when executing "moc -help".  
#
#  macro QT4_WRAP_UI(outfiles inputfile ... OPTIONS ...)
#        create code from a list of Qt designer ui files.
#        Options may be given to uic, such as those found
#        when executing "uic -help"
#
#  macro QT4_ADD_RESOURCES(outfiles inputfile ... OPTIONS ...)
#        create code from a list of Qt resource files.
#        Options may be given to rcc, such as those found
#        when executing "rcc -help"
#
#  macro QT4_GENERATE_MOC(inputfile outputfile )
#        creates a rule to run moc on infile and create outfile.
#        Use this if for some reason QT4_WRAP_CPP() isn't appropriate, e.g.
#        because you need a custom filename for the moc file or something similar.
#
#  macro QT4_AUTOMOC(sourcefile1 sourcefile2 ... )
#        This macro is still experimental.
#        It can be used to have moc automatically handled.
#        So if you have the files foo.h and foo.cpp, and in foo.h a 
#        a class uses the Q_OBJECT macro, moc has to run on it. If you don't
#        want to use QT4_WRAP_CPP() (which is reliable and mature), you can insert
#        #include "foo.moc"
#        in foo.cpp and then give foo.cpp as argument to QT4_AUTOMOC(). This will the
#        scan all listed files at cmake-time for such included moc files and if it finds
#        them cause a rule to be generated to run moc at build time on the 
#        accompanying header file foo.h.
#        If a source file has the SKIP_AUTOMOC property set it will be ignored by this macro.
#
#  macro QT4_ADD_DBUS_INTERFACE(outfiles interface basename)
#        create a the interface header and implementation files with the 
#        given basename from the given interface xml file and add it to 
#        the list of sources.
#        To disable generating a namespace header, set the source file property 
#        NO_NAMESPACE to TRUE on the interface file.
#        To include a header in the interface header, set the source file property
#        INCLUDE to the name of the header.
#        To specify a class name to use, set the source file property CLASSNAME
#        to the name of the class.
#
#  macro QT4_ADD_DBUS_INTERFACES(outfiles inputfile ... )
#        create the interface header and implementation files 
#        for all listed interface xml files
#        the name will be automatically determined from the name of the xml file
#        To disable generating namespace headers, set the source file property 
#        NO_NAMESPACE to TRUE for these inputfiles.
#        To include a header in the interface header, set the source file property
#        INCLUDE to the name of the header.
#        To specify a class name to use, set the source file property CLASSNAME
#        to the name of the class.
#
#  macro QT4_ADD_DBUS_ADAPTOR(outfiles xmlfile parentheader parentclassname [basename] [classname])
#        create a dbus adaptor (header and implementation file) from the xml file
#        describing the interface, and add it to the list of sources. The adaptor
#        forwards the calls to a parent class, defined in parentheader and named
#        parentclassname. The name of the generated files will be
#        <basename>adaptor.{cpp,h} where basename defaults to the basename of the xml file.
#        If <classname> is provided, then it will be used as the classname of the
#        adaptor itself.
#
#  macro QT4_GENERATE_DBUS_INTERFACE( header [interfacename] OPTIONS ...)
#        generate the xml interface file from the given header.
#        If the optional argument interfacename is omitted, the name of the 
#        interface file is constructed from the basename of the header with
#        the suffix .xml appended.
#        Options may be given to qdbuscpp2xml, such as those found when executing "qdbuscpp2xml --help"
#
#  macro QT4_CREATE_TRANSLATION( qm_files directories ... sources ... 
#                                ts_files ... OPTIONS ...)
#        out: qm_files
#        in:  directories sources ts_files
#        options: flags to pass to lupdate, such as -extensions to specify
#        extensions for a directory scan.
#        generates commands to create .ts (vie lupdate) and .qm
#        (via lrelease) - files from directories and/or sources. The ts files are 
#        created and/or updated in the source tree (unless given with full paths).
#        The qm files are generated in the build tree.
#        Updating the translations can be done by adding the qm_files
#        to the source list of your library/executable, so they are
#        always updated, or by adding a custom target to control when
#        they get updated/generated.
#
#  macro QT4_ADD_TRANSLATION( qm_files ts_files ... )
#        out: qm_files
#        in:  ts_files
#        generates commands to create .qm from .ts - files. The generated
#        filenames can be found in qm_files. The ts_files
#        must exists and are not updated in any way.
#
#
#  Below is a detailed list of variables that FindQt4.cmake sets.
#  QT_FOUND         If false, don't try to use Qt.
#  QT4_FOUND        If false, don't try to use Qt 4.
#
#  QT_VERSION_MAJOR The major version of Qt found.
#  QT_VERSION_MINOR The minor version of Qt found.
#  QT_VERSION_PATCH The patch version of Qt found.
#
#  QT_EDITION               Set to the edition of Qt (i.e. DesktopLight)
#  QT_EDITION_DESKTOPLIGHT  True if QT_EDITION == DesktopLight
#  QT_QTCORE_FOUND          True if QtCore was found.
#  QT_QTGUI_FOUND           True if QtGui was found.
#  QT_QT3SUPPORT_FOUND      True if Qt3Support was found.
#  QT_QTASSISTANT_FOUND     True if QtAssistant was found.
#  QT_QAXCONTAINER_FOUND     True if QAxContainer was found (Windows only).
#  QT_QAXSERVER_FOUND          True if QAxServer was found (Windows only).
#  QT_QTDBUS_FOUND          True if QtDBus was found.
#  QT_QTDESIGNER_FOUND      True if QtDesigner was found.
#  QT_QTDESIGNERCOMPONENTS  True if QtDesignerComponents was found.
#  QT_QTMOTIF_FOUND         True if QtMotif was found.
#  QT_QTNETWORK_FOUND       True if QtNetwork was found.
#  QT_QTNSPLUGIN_FOUND      True if QtNsPlugin was found.
#  QT_QTOPENGL_FOUND        True if QtOpenGL was found.
#  QT_QTSQL_FOUND           True if QtSql was found.
#  QT_QTXML_FOUND           True if QtXml was found.
#  QT_QTSVG_FOUND           True if QtSvg was found.
#  QT_QTSCRIPT_FOUND        True if QtScript was found.
#  QT_QTTEST_FOUND          True if QtTest was found.
#  QT_QTUITOOLS_FOUND       True if QtUiTools was found.
#  QT_QTASSISTANTCLIENT_FOUND  True if QtAssistantClient was found.
#  QT_QTHELP_FOUND          True if QtHelp was found.
#  QT_QTWEBKIT_FOUND        True if QtWebKit was found.
#  QT_QTXMLPATTERNS_FOUND   True if QtXmlPatterns was found.
#  QT_PHONON_FOUND          True if phonon was found.
#  QT_QTSCRIPTTOOLS_FOUND   True if QtScriptTools was found.
#
#  QT_MAC_USE_COCOA    For Mac OS X, its whether Cocoa or Carbon is used.
#                      In general, this should not be used, but its useful
#                      when having platform specific code.
#
#  QT_DEFINITIONS   Definitions to use when compiling code that uses Qt.
#                   You do not need to use this if you include QT_USE_FILE.
#                   The QT_USE_FILE will also define QT_DEBUG and QT_NO_DEBUG
#                   to fit your current build type.  Those are not contained
#                   in QT_DEFINITIONS.
#                  
#  QT_INCLUDES      List of paths to all include directories of 
#                   Qt4 QT_INCLUDE_DIR and QT_QTCORE_INCLUDE_DIR are
#                   always in this variable even if NOTFOUND,
#                   all other INCLUDE_DIRS are
#                   only added if they are found.
#                   You do not need to use this if you include QT_USE_FILE.
#   
#
#  Include directories for the Qt modules are listed here.
#  You do not need to use these variables if you include QT_USE_FILE.
#
#  QT_INCLUDE_DIR              Path to "include" of Qt4
#  QT_QT_INCLUDE_DIR           Path to "include/Qt" 
#  QT_QT3SUPPORT_INCLUDE_DIR   Path to "include/Qt3Support" 
#  QT_QTASSISTANT_INCLUDE_DIR  Path to "include/QtAssistant" 
#  QT_QAXCONTAINER_INCLUDE_DIR  Path to "include/ActiveQt" (Windows only)
#  QT_QAXSERVER_INCLUDE_DIR  Path to "include/ActiveQt" (Windows only)
#  QT_QTCORE_INCLUDE_DIR       Path to "include/QtCore"         
#  QT_QTDESIGNER_INCLUDE_DIR   Path to "include/QtDesigner" 
#  QT_QTDESIGNERCOMPONENTS_INCLUDE_DIR   Path to "include/QtDesigner"
#  QT_QTDBUS_INCLUDE_DIR       Path to "include/QtDBus" 
#  QT_QTGUI_INCLUDE_DIR        Path to "include/QtGui" 
#  QT_QTMOTIF_INCLUDE_DIR      Path to "include/QtMotif" 
#  QT_QTNETWORK_INCLUDE_DIR    Path to "include/QtNetwork" 
#  QT_QTNSPLUGIN_INCLUDE_DIR   Path to "include/QtNsPlugin" 
#  QT_QTOPENGL_INCLUDE_DIR     Path to "include/QtOpenGL" 
#  QT_QTSQL_INCLUDE_DIR        Path to "include/QtSql" 
#  QT_QTXML_INCLUDE_DIR        Path to "include/QtXml" 
#  QT_QTSVG_INCLUDE_DIR        Path to "include/QtSvg"
#  QT_QTSCRIPT_INCLUDE_DIR     Path to "include/QtScript"
#  QT_QTTEST_INCLUDE_DIR       Path to "include/QtTest"
#  QT_QTASSISTANTCLIENT_INCLUDE_DIR       Path to "include/QtAssistant"
#  QT_QTHELP_INCLUDE_DIR       Path to "include/QtHelp"
#  QT_QTWEBKIT_INCLUDE_DIR     Path to "include/QtWebKit"
#  QT_QTXMLPATTERNS_INCLUDE_DIR  Path to "include/QtXmlPatterns"
#  QT_PHONON_INCLUDE_DIR       Path to "include/phonon"
#  QT_QTSCRIPTTOOLS_INCLUDE_DIR       Path to "include/QtScriptTools"
#                            
#  QT_BINARY_DIR               Path to "bin" of Qt4
#  QT_LIBRARY_DIR              Path to "lib" of Qt4
#  QT_PLUGINS_DIR              Path to "plugins" for Qt4
#  QT_TRANSLATIONS_DIR         Path to "translations" of Qt4
#  QT_DOC_DIR                  Path to "doc" of Qt4
#  QT_MKSPECS_DIR              Path to "mkspecs" of Qt4
#                            
# For every library of Qt, a QT_QTFOO_LIBRARY variable is defined, with the full path to the library.
#
# So there are the following variables:
# The Qt3Support library:     QT_QT3SUPPORT_LIBRARY
#
# The QtAssistant library:    QT_QTASSISTANT_LIBRARY
#
# The QtAxServer library:     QT_QAXSERVER_LIBRARY
#
# The QtAxContainer library:  QT_QTAXCONTAINER_LIBRARY
#
# The QtCore library:         QT_QTCORE_LIBRARY
#
# The QtDBus library:         QT_QTDBUS_LIBRARY
#
# The QtDesigner library:     QT_QTDESIGNER_LIBRARY
#
# The QtDesignerComponents library:     QT_QTDESIGNERCOMPONENTS_LIBRARY
#
# The QtGui library:          QT_QTGUI_LIBRARY
#
# The QtMotif library:        QT_QTMOTIF_LIBRARY
#
# The QtNetwork library:      QT_QTNETWORK_LIBRARY
#
# The QtNsPLugin library:     QT_QTNSPLUGIN_LIBRARY
#
# The QtOpenGL library:       QT_QTOPENGL_LIBRARY
#
# The QtSql library:          QT_QTSQL_LIBRARY
#
# The QtXml library:          QT_QTXML_LIBRARY
#
# The QtSvg library:          QT_QTSVG_LIBRARY
#
# The QtScript library:       QT_QTSCRIPT_LIBRARY
#
# The QtTest library:         QT_QTTEST_LIBRARY
#
# The qtmain library for Windows QT_QTMAIN_LIBRARY
#
# The QtUiTools library:      QT_QTUITOOLS_LIBRARY
#
# The QtAssistantClient library:  QT_QTASSISTANTCLIENT_LIBRARY
#
# The QtHelp library:             QT_QTHELP_LIBRARY
#
# The QtWebKit library:           QT_QTWEBKIT_LIBRARY
#
# The QtXmlPatterns library:      QT_QTXMLPATTERNS_LIBRARY
#
# The Phonon library:             QT_PHONON_LIBRARY
#  
# The QtScriptTools library:      QT_QTSCRIPTTOOLS_LIBRARY
#
# also defined, but NOT for general use are
#  QT_MOC_EXECUTABLE                   Where to find the moc tool.
#  QT_UIC_EXECUTABLE                   Where to find the uic tool.
#  QT_UIC3_EXECUTABLE                  Where to find the uic3 tool.
#  QT_RCC_EXECUTABLE                   Where to find the rcc tool
#  QT_DBUSCPP2XML_EXECUTABLE           Where to find the qdbuscpp2xml tool.
#  QT_DBUSXML2CPP_EXECUTABLE           Where to find the qdbusxml2cpp tool.
#  QT_LUPDATE_EXECUTABLE               Where to find the lupdate tool.
#  QT_LRELEASE_EXECUTABLE              Where to find the lrelease tool.
#  QT_QCOLLECTIONGENERATOR_EXECUTABLE  Where to find the qcollectiongenerator tool.
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
#  QT_QT_LIBRARY        Qt-Library is now split

# Copyright (c) 2002 Kitware, Inc., Insight Consortium.  All rights reserved.
# See Copyright.txt or http://www.cmake.org/HTML/Copyright.html for details.

# Use FIND_PACKAGE( Qt4 COMPONENTS ... ) to enable modules
IF( Qt4_FIND_COMPONENTS )
  FOREACH( component ${Qt4_FIND_COMPONENTS} )
    STRING( TOUPPER ${component} _COMPONENT )
    SET( QT_USE_${_COMPONENT} 1 )
  ENDFOREACH( component )
  
  # To make sure we don't use QtCore or QtGui when not in COMPONENTS
  IF(NOT QT_USE_QTCORE)
    SET( QT_DONT_USE_QTCORE 1 )
  ENDIF(NOT QT_USE_QTCORE)
  
  IF(NOT QT_USE_QTGUI)
    SET( QT_DONT_USE_QTGUI 1 )
  ENDIF(NOT QT_USE_QTGUI)

ENDIF( Qt4_FIND_COMPONENTS )

# If Qt3 has already been found, fail.
IF(QT_QT_LIBRARY)
  IF(Qt4_FIND_REQUIRED)
    MESSAGE( FATAL_ERROR "Qt3 and Qt4 cannot be used together in one project.  If switching to Qt4, the CMakeCache.txt needs to be cleaned.")
  ELSE(Qt4_FIND_REQUIRED)
    IF(NOT Qt4_FIND_QUIETLY)
      MESSAGE( STATUS    "Qt3 and Qt4 cannot be used together in one project.  If switching to Qt4, the CMakeCache.txt needs to be cleaned.")
    ENDIF(NOT Qt4_FIND_QUIETLY)
    RETURN()
  ENDIF(Qt4_FIND_REQUIRED)
ENDIF(QT_QT_LIBRARY)


IF (QT4_QMAKE_FOUND)
   # Check already done in this cmake run, nothing more to do
   RETURN()
ENDIF (QT4_QMAKE_FOUND)

# check that QT_NO_DEBUG is defined for release configurations
MACRO(QT_CHECK_FLAG_EXISTS FLAG VAR DOC)
  IF(NOT ${VAR} MATCHES "${FLAG}")
    SET(${VAR} "${${VAR}} ${FLAG}" 
      CACHE STRING "Flags used by the compiler during ${DOC} builds." FORCE)
  ENDIF(NOT ${VAR} MATCHES "${FLAG}")
ENDMACRO(QT_CHECK_FLAG_EXISTS FLAG VAR)

QT_CHECK_FLAG_EXISTS(-DQT_NO_DEBUG CMAKE_CXX_FLAGS_RELWITHDEBINFO "Release with Debug Info")
QT_CHECK_FLAG_EXISTS(-DQT_NO_DEBUG CMAKE_CXX_FLAGS_RELEASE "release")
QT_CHECK_FLAG_EXISTS(-DQT_NO_DEBUG CMAKE_CXX_FLAGS_MINSIZEREL "release minsize")

INCLUDE(CheckSymbolExists)
INCLUDE(MacroAddFileDependencies)
INCLUDE(MacroPushRequiredVars)

SET(QT_USE_FILE ${CMAKE_ROOT}/Modules/UseQt4.cmake)

SET( QT_DEFINITIONS "")

IF (WIN32)
  SET(QT_DEFINITIONS -DQT_DLL)
ENDIF(WIN32)

SET(QT4_INSTALLED_VERSION_TOO_OLD FALSE)

#  macro for asking qmake to process pro files
MACRO(QT_QUERY_QMAKE outvar invar)
  IF(QT_QMAKE_EXECUTABLE)
    FILE(WRITE ${CMAKE_CURRENT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmpQmake/tmp.pro
         "message(CMAKE_MESSAGE<$$${invar}>)")

    # Invoke qmake with the tmp.pro program to get the desired
    # information.  Use the same variable for both stdout and stderr
    # to make sure we get the output on all platforms.
    EXECUTE_PROCESS(COMMAND ${QT_QMAKE_EXECUTABLE}
      WORKING_DIRECTORY  
      ${CMAKE_CURRENT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmpQmake
      OUTPUT_VARIABLE _qmake_query_output
      RESULT_VARIABLE _qmake_result
      ERROR_VARIABLE _qmake_query_output )

    FILE(REMOVE_RECURSE 
         "${CMAKE_CURRENT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmpQmake")

    IF(_qmake_result)
      MESSAGE(WARNING " querying qmake for ${invar}.  qmake reported:\n${_qmake_query_output}")
    ELSE(_qmake_result)
      STRING(REGEX REPLACE ".*CMAKE_MESSAGE<([^>]*).*" "\\1" ${outvar} "${_qmake_query_output}")
    ENDIF(_qmake_result)

  ENDIF(QT_QMAKE_EXECUTABLE)
ENDMACRO(QT_QUERY_QMAKE)

GET_FILENAME_COMPONENT(qt_install_version "[HKEY_CURRENT_USER\\Software\\trolltech\\Versions;DefaultQtVersion]" NAME)
# check for qmake
FIND_PROGRAM(QT_QMAKE_EXECUTABLE NAMES qmake qmake4 qmake-qt4 PATHS
  "[HKEY_CURRENT_USER\\Software\\Trolltech\\Qt3Versions\\4.0.0;InstallDir]/bin"
  "[HKEY_CURRENT_USER\\Software\\Trolltech\\Versions\\4.0.0;InstallDir]/bin"
  "[HKEY_CURRENT_USER\\Software\\Trolltech\\Versions\\${qt_install_version};InstallDir]/bin"
  $ENV{QTDIR}/bin
)

IF (QT_QMAKE_EXECUTABLE)

  IF(QT_QMAKE_EXECUTABLE_LAST)
    STRING(COMPARE NOTEQUAL "${QT_QMAKE_EXECUTABLE_LAST}" "${QT_QMAKE_EXECUTABLE}" QT_QMAKE_CHANGED)
  ENDIF(QT_QMAKE_EXECUTABLE_LAST)

  SET(QT_QMAKE_EXECUTABLE_LAST "${QT_QMAKE_EXECUTABLE}" CACHE INTERNAL "" FORCE)

  SET(QT4_QMAKE_FOUND FALSE)
  
  EXEC_PROGRAM(${QT_QMAKE_EXECUTABLE} ARGS "-query QT_VERSION" OUTPUT_VARIABLE QTVERSION)

  # check for qt3 qmake and then try and find qmake4 or qmake-qt4 in the path
  IF("${QTVERSION}" MATCHES "Unknown")
    SET(QT_QMAKE_EXECUTABLE NOTFOUND CACHE FILEPATH "" FORCE)
    FIND_PROGRAM(QT_QMAKE_EXECUTABLE NAMES qmake4 qmake-qt4 PATHS
      "[HKEY_CURRENT_USER\\Software\\Trolltech\\Qt3Versions\\4.0.0;InstallDir]/bin"
      "[HKEY_CURRENT_USER\\Software\\Trolltech\\Versions\\4.0.0;InstallDir]/bin"
      $ENV{QTDIR}/bin
      )
    IF(QT_QMAKE_EXECUTABLE)
      EXEC_PROGRAM(${QT_QMAKE_EXECUTABLE} 
        ARGS "-query QT_VERSION" OUTPUT_VARIABLE QTVERSION)
    ENDIF(QT_QMAKE_EXECUTABLE)
  ENDIF("${QTVERSION}" MATCHES "Unknown")

  # check that we found the Qt4 qmake, Qt3 qmake output won't match here
  STRING(REGEX MATCH "^[0-9]+\\.[0-9]+\\.[0-9]+" qt_version_tmp "${QTVERSION}")
  IF (qt_version_tmp)

    # we need at least version 4.0.0
    IF (NOT QT_MIN_VERSION)
      SET(QT_MIN_VERSION "4.0.0")
    ENDIF (NOT QT_MIN_VERSION)

    #now parse the parts of the user given version string into variables
    STRING(REGEX MATCH "^[0-9]+\\.[0-9]+\\.[0-9]+" req_qt_major_vers "${QT_MIN_VERSION}")
    IF (NOT req_qt_major_vers)
      MESSAGE( FATAL_ERROR "Invalid Qt version string given: \"${QT_MIN_VERSION}\", expected e.g. \"4.0.1\"")
    ENDIF (NOT req_qt_major_vers)

    # now parse the parts of the user given version string into variables
    STRING(REGEX REPLACE "^([0-9]+)\\.[0-9]+\\.[0-9]+" "\\1" req_qt_major_vers "${QT_MIN_VERSION}")
    STRING(REGEX REPLACE "^[0-9]+\\.([0-9])+\\.[0-9]+" "\\1" req_qt_minor_vers "${QT_MIN_VERSION}")
    STRING(REGEX REPLACE "^[0-9]+\\.[0-9]+\\.([0-9]+)" "\\1" req_qt_patch_vers "${QT_MIN_VERSION}")

    # Suppport finding at least a particular version, for instance FIND_PACKAGE( Qt4 4.4.3 )
    # This implementation is a hack to avoid duplicating code and make sure we stay
    # source-compatible with CMake 2.6.x
    IF( Qt4_FIND_VERSION )
      SET( QT_MIN_VERSION ${Qt4_FIND_VERSION} )
      SET( req_qt_major_vers ${Qt4_FIND_VERSION_MAJOR} )
      SET( req_qt_minor_vers ${Qt4_FIND_VERSION_MINOR} )
      SET( req_qt_patch_vers ${Qt4_FIND_VERSION_PATCH} )
    ENDIF( Qt4_FIND_VERSION )

    IF (NOT req_qt_major_vers EQUAL 4)
      MESSAGE( FATAL_ERROR "Invalid Qt version string given: \"${QT_MIN_VERSION}\", major version 4 is required, e.g. \"4.0.1\"")
    ENDIF (NOT req_qt_major_vers EQUAL 4)

    # and now the version string given by qmake
    STRING(REGEX REPLACE "^([0-9]+)\\.[0-9]+\\.[0-9]+.*" "\\1" QT_VERSION_MAJOR "${QTVERSION}")
    STRING(REGEX REPLACE "^[0-9]+\\.([0-9])+\\.[0-9]+.*" "\\1" QT_VERSION_MINOR "${QTVERSION}")
    STRING(REGEX REPLACE "^[0-9]+\\.[0-9]+\\.([0-9]+).*" "\\1" QT_VERSION_PATCH "${QTVERSION}")

    # compute an overall version number which can be compared at once
    MATH(EXPR req_vers "${req_qt_major_vers}*10000 + ${req_qt_minor_vers}*100 + ${req_qt_patch_vers}")
    MATH(EXPR found_vers "${QT_VERSION_MAJOR}*10000 + ${QT_VERSION_MINOR}*100 + ${QT_VERSION_PATCH}")

    # Support finding *exactly* a particular version, for instance FIND_PACKAGE( Qt4 4.4.3 EXACT )
    IF( Qt4_FIND_VERSION_EXACT )
      IF(found_vers EQUAL req_vers)
        SET( QT4_QMAKE_FOUND TRUE )
      ELSE(found_vers EQUAL req_vers)
        SET( QT4_QMAKE_FOUND FALSE )
        IF (found_vers LESS req_vers)
          SET(QT4_INSTALLED_VERSION_TOO_OLD TRUE)
        ELSE (found_vers LESS req_vers)
          SET(QT4_INSTALLED_VERSION_TOO_NEW TRUE)
        ENDIF (found_vers LESS req_vers)
      ENDIF(found_vers EQUAL req_vers)
    ELSE( Qt4_FIND_VERSION_EXACT )
      IF (found_vers LESS req_vers)
        SET(QT4_QMAKE_FOUND FALSE)
        SET(QT4_INSTALLED_VERSION_TOO_OLD TRUE)
      ELSE (found_vers LESS req_vers)
        SET(QT4_QMAKE_FOUND TRUE)
      ENDIF (found_vers LESS req_vers)
    ENDIF( Qt4_FIND_VERSION_EXACT )
  ENDIF (qt_version_tmp)

ENDIF (QT_QMAKE_EXECUTABLE)

IF (QT4_QMAKE_FOUND)

  if (WIN32)
    # get qt install dir 
    get_filename_component(_DIR ${QT_QMAKE_EXECUTABLE} PATH )
    get_filename_component(QT_INSTALL_DIR ${_DIR} PATH )
  endif (WIN32)

  # ask qmake for the library dir
  # Set QT_LIBRARY_DIR
  IF (NOT QT_LIBRARY_DIR OR QT_QMAKE_CHANGED)
    EXEC_PROGRAM( ${QT_QMAKE_EXECUTABLE}
      ARGS "-query QT_INSTALL_LIBS"
      OUTPUT_VARIABLE QT_LIBRARY_DIR_TMP )
    # make sure we have / and not \ as qmake gives on windows
    FILE(TO_CMAKE_PATH "${QT_LIBRARY_DIR_TMP}" QT_LIBRARY_DIR_TMP)
    IF(EXISTS "${QT_LIBRARY_DIR_TMP}")
      SET(QT_LIBRARY_DIR ${QT_LIBRARY_DIR_TMP} CACHE PATH "Qt library dir" FORCE)
    ELSE(EXISTS "${QT_LIBRARY_DIR_TMP}")
      MESSAGE("Warning: QT_QMAKE_EXECUTABLE reported QT_INSTALL_LIBS as ${QT_LIBRARY_DIR_TMP}")
      MESSAGE("Warning: ${QT_LIBRARY_DIR_TMP} does NOT exist, Qt must NOT be installed correctly.")
    ENDIF(EXISTS "${QT_LIBRARY_DIR_TMP}")
  ENDIF(NOT QT_LIBRARY_DIR OR QT_QMAKE_CHANGED)
  
  IF (APPLE)
    IF (EXISTS ${QT_LIBRARY_DIR}/QtCore.framework)
      SET(QT_USE_FRAMEWORKS ON
        CACHE BOOL "Set to ON if Qt build uses frameworks." FORCE)
    ELSE (EXISTS ${QT_LIBRARY_DIR}/QtCore.framework)
      SET(QT_USE_FRAMEWORKS OFF
        CACHE BOOL "Set to ON if Qt build uses frameworks." FORCE)
    ENDIF (EXISTS ${QT_LIBRARY_DIR}/QtCore.framework)
    
    MARK_AS_ADVANCED(QT_USE_FRAMEWORKS)
  ENDIF (APPLE)
  
  # ask qmake for the binary dir
  IF (QT_LIBRARY_DIR AND NOT QT_BINARY_DIR  OR  QT_QMAKE_CHANGED)
     EXEC_PROGRAM(${QT_QMAKE_EXECUTABLE}
       ARGS "-query QT_INSTALL_BINS"
       OUTPUT_VARIABLE qt_bins )
     # make sure we have / and not \ as qmake gives on windows
     FILE(TO_CMAKE_PATH "${qt_bins}" qt_bins)
     SET(QT_BINARY_DIR ${qt_bins} CACHE INTERNAL "" FORCE)
  ENDIF (QT_LIBRARY_DIR AND NOT QT_BINARY_DIR  OR  QT_QMAKE_CHANGED)

  # ask qmake for the include dir
  IF (QT_LIBRARY_DIR AND NOT QT_HEADERS_DIR  OR  QT_QMAKE_CHANGED)
      EXEC_PROGRAM( ${QT_QMAKE_EXECUTABLE}
        ARGS "-query QT_INSTALL_HEADERS" 
        OUTPUT_VARIABLE qt_headers ) 
      # make sure we have / and not \ as qmake gives on windows
      FILE(TO_CMAKE_PATH "${qt_headers}" qt_headers)
      SET(QT_HEADERS_DIR ${qt_headers} CACHE INTERNAL "" FORCE)
  ENDIF (QT_LIBRARY_DIR AND NOT QT_HEADERS_DIR  OR  QT_QMAKE_CHANGED)


  # ask qmake for the documentation directory
  IF (QT_LIBRARY_DIR AND NOT QT_DOC_DIR  OR  QT_QMAKE_CHANGED)
    EXEC_PROGRAM( ${QT_QMAKE_EXECUTABLE}
      ARGS "-query QT_INSTALL_DOCS"
      OUTPUT_VARIABLE qt_doc_dir )
    # make sure we have / and not \ as qmake gives on windows
    FILE(TO_CMAKE_PATH "${qt_doc_dir}" qt_doc_dir)
    SET(QT_DOC_DIR ${qt_doc_dir} CACHE PATH "The location of the Qt docs" FORCE)
  ENDIF (QT_LIBRARY_DIR AND NOT QT_DOC_DIR  OR  QT_QMAKE_CHANGED)

  # ask qmake for the mkspecs directory
  IF (QT_LIBRARY_DIR AND NOT QT_MKSPECS_DIR  OR  QT_QMAKE_CHANGED)
    EXEC_PROGRAM( ${QT_QMAKE_EXECUTABLE}
      ARGS "-query QMAKE_MKSPECS"
      OUTPUT_VARIABLE qt_mkspecs_dirs )
    # do not replace : on windows as it might be a drive letter
    # and windows should already use ; as a separator
    IF(UNIX)
      STRING(REPLACE ":" ";" qt_mkspecs_dirs "${qt_mkspecs_dirs}")
    ENDIF(UNIX)
    SET(QT_MKSPECS_DIR NOTFOUND)
    FIND_PATH(QT_MKSPECS_DIR qconfig.pri PATHS ${qt_mkspecs_dirs}
      DOC "The location of the Qt mkspecs containing qconfig.pri"
      NO_DEFAULT_PATH )
  ENDIF (QT_LIBRARY_DIR AND NOT QT_MKSPECS_DIR  OR  QT_QMAKE_CHANGED)

  # ask qmake for the plugins directory
  IF (QT_LIBRARY_DIR AND NOT QT_PLUGINS_DIR  OR  QT_QMAKE_CHANGED)
    EXEC_PROGRAM( ${QT_QMAKE_EXECUTABLE}
      ARGS "-query QT_INSTALL_PLUGINS"
      OUTPUT_VARIABLE qt_plugins_dir )
    # make sure we have / and not \ as qmake gives on windows
    FILE(TO_CMAKE_PATH "${qt_plugins_dir}" qt_plugins_dir)
    SET(QT_PLUGINS_DIR ${qt_plugins_dir} CACHE PATH "The location of the Qt plugins" FORCE)
  ENDIF (QT_LIBRARY_DIR AND NOT QT_PLUGINS_DIR  OR  QT_QMAKE_CHANGED)

  # ask qmake for the translations directory
  IF (QT_LIBRARY_DIR AND NOT QT_TRANSLATIONS_DIR  OR  QT_QMAKE_CHANGED)
    EXEC_PROGRAM( ${QT_QMAKE_EXECUTABLE}
      ARGS "-query QT_INSTALL_TRANSLATIONS"
      OUTPUT_VARIABLE qt_translations_dir )
    # make sure we have / and not \ as qmake gives on windows
    FILE(TO_CMAKE_PATH "${qt_translations_dir}" qt_translations_dir)
    SET(QT_TRANSLATIONS_DIR ${qt_translations_dir} CACHE PATH "The location of the Qt translations" FORCE)
  ENDIF (QT_LIBRARY_DIR AND NOT QT_TRANSLATIONS_DIR  OR  QT_QMAKE_CHANGED)

  ########################################
  #
  #       Setting the INCLUDE-Variables
  #
  ########################################

  FIND_PATH(QT_QTCORE_INCLUDE_DIR QtGlobal
    ${QT_HEADERS_DIR}/QtCore
    ${QT_LIBRARY_DIR}/QtCore.framework/Headers
    NO_DEFAULT_PATH
    )
  
  # Set QT_INCLUDE_DIR by removine "/QtCore" in the string ${QT_QTCORE_INCLUDE_DIR}
  IF( QT_QTCORE_INCLUDE_DIR AND NOT QT_INCLUDE_DIR)
    IF (QT_USE_FRAMEWORKS)
      SET(QT_INCLUDE_DIR ${QT_HEADERS_DIR})
    ELSE (QT_USE_FRAMEWORKS)
      STRING( REGEX REPLACE "/QtCore$" "" qt4_include_dir ${QT_QTCORE_INCLUDE_DIR})
      SET( QT_INCLUDE_DIR ${qt4_include_dir} CACHE PATH "")
    ENDIF (QT_USE_FRAMEWORKS)
  ENDIF( QT_QTCORE_INCLUDE_DIR AND NOT QT_INCLUDE_DIR)

  IF( NOT QT_INCLUDE_DIR)
    IF(Qt4_FIND_REQUIRED)
      MESSAGE( FATAL_ERROR "Could NOT find QtGlobal header")
    ENDIF(Qt4_FIND_REQUIRED)
  ENDIF( NOT QT_INCLUDE_DIR)

  # Make variables changeble to the advanced user
  MARK_AS_ADVANCED( QT_LIBRARY_DIR QT_INCLUDE_DIR QT_DOC_DIR QT_MKSPECS_DIR
                    QT_PLUGINS_DIR QT_TRANSLATIONS_DIR)

  # Set QT_INCLUDES
  SET( QT_INCLUDES ${QT_MKSPECS_DIR}/default ${QT_INCLUDE_DIR} )


  #############################################
  #
  # Find out what window system we're using
  #
  #############################################
  # Save required includes and required_flags variables
  MACRO_PUSH_REQUIRED_VARS()
  # Add QT_INCLUDE_DIR to CMAKE_REQUIRED_INCLUDES
  SET(CMAKE_REQUIRED_INCLUDES "${CMAKE_REQUIRED_INCLUDES};${QT_INCLUDE_DIR}")
  # On Mac OS X when Qt has framework support, also add the framework path
  IF( QT_USE_FRAMEWORKS )
    SET(CMAKE_REQUIRED_FLAGS "-F${QT_LIBRARY_DIR} ")
  ENDIF( QT_USE_FRAMEWORKS )
  # Check for Window system symbols (note: only one should end up being set)
  CHECK_SYMBOL_EXISTS(Q_WS_X11 "QtCore/qglobal.h" Q_WS_X11)
  CHECK_SYMBOL_EXISTS(Q_WS_WIN "QtCore/qglobal.h" Q_WS_WIN)
  CHECK_SYMBOL_EXISTS(Q_WS_QWS "QtCore/qglobal.h" Q_WS_QWS)
  CHECK_SYMBOL_EXISTS(Q_WS_MAC "QtCore/qglobal.h" Q_WS_MAC)
  IF(Q_WS_MAC)
    IF(QT_QMAKE_CHANGED)
      SET(QT_MAC_USE_COCOA "" CACHE BOOL "Use Cocoa on Mac" FORCE)
    ENDIF(QT_QMAKE_CHANGED)
    CHECK_SYMBOL_EXISTS(QT_MAC_USE_COCOA "QtCore/qconfig.h" QT_MAC_USE_COCOA)
  ENDIF(Q_WS_MAC)

  IF (QT_QTCOPY_REQUIRED)
     CHECK_SYMBOL_EXISTS(QT_IS_QTCOPY "QtCore/qglobal.h" QT_KDE_QT_COPY)
     IF (NOT QT_IS_QTCOPY)
        MESSAGE(FATAL_ERROR "qt-copy is required, but hasn't been found")
     ENDIF (NOT QT_IS_QTCOPY)
  ENDIF (QT_QTCOPY_REQUIRED)

  # Restore CMAKE_REQUIRED_INCLUDES+CMAKE_REQUIRED_FLAGS variables
  MACRO_POP_REQUIRED_VARS()
  #
  #############################################



  #######################################
  #
  #       Qt configuration
  #
  #######################################
  IF(EXISTS "${QT_MKSPECS_DIR}/qconfig.pri")
    FILE(READ ${QT_MKSPECS_DIR}/qconfig.pri _qconfig_FILE_contents)
    STRING(REGEX MATCH "QT_CONFIG[^\n]+" QT_QCONFIG "${_qconfig_FILE_contents}")
    STRING(REGEX MATCH "CONFIG[^\n]+" QT_CONFIG "${_qconfig_FILE_contents}")
    STRING(REGEX MATCH "EDITION[^\n]+" QT_EDITION "${_qconfig_FILE_contents}")
    STRING(REGEX MATCH "QT_LIBINFIX[^\n]+" _qconfig_qt_libinfix "${_qconfig_FILE_contents}")
    STRING(REGEX REPLACE "QT_LIBINFIX *= *([^\n]*)" "\\1" QT_LIBINFIX "${_qconfig_qt_libinfix}")
  ENDIF(EXISTS "${QT_MKSPECS_DIR}/qconfig.pri")
  IF("${QT_EDITION}" MATCHES "DesktopLight")
    SET(QT_EDITION_DESKTOPLIGHT 1)
  ENDIF("${QT_EDITION}" MATCHES "DesktopLight")


  IF (QT_USE_FRAMEWORKS)
    SET(QT_DEFINITIONS ${QT_DEFINITIONS} -F${QT_LIBRARY_DIR} -L${QT_LIBRARY_DIR} )
  ENDIF (QT_USE_FRAMEWORKS)

  # Set QT_QT3SUPPORT_INCLUDE_DIR
  FIND_PATH(QT_QT3SUPPORT_INCLUDE_DIR Qt3Support
    PATHS
    ${QT_INCLUDE_DIR}/Qt3Support
    ${QT_LIBRARY_DIR}/Qt3Support.framework/Headers
    NO_DEFAULT_PATH
    )

  # Set QT_QT_INCLUDE_DIR
  FIND_PATH(QT_QT_INCLUDE_DIR qglobal.h
    PATHS
    ${QT_INCLUDE_DIR}/Qt
    ${QT_LIBRARY_DIR}/QtCore.framework/Headers
    NO_DEFAULT_PATH
    )

  # Set QT_QTGUI_INCLUDE_DIR
  FIND_PATH(QT_QTGUI_INCLUDE_DIR QtGui
    PATHS
    ${QT_INCLUDE_DIR}/QtGui
    ${QT_LIBRARY_DIR}/QtGui.framework/Headers
    NO_DEFAULT_PATH
    )

  # Set QT_QTSVG_INCLUDE_DIR
  FIND_PATH(QT_QTSVG_INCLUDE_DIR QtSvg
    PATHS
    ${QT_INCLUDE_DIR}/QtSvg
    ${QT_LIBRARY_DIR}/QtSvg.framework/Headers
    NO_DEFAULT_PATH
    )

  # Set QT_QTSCRIPT_INCLUDE_DIR
  FIND_PATH(QT_QTSCRIPT_INCLUDE_DIR QtScript
    PATHS
    ${QT_INCLUDE_DIR}/QtScript
    ${QT_LIBRARY_DIR}/QtScript.framework/Headers
    NO_DEFAULT_PATH
    )

  # Set QT_QTSCRIPTTOOLS_INCLUDE_DIR
  FIND_PATH(QT_QTSCRIPTTOOLS_INCLUDE_DIR QtScriptTools
    PATHS
    ${QT_INCLUDE_DIR}/QtScriptTools
    ${QT_LIBRARY_DIR}/QtScriptTools.framework/Headers
    NO_DEFAULT_PATH
    )

  # Set QT_QTTEST_INCLUDE_DIR
  FIND_PATH(QT_QTTEST_INCLUDE_DIR QtTest
    PATHS
    ${QT_INCLUDE_DIR}/QtTest
    ${QT_LIBRARY_DIR}/QtTest.framework/Headers
    NO_DEFAULT_PATH
    )

  # Set QT_QTUITOOLS_INCLUDE_DIR
  FIND_PATH(QT_QTUITOOLS_INCLUDE_DIR QtUiTools
    PATHS
    ${QT_INCLUDE_DIR}/QtUiTools
    ${QT_LIBRARY_DIR}/QtUiTools.framework/Headers
    NO_DEFAULT_PATH
    )

  # Set QT_QTMOTIF_INCLUDE_DIR
  IF(Q_WS_X11)
    FIND_PATH(QT_QTMOTIF_INCLUDE_DIR QtMotif 
      PATHS 
      ${QT_INCLUDE_DIR}/QtMotif 
      NO_DEFAULT_PATH )
  ENDIF(Q_WS_X11)

  # Set QT_QTNETWORK_INCLUDE_DIR
  FIND_PATH(QT_QTNETWORK_INCLUDE_DIR QtNetwork
    PATHS
    ${QT_INCLUDE_DIR}/QtNetwork
    ${QT_LIBRARY_DIR}/QtNetwork.framework/Headers
    NO_DEFAULT_PATH
    )

  # Set QT_QTNSPLUGIN_INCLUDE_DIR
  FIND_PATH(QT_QTNSPLUGIN_INCLUDE_DIR QtNsPlugin
    PATHS
    ${QT_INCLUDE_DIR}/QtNsPlugin
    ${QT_LIBRARY_DIR}/QtNsPlugin.framework/Headers
    NO_DEFAULT_PATH
    )

  # Set QT_QTOPENGL_INCLUDE_DIR
  FIND_PATH(QT_QTOPENGL_INCLUDE_DIR QtOpenGL
    PATHS
    ${QT_INCLUDE_DIR}/QtOpenGL
    ${QT_LIBRARY_DIR}/QtOpenGL.framework/Headers
    NO_DEFAULT_PATH
    )

  # Set QT_QTSQL_INCLUDE_DIR
  FIND_PATH(QT_QTSQL_INCLUDE_DIR QtSql
    PATHS
    ${QT_INCLUDE_DIR}/QtSql
    ${QT_LIBRARY_DIR}/QtSql.framework/Headers
    NO_DEFAULT_PATH
    )

  # Set QT_QTXML_INCLUDE_DIR
  FIND_PATH(QT_QTXML_INCLUDE_DIR QtXml
    PATHS
    ${QT_INCLUDE_DIR}/QtXml
    ${QT_LIBRARY_DIR}/QtXml.framework/Headers
    NO_DEFAULT_PATH
    )

  # Set QT_QTASSISTANT_INCLUDE_DIR
  FIND_PATH(QT_QTASSISTANT_INCLUDE_DIR QtAssistant
    PATHS
    ${QT_INCLUDE_DIR}/QtAssistant
    ${QT_HEADERS_DIR}/QtAssistant
    ${QT_LIBRARY_DIR}/QtAssistant.framework/Headers
    NO_DEFAULT_PATH
    )

  IF(WIN32)
    # Set QT_QTAXSERVER_INCLUDE_DIR
    FIND_PATH(QT_QTAXSERVER_INCLUDE_DIR QtAxServer
    PATHS
    ${QT_INCLUDE_DIR}/QtAxServer
    ${QT_HEADERS_DIR}/QtAxServer
    NO_DEFAULT_PATH
    )

    # Set QT_QTAXCONTAINER_INCLUDE_DIR
    FIND_PATH(QT_QTAXCONTAINER_INCLUDE_DIR QtAxContainer
    PATHS
    ${QT_INCLUDE_DIR}/QtAxContainer
    ${QT_HEADERS_DIR}/QtAxContainer
    NO_DEFAULT_PATH
    )
  ENDIF(WIN32)
  # Set QT_QTDESIGNER_INCLUDE_DIR
  FIND_PATH(QT_QTDESIGNER_INCLUDE_DIR QDesignerComponents
    PATHS
    ${QT_INCLUDE_DIR}/QtDesigner
    ${QT_HEADERS_DIR}/QtDesigner 
    ${QT_LIBRARY_DIR}/QtDesigner.framework/Headers
    NO_DEFAULT_PATH
    )

  # Set QT_QTDESIGNERCOMPONENTS_INCLUDE_DIR
  FIND_PATH(QT_QTDESIGNERCOMPONENTS_INCLUDE_DIR QDesignerComponents
    PATHS
    ${QT_INCLUDE_DIR}/QtDesigner
    ${QT_HEADERS_DIR}/QtDesigner
    NO_DEFAULT_PATH
    )

  # Set QT_QTDBUS_INCLUDE_DIR
  FIND_PATH(QT_QTDBUS_INCLUDE_DIR QtDBus
    PATHS
    ${QT_INCLUDE_DIR}/QtDBus
    ${QT_HEADERS_DIR}/QtDBus
    ${QT_LIBRARY_DIR}/QtDBus.framework/Headers
    NO_DEFAULT_PATH
    )
  
  # Set QT_QTASSISTANTCLIENT_INCLUDE_DIR
  FIND_PATH(QT_QTASSISTANTCLIENT_INCLUDE_DIR QAssistantClient
    PATHS
    ${QT_INCLUDE_DIR}/QtAssistant
    ${QT_HEADERS_DIR}/QtAssistant
    NO_DEFAULT_PATH
    )
  
  # Set QT_QTHELP_INCLUDE_DIR
  FIND_PATH(QT_QTHELP_INCLUDE_DIR QtHelp
    PATHS
    ${QT_INCLUDE_DIR}/QtHelp
    ${QT_HEADERS_DIR}/QtHelp
    NO_DEFAULT_PATH
    )
  
  # Set QT_QTWEBKIT_INCLUDE_DIR
  FIND_PATH(QT_QTWEBKIT_INCLUDE_DIR QtWebKit
    PATHS
    ${QT_INCLUDE_DIR}/QtWebKit
    ${QT_HEADERS_DIR}/QtWebKit
    ${QT_LIBRARY_DIR}/QtWebKit.framework/Headers
    NO_DEFAULT_PATH
    )
  
  # Set QT_QTXMLPATTERNS_INCLUDE_DIR
  FIND_PATH(QT_QTXMLPATTERNS_INCLUDE_DIR QtXmlPatterns
    PATHS
    ${QT_INCLUDE_DIR}/QtXmlPatterns
    ${QT_HEADERS_DIR}/QtXmlPatterns
    NO_DEFAULT_PATH
    )

  # Set QT_PHONON_INCLUDE_DIR
  # Qt >= 4.5.3 (or kde-qt-4.5.2 which has the fix too) : Phonon/ClassName is inside include/phonon
  # With previous versions of Qt, this could not work; upgrade Qt or use a standalone phonon
  FIND_PATH(QT_PHONON_INCLUDE_DIR Phonon
    PATHS
    ${QT_HEADERS_DIR}/phonon
    NO_DEFAULT_PATH
    )

  # Make variables changeble to the advanced user
  MARK_AS_ADVANCED( QT_QT_INCLUDE_DIR)

  # Set QT_INCLUDES
  SET( QT_INCLUDES ${QT_QT_INCLUDE_DIR} ${QT_MKSPECS_DIR}/default ${QT_INCLUDE_DIR} )

  ########################################
  #
  #       Setting the LIBRARY-Variables
  #
  ########################################

  IF (QT_USE_FRAMEWORKS)
    # If FIND_LIBRARY found libraries in Apple frameworks, we would NOT have
    # to jump through these hoops.
    IF(EXISTS ${QT_LIBRARY_DIR}/QtCore.framework)
      SET(QT_QTCORE_FOUND TRUE)
      SET(QT_QTCORE_LIBRARY "-F${QT_LIBRARY_DIR} -framework QtCore" CACHE STRING "The QtCore library.")
    ELSE(EXISTS ${QT_LIBRARY_DIR}/QtCore.framework)
      SET(QT_QTCORE_FOUND FALSE)
    ENDIF(EXISTS ${QT_LIBRARY_DIR}/QtCore.framework)

    IF(EXISTS ${QT_LIBRARY_DIR}/QtGui.framework)
      SET(QT_QTGUI_FOUND TRUE)
      SET(QT_QTGUI_LIBRARY "-F${QT_LIBRARY_DIR} -framework QtGui" CACHE STRING "The QtGui library.")
    ELSE(EXISTS ${QT_LIBRARY_DIR}/QtGui.framework)
      SET(QT_QTGUI_FOUND FALSE)
    ENDIF(EXISTS ${QT_LIBRARY_DIR}/QtGui.framework)

    IF(EXISTS ${QT_LIBRARY_DIR}/Qt3Support.framework)
      SET(QT_QT3SUPPORT_FOUND TRUE)
      SET(QT_QT3SUPPORT_LIBRARY "-F${QT_LIBRARY_DIR} -framework Qt3Support" CACHE STRING "The Qt3Support library.")
    ELSE(EXISTS ${QT_LIBRARY_DIR}/Qt3Support.framework)
      SET(QT_QT3SUPPORT_FOUND FALSE)
    ENDIF(EXISTS ${QT_LIBRARY_DIR}/Qt3Support.framework)

    IF(EXISTS ${QT_LIBRARY_DIR}/QtNetwork.framework)
      SET(QT_QTNETWORK_FOUND TRUE)
      SET(QT_QTNETWORK_LIBRARY "-F${QT_LIBRARY_DIR} -framework QtNetwork" CACHE STRING "The QtNetwork library.")
    ELSE(EXISTS ${QT_LIBRARY_DIR}/QtNetwork.framework)
      SET(QT_QTNETWORK_FOUND FALSE)
    ENDIF(EXISTS ${QT_LIBRARY_DIR}/QtNetwork.framework)

    IF(EXISTS ${QT_LIBRARY_DIR}/QtOpenGL.framework)
      SET(QT_QTOPENGL_FOUND TRUE)
      SET(QT_QTOPENGL_LIBRARY "-F${QT_LIBRARY_DIR} -framework QtOpenGL" CACHE STRING "The QtOpenGL library.")
    ELSE(EXISTS ${QT_LIBRARY_DIR}/QtOpenGL.framework)
      SET(QT_QTOPENGL_FOUND FALSE)
    ENDIF(EXISTS ${QT_LIBRARY_DIR}/QtOpenGL.framework)

    IF(EXISTS ${QT_LIBRARY_DIR}/QtSql.framework)
      SET(QT_QTSQL_FOUND TRUE)
      SET(QT_QTSQL_LIBRARY "-F${QT_LIBRARY_DIR} -framework QtSql" CACHE STRING "The QtSql library.")
    ELSE(EXISTS ${QT_LIBRARY_DIR}/QtSql.framework)
      SET(QT_QTSQL_FOUND FALSE)
    ENDIF(EXISTS ${QT_LIBRARY_DIR}/QtSql.framework)

    IF(EXISTS ${QT_LIBRARY_DIR}/QtXml.framework)
      SET(QT_QTXML_FOUND TRUE)
      SET(QT_QTXML_LIBRARY "-F${QT_LIBRARY_DIR} -framework QtXml" CACHE STRING "The QtXml library.")
    ELSE(EXISTS ${QT_LIBRARY_DIR}/QtXml.framework)
      SET(QT_QTXML_FOUND FALSE)
    ENDIF(EXISTS ${QT_LIBRARY_DIR}/QtXml.framework)

    IF(EXISTS ${QT_LIBRARY_DIR}/QtSvg.framework)
      SET(QT_QTSVG_FOUND TRUE)
      SET(QT_QTSVG_LIBRARY "-F${QT_LIBRARY_DIR} -framework QtSvg" CACHE STRING "The QtSvg library.")
    ELSE(EXISTS ${QT_LIBRARY_DIR}/QtSvg.framework)
      SET(QT_QTSVG_FOUND FALSE)
    ENDIF(EXISTS ${QT_LIBRARY_DIR}/QtSvg.framework)

    IF(EXISTS ${QT_LIBRARY_DIR}/QtDBus.framework)
      SET(QT_QTDBUS_FOUND TRUE)
      SET(QT_QTDBUS_LIBRARY "-F${QT_LIBRARY_DIR} -framework QtDBus" CACHE STRING "The QtDBus library.")
    ELSE(EXISTS ${QT_LIBRARY_DIR}/QtDBus.framework)
      SET(QT_QTDBUS_FOUND FALSE)
    ENDIF(EXISTS ${QT_LIBRARY_DIR}/QtDBus.framework)

    IF(EXISTS ${QT_LIBRARY_DIR}/QtTest.framework)
      SET(QT_QTTEST_FOUND TRUE)
      SET(QT_QTTEST_LIBRARY "-F${QT_LIBRARY_DIR} -framework QtTest" CACHE STRING "The QtTest library.")
    ELSE(EXISTS ${QT_LIBRARY_DIR}/QtTest.framework)
      SET(QT_QTTEST_FOUND FALSE)
    ENDIF(EXISTS ${QT_LIBRARY_DIR}/QtTest.framework)

    IF(EXISTS ${QT_LIBRARY_DIR}/QtAssistantClient.framework)
      SET(QT_QTASSISTANTCLIENT_FOUND TRUE)
      SET(QT_QTASSISTANTCLIENT_LIBRARY "-F${QT_LIBRARY_DIR} -framework QtAssistantClient" CACHE STRING "The QtAssistantClient library.")
    ELSE(EXISTS ${QT_LIBRARY_DIR}/QtAssistantClient.framework)
      SET(QT_QTASSISTANTCLIENT_FOUND FALSE)
    ENDIF(EXISTS ${QT_LIBRARY_DIR}/QtAssistantClient.framework)

    IF(EXISTS ${QT_LIBRARY_DIR}/QtWebKit.framework)
      SET(QT_QTWEBKIT_FOUND TRUE)
      SET(QT_QTWEBKIT_LIBRARY "-F${QT_LIBRARY_DIR} -framework QtWebKit" CACHE STRING "The QtWebKit library.")
    ELSE(EXISTS ${QT_LIBRARY_DIR}/QtWebKit.framework)
      SET(QT_QTWEBKIT_FOUND FALSE)
    ENDIF(EXISTS ${QT_LIBRARY_DIR}/QtWebKit.framework)

    IF(EXISTS ${QT_LIBRARY_DIR}/QtXmlPatterns.framework)
      SET(QT_QTXMLPATTERNS_FOUND TRUE)
      SET(QT_QTXMLPATTERNS_LIBRARY "-F${QT_LIBRARY_DIR} -framework QtXmlPatterns" CACHE STRING "The QtXmlPatterns library.")
    ELSE(EXISTS ${QT_LIBRARY_DIR}/QtXmlPatterns.framework)
      SET(QT_QTXMLPATTERNS_FOUND FALSE)
    ENDIF(EXISTS ${QT_LIBRARY_DIR}/QtXmlPatterns.framework)

    IF(EXISTS ${QT_LIBRARY_DIR}/QtHelp.framework)
      SET(QT_QTHELP_FOUND TRUE)
      SET(QT_QTHELP_LIBRARY "-F${QT_LIBRARY_DIR} -framework QtHelp" CACHE STRING "The QtHelp library.")
    ELSE(EXISTS ${QT_LIBRARY_DIR}/QtHelp.framework)
      SET(QT_QTHELP_FOUND FALSE)
    ENDIF(EXISTS ${QT_LIBRARY_DIR}/QtHelp.framework)

    # WTF?  why don't we have frameworks?  :P
    # Set QT_QTUITOOLS_LIBRARY
    FIND_LIBRARY(QT_QTUITOOLS_LIBRARY NAMES QtUiTools QtUiTools4 PATHS ${QT_LIBRARY_DIR} )
    # Set QT_QTSCRIPT_LIBRARY
    FIND_LIBRARY(QT_QTSCRIPT_LIBRARY NAMES QtScript QtScript4    PATHS ${QT_LIBRARY_DIR} )
    # Set QT_QTSCRIPTTOOLS_LIBRARY
    FIND_LIBRARY(QT_QTSCRIPTTOOLS_LIBRARY NAMES QtScriptTools QtScriptTools4    PATHS ${QT_LIBRARY_DIR} )

  ELSE (QT_USE_FRAMEWORKS)
    
    # Set QT_QTCORE_LIBRARY by searching for a lib with "QtCore."  as part of the filename
    FIND_LIBRARY(QT_QTCORE_LIBRARY NAMES QtCore QtCore4 QtCored4 QtCore_debug         PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH )

    # Set QT_QT3SUPPORT_LIBRARY
    FIND_LIBRARY(QT_QT3SUPPORT_LIBRARY NAMES Qt3Support Qt3Support_debug Qt3Support4 Qt3Supportd4 PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)

    # Set QT_QTGUI_LIBRARY
    FIND_LIBRARY(QT_QTGUI_LIBRARY NAMES QtGui QtGui_debug QtGui_debug QtGui4 QtGuid4            PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)

    # Set QT_QTMOTIF_LIBRARY
    IF(Q_WS_X11)
      FIND_LIBRARY(QT_QTMOTIF_LIBRARY NAMES QtMotif  QtMotif_debug PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
    ENDIF(Q_WS_X11)

    # Set QT_QTNETWORK_LIBRARY
    FIND_LIBRARY(QT_QTNETWORK_LIBRARY NAMES QtNetwork QtNetwork_debug QtNetwork4 QtNetworkd4 PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)

    # Set QT_QTNSPLUGIN_LIBRARY
    FIND_LIBRARY(QT_QTNSPLUGIN_LIBRARY NAMES QtNsPlugin QtNsPlugin_debug PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)

    # Set QT_QTOPENGL_LIBRARY
    FIND_LIBRARY(QT_QTOPENGL_LIBRARY NAMES QtOpenGL QtOpenGL_debug QtOpenGL4 QtOpenGLd4    PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)

    # Set QT_QTSQL_LIBRARY
    FIND_LIBRARY(QT_QTSQL_LIBRARY NAMES QtSql QtSql_debug QtSql4 QtSqld4       PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)

    # Set QT_QTXML_LIBRARY
    FIND_LIBRARY(QT_QTXML_LIBRARY NAMES QtXml QtXml_debug QtXml4 QtXmld4       PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)

    # Set QT_QTSVG_LIBRARY
    FIND_LIBRARY(QT_QTSVG_LIBRARY NAMES QtSvg QtSvg_debug QtSvg4 QtSvgd4       PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)

    # Set QT_QTSCRIPT_LIBRARY
    FIND_LIBRARY(QT_QTSCRIPT_LIBRARY NAMES QtScript QtScript_debug QtScript4 QtScriptd4   PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)

    # Set QT_QTUITOOLS_LIBRARY
    FIND_LIBRARY(QT_QTUITOOLS_LIBRARY NAMES QtUiTools QtUiTools_debug QtUiTools4 QtUiToolsd4 PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)

    # Set QT_QTTEST_LIBRARY
    FIND_LIBRARY(QT_QTTEST_LIBRARY NAMES QtTest QtTest_debug QtTest4 QtTestd4          PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)

    FIND_LIBRARY(QT_QTDBUS_LIBRARY NAMES QtDBus QtDBus_debug QtDBus4 QtDBusd4         PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)

    FIND_LIBRARY(QT_QTASSISTANTCLIENT_LIBRARY NAMES QtAssistantClient QtAssistantClient_debug QtAssistantClient4 QtAssistantClientd4         PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)

    IF(WIN32)
      FIND_LIBRARY(QT_QTAXSERVER_LIBRARY NAMES QtAxServer QtAxServer4 QtAxServerd4         PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
      
      FIND_LIBRARY(QT_QTAXCONTAINER_LIBRARY NAMES QtAxContainer QtAxContainer4 QtAxContainerd4         PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
    ENDIF(WIN32)

    FIND_LIBRARY(QT_QTHELP_LIBRARY NAMES QtHelp QtHelp_debug QtHelp4 QtHelpd4         PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)

    FIND_LIBRARY(QT_QTWEBKIT_LIBRARY NAMES QtWebKit QtWebKit_debug QtWebKit4 QtWebKitd4         PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)

    FIND_LIBRARY(QT_QTXMLPATTERNS_LIBRARY NAMES QtXmlPatterns QtXmlPatterns_debug QtXmlPatterns4 QtXmlPatternsd4         PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)

    FIND_LIBRARY(QT_PHONON_LIBRARY NAMES phonon phonon4 phonon_debug phonond4    PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)

    FIND_LIBRARY(QT_QTSCRIPTTOOLS_LIBRARY NAMES QtXmlPatterns QtXmlPatterns_debug QtXmlPatterns4 QtXmlPatternsd4         PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)

    IF(MSVC)
      FIND_LIBRARY(QT_QTCORE_LIBRARY_RELEASE    NAMES QtCore4            PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
      FIND_LIBRARY(QT_QTCORE_LIBRARY_DEBUG      NAMES QtCored4            PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
      FIND_LIBRARY(QT_QT3SUPPORT_LIBRARY_RELEASE NAMES Qt3Support4        PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
      FIND_LIBRARY(QT_QT3SUPPORT_LIBRARY_DEBUG  NAMES Qt3Supportd4        PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
      FIND_LIBRARY(QT_QTGUI_LIBRARY_RELEASE     NAMES QtGui4             PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
      FIND_LIBRARY(QT_QTGUI_LIBRARY_DEBUG       NAMES QtGuid4             PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
      FIND_LIBRARY(QT_QTNETWORK_LIBRARY_RELEASE NAMES QtNetwork4         PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
      FIND_LIBRARY(QT_QTNETWORK_LIBRARY_DEBUG   NAMES QtNetworkd4         PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
      FIND_LIBRARY(QT_QTOPENGL_LIBRARY_RELEASE  NAMES QtOpenGL4          PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
      FIND_LIBRARY(QT_QTOPENGL_LIBRARY_DEBUG    NAMES QtOpenGLd4          PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
      FIND_LIBRARY(QT_QTSQL_LIBRARY_RELEASE     NAMES QtSql4             PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
      FIND_LIBRARY(QT_QTSQL_LIBRARY_DEBUG       NAMES QtSqld4             PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
      FIND_LIBRARY(QT_QTXML_LIBRARY_RELEASE     NAMES QtXml4             PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
      FIND_LIBRARY(QT_QTXML_LIBRARY_DEBUG       NAMES QtXmld4             PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
      FIND_LIBRARY(QT_QTSVG_LIBRARY_RELEASE     NAMES QtSvg4             PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
      FIND_LIBRARY(QT_QTSVG_LIBRARY_DEBUG       NAMES QtSvgd4             PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
      FIND_LIBRARY(QT_QTSCRIPT_LIBRARY_RELEASE  NAMES QtScript4          PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
      FIND_LIBRARY(QT_QTSCRIPT_LIBRARY_DEBUG    NAMES QtScriptd4          PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
      FIND_LIBRARY(QT_QTUITOOLS_LIBRARY_RELEASE NAMES QtUiTools QtUiTools4 PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
      FIND_LIBRARY(QT_QTUITOOLS_LIBRARY_DEBUG   NAMES QtUiToolsd QtUiToolsd4 PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
      FIND_LIBRARY(QT_QTTEST_LIBRARY_RELEASE    NAMES QtTest4            PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
      FIND_LIBRARY(QT_QTTEST_LIBRARY_DEBUG      NAMES QtTestd4            PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
      FIND_LIBRARY(QT_QTDBUS_LIBRARY_RELEASE    NAMES QtDBus4            PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
      FIND_LIBRARY(QT_QTDBUS_LIBRARY_DEBUG      NAMES QtDBusd4            PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
      FIND_LIBRARY(QT_QTASSISTANT_LIBRARY_RELEASE NAMES QtAssistantClient4 PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
      FIND_LIBRARY(QT_QTASSISTANT_LIBRARY_DEBUG NAMES QtAssistantClientd4 PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
      FIND_LIBRARY(QT_QTAXSERVER_LIBRARY_RELEASE NAMES QtAxServer PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
      FIND_LIBRARY(QT_QTAXSERVER_LIBRARY_DEBUG NAMES QtAxServerd4 PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
      FIND_LIBRARY(QT_QTAXCONTAINER_LIBRARY_RELEASE NAMES QtAxContainer PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
      FIND_LIBRARY(QT_QTAXCONTAINER_LIBRARY_DEBUG NAMES QtAxContainerd4 PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
      FIND_LIBRARY(QT_QTDESIGNER_LIBRARY_RELEASE NAMES QtDesigner4            PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
      FIND_LIBRARY(QT_QTDESIGNER_LIBRARY_DEBUG  NAMES QtDesignerd4            PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
      FIND_LIBRARY(QT_QTDESIGNERCOMPONENTS_LIBRARY_RELEASE NAMES QtDesignerComponents4 PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
      FIND_LIBRARY(QT_QTDESIGNERCOMPONENTS_LIBRARY_DEBUG NAMES QtDesignerComponentsd4 PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
      FIND_LIBRARY(QT_QTMAIN_LIBRARY_RELEASE    NAMES qtmain             PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
      FIND_LIBRARY(QT_QTMAIN_LIBRARY_DEBUG      NAMES qtmaind             PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
      FIND_LIBRARY(QT_QTSCRIPTTOOLS_LIBRARY_RELEASE NAMES QtScriptTools4            PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
      FIND_LIBRARY(QT_QTSCRIPTTOOLS_LIBRARY_DEBUG  NAMES QtScriptToolsd4            PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
    ENDIF(MSVC)
  ENDIF (QT_USE_FRAMEWORKS)

  IF( NOT QT_QTCORE_LIBRARY )
    IF(Qt4_FIND_REQUIRED)
      MESSAGE( FATAL_ERROR "Could NOT find QtCore. Check ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeError.log for more details.")
    ENDIF(Qt4_FIND_REQUIRED)
  ENDIF( NOT QT_QTCORE_LIBRARY )

  # Set QT_QTASSISTANT_LIBRARY
  FIND_LIBRARY(QT_QTASSISTANT_LIBRARY NAMES QtAssistantClient QtAssistantClient4 QtAssistant QtAssistant4 QtAssistantd4 PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)

  # Set QT_QTDESIGNER_LIBRARY
  FIND_LIBRARY(QT_QTDESIGNER_LIBRARY NAMES QtDesigner QtDesigner_debug QtDesigner4 QtDesignerd4 PATHS ${QT_LIBRARY_DIR}        NO_DEFAULT_PATH)

  # Set QT_QTDESIGNERCOMPONENTS_LIBRARY
  FIND_LIBRARY(QT_QTDESIGNERCOMPONENTS_LIBRARY NAMES QtDesignerComponents QtDesignerComponents_debug QtDesignerComponents4 QtDesignerComponentsd4 PATHS ${QT_LIBRARY_DIR}        NO_DEFAULT_PATH)

  # Set QT_QTMAIN_LIBRARY
  IF(WIN32)
    FIND_LIBRARY(QT_QTMAIN_LIBRARY NAMES qtmain qtmaind PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
  ENDIF(WIN32)

  # Set QT_QTHELP_LIBRARY
  FIND_LIBRARY(QT_QTCLUCENE_LIBRARY_RELEASE NAMES QtCLucene${QT_LIBINFIX} QtCLucene${QT_LIBINFIX}4 PATHS ${QT_LIBRARY_DIR}        NO_DEFAULT_PATH)
  FIND_LIBRARY(QT_QTCLUCENE_LIBRARY_DEBUG   NAMES QtCLucene${QT_LIBINFIX}_debug QtCLucene${QT_LIBINFIX}d QtCLucene${QT_LIBINFIX}d4 PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
  # QtCLucene not with other frameworks with binary installation (in /usr/lib)
  IF(Q_WS_MAC AND QT_QTCORE_LIBRARY_RELEASE AND NOT QT_QTCLUCENE_LIBRARY_RELEASE)
    FIND_LIBRARY(QT_QTCLUCENE_LIBRARY_RELEASE NAMES QtCLucene${QT_LIBINFIX} PATHS ${QT_LIBRARY_DIR})
  ENDIF(Q_WS_MAC AND QT_QTCORE_LIBRARY_RELEASE AND NOT QT_QTCLUCENE_LIBRARY_RELEASE)

  ############################################
  #
  # Check the existence of the libraries.
  #
  ############################################

  MACRO (_QT4_ADJUST_LIB_VARS basename)
    IF (QT_${basename}_LIBRARY OR QT_${basename}_LIBRARY_DEBUG)

      IF(MSVC)
        # Both set
        IF (QT_${basename}_LIBRARY_RELEASE AND QT_${basename}_LIBRARY_DEBUG)
          SET(QT_${basename}_LIBRARY optimized ${QT_${basename}_LIBRARY_RELEASE} debug ${QT_${basename}_LIBRARY_DEBUG})
        ENDIF (QT_${basename}_LIBRARY_RELEASE AND QT_${basename}_LIBRARY_DEBUG)

        # Only debug was found
        IF (NOT QT_${basename}_LIBRARY_RELEASE AND QT_${basename}_LIBRARY_DEBUG)
          SET(QT_${basename}_LIBRARY ${QT_${basename}_LIBRARY_DEBUG})
        ENDIF (NOT QT_${basename}_LIBRARY_RELEASE AND QT_${basename}_LIBRARY_DEBUG)

        # Only release was found
        IF (QT_${basename}_LIBRARY_RELEASE AND NOT QT_${basename}_LIBRARY_DEBUG)
          SET(QT_${basename}_LIBRARY ${QT_${basename}_LIBRARY_RELEASE})
        ENDIF (QT_${basename}_LIBRARY_RELEASE AND NOT QT_${basename}_LIBRARY_DEBUG)

        # Hmm, is this used anywhere ? Yes, in UseQt4.cmake. We are currently incompatible :-(
        SET(QT_${basename}_LIBRARIES optimized ${QT_${basename}_LIBRARY} debug ${QT_${basename}_LIBRARY_DEBUG})

      ENDIF(MSVC)

      SET(QT_${basename}_LIBRARY ${QT_${basename}_LIBRARY} CACHE FILEPATH "The Qt ${basename} library")

      IF (QT_${basename}_LIBRARY)
        SET(QT_${basename}_FOUND 1)
      ENDIF (QT_${basename}_LIBRARY)
      
    ENDIF (QT_${basename}_LIBRARY OR QT_${basename}_LIBRARY_DEBUG)
    
    IF (QT_${basename}_INCLUDE_DIR)
      #add the include directory to QT_INCLUDES
      SET(QT_INCLUDES "${QT_${basename}_INCLUDE_DIR}" ${QT_INCLUDES})
    ENDIF (QT_${basename}_INCLUDE_DIR)

    # Make variables changeble to the advanced user
    MARK_AS_ADVANCED(QT_${basename}_LIBRARY QT_${basename}_INCLUDE_DIR)
  ENDMACRO (_QT4_ADJUST_LIB_VARS)


  # Set QT_xyz_LIBRARY variable and add 
  # library include path to QT_INCLUDES
  _QT4_ADJUST_LIB_VARS(QTCORE)
  _QT4_ADJUST_LIB_VARS(QTGUI)
  _QT4_ADJUST_LIB_VARS(QT3SUPPORT)
  _QT4_ADJUST_LIB_VARS(QTASSISTANT)
  _QT4_ADJUST_LIB_VARS(QTDESIGNER)
  _QT4_ADJUST_LIB_VARS(QTDESIGNERCOMPONENTS)
  _QT4_ADJUST_LIB_VARS(QTNETWORK)
  _QT4_ADJUST_LIB_VARS(QTNSPLUGIN)
  _QT4_ADJUST_LIB_VARS(QTOPENGL)
  _QT4_ADJUST_LIB_VARS(QTSQL)
  _QT4_ADJUST_LIB_VARS(QTXML)
  _QT4_ADJUST_LIB_VARS(QTSVG)
  _QT4_ADJUST_LIB_VARS(QTSCRIPT)
  _QT4_ADJUST_LIB_VARS(QTUITOOLS)
  _QT4_ADJUST_LIB_VARS(QTTEST)
  _QT4_ADJUST_LIB_VARS(QTDBUS)
  _QT4_ADJUST_LIB_VARS(QTASSISTANTCLIENT)
  _QT4_ADJUST_LIB_VARS(QTHELP)
  _QT4_ADJUST_LIB_VARS(QTWEBKIT)
  _QT4_ADJUST_LIB_VARS(QTXMLPATTERNS)
  _QT4_ADJUST_LIB_VARS(PHONON)
  _QT4_ADJUST_LIB_VARS(QTCLUCENE)
  _QT4_ADJUST_LIB_VARS(QTSCRIPTTOOLS)
 

  # platform dependent libraries
  IF(Q_WS_X11)
    _QT4_ADJUST_LIB_VARS(QTMOTIF)
  ENDIF(Q_WS_X11)
  IF(WIN32)
    _QT4_ADJUST_LIB_VARS(QTMAIN)
    _QT4_ADJUST_LIB_VARS(QAXSERVER)
    _QT4_ADJUST_LIB_VARS(QAXCONTAINER)
  ENDIF(WIN32)
  

  #######################################
  #
  #       Check the executables of Qt 
  #          ( moc, uic, rcc )
  #
  #######################################


  IF(QT_QMAKE_CHANGED)
    SET(QT_UIC_EXECUTABLE NOTFOUND)
    SET(QT_MOC_EXECUTABLE NOTFOUND)
    SET(QT_UIC3_EXECUTABLE NOTFOUND)
    SET(QT_RCC_EXECUTABLE NOTFOUND)
    SET(QT_DBUSCPP2XML_EXECUTABLE NOTFOUND)
    SET(QT_DBUSXML2CPP_EXECUTABLE NOTFOUND)
    SET(QT_LUPDATE_EXECUTABLE NOTFOUND)
    SET(QT_LRELEASE_EXECUTABLE NOTFOUND)
    SET(QT_QCOLLECTIONGENERATOR_EXECUTABLE NOTFOUND)
  ENDIF(QT_QMAKE_CHANGED)
  
  FIND_PROGRAM(QT_MOC_EXECUTABLE
    NAMES moc-qt4 moc
    PATHS ${QT_BINARY_DIR}
    NO_DEFAULT_PATH
    )

  FIND_PROGRAM(QT_UIC_EXECUTABLE
    NAMES uic-qt4 uic
    PATHS ${QT_BINARY_DIR}
    NO_DEFAULT_PATH
    )

  FIND_PROGRAM(QT_UIC3_EXECUTABLE
    NAMES uic3
    PATHS ${QT_BINARY_DIR}
    NO_DEFAULT_PATH
    )

  FIND_PROGRAM(QT_RCC_EXECUTABLE 
    NAMES rcc
    PATHS ${QT_BINARY_DIR}
    NO_DEFAULT_PATH
    )

  FIND_PROGRAM(QT_DBUSCPP2XML_EXECUTABLE 
    NAMES qdbuscpp2xml
    PATHS ${QT_BINARY_DIR}
    NO_DEFAULT_PATH
    )

  FIND_PROGRAM(QT_DBUSXML2CPP_EXECUTABLE 
    NAMES qdbusxml2cpp
    PATHS ${QT_BINARY_DIR}
    NO_DEFAULT_PATH
    )

  FIND_PROGRAM(QT_LUPDATE_EXECUTABLE
    NAMES lupdate-qt4 lupdate
    PATHS ${QT_BINARY_DIR}
    NO_DEFAULT_PATH
    )

  FIND_PROGRAM(QT_LRELEASE_EXECUTABLE
    NAMES lrelease-qt4 lrelease
    PATHS ${QT_BINARY_DIR}
    NO_DEFAULT_PATH
    )

  FIND_PROGRAM(QT_QCOLLECTIONGENERATOR_EXECUTABLE
    NAMES qcollectiongenerator-qt4 qcollectiongenerator
    PATHS ${QT_BINARY_DIR}
    NO_DEFAULT_PATH
    )

  IF (QT_MOC_EXECUTABLE)
     SET(QT_WRAP_CPP "YES")
  ENDIF (QT_MOC_EXECUTABLE)

  IF (QT_UIC_EXECUTABLE)
     SET(QT_WRAP_UI "YES")
  ENDIF (QT_UIC_EXECUTABLE)



  MARK_AS_ADVANCED( QT_UIC_EXECUTABLE QT_UIC3_EXECUTABLE QT_MOC_EXECUTABLE
    QT_RCC_EXECUTABLE QT_DBUSXML2CPP_EXECUTABLE QT_DBUSCPP2XML_EXECUTABLE
    QT_LUPDATE_EXECUTABLE QT_LRELEASE_EXECUTABLE QT_QCOLLECTIONGENERATOR_EXECUTABLE)

  ######################################
  #
  #       Macros for building Qt files
  #
  ######################################

  MACRO (QT4_EXTRACT_OPTIONS _qt4_files _qt4_options)
    SET(${_qt4_files})
    SET(${_qt4_options})
    SET(_QT4_DOING_OPTIONS FALSE)
    FOREACH(_currentArg ${ARGN})
      IF ("${_currentArg}" STREQUAL "OPTIONS")
        SET(_QT4_DOING_OPTIONS TRUE)
      ELSE ("${_currentArg}" STREQUAL "OPTIONS")
        IF(_QT4_DOING_OPTIONS) 
          LIST(APPEND ${_qt4_options} "${_currentArg}")
        ELSE(_QT4_DOING_OPTIONS)
          LIST(APPEND ${_qt4_files} "${_currentArg}")
        ENDIF(_QT4_DOING_OPTIONS)
      ENDIF ("${_currentArg}" STREQUAL "OPTIONS")
    ENDFOREACH(_currentArg) 
  ENDMACRO (QT4_EXTRACT_OPTIONS)
  
  # macro used to create the names of output files preserving relative dirs
  MACRO (QT4_MAKE_OUTPUT_FILE infile prefix ext outfile )
    STRING(LENGTH ${CMAKE_CURRENT_BINARY_DIR} _binlength)
    STRING(LENGTH ${infile} _infileLength)
    SET(_checkinfile ${CMAKE_CURRENT_SOURCE_DIR})
    IF(_infileLength GREATER _binlength)
      STRING(SUBSTRING "${infile}" 0 ${_binlength} _checkinfile)
      IF(_checkinfile STREQUAL "${CMAKE_CURRENT_BINARY_DIR}")
        FILE(RELATIVE_PATH rel ${CMAKE_CURRENT_BINARY_DIR} ${infile})
      ELSE(_checkinfile STREQUAL "${CMAKE_CURRENT_BINARY_DIR}")
        FILE(RELATIVE_PATH rel ${CMAKE_CURRENT_SOURCE_DIR} ${infile})
      ENDIF(_checkinfile STREQUAL "${CMAKE_CURRENT_BINARY_DIR}")
    ELSE(_infileLength GREATER _binlength)
      FILE(RELATIVE_PATH rel ${CMAKE_CURRENT_SOURCE_DIR} ${infile})
    ENDIF(_infileLength GREATER _binlength)
    IF(WIN32 AND rel MATCHES "^[a-zA-Z]:") # absolute path 
      STRING(REGEX REPLACE "^([a-zA-Z]):(.*)$" "\\1_\\2" rel "${rel}")
    ENDIF(WIN32 AND rel MATCHES "^[a-zA-Z]:") 
    SET(_outfile "${CMAKE_CURRENT_BINARY_DIR}/${rel}")
    STRING(REPLACE ".." "__" _outfile ${_outfile})
    GET_FILENAME_COMPONENT(outpath ${_outfile} PATH)
    GET_FILENAME_COMPONENT(_outfile ${_outfile} NAME_WE)
    FILE(MAKE_DIRECTORY ${outpath})
    SET(${outfile} ${outpath}/${prefix}${_outfile}.${ext})
  ENDMACRO (QT4_MAKE_OUTPUT_FILE )

  MACRO (QT4_GET_MOC_FLAGS _moc_flags)
     SET(${_moc_flags})
     GET_DIRECTORY_PROPERTY(_inc_DIRS INCLUDE_DIRECTORIES)

     FOREACH(_current ${_inc_DIRS})
        SET(${_moc_flags} ${${_moc_flags}} "-I${_current}")
     ENDFOREACH(_current ${_inc_DIRS})
     
     GET_DIRECTORY_PROPERTY(_defines COMPILE_DEFINITIONS)
     FOREACH(_current ${_defines})
        SET(${_moc_flags} ${${_moc_flags}} "-D${_current}")
     ENDFOREACH(_current ${_defines})

     IF(Q_WS_WIN)
       SET(${_moc_flags} ${${_moc_flags}} -DWIN32)
     ENDIF(Q_WS_WIN)

     # if Qt is installed only as framework, add -F /library/Frameworks to the moc arguments
     # otherwise moc can't find the headers in the framework include dirs
     IF(APPLE  AND  "${QT_QTCORE_INCLUDE_DIR}" MATCHES "/Library/Frameworks/")
        SET(${_moc_INC_DIRS} ${${_moc_INC_DIRS}} "-F/Library/Frameworks")
     ENDIF(APPLE  AND  "${QT_QTCORE_INCLUDE_DIR}" MATCHES "/Library/Frameworks/")

  ENDMACRO(QT4_GET_MOC_FLAGS)

  # helper macro to set up a moc rule
  MACRO (QT4_CREATE_MOC_COMMAND infile outfile moc_flags moc_options)
    # For Windows, create a parameters file to work around command line length limit
    IF (WIN32)
      # Pass the parameters in a file.  Set the working directory to
      # be that containing the parameters file and reference it by
      # just the file name.  This is necessary because the moc tool on
      # MinGW builds does not seem to handle spaces in the path to the
      # file given with the @ syntax.
      GET_FILENAME_COMPONENT(_moc_outfile_name "${outfile}" NAME)
      GET_FILENAME_COMPONENT(_moc_outfile_dir "${outfile}" PATH)
      IF(_moc_outfile_dir)
        SET(_moc_working_dir WORKING_DIRECTORY ${_moc_outfile_dir})
      ENDIF(_moc_outfile_dir)
      SET (_moc_parameters_file ${outfile}_parameters)
      SET (_moc_parameters ${moc_flags} ${moc_options} -o "${outfile}" "${infile}")
      FILE (REMOVE ${_moc_parameters_file})
      FOREACH(arg ${_moc_parameters})
        FILE (APPEND ${_moc_parameters_file} "${arg}\n")
      ENDFOREACH(arg)
      ADD_CUSTOM_COMMAND(OUTPUT ${outfile}
                         COMMAND ${QT_MOC_EXECUTABLE} @${_moc_outfile_name}_parameters
                         DEPENDS ${infile}
                         ${_moc_working_dir}
                         VERBATIM)
    ELSE (WIN32)     
      ADD_CUSTOM_COMMAND(OUTPUT ${outfile}
                         COMMAND ${QT_MOC_EXECUTABLE}
                         ARGS ${moc_flags} ${moc_options} -o ${outfile} ${infile}
                         DEPENDS ${infile})     
    ENDIF (WIN32)
  ENDMACRO (QT4_CREATE_MOC_COMMAND)

  
  MACRO (QT4_GENERATE_MOC infile outfile )
  # get include dirs and flags
     QT4_GET_MOC_FLAGS(moc_flags)
     GET_FILENAME_COMPONENT(abs_infile ${infile} ABSOLUTE)
     QT4_CREATE_MOC_COMMAND(${abs_infile} ${outfile} "${moc_flags}" "")
     SET_SOURCE_FILES_PROPERTIES(${outfile} PROPERTIES SKIP_AUTOMOC TRUE)  # dont run automoc on this file

     MACRO_ADD_FILE_DEPENDENCIES(${abs_infile} ${outfile})
  ENDMACRO (QT4_GENERATE_MOC)


  # QT4_WRAP_CPP(outfiles inputfile ... )

  MACRO (QT4_WRAP_CPP outfiles )
    # get include dirs
    QT4_GET_MOC_FLAGS(moc_flags)
    QT4_EXTRACT_OPTIONS(moc_files moc_options ${ARGN})

    FOREACH (it ${moc_files})
      GET_FILENAME_COMPONENT(it ${it} ABSOLUTE)
      QT4_MAKE_OUTPUT_FILE(${it} moc_ cxx outfile)
      QT4_CREATE_MOC_COMMAND(${it} ${outfile} "${moc_flags}" "${moc_options}")
      SET(${outfiles} ${${outfiles}} ${outfile})
    ENDFOREACH(it)

  ENDMACRO (QT4_WRAP_CPP)


  # QT4_WRAP_UI(outfiles inputfile ... )

  MACRO (QT4_WRAP_UI outfiles )
    QT4_EXTRACT_OPTIONS(ui_files ui_options ${ARGN})

    FOREACH (it ${ui_files})
      GET_FILENAME_COMPONENT(outfile ${it} NAME_WE)
      GET_FILENAME_COMPONENT(infile ${it} ABSOLUTE)
      SET(outfile ${CMAKE_CURRENT_BINARY_DIR}/ui_${outfile}.h)
      ADD_CUSTOM_COMMAND(OUTPUT ${outfile}
        COMMAND ${QT_UIC_EXECUTABLE}
        ARGS ${ui_options} -o ${outfile} ${infile}
        MAIN_DEPENDENCY ${infile})
      SET(${outfiles} ${${outfiles}} ${outfile})
    ENDFOREACH (it)

  ENDMACRO (QT4_WRAP_UI)


  # QT4_ADD_RESOURCES(outfiles inputfile ... )

  MACRO (QT4_ADD_RESOURCES outfiles )
    QT4_EXTRACT_OPTIONS(rcc_files rcc_options ${ARGN})

    FOREACH (it ${rcc_files})
      GET_FILENAME_COMPONENT(outfilename ${it} NAME_WE)
      GET_FILENAME_COMPONENT(infile ${it} ABSOLUTE)
      GET_FILENAME_COMPONENT(rc_path ${infile} PATH)
      SET(outfile ${CMAKE_CURRENT_BINARY_DIR}/qrc_${outfilename}.cxx)
      #  parse file for dependencies 
      #  all files are absolute paths or relative to the location of the qrc file
      FILE(READ "${infile}" _RC_FILE_CONTENTS)
      STRING(REGEX MATCHALL "<file[^<]+" _RC_FILES "${_RC_FILE_CONTENTS}")
      SET(_RC_DEPENDS)
      FOREACH(_RC_FILE ${_RC_FILES})
        STRING(REGEX REPLACE "^<file[^>]*>" "" _RC_FILE "${_RC_FILE}")
        STRING(REGEX MATCH "^/|([A-Za-z]:/)" _ABS_PATH_INDICATOR "${_RC_FILE}")
        IF(NOT _ABS_PATH_INDICATOR)
          SET(_RC_FILE "${rc_path}/${_RC_FILE}")
        ENDIF(NOT _ABS_PATH_INDICATOR)
        SET(_RC_DEPENDS ${_RC_DEPENDS} "${_RC_FILE}")
      ENDFOREACH(_RC_FILE)
      ADD_CUSTOM_COMMAND(OUTPUT ${outfile}
        COMMAND ${QT_RCC_EXECUTABLE}
        ARGS ${rcc_options} -name ${outfilename} -o ${outfile} ${infile}
        MAIN_DEPENDENCY ${infile}
        DEPENDS ${_RC_DEPENDS})
      SET(${outfiles} ${${outfiles}} ${outfile})
    ENDFOREACH (it)

  ENDMACRO (QT4_ADD_RESOURCES)

  MACRO(QT4_ADD_DBUS_INTERFACE _sources _interface _basename)
    GET_FILENAME_COMPONENT(_infile ${_interface} ABSOLUTE)
    SET(_header ${CMAKE_CURRENT_BINARY_DIR}/${_basename}.h)
    SET(_impl   ${CMAKE_CURRENT_BINARY_DIR}/${_basename}.cpp)
    SET(_moc    ${CMAKE_CURRENT_BINARY_DIR}/${_basename}.moc)

    GET_SOURCE_FILE_PROPERTY(_nonamespace ${_interface} NO_NAMESPACE)
    IF ( _nonamespace )
        SET(_params -N -m)
    ELSE ( _nonamespace )
        SET(_params -m)
    ENDIF ( _nonamespace )

    GET_SOURCE_FILE_PROPERTY(_classname ${_interface} CLASSNAME)
    IF ( _classname )
        SET(_params ${_params} -c ${_classname})
    ENDIF ( _classname )

    GET_SOURCE_FILE_PROPERTY(_include ${_interface} INCLUDE)
    IF ( _include )
        SET(_params ${_params} -i ${_include})
    ENDIF ( _include )

    ADD_CUSTOM_COMMAND(OUTPUT ${_impl} ${_header}
        COMMAND ${QT_DBUSXML2CPP_EXECUTABLE} ${_params} -p ${_basename} ${_infile}
        DEPENDS ${_infile})
  
    SET_SOURCE_FILES_PROPERTIES(${_impl} PROPERTIES SKIP_AUTOMOC TRUE)
    
    QT4_GENERATE_MOC(${_header} ${_moc})
  
    SET(${_sources} ${${_sources}} ${_impl} ${_header} ${_moc})
    MACRO_ADD_FILE_DEPENDENCIES(${_impl} ${_moc})
  
  ENDMACRO(QT4_ADD_DBUS_INTERFACE)
  
  
  MACRO(QT4_ADD_DBUS_INTERFACES _sources)
     FOREACH (_current_FILE ${ARGN})
        GET_FILENAME_COMPONENT(_infile ${_current_FILE} ABSOLUTE)
        # get the part before the ".xml" suffix
        STRING(REGEX REPLACE "(.*[/\\.])?([^\\.]+)\\.xml" "\\2" _basename ${_current_FILE})
        STRING(TOLOWER ${_basename} _basename)
        QT4_ADD_DBUS_INTERFACE(${_sources} ${_infile} ${_basename}interface)
     ENDFOREACH (_current_FILE)
  ENDMACRO(QT4_ADD_DBUS_INTERFACES)
  
  
  MACRO(QT4_GENERATE_DBUS_INTERFACE _header) # _customName OPTIONS -some -options )
    QT4_EXTRACT_OPTIONS(_customName _qt4_dbus_options ${ARGN})

    GET_FILENAME_COMPONENT(_in_file ${_header} ABSOLUTE)
    GET_FILENAME_COMPONENT(_basename ${_header} NAME_WE)
    
    IF (_customName)
      SET(_target ${CMAKE_CURRENT_BINARY_DIR}/${_customName})
    ELSE (_customName)
      SET(_target ${CMAKE_CURRENT_BINARY_DIR}/${_basename}.xml)
    ENDIF (_customName)
  
    ADD_CUSTOM_COMMAND(OUTPUT ${_target}
        COMMAND ${QT_DBUSCPP2XML_EXECUTABLE} ${_qt4_dbus_options} ${_in_file} -o ${_target}
        DEPENDS ${_in_file}
    )
  ENDMACRO(QT4_GENERATE_DBUS_INTERFACE)
  
  
  MACRO(QT4_ADD_DBUS_ADAPTOR _sources _xml_file _include _parentClass) # _optionalBasename _optionalClassName)
    GET_FILENAME_COMPONENT(_infile ${_xml_file} ABSOLUTE)
    
    SET(_optionalBasename "${ARGV4}")
    IF (_optionalBasename)
       SET(_basename ${_optionalBasename} )
    ELSE (_optionalBasename)
       STRING(REGEX REPLACE "(.*[/\\.])?([^\\.]+)\\.xml" "\\2adaptor" _basename ${_infile})
       STRING(TOLOWER ${_basename} _basename)
    ENDIF (_optionalBasename)

    SET(_optionalClassName "${ARGV5}")
    SET(_header ${CMAKE_CURRENT_BINARY_DIR}/${_basename}.h)
    SET(_impl   ${CMAKE_CURRENT_BINARY_DIR}/${_basename}.cpp)
    SET(_moc    ${CMAKE_CURRENT_BINARY_DIR}/${_basename}.moc)

    IF(_optionalClassName)
       ADD_CUSTOM_COMMAND(OUTPUT ${_impl} ${_header}
          COMMAND ${QT_DBUSXML2CPP_EXECUTABLE} -m -a ${_basename} -c ${_optionalClassName} -i ${_include} -l ${_parentClass} ${_infile}
          DEPENDS ${_infile}
        )
    ELSE(_optionalClassName)
       ADD_CUSTOM_COMMAND(OUTPUT ${_impl} ${_header}
          COMMAND ${QT_DBUSXML2CPP_EXECUTABLE} -m -a ${_basename} -i ${_include} -l ${_parentClass} ${_infile}
          DEPENDS ${_infile}
        )
    ENDIF(_optionalClassName)

    QT4_GENERATE_MOC(${_header} ${_moc})
    SET_SOURCE_FILES_PROPERTIES(${_impl} PROPERTIES SKIP_AUTOMOC TRUE)
    MACRO_ADD_FILE_DEPENDENCIES(${_impl} ${_moc})

    SET(${_sources} ${${_sources}} ${_impl} ${_header} ${_moc})
  ENDMACRO(QT4_ADD_DBUS_ADAPTOR)

   MACRO(QT4_AUTOMOC)
      QT4_GET_MOC_FLAGS(_moc_INCS)

      SET(_matching_FILES )
      FOREACH (_current_FILE ${ARGN})

         GET_FILENAME_COMPONENT(_abs_FILE ${_current_FILE} ABSOLUTE)
         # if "SKIP_AUTOMOC" is set to true, we will not handle this file here.
         # This is required to make uic work correctly:
         # we need to add generated .cpp files to the sources (to compile them),
         # but we cannot let automoc handle them, as the .cpp files don't exist yet when
         # cmake is run for the very first time on them -> however the .cpp files might
         # exist at a later run. at that time we need to skip them, so that we don't add two
         # different rules for the same moc file
         GET_SOURCE_FILE_PROPERTY(_skip ${_abs_FILE} SKIP_AUTOMOC)

         IF ( NOT _skip AND EXISTS ${_abs_FILE} )

            FILE(READ ${_abs_FILE} _contents)

            GET_FILENAME_COMPONENT(_abs_PATH ${_abs_FILE} PATH)

            STRING(REGEX MATCHALL "# *include +[^ ]+\\.moc[\">]" _match "${_contents}")
            IF(_match)
               FOREACH (_current_MOC_INC ${_match})
                  STRING(REGEX MATCH "[^ <\"]+\\.moc" _current_MOC "${_current_MOC_INC}")

                  GET_FILENAME_COMPONENT(_basename ${_current_MOC} NAME_WE)
                  IF(EXISTS ${_abs_PATH}/${_basename}.hpp)
                    SET(_header ${_abs_PATH}/${_basename}.hpp)
                  ELSE(EXISTS ${_abs_PATH}/${_basename}.hpp)
                    SET(_header ${_abs_PATH}/${_basename}.h)
                  ENDIF(EXISTS ${_abs_PATH}/${_basename}.hpp)
                  SET(_moc    ${CMAKE_CURRENT_BINARY_DIR}/${_current_MOC})
                  QT4_CREATE_MOC_COMMAND(${_header} ${_moc} "${_moc_INCS}" "")
                  MACRO_ADD_FILE_DEPENDENCIES(${_abs_FILE} ${_moc})
               ENDFOREACH (_current_MOC_INC)
            ENDIF(_match)
         ENDIF ( NOT _skip AND EXISTS ${_abs_FILE} )
      ENDFOREACH (_current_FILE)
   ENDMACRO(QT4_AUTOMOC)

   MACRO(QT4_CREATE_TRANSLATION _qm_files)
      QT4_EXTRACT_OPTIONS(_lupdate_files _lupdate_options ${ARGN})
      SET(_my_sources)
      SET(_my_dirs)
      SET(_my_tsfiles)
      SET(_ts_pro)
      FOREACH (_file ${_lupdate_files})
         GET_FILENAME_COMPONENT(_ext ${_file} EXT)
         GET_FILENAME_COMPONENT(_abs_FILE ${_file} ABSOLUTE)
         IF(_ext MATCHES "ts")
           LIST(APPEND _my_tsfiles ${_abs_FILE})
         ELSE(_ext MATCHES "ts")
           IF(NOT _ext)
             LIST(APPEND _my_dirs ${_abs_FILE})
           ELSE(NOT _ext)
             LIST(APPEND _my_sources ${_abs_FILE})
           ENDIF(NOT _ext)
         ENDIF(_ext MATCHES "ts")
      ENDFOREACH(_file)
      FOREACH(_ts_file ${_my_tsfiles})
        IF(_my_sources)
          # make a .pro file to call lupdate on, so we don't make our commands too
          # long for some systems
          GET_FILENAME_COMPONENT(_ts_name ${_ts_file} NAME_WE)
          SET(_ts_pro ${CMAKE_CURRENT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/${_ts_name}_lupdate.pro)
          SET(_pro_srcs)
          FOREACH(_pro_src ${_my_sources})
            SET(_pro_srcs "${_pro_srcs} \"${_pro_src}\"")
          ENDFOREACH(_pro_src ${_my_sources})
          FILE(WRITE ${_ts_pro} "SOURCES = ${_pro_srcs}")
        ENDIF(_my_sources)
        ADD_CUSTOM_COMMAND(OUTPUT ${_ts_file}
           COMMAND ${QT_LUPDATE_EXECUTABLE}
           ARGS ${_lupdate_options} ${_ts_pro} ${_my_dirs} -ts ${_ts_file}
           DEPENDS ${_my_sources} ${_ts_pro})
      ENDFOREACH(_ts_file)
      QT4_ADD_TRANSLATION(${_qm_files} ${_my_tsfiles})
   ENDMACRO(QT4_CREATE_TRANSLATION)

   MACRO(QT4_ADD_TRANSLATION _qm_files)
      FOREACH (_current_FILE ${ARGN})
         GET_FILENAME_COMPONENT(_abs_FILE ${_current_FILE} ABSOLUTE)
         GET_FILENAME_COMPONENT(qm ${_abs_FILE} NAME_WE)
         GET_SOURCE_FILE_PROPERTY(output_location ${_abs_FILE} OUTPUT_LOCATION)
         IF(output_location)
           FILE(MAKE_DIRECTORY "${output_location}")
           SET(qm "${output_location}/${qm}.qm")
         ELSE(output_location)
           SET(qm "${CMAKE_CURRENT_BINARY_DIR}/${qm}.qm")
         ENDIF(output_location)

         ADD_CUSTOM_COMMAND(OUTPUT ${qm}
            COMMAND ${QT_LRELEASE_EXECUTABLE}
            ARGS ${_abs_FILE} -qm ${qm}
            DEPENDS ${_abs_FILE}
         )
         SET(${_qm_files} ${${_qm_files}} ${qm})
      ENDFOREACH (_current_FILE)
   ENDMACRO(QT4_ADD_TRANSLATION)





  ######################################
  #
  #       decide if Qt got found
  #
  ######################################

  # if the includes,libraries,moc,uic and rcc are found then we have it
  IF( QT_LIBRARY_DIR AND QT_INCLUDE_DIR AND QT_MOC_EXECUTABLE AND 
      QT_UIC_EXECUTABLE AND QT_RCC_EXECUTABLE AND QT_QTCORE_LIBRARY)
    SET( QT4_FOUND "YES" )
    IF( NOT Qt4_FIND_QUIETLY)
      MESSAGE(STATUS "Found Qt-Version ${QTVERSION} (using ${QT_QMAKE_EXECUTABLE})")
    ENDIF( NOT Qt4_FIND_QUIETLY)
  ELSE( QT_LIBRARY_DIR AND QT_INCLUDE_DIR AND QT_MOC_EXECUTABLE AND 
      QT_UIC_EXECUTABLE AND QT_RCC_EXECUTABLE AND QT_QTCORE_LIBRARY)
    SET( QT4_FOUND "NO")
    SET(QT_QMAKE_EXECUTABLE "${QT_QMAKE_EXECUTABLE}-NOTFOUND" CACHE FILEPATH "Invalid qmake found" FORCE)
    IF( Qt4_FIND_REQUIRED)
      IF ( NOT QT_LIBRARY_DIR )
        MESSAGE(STATUS "Qt libraries NOT found!")
      ENDIF(NOT QT_LIBRARY_DIR )
      IF ( NOT QT_INCLUDE_DIR )
        MESSAGE(STATUS "Qt includes NOT found!")
      ENDIF( NOT QT_INCLUDE_DIR )
      IF ( NOT QT_MOC_EXECUTABLE )
        MESSAGE(STATUS "Qt's moc NOT found!")
      ENDIF( NOT QT_MOC_EXECUTABLE )
      IF ( NOT QT_UIC_EXECUTABLE )
        MESSAGE(STATUS "Qt's uic NOT found!")
      ENDIF( NOT QT_UIC_EXECUTABLE )
      IF ( NOT QT_RCC_EXECUTABLE )
        MESSAGE(STATUS "Qt's rcc NOT found!")
      ENDIF( NOT QT_RCC_EXECUTABLE )
      MESSAGE( FATAL_ERROR "Qt libraries, includes, moc, uic or/and rcc NOT found!")
    ENDIF( Qt4_FIND_REQUIRED)
  ENDIF( QT_LIBRARY_DIR AND QT_INCLUDE_DIR AND QT_MOC_EXECUTABLE AND 
         QT_UIC_EXECUTABLE AND  QT_RCC_EXECUTABLE AND QT_QTCORE_LIBRARY)
  
  SET(QT_FOUND ${QT4_FOUND})


  ###############################################
  #
  #       configuration/system dependent settings  
  #
  ###############################################
  # for unix add X11 stuff
  IF(UNIX)
    # on OS X X11 may not be required
    IF (Q_WS_X11)
      FIND_PACKAGE(X11 REQUIRED)
    ENDIF (Q_WS_X11)
    FIND_PACKAGE(Threads)
    SET(QT_QTCORE_LIBRARY ${QT_QTCORE_LIBRARY} ${CMAKE_THREAD_LIBS_INIT})
  ENDIF(UNIX)


  #######################################
  #
  #       compatibility settings 
  #
  #######################################
  # Backwards compatibility for CMake1.4 and 1.2
  SET (QT_MOC_EXE ${QT_MOC_EXECUTABLE} )
  SET (QT_UIC_EXE ${QT_UIC_EXECUTABLE} )

  SET( QT_QT_LIBRARY "")

ELSE(QT4_QMAKE_FOUND)
   
   SET(QT_QMAKE_EXECUTABLE "${QT_QMAKE_EXECUTABLE}-NOTFOUND" CACHE FILEPATH "Invalid qmake found" FORCE)
   
   # The code below is overly complex to make sure we do not break compatibility with CMake 2.6.x
   # For CMake 2.8, it should be simplified by getting rid of QT4_INSTALLED_VERSION_TOO_OLD and 
   # QT4_INSTALLED_VERSION_TOO_NEW
   IF(Qt4_FIND_REQUIRED)
      IF(QT4_INSTALLED_VERSION_TOO_OLD)
    IF( Qt4_FIND_VERSION_EXACT )
      MESSAGE(FATAL_ERROR "The installed Qt version ${QTVERSION} is too old, version ${QT_MIN_VERSION} is required")
    ELSE( Qt4_FIND_VERSION_EXACT )
      MESSAGE(FATAL_ERROR "The installed Qt version ${QTVERSION} is too old, at least version ${QT_MIN_VERSION} is required")
    ENDIF( Qt4_FIND_VERSION_EXACT )
      ELSE(QT4_INSTALLED_VERSION_TOO_OLD)
      IF( Qt4_FIND_VERSION_EXACT AND QT4_INSTALLED_VERSION_TOO_NEW )
      MESSAGE(FATAL_ERROR "The installed Qt version ${QTVERSION} is too new, version ${QT_MIN_VERSION} is required")
    ELSE( Qt4_FIND_VERSION_EXACT AND QT4_INSTALLED_VERSION_TOO_NEW )
      MESSAGE( FATAL_ERROR "Qt qmake not found!")
    ENDIF( Qt4_FIND_VERSION_EXACT AND QT4_INSTALLED_VERSION_TOO_NEW )
      ENDIF(QT4_INSTALLED_VERSION_TOO_OLD)
   ELSE(Qt4_FIND_REQUIRED)
      IF(QT4_INSTALLED_VERSION_TOO_OLD AND NOT Qt4_FIND_QUIETLY)
         MESSAGE(STATUS "The installed Qt version ${QTVERSION} is too old, at least version ${QT_MIN_VERSION} is required")
      ENDIF(QT4_INSTALLED_VERSION_TOO_OLD AND NOT Qt4_FIND_QUIETLY)
   ENDIF(Qt4_FIND_REQUIRED)
 
ENDIF (QT4_QMAKE_FOUND)

