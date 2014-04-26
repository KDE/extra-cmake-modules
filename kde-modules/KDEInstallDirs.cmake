#.rst:
# KDEInstallDirs
# --------------
#
# Define KDE standard installation directories.
#
# Inclusion of this module defines the following variables (default values in
# parentheses):
#
# ``BUNDLE_INSTALL_DIR``
#     (Mac only) application bundles (``/Applications/KDE5``)
# ``BIN_INSTALL_DIR``
#     user executables (``bin``)
# ``SBIN_INSTALL_DIR``
#     system admin executables (``sbin``)
# ``LIB_INSTALL_DIR``
#     object code libraries (``lib or lib64 or lib/<multiarch-tuple> on
#     Debian``)
# ``LIBEXEC_INSTALL_DIR``
#     internal executables (``${LIB_INSTALL_DIR}/kde5/libexec``)
# ``INSTALL_TARGETS_DEFAULT_ARGS``
#     combines BUNDLE_INSTALL_DIR, BIN_INSTALL_DIR and LIB_INSTALL_DIR; see
#     below
# ``INCLUDE_INSTALL_DIR``
#     C and C++ header files (``include/KF5``)
# ``QT_PLUGIN_INSTALL_DIR``
#     Qt plugins (``${LIB_INSTALL_DIR}/plugins``)
# ``PLUGIN_INSTALL_DIR``
#     KDE plugins (``${QT_PLUGIN_INSTALL_DIR}/kf5``)
# ``IMPORTS_INSTALL_DIR``
#     QML imports (``${QT_PLUGIN_INSTALL_DIR}/imports``)
# ``QML_INSTALL_DIR``
#     QML2 imports (``${LIB_INSTALL_DIR}/qml``)
# ``CMAKECONFIG_INSTALL_PREFIX``
#     CMake configuration files (``${LIB_INSTALL_DIR}/cmake``)
# ``DATA_INSTALL_DIR``
#     read-only architecture-independent data (``share``)
# ``KCONF_UPDATE_INSTALL_DIR``
#     kconf_update files (``${DATA_INSTALL_DIR}/kconf_update``)
# ``DBUS_INTERFACES_INSTALL_DIR``
#     dbus interfaces (``share/dbus-1/interfaces``)
# ``DBUS_SERVICES_INSTALL_DIR``
#     dbus services (``share/dbus-1/services``)
# ``DBUS_SYSTEM_SERVICES_INSTALL_DIR``
#     dbus system services (``share/dbus-1/system-services``)
# ``HTML_INSTALL_DIR``
#     HTML documentation (``share/doc/HTML``)
# ``ICON_INSTALL_DIR``
#     the icons (``share/icons``)
# ``KCFG_INSTALL_DIR``
#     kconfig files (``share/config.kcfg``)
# ``LOCALE_INSTALL_DIR``
#     translations (``share/locale``)
# ``MAN_INSTALL_DIR``
#     man pages (``share/man``)
# ``SERVICES_INSTALL_DIR``
#     service (desktop, protocol, ...) files (``share/kde5/services``)
# ``SERVICETYPES_INSTALL_DIR``
#     service types desktop files (``share/kde5/servicetypes``)
# ``SOUND_INSTALL_DIR``
#     sound files (``share/sounds``)
# ``TEMPLATES_INSTALL_DIR``
#     templates (``share/templates``)
# ``WALLPAPER_INSTALL_DIR``
#     wallpapers (``share/wallpapers``)
# ``XDG_APPS_INSTALL_DIR``
#     application desktop files (``share/applications/kde5``)
# ``XDG_DIRECTORY_INSTALL_DIR``
#     XDG directory (``share/desktop-directories``)
# ``XDG_MIME_INSTALL_DIR``
#     mimetype XML files (``share/mime/packages``)
# ``SYSCONF_INSTALL_DIR``
#     sysconfig files (``etc``)
# ``CONFIG_INSTALL_DIR``
#     config files (``${SYSCONF_INSTALL_DIR}/xdg``)
# ``AUTOSTART_INSTALL_DIR``
#     autostart files (``${CONFIG_INSTALL_DIR}/autostart``)
# ``EXEC_INSTALL_PREFIX``
#     prefix for default values of BIN_INSTALL_DIR, SBIN_INSTALL_DIR and
#     LIB_INSTALL_DIR (``empty by default``)
# ``SHARE_INSTALL_PREFIX``
#     replaces "share" in the other variables if set
#
# The ``*_INSTALL_DIR`` variables may be passed to the DESTINATION options of
# install() commands for the corresponding file type.  They are set in the
# CMake cache, and so the defaults above can be overridden by users.
#
# Note that these variables do not provide any information about the location of
# already-installed KDE software.
#
# The INSTALL_TARGETS_DEFAULT_ARGS variable should be used when libraries or
# user-executable applications are installed, in the following manner:
#
# .. code-block:: cmake
#
#   install(TARGETS mylib myapp ${INSTALL_TARGETS_DEFAULT_ARGS})
#
# It MUST NOT be used for installing plugins, system admin executables or
# executables only intended for use internally by other code.  Those should use
# one of the PLUGIN variables, SBIN_INSTALL_DIR or LIBEXEC_INSTALL_DIR
# respectively.

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


