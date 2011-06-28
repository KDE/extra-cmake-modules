# - Try to find the sasl2 directory library
# Once done this will define
#
#  SASL2_FOUND - system has SASL2
#  SASL2_INCLUDE_DIR - the SASL2 include directory
#  SASL2_LIBRARIES - The libraries needed to use SASL2

# Copyright (c) 2006, 2007 Laurent Montel, <montel@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.


find_path(SASL2_INCLUDE_DIR sasl/sasl.h
)

# libsasl2 add for windows, because the windows package of cyrus-sasl2
# contains a libsasl2 also for msvc which is not standard conform
find_library(SASL2_LIBRARIES NAMES sasl2 libsasl2
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Sasl2  DEFAULT_MSG  SASL2_LIBRARIES SASL2_INCLUDE_DIR)

mark_as_advanced(SASL2_INCLUDE_DIR SASL2_LIBRARIES)

