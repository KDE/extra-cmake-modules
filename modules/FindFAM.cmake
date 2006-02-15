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


if(FAM_INCLUDE_DIR AND FAM_LIBRARIES)
   set(FAM_FOUND TRUE)
endif(FAM_INCLUDE_DIR AND FAM_LIBRARIES)


if(FAM_FOUND)
   if(not FAM_FIND_QUIETLY)
      message(STATUS "Found fam: ${FAM_LIBRARIES}")
   endif(not FAM_FIND_QUIETLY)
else(FAM_FOUND)
   if(FAM_FIND_REQUIRED)
      message(FATAL_ERROR "Could not find fam library")
   endif(FAM_FIND_REQUIRED)
endif(FAM_FOUND)

MARK_AS_ADVANCED(FAM_INCLUDE_DIR FAM_LIBRARIES)

