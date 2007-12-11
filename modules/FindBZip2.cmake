# Try to find the BZip2 librairies
# BZIP2_FOUND - system has BZip2 lib
# BZIP2_INCLUDE_DIR - the BZip2 include directory
# BZIP2_LIBRARIES - Libraries needed to use BZip2

# Copyright (c) 2007, Allen Winter <winter@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.


if (BZIP2_INCLUDE_DIR AND BZIP2_LIBRARIES)
  # Already in cache, be silent
  set(BZIP2_FIND_QUIETLY TRUE)
endif (BZIP2_INCLUDE_DIR AND BZIP2_LIBRARIES)

find_path(BZIP2_INCLUDE_DIR NAMES bzlib.h )
find_library(BZIP2_LIBRARIES NAMES bz2 )

include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(BZIP2 DEFAULT_MSG BZIP2_INCLUDE_DIR BZIP2_LIBRARIES)

mark_as_advanced(BZIP2_INCLUDE_DIR BZIP2_LIBRARIES)