# TODO:
# - Provide GNUInstallDirs-style names (CMAKE_INSTALL_*)
#   (NB: need to be able to set current names on command line still)
# - Make sure libdir logic is up-to-date
# - Perhaps include GNUInstallDirs, to keep current with libdir logic?
# - Try to figure out proper Qt-related dirs when installing to the same
#   prefix as Qt (look for qtpaths)

# Figure out what the default install directory for libraries should be.
# This is the same logic as in cmake's GNUInstallDirs.cmake.
set(_LIBDIR_DEFAULT "lib")
# Override this default 'lib' with 'lib64' iff:
#  - we are on Linux system but NOT cross-compiling
#  - we are NOT on debian
#  - we are on a 64 bits system
# reason is: amd64 ABI: http://www.x86-64.org/documentation/abi.pdf
# For Debian with multiarch, use 'lib/${CMAKE_LIBRARY_ARCHITECTURE}' if
# CMAKE_LIBRARY_ARCHITECTURE is set (which contains e.g. "i386-linux-gnu"
# See http://wiki.debian.org/Multiarch
if(CMAKE_SYSTEM_NAME MATCHES "Linux" AND NOT CMAKE_CROSSCOMPILING)
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


# This macro implements some very special logic how to deal with the cache.
# By default the various install locations inherit their value from their "parent" variable
# so if you set CMAKE_INSTALL_PREFIX, then EXEC_INSTALL_PREFIX, PLUGIN_INSTALL_DIR will
# calculate their value by appending subdirs to CMAKE_INSTALL_PREFIX .
# This would work completely without using the cache.
# But if somebody wants e.g. a different EXEC_INSTALL_PREFIX this value has to go into
# the cache, otherwise it will be forgotten on the next cmake run.
# Once a variable is in the cache, it doesn't depend on its "parent" variables
# anymore and you can only change it by editing it directly.
# this macro helps in this regard, because as long as you don't set one of the
# variables explicitely to some location, it will always calculate its value from its
# parents. So modifying CMAKE_INSTALL_PREFIX later on will have the desired effect.
# But once you decide to set e.g. EXEC_INSTALL_PREFIX to some special location
# this will go into the cache and it will no longer depend on CMAKE_INSTALL_PREFIX.
#
# additionally if installing to the same location as kdelibs, the other install
# directories are reused from the installed kdelibs
macro(_SET_FANCY _var _value _comment)
  if (NOT DEFINED ${_var})
      set(${_var} ${_value})
  else()
      set(${_var} "${${_var}}" CACHE STRING "${_comment}")
  endif()
endmacro(_SET_FANCY)


if(APPLE)
  set(BUNDLE_INSTALL_DIR             "/Applications/KDE5" CACHE PATH               "Directory where application bundles will be installed to on OSX" )
endif(APPLE)

