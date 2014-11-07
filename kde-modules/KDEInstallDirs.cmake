#.rst:
# KDEInstallDirs
# --------------
#
# Define KDE standard installation directories.
#
# Note that none of the variables defined by this module provide any
# information about the location of already-installed KDE software.
#
# Inclusion of this module defines the following variables:
#
# ``CMAKE_INSTALL_<dir>``
#     destination for files of a given type
# ``CMAKE_INSTALL_FULL_<dir>``
#     corresponding absolute path
#
# where ``<dir>`` is one of (default values in parentheses and alternative,
# deprecated variable name in square brackets):
#
# ``BUNDLEDIR``
#     application bundles (``/Applications/KDE``) [``BUNDLE_INSTALL_DIR``]
# ``EXECROOTDIR``
#     executables and libraries (``<empty>``) [``EXEC_INSTALL_PREFIX``]
# ``BINDIR``
#     user executables (``EXECROOTDIR/bin``) [``BIN_INSTALL_DIR``]
# ``SBINDIR``
#     system admin executables (``EXECROOTDIR/sbin``) [``SBIN_INSTALL_DIR``]
# ``LIBDIR``
#     object code libraries (``EXECROOTDIR/lib``, ``EXECROOTDIR/lib64`` or
#     ``EXECROOTDIR/lib/<multiarch-tuple`` on Debian) [``LIB_INSTALL_DIR``]
# ``LIBEXECDIR``
#     executables for internal use by programs and libraries (``BINDIR`` on
#     Windows, ``LIBDIR/libexec`` otherwise) [``LIBEXEC_INSTALL_DIR``]
# ``CMAKEPACKAGEDIR``
#     CMake packages, including config files (``LIBDIR/cmake``)
#     [``CMAKECONFIG_INSTALL_PREFIX``]
# ``QTPLUGINDIR``
#     Qt plugins (``LIBDIR/plugins``) [``QT_PLUGIN_INSTALL_DIR``]
# ``PLUGINDIR``
#     Plugins (``QTPLUGINDIR``) [``PLUGIN_INSTALL_DIR``]
# ``QTQUICKIMPORTSDIR``
#     QtQuick1 imports (``QTPLUGINDIR/imports``) [``IMPORTS_INSTALL_DIR``]
# ``QMLDIR``
#     QtQuick2 imports (``LIBDIR/qml``) [``QML_INSTALL_DIR``]
# ``INCLUDEDIR``
#     C and C++ header files (``include``) [``INCLUDE_INSTALL_DIR``]
# ``LOCALSTATEDIR``
#     modifiable single-machine data (``var``)
# ``SHAREDSTATEDIR``
#     modifiable architecture-independent data (``com``)
# ``DATAROOTDIR``
#     read-only architecture-independent data root (``share``)
#     [``SHARE_INSTALL_PREFIX``]
# ``DATADIR``
#     read-only architecture-independent data (``DATAROOTDIR``)
#     [``DATA_INSTALL_DIR``]
# ``DOCBUNDLEDIR``
#     documentation bundles generated using kdoctools
#     (``DATAROOTDIR/doc/HTML``) [``HTML_INSTALL_DIR``]
# ``KCFGDIR``
#     kconfig description files (``DATAROOTDIR/config.kcfg``)
#     [``KCFG_INSTALL_DIR``]
# ``KCONFUPDATEDIR``
#     kconf_update scripts (``DATAROOTDIR/kconf_update``)
#     [``KCONF_UPDATE_INSTALL_DIR``]
# ``KSERVICES5DIR``
#     services for KDE Frameworks 5 (``DATAROOTDIR/kservices5``)
#     [``SERVICES_INSTALL_DIR``]
# ``KSERVICETYPES5DIR``
#     service types for KDE Frameworks 5 (``DATAROOTDIR/kservicetypes5``)
#     [``SERVICETYPES_INSTALL_DIR``]
# ``KXMLGUI5DIR``
#     knotify description files (``DATAROOTDIR/kxmlgui5``)
#     [``KXMLGUI_INSTALL_DIR``]
# ``KNOTIFY5RCDIR``
#     knotify description files (``DATAROOTDIR/knotifications5``)
#     [``KNOTIFYRC_INSTALL_DIR``]
# ``ICONDIR``
#     icons (``DATAROOTDIR/icons``) [``ICON_INSTALL_DIR``]
# ``LOCALEDIR``
#     knotify description files (``DATAROOTDIR/locale``)
#     [``LOCALE_INSTALL_DIR``]
# ``SOUNDDIR``
#     sound files (``DATAROOTDIR/sounds``) [``SOUND_INSTALL_DIR``]
# ``TEMPLATEDIR``
#     templates (``DATAROOTDIR/templates``) [``TEMPLATES_INSTALL_DIR``]
# ``WALLPAPERDIR``
#     desktop wallpaper images (``DATAROOTDIR/wallpapers``)
#     [``WALLPAPER_INSTALL_DIR``]
# ``APPDIR``
#     application desktop files (``DATAROOTDIR/applications``)
#     [``XDG_APPS_INSTALL_DIR``]
# ``DESKTOPDIR``
#     desktop directories (``DATAROOTDIR/desktop-directories``)
#     [``XDG_DIRECTORY_INSTALL_DIR``]
# ``MIMEDIR``
#     mime description files (``DATAROOTDIR/mime/packages``)
#     [``XDG_MIME_INSTALL_DIR``]
# ``METAINFODIR``
#     AppStream component metadata files (``DATAROOTDIR/appdata``)
# ``MANDIR``
#     man documentation (``DATAROOTDIR/man``) [``MAN_INSTALL_DIR``]
# ``INFODIR``
#     info documentation (``DATAROOTDIR/info``)
# ``DBUSDIR``
#     D-Bus (``DATAROOTDIR/dbus-1``)
# ``DBUSINTERFACEDIR``
#     D-Bus interfaces (``DBUSDIR/interfaces``)
#     [``DBUS_INTERFACES_INSTALL_DIR``]
# ``DBUSSERVICEDIR``
#     D-Bus session services (``DBUSDIR/services``)
#     [``DBUS_SERVICES_INSTALL_DIR``]
# ``DBUSSYSTEMSERVICEDIR``
#     D-Bus system services (``DBUSDIR/system-services``)
#     [``DBUS_SYSTEM_SERVICES_INSTALL_DIR``]
# ``SYSCONFDIR``
#     read-only single-machine data
#     (``etc``, or ``/etc`` if ``CMAKE_INSTALL_DIR`` is ``/usr``)
#     [``SYSCONF_INSTALL_DIR``]
# ``CONFDIR``
#     application configuration files (``SYSCONFDIR/xdg``)
#     [``CONFIG_INSTALL_DIR``]
# ``AUTOSTARTDIR``
#     autostart files (``CONFDIR/autostart``) [``AUTOSTART_INSTALL_DIR``]
#
# The ``CMAKE_INSTALL_<dir>`` variables (or their deprecated counterparts) may
# be passed to the DESTINATION options of ``install()`` commands for the
# corresponding file type.  They are set in the CMake cache, and so the
# defaults above can be overridden by users.
#
# Note that either the ``CMAKE_INSTALL_<dir>`` form of the variable or the
# deprecated form can be changed using CMake command line variable definitions;
# in either case, both forms of the variable will be affected. The effect of
# passing both forms on the command line is undefined.
#
# The variable ``INSTALL_TARGETS_DEFAULT_ARGS`` is also defined.  This should
# be used when libraries or user-executable applications are installed, in the
# following manner:
#
# .. code-block:: cmake
#
#   install(TARGETS mylib myapp ${INSTALL_TARGETS_DEFAULT_ARGS})
#
# It MUST NOT be used for installing plugins, system admin executables or
# executables only intended for use internally by other code.  Those should use
# ``CMAKE_INSTALL_PLUGINDIR``, ``CMAKE_INSTALL_SBINDIR`` or
# ``CMAKE_INSTALL_LIBEXECDIR`` respectively.

