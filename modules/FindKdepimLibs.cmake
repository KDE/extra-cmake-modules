# Find if we installed kdepimlibs before to compile it
# Once done this will define
#
#  KDEPIMLIBS_FOUND - system has KDE PIM Libraries
#  KDEPIMLIBS_INCLUDE_DIR - the KDE PIM Libraries include directory
# It also sets:
#   KDEPIMLIBS_AKONADI_LIBS
#   KDEPIMLIBS_AKONADI_KMIME_LIBS
#   KDEPIMLIBS_AKONADI_KABC_LIBS
#   KDEPIMLIBS_GPGMEPP_LIBS
#   KDEPIMLIBS_KABC_LIBS
#   KDEPIMLIBS_KBLOG_LIBS
#   KDEPIMLIBS_KCAL_LIBS
#   KDEPIMLIBS_KIMAP_LIBS
#   KDEPIMLIBS_KLDAP_LIBS
#   KDEPIMLIBS_KMIME_LIBS
#   KDEPIMLIBS_KPIMIDENTITIES_LIBS
#   KDEPIMLIBS_KPIMUTILS_LIBS
#   KDEPIMLIBS_KRESOURCES_LIBS
#   KDEPIMLIBS_KTNEF_LIBS
#   KDEPIMLIBS_KXMLRPCCLIENT_LIBS
#   KDEPIMLIBS_MAILTRANSPORT_LIBS
#   KDEPIMLIBS_QGPGME_LIBS
#   KDEPIMLIBS_SYNDICATION_LIBS

# Copyright (c) 2006, Laurent Montel, <montel@kde.org>
# Copyright (c) 2006, Ralf Habacker, <ralf.habacker@freenet.de>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

if (WIN32)
  if (KDEPIMLIBS_DIR)
      set (KDE4_INCLUDE_DIR ${KDE4_INCLUDE_DIR} ${KDEPIMLIBS_DIR}/include)
      set (KDE4_LIB_DIR ${KDE4_LIB_DIR}  ${KDEPIMLIBS_DIR}/lib)
  else (KDEPIMLIBS_DIR)
      file(TO_CMAKE_PATH "$ENV{PROGRAMFILES}" _progFiles)
      set (KDE4_INCLUDE_DIR ${KDE4_INCLUDE_DIR} ${_progFiles}/kdepimlibs/include)
      set (KDE4_LIB_DIR ${KDE4_LIB_DIR} ${_progFiles}/kdepimlibs/lib)
  endif (KDEPIMLIBS_DIR)
endif (WIN32)

find_path( KDEPIMLIBS_INCLUDE_DIR NAMES kcal/kcal_export.h 
  HINTS ${KDE4_INCLUDE_DIR}
)

macro(_KDEPIMLibs_Set_Lib_Vars _prefix _lib)
  # KDEPIMLIBS_TARGET_PREFIX exists since 03. Dec. and is empty before that, Alex
  set(KDEPIMLIBS_${_prefix}_LIBRARY ${KDEPIMLIBS_TARGET_PREFIX}${_lib})
  set(KDEPIMLIBS_${_prefix}_LIBS    ${KDEPIMLIBS_TARGET_PREFIX}${_lib})
  # these two are set for compatibility with KDE 4.[01], Alex:
  set(KDE4_${_prefix}_LIBRARY       ${KDEPIMLIBS_TARGET_PREFIX}${_lib})
  set(KDE4_${_prefix}_LIBS          ${KDEPIMLIBS_TARGET_PREFIX}${_lib})
endmacro(_KDEPIMLibs_Set_Lib_Vars)


