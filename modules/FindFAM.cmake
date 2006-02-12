# - Try to find the FAM directory notification library
# Once done this will define
#
#  FAM_FOUND - system has FAM
#  FAM_INCLUDE_DIR - the FAM include directory
#  FAM_LIBRARIES - The libraries needed to use FAM

FIND_PATH(FAM_INCLUDE_DIR fam.h
   /usr/include
   /usr/local/include
)

FIND_LIBRARY(FAM_LIBRARIES NAMES fam
   PATHS
   /usr/lib
   /usr/local/lib
)


IF(FAM_INCLUDE_DIR AND FAM_LIBRARIES)
   SET(FAM_FOUND TRUE)
ENDIF(FAM_INCLUDE_DIR AND FAM_LIBRARIES)


IF(FAM_FOUND)
   IF(NOT FAM_FIND_QUIETLY)
      MESSAGE(STATUS "Found fam: ${FAM_LIBRARIES}")
   ENDIF(NOT FAM_FIND_QUIETLY)
ELSE(FAM_FOUND)
   IF(FAM_FIND_REQUIRED)
      MESSAGE(FATAL_ERROR "Could not find fam library")
   ENDIF(FAM_FIND_REQUIRED)
ENDIF(FAM_FOUND)

MARK_AS_ADVANCED(FAM_INCLUDE_DIR FAM_LIBRARIES)