#=============================================================================
# Copyright 2014      Alex Merry <alex.merry@kde.org>
# Copyright 2013      Stephen Kelly <steveire@gmail.com>
# Copyright 2012      David Faure <faure@kde.org>
# Copyright 2007      Matthias Kretz <kretz@kde.org>
# Copyright 2006-2007 Laurent Montel <montel@kde.org>
# Copyright 2006-2013 Alex Neundorf <neundorf@kde.org>
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file COPYING-CMAKE-SCRIPTS for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# (To distribute this file outside of extra-cmake-modules, substitute the full
#  License text for the above reference.)

# Figure out what the default install directory for libraries should be.
# This is based on the logic in GNUInstallDirs, but simplified (the
# GNUInstallDirs code deals with re-configuring, but that is dealt with
# by the _define_* macros in this module).
set(_LIBDIR_DEFAULT "lib")
# Override this default 'lib' with 'lib64' iff:
#  - we are on a Linux, kFreeBSD or Hurd system but NOT cross-compiling
#  - we are NOT on debian
#  - we are on a 64 bits system
# reason is: amd64 ABI: http://www.x86-64.org/documentation/abi.pdf
# For Debian with multiarch, use 'lib/${CMAKE_LIBRARY_ARCHITECTURE}' if
# CMAKE_LIBRARY_ARCHITECTURE is set (which contains e.g. "i386-linux-gnu"
# See http://wiki.debian.org/Multiarch
if((CMAKE_SYSTEM_NAME MATCHES "Linux|kFreeBSD" OR CMAKE_SYSTEM_NAME STREQUAL "GNU")
   AND NOT CMAKE_CROSSCOMPILING)
  if (EXISTS "/etc/debian_version") # is this a debian system ?
    if(CMAKE_LIBRARY_ARCHITECTURE)
      set(_LIBDIR_DEFAULT "lib/${CMAKE_LIBRARY_ARCHITECTURE}")
    endif()
  else() # not debian, rely on CMAKE_SIZEOF_VOID_P:
    if(NOT DEFINED CMAKE_SIZEOF_VOID_P)
      message(AUTHOR_WARNING
        "Unable to determine default LIB_INSTALL_LIBDIR directory because no target architecture is known. "
        "Please enable at least one language before including KDEInstallDirs.")
    else()
      if("${CMAKE_SIZEOF_VOID_P}" EQUAL "8")
        set(_LIBDIR_DEFAULT "lib64")
      endif()
    endif()
  endif()
