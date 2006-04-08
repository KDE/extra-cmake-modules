# - Try to find the PCRE regular expression library
# Once done this will define
#
#  PCRE_FOUND - system has the PCRE library
#  PCRE_INCLUDE_DIR - the PCRE include directory
#  PCRE_LIBRARIES - The libraries needed to use PCRE

FIND_PATH(PCRE_INCLUDE_DIR pcre.h
   /usr/include/
   /usr/local/include/
)

FIND_LIBRARY(PCRE_PCRE_LIBRARY NAMES pcre
   PATHS
   /usr/lib
   /usr/local/lib
)

FIND_LIBRARY(PCRE_PCREPOSIX_LIBRARY NAMES pcreposix
   PATHS
   /usr/lib
   /usr/local/lib
)

set(PCRE_LIBRARIES ${PCRE_PCRE_LIBRARY} ${PCRE_PCREPOSIX_LIBRARY} CACHE STRING "The libraries needed to use PCRE")

if (PCRE_INCLUDE_DIR AND PCRE_LIBRARIES)
   set(PCRE_FOUND TRUE)
endif (PCRE_INCLUDE_DIR AND PCRE_LIBRARIES)


if (PCRE_FOUND)
   if (NOT PCRE_FIND_QUIETLY)
      message(STATUS "Found PCRE: ${PCRE_LIBRARIES}")
   endif (NOT PCRE_FIND_QUIETLY)
else (PCRE_FOUND)
   if (PCRE_FIND_REQUIRED)
      message(FATAL_ERROR "Could NOT find PCRE")
   endif (PCRE_FIND_REQUIRED)
endif (PCRE_FOUND)

MARK_AS_ADVANCED(PCRE_INCLUDE_DIR PCRE_LIBRARIES PCRE_PCREPOSIX_LIBRARY PCRE_PCRE_LIBRARY)
