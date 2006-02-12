# - Try to find the Jasper JPEG2000 library
# Once done this will define
#
#  JASPER_FOUND - system has Jasper
#  JASPER_INCLUDE_DIR - the Jasper include directory
#  JASPER_LIBRARIES - The libraries needed to use Jasper

FIND_PATH(JASPER_INCLUDE_DIR jasper/jasper.h
   /usr/include
   /usr/local/include
)

FIND_LIBRARY(JASPER_LIBRARIES NAMES jasper libjasper
   PATHS
   /usr/lib
   /usr/local/lib
)


IF(JASPER_INCLUDE_DIR AND JASPER_LIBRARIES)
   SET(JASPER_FOUND TRUE)
ENDIF(JASPER_INCLUDE_DIR AND JASPER_LIBRARIES)


IF(JASPER_FOUND)
   IF(NOT Jasper_FIND_QUIETLY)
      MESSAGE(STATUS "Found jasper: ${JASPER_LIBRARIES}")
   ENDIF(NOT Jasper_FIND_QUIETLY)
ELSE(JASPER_FOUND)
   IF(Jasper_FIND_REQUIRED)
      MESSAGE(FATAL_ERROR "Could not find jasper library")
   ENDIF(Jasper_FIND_REQUIRED)
ENDIF(JASPER_FOUND)

MARK_AS_ADVANCED(JASPER_INCLUDE_DIR JASPER_LIBRARIES)
