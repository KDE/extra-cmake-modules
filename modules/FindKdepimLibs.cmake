# Find if we installed kdepimlibs before to compile it
# Once done this will define
#
#  KDEPIMLIBS_FOUND - system has KDE PIM Libraries
#  KDEPIMLIBS_INCLUDE_DIR - the KDE PIM Libraries include directory


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

find_path( KDEPIMLIBS_INCLUDE_DIR kcal/kcal_export.h
  ${KDE4_INCLUDE_DIR}
)

if( KDEPIMLIBS_INCLUDE_DIR )
  set(KDEPIMLIBS_FOUND TRUE)

  # this file contains all dependencies of all libraries of kdepimlibs, Alex
  include(KDEPimLibsDependencies)

  find_library(KDE4_AKONADI_LIBRARY NAMES akonadi-kde PATHS ${KDE4_LIB_DIR} NO_DEFAULT_PATH )
  set(KDE4_AKONADI_LIBS ${akonadi_LIB_DEPENDS} ${KDE4_AKONADI_LIBRARY} )

  find_library(KDE4_AKONADI_KMIME_LIBRARY NAMES akonadi-kmime PATHS ${KDE4_LIB_DIR} NO_DEFAULT_PATH )
  set(KDE4_AKONADI_KMIME_LIBS ${akonadi_kmime_LIB_DEPENDS} ${KDE4_AKONADI_KMIME_LIBRARY} )

  find_library(KDE4_AKONADI_KABC_LIBRARY NAMES akonadi-kabc PATHS ${KDE4_LIB_DIR} NO_DEFAULT_PATH )
  set(KDE4_AKONADI_KABC_LIBS ${akonadi_kabc_LIB_DEPENDS} ${KDE4_AKONADI_KABC_LIBRARY} )

  find_library(KDE4_GPGMEPP_LIBRARY NAMES gpgme++ PATHS ${KDE4_LIB_DIR} NO_DEFAULT_PATH )
  set(KDE4_GPGMEPP_LIBS ${gpgmepp_LIB_DEPENDS} ${KDE4_GPGMEPP_LIBRARY} )

  find_library(KDE4_KABC_LIBRARY NAMES kabc PATHS ${KDE4_LIB_DIR} NO_DEFAULT_PATH )
  set(KDE4_KABC_LIBS ${kabc_LIB_DEPENDS} ${KDE4_KABC_LIBRARY} )

  find_library(KDE4_KBLOG_LIBRARY NAMES kblog PATHS ${KDE4_LIB_DIR} NO_DEFAULT_PATH )
  set(KDE4_KBLOG_LIBS ${kblog_LIB_DEPENDS} ${KDE4_KBLOG_LIBRARY} )

  find_library(KDE4_KCAL_LIBRARY NAMES kcal PATHS ${KDE4_LIB_DIR} NO_DEFAULT_PATH )
  set(KDE4_KCAL_LIBS ${kcal_LIB_DEPENDS} ${KDE4_KCAL_LIBRARY} )

  find_library(KDE4_KIMAP_LIBRARY NAMES kimap PATHS ${KDE4_LIB_DIR} NO_DEFAULT_PATH )
  set(KDE4_KIMAP_LIBS ${kimap_LIB_DEPENDS} ${KDE4_KIMAP_LIBRARY} )

  find_library(KDE4_KLDAP_LIBRARY NAMES kldap PATHS ${KDE4_LIB_DIR} NO_DEFAULT_PATH )
  set(KDE4_KLDAP_LIBS ${kldap_LIB_DEPENDS} ${KDE4_KLDAP_LIBRARY} )

  find_library(KDE4_KMIME_LIBRARY NAMES kmime PATHS ${KDE4_LIB_DIR} NO_DEFAULT_PATH )
  set(KDE4_KMIME_LIBS ${kmime_LIB_DEPENDS} ${KDE4_KMIME_LIBRARY} )

  find_library(KDE4_KPIMIDENTITIES_LIBRARY NAMES kpimidentities PATHS ${KDE4_LIB_DIR} NO_DEFAULT_PATH )
  set(KDE4_KPIMIDENTITIES_LIBS ${kpimidentities_LIB_DEPENDS} ${KDE4_KPIMIDENTITIES_LIBRARY} )

  find_library(KDE4_KPIMUTILS_LIBRARY NAMES kpimutils PATHS ${KDE4_LIB_DIR} NO_DEFAULT_PATH )
  set(KDE4_KPIMUTILS_LIBS ${kpimutils_LIB_DEPENDS} ${KDE4_KPIMUTILS_LIBRARY} )

  find_library(KDE4_KRESOURCES_LIBRARY NAMES kresources PATHS ${KDE4_LIB_DIR} NO_DEFAULT_PATH )
  set(KDE4_KRESOURCES_LIBS ${kresources_LIB_DEPENDS} ${KDE4_KRESOURCES_LIBRARY} )

  find_library(KDE4_KTNEF_LIBRARY NAMES ktnef PATHS ${KDE4_LIB_DIR} NO_DEFAULT_PATH )
  set(KDE4_KTNEF_LIBS ${ktnef_LIB_DEPENDS} ${KDE4_KTNEF_LIBRARY} )

  find_library(KDE4_KXMLRPCCLIENT_LIBRARY NAMES kxmlrpcclient PATHS ${KDE4_LIB_DIR} NO_DEFAULT_PATH )
  set(KDE4_KXMLRPCCLIENT_LIBS ${kxmlrpcclient_LIB_DEPENDS} ${KDE4_KXMLRPCCLIENT_LIBRARY} )

  find_library(KDE4_MAILTRANSPORT_LIBRARY NAMES mailtransport PATHS ${KDE4_LIB_DIR} NO_DEFAULT_PATH )
  set(KDE4_MAILTRANSPORT_LIBS ${mailtransport_LIB_DEPENDS} ${KDE4_MAILTRANSPORT_LIBRARY} )

  find_library(KDE4_QGPGME_LIBRARY NAMES qgpgme PATHS ${KDE4_LIB_DIR} NO_DEFAULT_PATH )
  set(KDE4_QGPGME_LIBS ${qgpgme_LIB_DEPENDS} ${KDE4_QGPGME_LIBRARY} )

  find_library(KDE4_SYNDICATION_LIBRARY NAMES syndication PATHS ${KDE4_LIB_DIR} NO_DEFAULT_PATH )
  set(KDE4_SYNDICATION_LIBS ${syndication_LIB_DEPENDS} ${KDE4_SYNDICATION_LIBRARY} )

  # setup global used KDE include
  set (KDE4_INCLUDES ${KDE4_INCLUDES} ${KDEPIMLIBS_INCLUDE_DIR})
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


