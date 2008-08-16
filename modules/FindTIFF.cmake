# - Find TIFF library
# Find the native TIFF includes and library
# This module defines
#  TIFF_INCLUDE_DIR, where to find tiff.h, etc.
#  TIFF_LIBRARIES, libraries to link against to use TIFF.
#  TIFF_FOUND, If false, do not try to use TIFF.
# also defined, but not for general use are
#  TIFF_LIBRARY, where to find the TIFF library.

# Copyright (c) 2002 Kitware, Inc., Insight Consortium.  All rights reserved.
# See Copyright.txt or http://www.cmake.org/HTML/Copyright.html for details.

if (TIFF_INCLUDE_DIR AND TIFF_LIBRARY)
  # Already in cache, be silent
  set(TIFF_FIND_QUIETLY TRUE)
endif (TIFF_INCLUDE_DIR AND TIFF_LIBRARY)

find_path(TIFF_INCLUDE_DIR NAMES tiff.h )

set(TIFF_NAMES ${TIFF_NAMES} tiff libtiff libtiff3)
find_library(TIFF_LIBRARY NAMES ${TIFF_NAMES} )

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(TIFF  DEFAULT_MSG  TIFF_INCLUDE_DIR  TIFF_LIBRARY)

set(TIFF_LIBRARIES ${TIFF_LIBRARY} )
mark_as_advanced(TIFF_INCLUDE_DIR TIFF_LIBRARY)
