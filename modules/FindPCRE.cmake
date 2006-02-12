# - Try to find the PCRE regular expression library
# Once done this will define
#
#  PCRE_FOUND - system has the PCRE library
#  PCRE_INCLUDE_DIR - the PCRE include directory
#  PCRE_LIBRARIES - The libraries needed to use PCRE
# under Windows this also checks in the GNUWIN32 directory, so make
# sure that the GNUWIN32 directory gets found if you use the GNUWIN32 version of PCRE
#


# under windows, try to find the base gnuwin32 directory, do nothing under UNIX
FIND_PACKAGE(GNUWIN32)

FIND_PATH(PCRE_INCLUDE_DIR pcre.h
   /usr/include/
   /usr/local/include/
   ${GNUWIN32_DIR}/include
)

FIND_LIBRARY(PCRE_PCRE_LIBRARY NAMES pcre
   PATHS
   /usr/lib
   /usr/local/lib
   ${GNUWIN32_DIR}/lib
)

FIND_LIBRARY(PCRE_PCREPOSIX_LIBRARY NAMES pcreposix
   PATHS
   /usr/lib
   /usr/local/lib
   ${GNUWIN32_DIR}/lib
)

SET(PCRE_LIBRARIES ${PCRE_PCRE_LIBRARY} ${PCRE_PCREPOSIX_LIBRARY} CACHE STRING "The libraries needed to use PCRE")

IF(PCRE_INCLUDE_DIR AND PCRE_LIBRARIES)
   SET(PCRE_FOUND TRUE)
ENDIF(PCRE_INCLUDE_DIR AND PCRE_LIBRARIES)


IF(PCRE_FOUND)
   IF(NOT PCRE_FIND_QUIETLY)
      MESSAGE(STATUS "Found PCRE: ${PCRE_LIBRARIES}")
   ENDIF(NOT PCRE_FIND_QUIETLY)
ELSE(PCRE_FOUND)
   IF(PCRE_FIND_REQUIRED)
      MESSAGE(FATAL_ERROR "Could not find PCRE")
   ENDIF(PCRE_FIND_REQUIRED)
ENDIF(PCRE_FOUND)

MARK_AS_ADVANCED(PCRE_INCLUDE_DIR PCRE_LIBRARIES PCRE_PCREPOSIX_LIBRARY PCRE_PCRE_LIBRARY)