_set_fancy(EXEC_INSTALL_PREFIX       ""                                            "Base directory for executables and libraries")
_set_fancy(SHARE_INSTALL_PREFIX      "share"                                       "Base directory for files which go to share/")

_set_fancy(BIN_INSTALL_DIR           "${EXEC_INSTALL_PREFIX}bin"                   "The install dir for executables (default ${EXEC_INSTALL_PREFIX}/bin)")
_set_fancy(SBIN_INSTALL_DIR          "${EXEC_INSTALL_PREFIX}sbin"                  "The install dir for system executables (default ${EXEC_INSTALL_PREFIX}/sbin)")
_set_fancy(LIB_INSTALL_DIR           "${EXEC_INSTALL_PREFIX}${_LIBDIR_DEFAULT}"    "The subdirectory relative to the install prefix where libraries will be installed (default is ${EXEC_INSTALL_PREFIX}/lib[64], Debian multiarch is taken into account)")
if(WIN32)
  _set_fancy(LIBEXEC_INSTALL_DIR     "${BIN_INSTALL_DIR}"                          "The install dir for libexec executables (default is ${BIN_INSTALL_DIR} on Windows)")
else()
  _set_fancy(LIBEXEC_INSTALL_DIR     "${LIB_INSTALL_DIR}/kde5/libexec"             "The install dir for libexec executables (default is ${LIB_INSTALL_DIR}/kde5/libexec)")
endif()
_set_fancy(INCLUDE_INSTALL_DIR       "include"                                     "The install dir for header files")
# this exists as a convenience for frameworks
set(KF5_INCLUDE_INSTALL_DIR          "${INCLUDE_INSTALL_DIR}/KF5")

_set_fancy(QT_PLUGIN_INSTALL_DIR     "${LIB_INSTALL_DIR}/plugins"                  "The install dir where Qt plugins will be installed (default is ${LIB_INSTALL_DIR}/plugins)")
_set_fancy(PLUGIN_INSTALL_DIR        "${QT_PLUGIN_INSTALL_DIR}/kf5"                "The install dir where plugins (loaded via KPluginLoader) will be installed (default is ${LIB_INSTALL_DIR}/plugins/kf5)")
_set_fancy(IMPORTS_INSTALL_DIR       "${QT_PLUGIN_INSTALL_DIR}/imports"            "The install dir where QtQuick1 imports will be installed")
_set_fancy(QML_INSTALL_DIR           "${LIB_INSTALL_DIR}/qml"                      "The install dir where QtQuick2 imports will be installed")
_set_fancy(CMAKECONFIG_INSTALL_PREFIX "${LIB_INSTALL_DIR}/cmake"                   "The prefix under which packages will create their own subdirectory for their CMake configuration files")
_set_fancy(DATA_INSTALL_DIR          "${SHARE_INSTALL_PREFIX}"                     "The parent directory where applications can install their data")
_set_fancy(KF5_DATA_INSTALL_DIR      "${DATA_INSTALL_DIR}/kf5"                     "The parent directory where frameworks can install their data")
_set_fancy(HTML_INSTALL_DIR          "${SHARE_INSTALL_PREFIX}/doc/HTML"            "The HTML install dir for documentation")
_set_fancy(ICON_INSTALL_DIR          "${SHARE_INSTALL_PREFIX}/icons"               "The icon install dir (default ${SHARE_INSTALL_PREFIX}/share/icons/)")
_set_fancy(KCFG_INSTALL_DIR          "${SHARE_INSTALL_PREFIX}/config.kcfg"         "The install dir for kconfig files")
_set_fancy(LOCALE_INSTALL_DIR        "${SHARE_INSTALL_PREFIX}/locale"              "The install dir for translations")
_set_fancy(SERVICES_INSTALL_DIR      "${SHARE_INSTALL_PREFIX}/kde5/services"       "The install dir for service (desktop, protocol, ...) files")
_set_fancy(SERVICETYPES_INSTALL_DIR  "${SHARE_INSTALL_PREFIX}/kde5/servicetypes"   "The install dir for servicestypes desktop files")
_set_fancy(SOUND_INSTALL_DIR         "${SHARE_INSTALL_PREFIX}/sounds"              "The install dir for sound files")
_set_fancy(TEMPLATES_INSTALL_DIR     "${SHARE_INSTALL_PREFIX}/templates"           "The install dir for templates (Create new file...)")
_set_fancy(WALLPAPER_INSTALL_DIR     "${SHARE_INSTALL_PREFIX}/wallpapers"          "The install dir for wallpapers")
_set_fancy(KCONF_UPDATE_INSTALL_DIR  "${DATA_INSTALL_DIR}/kconf_update"            "The kconf_update install dir")

