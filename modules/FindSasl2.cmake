# - Try to find the sasl2 directory library
# Once done this will define
#
#  SASL2_FOUND - system has SASL2
#  SASL2_INCLUDE_DIR - the SASL2 include directory
#  SASL2_LIBRARIES - The libraries needed to use SASL2

FIND_PATH(SASL2_INCLUDE_DIR sasl/sasl.h
   /usr/include
   /usr/local/include
)

FIND_LIBRARY(SASL2_LIBRARIES NAMES sasl2
   PATHS
   /usr/lib
   /usr/local/lib
)


if(SASL2_INCLUDE_DIR AND SASL2_LIBRARIES)
   set(SASL2_FOUND TRUE)
endif(SASL2_INCLUDE_DIR AND SASL2_LIBRARIES)


if(SASL2_FOUND)
   if(NOT SASL2_FIND_QUIETLY)
      message(STATUS "Found sasl2: ${SASL2_LIBRARIES}")
   endif(NOT SASL2_FIND_QUIETLY)
endif(SASL2_FOUND)

MARK_AS_ADVANCED(SASL2_INCLUDE_DIR SASL2_LIBRARIES)