endif()

# Macro for variables that are relative to another variable. We store an empty
# value in the cache (for documentation/GUI cache editor purposes), and store
# the default value in a local variable. If the cache variable is ever set to
# something non-empty, the local variable will no longer be set. However, if
# the cache variable remains (or is set to be) empty, the value will be
# relative to that of the parent variable.
#
# varname:   the variable name suffix (eg: BINDIR for CMAKE_INSTALL_BINDIR)
# parent:    the variable suffix of the variable this is relative to
#            (eg: DATAROOTDIR for CMAKE_INSTALL_DATAROOTDIR)
# subdir:    the path of the default value of CMAKE_INSTALL_${varname}
#            relative to CMAKE_INSTALL_${parent}: no leading /
# docstring: documentation about the variable (not including the default value)
# oldstylename (optional): the old-style name of the variable
macro(_define_relative varname parent subdir docstring)
    set(_oldstylename)
    if(${ARGC} GREATER 4)
        set(_oldstylename "${ARGV4}")
    endif()

    # Surprisingly complex logic to deal with joining paths.
    # Note that we cannot use arg vars directly in if() because macro args are
    # not proper variables.
    set(_parent "${parent}")
    set(_subdir "${subdir}")
    if(_parent AND _subdir)
        set(_docpath "${_parent}/${_subdir}")
        if(CMAKE_INSTALL_${_parent})
            set(_realpath "${CMAKE_INSTALL_${_parent}}/${_subdir}")
        else()
            set(_realpath "${_subdir}")
        endif()
    elseif(_parent)
        set(_docpath "${_parent}")
        set(_realpath "${CMAKE_INSTALL_${_parent}}")
    else()
        set(_docpath "${_subdir}")
        set(_realpath "${_subdir}")
    endif()

    if(${_oldstylename})
        # The old name was given (probably on the command line): move
        # it to the new name
        set(CMAKE_INSTALL_${varname} "${${_oldstylename}}"
            CACHE PATH
                  "${docstring} (${_docpath})"
                  FORCE)
        unset(${_oldstylename} CACHE)
    elseif(NOT CMAKE_INSTALL_${varname})
        set(CMAKE_INSTALL_${varname} ""
            CACHE PATH "${docstring} (${_docpath})")
        set(CMAKE_INSTALL_${varname} "${_realpath}")
    else()
        get_property(_iscached CACHE CMAKE_INSTALL_${varname} PROPERTY VALUE SET)
        if (_iscached)
            # make sure the docs are still set if it was passed on the command line
            set_property(CACHE CMAKE_INSTALL_${varname}
                PROPERTY HELPSTRING "${docstring} (${_docpath})")
            # make sure the type is correct if it was passed on the command line
            set_property(CACHE CMAKE_INSTALL_${varname}
                PROPERTY TYPE PATH)
        endif()
    endif()

    if(_oldstylename)
        set(${_oldstylename} "${CMAKE_INSTALL_${varname}}")
    endif()

    mark_as_advanced(CMAKE_INSTALL_${varname})

    if(NOT IS_ABSOLUTE ${CMAKE_INSTALL_${varname}})
        set(CMAKE_INSTALL_FULL_${varname}
            "${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_${varname}}")
    else()
        set(CMAKE_INSTALL_FULL_${varname} "${CMAKE_INSTALL_${varname}}")
    endif()