_set_fancy(XDG_APPS_INSTALL_DIR      "${SHARE_INSTALL_PREFIX}/applications"        "The XDG apps dir")
_set_fancy(XDG_DIRECTORY_INSTALL_DIR "${SHARE_INSTALL_PREFIX}/desktop-directories" "The XDG directory")
_set_fancy(XDG_MIME_INSTALL_DIR      "${SHARE_INSTALL_PREFIX}/mime/packages"       "The install dir for the xdg mimetypes")

_set_fancy(SYSCONF_INSTALL_DIR       "etc"                                         "The sysconfig install dir (default etc)")
_set_fancy(CONFIG_INSTALL_DIR        "${SYSCONF_INSTALL_DIR}/xdg"                  "The config file install dir")
_set_fancy(AUTOSTART_INSTALL_DIR     "${CONFIG_INSTALL_DIR}/autostart"             "The install dir for autostart files")
_set_fancy(MAN_INSTALL_DIR           "${SHARE_INSTALL_PREFIX}/man"                 "The man install dir (default ${SHARE_INSTALL_PREFIX}/man)")

_set_fancy(DBUS_INTERFACES_INSTALL_DIR      "${SHARE_INSTALL_PREFIX}/dbus-1/interfaces"      "The dbus interfaces install dir (default  ${SHARE_INSTALL_PREFIX}/dbus-1/interfaces)")
_set_fancy(DBUS_SERVICES_INSTALL_DIR        "${SHARE_INSTALL_PREFIX}/dbus-1/services"        "The dbus services install dir (default  ${SHARE_INSTALL_PREFIX}/dbus-1/services)")
_set_fancy(DBUS_SYSTEM_SERVICES_INSTALL_DIR "${SHARE_INSTALL_PREFIX}/dbus-1/system-services" "The dbus system services install dir (default  ${SHARE_INSTALL_PREFIX}/dbus-1/system-services)")



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
set(INSTALL_TARGETS_DEFAULT_ARGS  RUNTIME DESTINATION "${BIN_INSTALL_DIR}"
                                  LIBRARY DESTINATION "${LIB_INSTALL_DIR}"
                                  ARCHIVE DESTINATION "${LIB_INSTALL_DIR}" COMPONENT Devel
                                  INCLUDES DESTINATION "${INCLUDE_INSTALL_DIR}"
)
set(KF5_INSTALL_TARGETS_DEFAULT_ARGS  RUNTIME DESTINATION "${BIN_INSTALL_DIR}"
                                      LIBRARY DESTINATION "${LIB_INSTALL_DIR}"
                                      ARCHIVE DESTINATION "${LIB_INSTALL_DIR}" COMPONENT Devel
                                      INCLUDES DESTINATION "${KF5_INCLUDE_INSTALL_DIR}"
)


# on the Mac support an extra install directory for application bundles
if(APPLE)
  set(INSTALL_TARGETS_DEFAULT_ARGS  ${INSTALL_TARGETS_DEFAULT_ARGS}
                                    BUNDLE DESTINATION "${BUNDLE_INSTALL_DIR}" )
endif(APPLE)

# new in cmake 2.8.9: this is used for all installed files which do not have a component set
# so set the default component name to the name of the project, if a project name has been set:
if(NOT "${PROJECT_NAME}" STREQUAL "Project")
  set(CMAKE_INSTALL_DEFAULT_COMPONENT_NAME "${PROJECT_NAME}")
endif()
