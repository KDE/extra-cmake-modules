# Finds KDE frameworks 5 and its components, like e.g. KArchive
#
# KF5_INCLUDE_DIRS - the include dirs of all requested components
# KF5_<comp>_LIBRARIES - the libraries to link against of all requested components
# KF5_<comp>_FOUND - signals whether the requested component <comp> has been found
#
# Known "pseudo" components, these do not actually search any libraries, but offer other features.
#   Compiler  -  When specified, KDE-recommended compiler flags etc. are applied. See KDECompilerSettings.cmake.
#   CMake - When specified, KDE-recommended CMake settings are applied. See KDECMakeSettings.cmake.
#   InstallDirs - When specified, the set of install variables is loaded. See KDEInstallDirs.cmake.
#
# The following components do not have dependencies to any other components:
#   ItemModels
#   KArchive
#   KCodecs
#   KCoreAddons
#   KDBusAddons
#   KIdleTime
#   kjs
#   KPlotting
#   KWidgetsAddons
#   KWindowSystem
#   Solid
#   Sonnet
#   ThreadWeaver
#
# The following components have dependencies to some of the components above:
#   KAuth
#   KConfig
#
# When searching for multiple components, the first real component is searched as usual
# using CMAKE_PREFIX_PATH and additionally in the environment variables KF5_DIRS.
# All following components are searched only in the same prefix as the first one, and in those
# contained in KF5_DIRS. This is to ensure that a matching set of KF5 libraries is found.

# Copyright (c) 2013, Alexander Neundorf, <neundorf@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

# hmm, any better ideas ?
set(KF5_VERSION_STRING "5.0.0")

# we probably only want to search known components, so people don't start
# misusing this file for searching their own libraries.

set(knownComponentsTier1  ItemModels
                          ItemViews
                          KArchive
                          KCodecs
                          KConfig
                          KCoreAddons
                          KDBusAddons
                          KGuiAddons
                          KIdleTime
                          KJS
                          KPlotting
                          KTextWidgets
                          KWidgetsAddons
                          KWindowSystem
                          Solid
                          Sonnet
                          ThreadWeaver)

set(knownComponentsTier2  KAuth
                          KCrash
                          KNotifications
                          KI18n)

set(knownComponentsTier3  KUnitConversion
                          KConfigWidgets
                          KDESu
                          XmlGui
                          KParts
                          KIconThemes
                          KPrintUtils
                          KTextWidgets
                          KPty
                          KDeclarative)

set(knownComponentsTier4 KCMUtils)

set(knownComponentsStaging
   KDE4Attic
   KIO
   KBookmarks
   KCompletion
   KJobWidgets
   KService
   KWallet
   KStyle
   KNotifyConfig
   Kross
)

set(allKnownComponents Compiler CMake InstallDirs ${knownComponentsTier1} ${knownComponentsTier2} ${knownComponentsTier3} ${knownComponentsTier4} ${knownComponentsStaging})

set(cmakeCompRequested FALSE)
set(compilerCompRequested FALSE)
set(installDirsCompRequested FALSE)

unset(unknownComponents)

set(firstComponent )
set(followingComponents )

# iterate through the list of requested components, and check that we know them all.
# If not, fail.
foreach(comp ${KF5_FIND_COMPONENTS})
   list(FIND allKnownComponents ${comp} index )
   if("${index}" STREQUAL "-1")
      list(APPEND unknownComponents "${comp}")
   else()
      if("${comp}" STREQUAL "CMake")
         set(cmakeCompRequested TRUE)
      elseif("${comp}" STREQUAL "Compiler")
         set(compilerCompRequested TRUE)
      elseif("${comp}" STREQUAL "InstallDirs")
         set(installDirsCompRequested TRUE)
      else()
         if(NOT firstComponent)
            set(firstComponent "${comp}")
         else()
            list(APPEND followingComponents "${comp}")
         endif()
      endif()
   endif()
endforeach()


if(DEFINED unknownComponents)
   set(msgType STATUS)
   if(KF5_FIND_REQUIRED)
      set(msgType FATAL_ERROR)
   endif()
   message(${msgType} "KF5: requested unknown components ${unknownComponents}")
   return()
endif()

get_filename_component(_kf5KdeModuleDir "${CMAKE_CURRENT_LIST_DIR}/../kde-modules" REALPATH)

if(installDirsCompRequested)
   include("${_kf5KdeModuleDir}/KDEInstallDirs.cmake")
   if(NOT KF5_FIND_QUIETLY)
      message(STATUS "KF5[InstallDirs]: Loaded settings from ${_kf5KdeModuleDir}/KDEInstallDirs.cmake")
   endif()
   set(KF5_InstallDirs_FOUND TRUE)
endif()

if(cmakeCompRequested)
   include("${_kf5KdeModuleDir}/KDECMakeSettings.cmake")
   if(NOT KF5_FIND_QUIETLY)
      message(STATUS "KF5[CMake]: Loaded settings from ${_kf5KdeModuleDir}/KDECMakeSettings.cmake")
   endif()
   set(KF5_CMake_FOUND TRUE)
endif()

if(compilerCompRequested)
   include("${_kf5KdeModuleDir}/KDECompilerSettings.cmake")
   if(NOT KF5_FIND_QUIETLY)
      message(STATUS "KF5[Compiler]: Loaded settings from ${_kf5KdeModuleDir}/KDECompilerSettings.cmake")
   endif()
   set(KF5_Compiler_FOUND TRUE)
endif()

unset(KF5_INCLUDE_DIRS)
unset(KF5_LIBRARIES)


macro(_KF5_HANDLE_COMPONENT _comp)
   set(KF5_${_comp}_FOUND TRUE)
   if(NOT KF5_FIND_QUIETLY)
      message(STATUS "KF5[${_comp}]: Loaded ${${_comp}_CONFIG}")
   endif()
   set(KF5_INCLUDE_DIRS ${KF5_INCLUDE_DIRS} ${${_comp}_INCLUDE_DIRS} )
   set(KF5_LIBRARIES ${KF5_LIBRARIES} ${${_comp}_LIBRARIES} )
endmacro()


if(firstComponent)
   file(TO_CMAKE_PATH "$ENV{KF5_DIRS}" _KDEDIRS)

   set(_CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} )
   set(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} ${_KDEDIRS} )

   find_package(${firstComponent}  ${KF5_FIND_VERSION} CONFIG )

   set(KF5_File "${${firstComponent}_CONFIG}}")

   if(${firstComponent}_CONFIG)
      _kf5_handle_component(${firstComponent})
   endif()

   # search for the other components first in the same directory where the first one
   # has been found, and additionally in KDEDIRS. This is to make sure we don't
   # get a random mix of installed KDE libraries.
  get_filename_component(packages_dir "${${firstComponent}_DIR}/.." ABSOLUTE)

   foreach(comp ${followingComponents})
      find_package(${comp} ${KF5_FIND_VERSION} CONFIG
        PATHS "${packages_dir}"
        NO_DEFAULT_PATH
      )
      if(${comp}_CONFIG)
         _kf5_handle_component(${comp})
      endif()
   endforeach()

   set(CMAKE_PREFIX_PATH ${_CMAKE_PREFIX_PATH} )
else()
   set(KF5_File "${CMAKE_CURRENT_LIST_FILE}")
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(KF5
                                  REQUIRED_VARS KF5_File
                                  VERSION_VAR KF5_VERSION_STRING
                                  HANDLE_COMPONENTS
                                  )
