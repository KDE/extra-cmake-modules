# - Try to find the PCRE regular expression library
# Once done this will define
#
#  PCRE_FOUND - system has the PCRE library
#  PCRE_INCLUDE_DIR - the PCRE include directory
#  PCRE_LIBRARIES - The libraries needed to use PCRE
#
# Copyright (c) 2006, Alexander Neundorf, <neundorf@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.


if (PCRE_INCLUDE_DIR AND PCRE_PCREPOSIX_LIBRARY AND PCRE_PCRE_LIBRARY)
  # Already in cache, be silent
  set(PCRE_FIND_QUIETLY TRUE)
endif (PCRE_INCLUDE_DIR AND PCRE_PCREPOSIX_LIBRARY AND PCRE_PCRE_LIBRARY)

FIND_PATH(PCRE_INCLUDE_DIR pcre.h PATH_SUFFIXES pcre)

FIND_LIBRARY(PCRE_PCRE_LIBRARY NAMES pcre)

FIND_LIBRARY(PCRE_PCREPOSIX_LIBRARY NAMES pcreposix)

include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(PCRE DEFAULT_MSG PCRE_INCLUDE_DIR PCRE_PCRE_LIBRARY PCRE_PCREPOSIX_LIBRARY )

set(PCRE_LIBRARIES ${PCRE_PCRE_LIBRARY} ${PCRE_PCREPOSIX_LIBRARY} CACHE STRING "The libraries needed to use PCRE")

MARK_AS_ADVANCED(PCRE_INCLUDE_DIR PCRE_LIBRARIES PCRE_PCREPOSIX_LIBRARY PCRE_PCRE_LIBRARY)
