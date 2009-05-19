# - Try to find konqueror library
# Once done this will define
#
#  LIBKONQ_FOUND - system has libkonq library
#  LIBKONQ_INCLUDE_DIR - the LIBKONQ include directory
#  LIBKONQ_LIBRARY - the libkonq library

#  Original file: FindMarbleWidget.cmake (found in digikam-0.10.0-beta2)
#  copyright 2008 by Patrick Spendrin <ps_ml@gmx.de>
#  Copyright (c) 2009, Alexander Neundorf, <neundorf@kde.org>
#  use this file as you like
#
#  Modifications to find libkonq by Joachim Eibl 2008

find_path(LIBKONQ_INCLUDE_DIR konq_popupmenuplugin.h )

find_library(LIBKONQ_LIBRARY konq)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(LIBKONQ  DEFAULT_MSG  LIBKONQ_INCLUDE_DIR LIBKONQ_LIBRARY )

mark_as_advanced(LIBKONQ_INCLUDE_DIR LIBKONQ_LIBRARY)
