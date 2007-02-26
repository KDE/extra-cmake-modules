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
  file(TO_CMAKE_PATH "$ENV{PROGRAMFILES}" _progFiles)
  set (KDE4_INCLUDE_DIR ${KDE4_INCLUDE_DIR} ${_progFiles}/kdepimlibs/include)
  set (KDE4_LIB_DIR ${KDE4_LIB_DIR} ${_progFiles}/kdepimlibs/lib)
endif (WIN32)

find_path( KDEPIMLIBS_INCLUDE_DIR kcal/kcal.h
  ${KDE4_INCLUDE_DIR}
)

if( KDEPIMLIBS_INCLUDE_DIR )
  set(KDEPIMLIBS_FOUND TRUE)
  if (WIN32)
    find_library(KDE4_KABC_LIBRARY NAMES kabc PATHS ${KDE4_LIB_DIR} NO_DEFAULT_PATH )
    set(KDE4_KABC_LIBS ${kabc_LIB_DEPENDS} ${KDE4_KABC_LIBRARY} )

    find_library(KDE4_EMAILFUNCTIONS_LIBRARY NAMES emailfunctions PATHS ${KDE4_LIB_DIR} NO_DEFAULT_PATH )
    set(KDE4_EMAILFUNCTIONS_LIBS ${emailfunctions_LIB_DEPENDS} ${KDE4_EMAILFUNCTIONS_LIBRARY} )

    find_library(KDE4_KCAL_LIBRARY NAMES kcal PATHS ${KDE4_LIB_DIR} NO_DEFAULT_PATH )
    set(KDE4_KCAL_LIBS ${kcal_LIB_DEPENDS} ${KDE4_KCAL_LIBRARY} )

    find_library(KDE4_KTNEF_LIBRARY NAMES ktnef PATHS ${KDE4_LIB_DIR} NO_DEFAULT_PATH )
    set(KDE4_KTNEF_LIBS ${ktnef_LIB_DEPENDS} ${KDE4_KTNEF_LIBRARY} )

    find_library(KDE4_KRESOURCES_LIBRARY NAMES kresources PATHS ${KDE4_LIB_DIR} NO_DEFAULT_PATH )
    set(KDE4_KRESOURCES_LIBS ${kresources_LIB_DEPENDS} ${KDE4_KRESOURCES_LIBRARY} )

    find_library(KDE4_SYNDICATION_LIBRARY NAMES syndication PATHS ${KDE4_LIB_DIR} NO_DEFAULT_PATH )
    set(KDE4_SYNDICATION_LIBS ${syndication_LIB_DEPENDS} ${KDE4_SYNDICATION_LIBRARY} )

    find_library(KDE4_KLDAP_LIBRARY NAMES kldap PATHS ${KDE4_LIB_DIR} NO_DEFAULT_PATH )
    set(KDE4_KLDAP_LIBS ${kldap_LIB_DEPENDS} ${KDE4_KLDAP_LIBRARY} )

    find_library(KDE4_KMIME_LIBRARY NAMES kmime PATHS ${KDE4_LIB_DIR} NO_DEFAULT_PATH )
    set(KDE4_KMIME_LIBS ${kmime_LIB_DEPENDS} ${KDE4_KMIME_LIBRARY} )

  else (WIN32)
    set(KDE4_EMAILFUNCTIONS_LIBS emailfunctions)
    set(KDE4_KABC_LIBS kabc)
    set(KDE4_KCAL_LIBS kcal)
    set(KDE4_KTNEF_LIBS ktnef)
    set(KDE4_KRESOURCES_LIBS kresources)
    set(KDE4_SYNDICATION_LIBS syndication)
    set(KDE4_KLDAP_LIBS kldap)
    set(KDE4_KMIME_LIBS kmime)
  endif(WIN32)

  # setup global used KDE include
  set (KDE4_INCLUDES ${KDE4_INCLUDES} ${KDEPIMLIBS_INCLUDE_DIR})
else( KDEPIMLIBS_INCLUDE_DIR )
  set(KDEPIMLIBS_FOUND FALSE)
  message(FATAL_ERROR "Could NOT find a kdepimlibs installation in ${KDE4_INCLUDE_DIR}.\nPlease build and install kdepimlibs first.")
endif( KDEPIMLIBS_INCLUDE_DIR )

if (KDEPIMLIBS_FOUND)
   if (NOT KdepimLibs_FIND_QUIETLY)
      message(STATUS "Found KDE PIM libraries")
   endif (NOT KdepimLibs_FIND_QUIETLY)
else (KDEPIMLIBS_FOUND)
   if (KdepimLibs_FIND_REQUIRED)
      message(FATAL_ERROR "Could not find KDE PIM libraries")
   endif (KdepimLibs_FIND_REQUIRED)
endif (KDEPIMLIBS_FOUND)


