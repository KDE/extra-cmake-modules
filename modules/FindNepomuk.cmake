# Once done this will define
#
# Nepomuk requires Soprano, so this module checks for Soprano too.
#
#  NEPOMUK_FOUND - system has Nepomuk
#  NEPOMUK_INCLUDE_DIR - the Nepomuk include directory
#  NEPOMUK_LIBRARIES - Link these to use Nepomuk
#  NEPOMUK_QUERY_LIBRARIES - Link these to use Nepomuk query
#  NEPOMUK_DEFINITIONS - Compiler switches required for using Nepomuk
#


# Copyright (c) 2008-2009, Sebastian Trueg, <sebastian@trueg.de>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.


if (NOT DEFINED Soprano_FOUND)
  macro_optional_find_package(Soprano)
  macro_log_feature(Soprano_FOUND "Soprano" "Semantic Desktop Storing" "" FALSE "" "Soprano is needed for Nepomuk")
endif (NOT DEFINED Soprano_FOUND)

if (Soprano_FOUND)

  find_path(NEPOMUK_INCLUDE_DIR
    NAMES
    nepomuk/global.h
    HINTS
    ${KDE4_INCLUDE_DIR}
    ${INCLUDE_INSTALL_DIR}
    )

  find_library(NEPOMUK_LIBRARIES
    NAMES
    nepomuk
    HINTS
    ${KDE4_LIB_DIR}
    ${LIB_INSTALL_DIR}
    )

  find_library(NEPOMUK_QUERY_LIBRARIES
    NAMES
    nepomukquery
    HINTS
    ${KDE4_LIB_DIR}
    ${LIB_INSTALL_DIR}
    )

  mark_as_advanced(NEPOMUK_INCLUDE_DIR NEPOMUK_LIBRARIES NEPOMUK_QUERY_LIBRARIES)

endif (Soprano_FOUND)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Nepomuk  DEFAULT_MSG 
                                  NEPOMUK_LIBRARIES NEPOMUK_INCLUDE_DIR)

#to retain backward compatibility
set (Nepomuk_FOUND ${NEPOMUK_FOUND})

