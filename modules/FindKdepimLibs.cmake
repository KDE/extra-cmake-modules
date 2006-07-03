# Find if we installed kdepimlibs before to compile it

FIND_PATH( KDEPIMLIBS_INCLUDE_DIR emailfunctions/email.h 
  ${KDE4_INCLUDE_DIR}
)

if( NOT KDEPIMLIBS_INCLUDE_DIR )
	message( FATAL_ERROR "You didn't compile kdepimlibs before to compile it. Please install it" )
endif(NOT KDEPIMLIBS_INCLUDE_DIR )
