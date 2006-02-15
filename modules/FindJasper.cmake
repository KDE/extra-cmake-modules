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

FIND_LIBRARY(JASPER_LIBRARY NAMES jasper libjasper
   PATHS
   /usr/lib
   /usr/local/lib
)

FIND_PACKAGE(JPEG)

if(JASPER_INCLUDE_DIR AND JASPER_LIBRARIES AND JPEG_LIBRARIES)
   set(JASPER_FOUND TRUE)
   set(JASPER_LIBRARIES ${JASPER_LIBRARY} ${JPEG_LIBRARIES} )
endif(JASPER_INCLUDE_DIR AND JASPER_LIBRARIES AND JPEG_LIBRARIES)


if(JASPER_FOUND)
   if(not Jasper_FIND_QUIETLY)
      message(STATUS "Found jasper: ${JASPER_LIBRARIES}")
   endif(not Jasper_FIND_QUIETLY)
else(JASPER_FOUND)
   if(Jasper_FIND_REQUIRED)
      message(FATAL_ERROR "Could not find jasper library")
   endif(Jasper_FIND_REQUIRED)
endif(JASPER_FOUND)

MARK_AS_ADVANCED(JASPER_INCLUDE_DIR JASPER_LIBRARIES)
