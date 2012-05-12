# hmm, any better ideas ?
set(KF5_VERSION_STRING "5.0.0")

# we probably only want to search known components, so people don't start
# misusing this file for searching their own libraries.

set(knownComponentsTier1  itemmodels
                          kcoreaddons
                          kdbusaddons
                          kplotting
                          kwindowsystem
                          solid
                          threadweaver)

set(knownComponentsTier2  kauth )

set(knownComponentsTier3   )

set(allKnownComponents Compiler CMake InstallDirs ${knownComponentsTier1} ${knownComponentsTier2} ${knownComponentsTier3} )

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


if(installDirsCompRequested)
   include(${CMAKE_CURRENT_LIST_DIR}/../kde-modules/KDEInstallDirs.cmake)
   set(KF5_InstallDirs_FOUND TRUE)
endif()

if(cmakeCompRequested)
   include(${CMAKE_CURRENT_LIST_DIR}/../kde-modules/KDECMakeSettings.cmake)
   set(KF5_CMake_FOUND TRUE)
endif()

if(compilerCompRequested)
   include(${CMAKE_CURRENT_LIST_DIR}/../kde-modules/KDECompilerSettings.cmake)
   set(KF5_Compiler_FOUND TRUE)
endif()


if(firstComponent)
   file(TO_CMAKE_PATH "$ENV{KDEDIRS}" _KDEDIRS)

   set(_CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} )
   set(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} ${_KDEDIRS} )

   find_package(${firstComponent}  ${KF5_FIND_VERSION} CONFIG )

   set(KF5_File "${firstComponent_CONFIG}")

   if(NOT DEFINED ${firstComponent}_INSTALL_PREFIX)
      message(STATUS "${firstComponent} does not set ${firstComponent}_INSTALL_PREFIX !")
   endif()

   # search for the other components first in the same directory where the first one
   # has been found, and additionally in KDEDIRS. This is to make sure we don't
   # get a random mix of installed KDE libraries.
   set(CMAKE_PREFIX_PATH ${${firstComponent}_INSTALL_PREFIX} ${_KDEDIRS})

   foreach(comp ${followingComponents})
      find_package(${comp} ${KF5_FIND_VERSION} CONFIG
                   NO_CMAKE_ENVIRONMENT_PATH
                   NO_SYSTEM_ENVIRONMENT_PATH
                   NO_CMAKE_BUILDS_PATH
                   NO_CMAKE_PACKAGE_REGISTRY
                   NO_CMAKE_SYSTEM_PATH
                   NO_CMAKE_SYSTEM_PACKAGE_REGISTRY
                 )
      message(STATUS "${comp}: ${${comp}_CONFIG}")
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
