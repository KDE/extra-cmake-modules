# Find if we installed kdepimlibs before to compile it
# Once done this will define
#
#  KDEPIMLIBS_FOUND - system has KDE PIM Libraries
#  KDEPIMLIBS_INCLUDE_DIR - the KDE PIM Libraries include directory


# Copyright (c) 2006, Laurent Montel, <montel@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.


find_path( KDEPIMLIBS_INCLUDE_DIR kcal/kcal.h
  ${KDE4_INCLUDE_DIR}
)

if( KDEPIMLIBS_INCLUDE_DIR )
  set(KDEPIMLIBS_FOUND TRUE)
  set(KDE4_EMAILFUNCTIONS_LIBS emailfunctions)
  set(KDE4_KABC_LIBS kabc)

  set(KDE4_KCAL_LIBS kcal)
  set(KDE4_KTNEF_LIBS ktnef)
  set(KDE4_KRESOURCES_LIBS kresources)
  set(KDE4_SYNDICATION_LIBS syndication)
  set(KDE4_KLDAP_LIBS kldap)
  set(KDE4_KMIME_LIBS kmime)
else( KDEPIMLIBS_INCLUDE_DIR )
  set(KDEPIMLIBS_FOUND FALSE)  
  message(FATAL_ERROR "Could NOT find a kdepimlibs installation.\nPlease build and install kdepimlibs first.")
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