endmacro()

# varname:   the variable name suffix (eg: BINDIR for CMAKE_INSTALL_BINDIR)
# dir:       the relative path of the default value of CMAKE_INSTALL_${varname}
#            relative to CMAKE_INSTALL_PREFIX: no leading /
# docstring: documentation about the variable (not including the default value)
# oldstylename (optional): the old-style name of the variable
macro(_define_absolute varname dir docstring)
    _define_relative("${varname}" "" "${dir}" "${docstring}" ${ARGN})
endmacro()

if(APPLE)
    _define_absolute(BUNDLEDIR "/Applications/KDE"
        "application bundles"
        BUNDLE_INSTALL_DIR)
endif(APPLE)



_define_absolute(EXECROOTDIR ""
    "executables and libraries"
    EXEC_INSTALL_PREFIX)

_define_relative(BINDIR EXECROOTDIR "bin"
    "user executables"
    BIN_INSTALL_DIR)
_define_relative(SBINDIR EXECROOTDIR "sbin"
    "system admin executables"
    SBIN_INSTALL_DIR)
_define_relative(LIBDIR EXECROOTDIR "${_LIBDIR_DEFAULT}"
    "object code libraries"
    LIB_INSTALL_DIR)

if(WIN32)
    _define_relative(LIBEXECDIR BINDIR ""
        "executables for internal use by programs and libraries"
        LIBEXEC_INSTALL_DIR)
    set(CMAKE_INSTALL_LIBEXECDIR_KF5 "${CMAKE_INSTALL_LIBEXECDIR}")
    set(CMAKE_INSTALL_FULL_LIBEXECDIR_KF5 "${CMAKE_INSTALL_FULL_LIBEXECDIR}")
else()
    _define_relative(LIBEXECDIR LIBDIR "libexec"
        "executables for internal use by programs and libraries"
        LIBEXEC_INSTALL_DIR)
    set(CMAKE_INSTALL_LIBEXECDIR_KF5 "${CMAKE_INSTALL_LIBEXECDIR}/kf5")
    set(CMAKE_INSTALL_FULL_LIBEXECDIR_KF5 "${CMAKE_INSTALL_FULL_LIBEXECDIR}/kf5")
endif()
set(KF5_LIBEXEC_INSTALL_DIR "${CMAKE_INSTALL_LIBEXECDIR_KF5}")
_define_relative(CMAKEPACKAGEDIR LIBDIR "cmake"
    "CMake packages, including config files"
    CMAKECONFIG_INSTALL_PREFIX)

