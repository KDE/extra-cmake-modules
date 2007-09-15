# - Try to find blitz lib
# Once done this will define
#
#  BLITZ_FOUND - system has blitz lib
#  BLITZ_INCLUDES - the blitz include directory
#  BLITZ_LIBRARIES - The libraries needed to use blitz
#
# Copyright (c) 2006, Montel Laurent, <montel@kde.org>
# Copyright (c) 2007, Allen Winter, <winter@kde.org>
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

if (BLITZ_INCLUDES AND BLITZ_LIBRARIES)
  set(Blitz_FIND_QUIETLY TRUE)
endif (BLITZ_INCLUDES AND BLITZ_LIBRARIES)

find_path(BLITZ_INCLUDES
  NAMES
  qimageblitz.h
  PATH_SUFFIXES qimageblitz
  PATHS
  $ENV{QIMAGEBLITZDIR}/include
  ${KDE4_INCLUDE_DIR}
  ${INCLUDE_INSTALL_DIR}
)
if(MSVC)
  FIND_LIBRARY(BLITZ_LIBRARIES_DEBUG NAMES qimageblitzd)
  FIND_LIBRARY(BLITZ_LIBRARIES_RELEASE NAMES qimageblitz)

  if(BLITZ_LIBRARIES_DEBUG AND BLITZ_LIBRARIES_RELEASE)
    set(BLITZ_LIBRARIES optimized ${BLITZ_LIBRARIES_RELEASE}
                        debug ${BLITZ_LIBRARIES_DEBUG})
  else(BLITZ_LIBRARIES_DEBUG AND BLITZ_LIBRARIES_RELEASE)
    if(BLITZ_LIBRARIES_DEBUG)
      set(BLITZ_LIBRARIES ${BLITZ_LIBRARIES_DEBUG})
    else(BLITZ_LIBRARIES_DEBUG)
      if(BLITZ_LIBRARIES_RELEASE)
        set(BLITZ_LIBRARIES ${BLITZ_LIBRARIES_RELEASE})
      endif(BLITZ_LIBRARIES_RELEASE)
    endif(BLITZ_LIBRARIES_DEBUG)
  endif(BLITZ_LIBRARIES_DEBUG AND BLITZ_LIBRARIES_RELEASE)
else(MSVC)
  FIND_LIBRARY(BLITZ_LIBRARIES
  NAMES
   qimageblitz
   PATHS
   $ENV{QIMAGEBLITZDIR}/lib
   ${KDE4_LIB_DIR}
   ${LIB_INSTALL_DIR}
  )
endif(MSVC)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Blitz DEFAULT_MSG 
                                  BLITZ_INCLUDES BLITZ_LIBRARIES)

mark_as_advanced(BLITZ_INCLUDES BLITZ_LIBRARIES)
