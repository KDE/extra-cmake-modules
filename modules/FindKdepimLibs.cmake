# Find if we installed kdepimlibs before to compile it

#TODO: use kcal/kcal.h, but it doesn't exist yet
FIND_PATH( KDEPIMLIBS_INCLUDE_DIR emailfunctions/email.h 
  ${KDE4_INCLUDE_DIR}
)

if( NOT KDEPIMLIBS_INCLUDE_DIR )
  message(FATAL_ERROR "Could NOT find a kdepimlibs installation.\nPlease build and install kdepimlibs first.")
endif(NOT KDEPIMLIBS_INCLUDE_DIR )

set(KDE4_EMAILFUNCTIONS_LIBS emailfunctions)
set(KDE4_KCAL_LIBS kcal)
set(KDE4_KTNEF_LIBS ktnef)