option (KDE_INSTALL_USE_QT_SYS_PATHS "Install mkspecs files, Plugins and Imports to the Qt 5 install dir")
if(KDE_INSTALL_USE_QT_SYS_PATHS)
# Qt-specific vars
    include("${ECM_MODULE_DIR}/ECMQueryQmake.cmake")

    query_qmake(qt_plugins_dir QT_INSTALL_PLUGINS)

    _define_absolute(QTPLUGINDIR ${qt_plugins_dir}
        "Qt plugins"
         QT_PLUGIN_INSTALL_DIR)

    query_qmake(qt_imports_dir QT_INSTALL_IMPORTS)

    _define_absolute(QTQUICKIMPORTSDIR ${qt_imports_dir}
        "QtQuick1 imports"
        IMPORTS_INSTALL_DIR)

    query_qmake(qt_qml_dir QT_INSTALL_QML)

    _define_absolute(QMLDIR ${qt_qml_dir}
        "QtQuick2 imports"
        QML_INSTALL_DIR)
else()
    _define_relative(QTPLUGINDIR LIBDIR "plugins"
        "Qt plugins"
        QT_PLUGIN_INSTALL_DIR)

    _define_relative(QTQUICKIMPORTSDIR QTPLUGINDIR "imports"
        "QtQuick1 imports"
        IMPORTS_INSTALL_DIR)

    _define_relative(QMLDIR LIBDIR "qml"
        "QtQuick2 imports"
        QML_INSTALL_DIR)
endif()

_define_relative(PLUGINDIR QTPLUGINDIR ""
    "Plugins"
    PLUGIN_INSTALL_DIR)

_define_absolute(INCLUDEDIR "include"
    "C and C++ header files"
    INCLUDE_INSTALL_DIR)
set(CMAKE_INSTALL_INCLUDEDIR_KF5 "${CMAKE_INSTALL_INCLUDEDIR}/KF5")
set(CMAKE_INSTALL_FULL_INCLUDEDIR_KF5 "${CMAKE_INSTALL_FULL_INCLUDEDIR}/KF5")
set(KF5_INCLUDE_INSTALL_DIR "${CMAKE_INSTALL_INCLUDEDIR_KF5}")

_define_absolute(LOCALSTATEDIR "var"
    "modifiable single-machine data")

_define_absolute(SHAREDSTATEDIR "com"
    "modifiable architecture-independent data")




_define_absolute(DATAROOTDIR "share"
    "read-only architecture-independent data root"
    SHARE_INSTALL_PREFIX)

_define_relative(DATADIR DATAROOTDIR ""
    "read-only architecture-independent data"
    DATA_INSTALL_DIR)
set(CMAKE_INSTALL_DATADIR_KF5 "${CMAKE_INSTALL_DATADIR}/kf5")
set(CMAKE_INSTALL_FULL_DATADIR_KF5 "${CMAKE_INSTALL_FULL_DATADIR}/kf5")
set(KF5_DATA_INSTALL_DIR "${CMAKE_INSTALL_DATADIR_KF5}")

# KDE Framework-specific things
_define_relative(DOCBUNDLEDIR DATAROOTDIR "doc/HTML"
    "documentation bundles generated using kdoctools"
    HTML_INSTALL_DIR)
_define_relative(KCFGDIR DATAROOTDIR "config.kcfg"
    "kconfig description files"
    KCFG_INSTALL_DIR)
_define_relative(KCONFUPDATEDIR DATAROOTDIR "kconf_update"
    "kconf_update scripts"
    KCONF_UPDATE_INSTALL_DIR)
_define_relative(KSERVICES5DIR DATAROOTDIR "kservices5"
    "services for KDE Frameworks 5"
    SERVICES_INSTALL_DIR)
_define_relative(KSERVICETYPES5DIR DATAROOTDIR "kservicetypes5"
    "service types for KDE Frameworks 5"
    SERVICETYPES_INSTALL_DIR)
_define_relative(KNOTIFY5RCDIR DATAROOTDIR "knotifications5"
    "knotify description files"
    KNOTIFYRC_INSTALL_DIR)
_define_relative(KXMLGUI5DIR DATAROOTDIR "kxmlgui5"
    "kxmlgui .rc files"
    KXMLGUI_INSTALL_DIR)

# Cross-desktop or other system things
_define_relative(ICONDIR DATAROOTDIR "icons"
    "icons"
    ICON_INSTALL_DIR)
_define_relative(LOCALEDIR DATAROOTDIR "locale"
    "knotify description files"
    LOCALE_INSTALL_DIR)
_define_relative(SOUNDDIR DATAROOTDIR "sounds"
    "sound files"
    SOUND_INSTALL_DIR)
