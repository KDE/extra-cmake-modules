# - Try to find Boost include dirs and libraries
#
# Please see the Documentation for Boost in the CMake Manual for details
# This module only forwards to the one included in cmake for compatibility
# reasons.

# This call is kept for compatibility of this module with CMake 2.6.2, which
# only knows about Boost < 1.37.
# Note: Do _not_ add new Boost versions here, we're trying to get rid
# of this module in kdelibs, but thats only possible if there's a CMake-included
# version that finds all modules that this file finds.
# Instead add a similar call with newer version numbers to the CMakeLists.txt
# in your project before calling find_package(Boost)
#
#  Copyright (c) 2009      Andreas Pakulat <apaku@gmx.de>
#
#  Redistribution AND use is allowed according to the terms of the New
#  BSD license.
#  For details see the accompanying COPYING-CMAKE-SCRIPTS file.


set( Boost_ADDITIONAL_VERSIONS ${Boost_ADDITIONAL_VERSIONS} "1.37" )

include(${CMAKE_ROOT}/Modules/FindBoost.cmake)