if( KDEPIMLIBS_INCLUDE_DIR )
  set(KDEPIMLIBS_FOUND TRUE)

  get_filename_component( kdepimlibs_cmake_module_dir  "${KDEPIMLIBS_INCLUDE_DIR}" PATH)
  set(kdepimlibs_cmake_module_dir "${kdepimlibs_cmake_module_dir}/share/apps/cmake/modules")
  set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${kdepimlibs_cmake_module_dir}")

  # this file contains all dependencies of all libraries of kdepimlibs, Alex
  include("${kdepimlibs_cmake_module_dir}/KDEPimLibsInformation.cmake" OPTIONAL RESULT_VARIABLE _newKdepimLibsFound)
  # if this file could not be loaded, we found an older version of Kdepimlibs, tell the
  # developer that he should update kdepimlibs. Alex
  if (NOT _newKdepimLibsFound)
     message(FATAL_ERROR "You need a newer version of kdepimlibs, please update it")
  endif (NOT _newKdepimLibsFound)

  # this is for compatibility, starting next monday only the version with prefix will be installed, Alex
  include("${kdepimlibs_cmake_module_dir}/KDEPimLibsLibraryTargetsWithPrefix.cmake" OPTIONAL RESULT_VARIABLE KDEPimLibsLibraryTargetsWithPrefix_LOADED)
  if(NOT KDEPimLibsLibraryTargetsWithPrefix_LOADED)
     include("${kdepimlibs_cmake_module_dir}/KDEPimLibsLibraryTargets.cmake")
  endif(NOT KDEPimLibsLibraryTargetsWithPrefix_LOADED)

  _kdepimlibs_set_lib_vars( AKONADI        akonadi-kde)
  _kdepimlibs_set_lib_vars( AKONADI_KMIME  akonadi-kmime)
  _kdepimlibs_set_lib_vars( AKONADI_KABC   akonadi-kabc)
  _kdepimlibs_set_lib_vars( GPGMEPP        gpgmepp)
  _kdepimlibs_set_lib_vars( KABC           kabc)
  _kdepimlibs_set_lib_vars( KBLOG          kblog)
  _kdepimlibs_set_lib_vars( KCAL           kcal)
  _kdepimlibs_set_lib_vars( KIMAP          kimap)
  _kdepimlibs_set_lib_vars( KLDAP          kldap)
  _kdepimlibs_set_lib_vars( KMIME          kmime)
  _kdepimlibs_set_lib_vars( KPIMIDENTITIES kpimidentities)
  _kdepimlibs_set_lib_vars( KPIMUTILS      kpimutils)
  _kdepimlibs_set_lib_vars( KRESOURCES     kresources)
  _kdepimlibs_set_lib_vars( KTNEF          ktnef)
  _kdepimlibs_set_lib_vars( KXMLRPCCLIENT  kxmlrpcclient)
  _kdepimlibs_set_lib_vars( MAILTRANSPORT  mailtransport)
  _kdepimlibs_set_lib_vars( QGPGME         qgpgme)
  _kdepimlibs_set_lib_vars( SYNDICATION    syndication)

  # this is bad, so I commented it out. A module shouldn't modify variables
  # set by another module. Alex.
  # # setup global used KDE include
  # set (KDE4_INCLUDES ${KDE4_INCLUDES} ${KDEPIMLIBS_INCLUDE_DIR})

else( KDEPIMLIBS_INCLUDE_DIR )
  set(KDEPIMLIBS_FOUND FALSE)
endif( KDEPIMLIBS_INCLUDE_DIR )


if (KDEPIMLIBS_FOUND)
   if (NOT KdepimLibs_FIND_QUIETLY)
      message(STATUS "Found KDE PIM libraries")
   endif (NOT KdepimLibs_FIND_QUIETLY)
else (KDEPIMLIBS_FOUND)
   if (KdepimLibs_FIND_REQUIRED)
      message(FATAL_ERROR "Could NOT find a kdepimlibs installation in ${KDE4_INCLUDE_DIR}.\nPlease build and install kdepimlibs first.")
   endif (KdepimLibs_FIND_REQUIRED)
endif (KDEPIMLIBS_FOUND)