_define_relative(TEMPLATEDIR DATAROOTDIR "templates"
    "templates"
    TEMPLATES_INSTALL_DIR)
_define_relative(WALLPAPERDIR DATAROOTDIR "wallpapers"
    "desktop wallpaper images"
    WALLPAPER_INSTALL_DIR)
_define_relative(APPDIR DATAROOTDIR "applications"
    "application desktop files"
    XDG_APPS_INSTALL_DIR)
_define_relative(DESKTOPDIR DATAROOTDIR "desktop-directories"
    "desktop directories"
    XDG_DIRECTORY_INSTALL_DIR)
_define_relative(MIMEDIR DATAROOTDIR "mime/packages"
    "mime description files"
    XDG_MIME_INSTALL_DIR)
_define_relative(METAINFODIR DATAROOTDIR "appdata"
    "AppStream component metadata")
_define_relative(MANDIR DATAROOTDIR "man"
    "man documentation"
    MAN_INSTALL_DIR)
_define_relative(INFODIR DATAROOTDIR "info"
    "info documentation")
_define_relative(DBUSDIR DATAROOTDIR "dbus-1"
    "D-Bus")
_define_relative(DBUSINTERFACEDIR DBUSDIR "interfaces"
    "D-Bus interfaces"
    DBUS_INTERFACES_INSTALL_DIR)
_define_relative(DBUSSERVICEDIR DBUSDIR "services"
    "D-Bus session services"
    DBUS_SERVICES_INSTALL_DIR)
_define_relative(DBUSSYSTEMSERVICEDIR DBUSDIR "system-services"
    "D-Bus system services"
    DBUS_SYSTEM_SERVICES_INSTALL_DIR)




set(_default_sysconf_dir "etc")
if (CMAKE_INSTALL_PREFIX STREQUAL "/usr")
    set(_default_sysconf_dir "/etc")
endif()


_define_absolute(SYSCONFDIR "${_default_sysconf_dir}"
    "read-only single-machine data"
    SYSCONF_INSTALL_DIR)
_define_relative(CONFDIR SYSCONFDIR "xdg"
    "application configuration files"
    CONFIG_INSTALL_DIR)
_define_relative(AUTOSTARTDIR CONFDIR "autostart"
    "autostart files"
    AUTOSTART_INSTALL_DIR)



# For more documentation see above.
# Later on it will be possible to extend this for installing OSX frameworks
# The COMPONENT Devel argument has the effect that static libraries belong to the
# "Devel" install component. If we use this also for all install() commands
# for header files, it will be possible to install
#   -everything: make install OR cmake -P cmake_install.cmake
#   -only the development files: cmake -DCOMPONENT=Devel -P cmake_install.cmake
#   -everything except the development files: cmake -DCOMPONENT=Unspecified -P cmake_install.cmake
# This can then also be used for packaging with cpack.
# FIXME: why is INCLUDES (only) set for ARCHIVE targets?
set(INSTALL_TARGETS_DEFAULT_ARGS  RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}"
                                  LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}"
                                  ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}" COMPONENT Devel
                                  INCLUDES DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
)
set(KF5_INSTALL_TARGETS_DEFAULT_ARGS  RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}"
                                      LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}"
                                      ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}" COMPONENT Devel
                                      INCLUDES DESTINATION "${CMAKE_INSTALL_INCLUDEDIR_KF5}"
)


# on the Mac support an extra install directory for application bundles
if(APPLE)
  set(INSTALL_TARGETS_DEFAULT_ARGS  ${INSTALL_TARGETS_DEFAULT_ARGS}
                                    BUNDLE DESTINATION "${BUNDLE_INSTALL_DIR}" )
  set(KF5_INSTALL_TARGETS_DEFAULT_ARGS  ${KF5_INSTALL_TARGETS_DEFAULT_ARGS}
                                    BUNDLE DESTINATION "${BUNDLE_INSTALL_DIR}" )
endif(APPLE)

# new in cmake 2.8.9: this is used for all installed files which do not have a component set
# so set the default component name to the name of the project, if a project name has been set:
if(NOT "${PROJECT_NAME}" STREQUAL "Project")
  set(CMAKE_INSTALL_DEFAULT_COMPONENT_NAME "${PROJECT_NAME}")
endif()
