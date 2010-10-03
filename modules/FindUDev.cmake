# - Try to find UDev
# Once done this will define
#
#  UDEV_FOUND - system has UDev
#  UDEV_LIBS - The libraries needed to use UDev

# Copyright (c) 2010, Rafael Fernández López, <ereslibre@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

find_library(UDEV_LIBS udev)

if(UDEV_LIBS)
  set(UDEV_FOUND TRUE)
endif(UDEV_LIBS)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(UDev DEFAULT_MSG UDEV_LIBRARY UDEV_INCLUDE_DIR)
