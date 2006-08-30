# Find if we installed kdepimlibs before to compile it

FIND_PATH( KDEPIMLIBS_INCLUDE_DIR kcal/kcal.h
  ${KDE4_INCLUDE_DIR}
)

if( NOT KDEPIMLIBS_INCLUDE_DIR )
  message(FATAL_ERROR "Could NOT find a kdepimlibs installation.\nPlease build and install kdepimlibs first.")
endif(NOT KDEPIMLIBS_INCLUDE_DIR )

set(KDE4_EMAILFUNCTIONS_LIBS emailfunctions)
set(KDE4_KABC_LIBS kabc)
set(KDE4_KCAL_LIBS kcal)
set(KDE4_KTNEF_LIBS ktnef)
set(KDE4_KRESOURCES_LIBS kresources)
set(KDE4_SYNDICATION_LIBS syndication)
set(KDE4_KLDAP_LIBS kldap)
