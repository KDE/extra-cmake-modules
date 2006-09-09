# Copyright (c) 2006, Benjamin Reed, <ranger@befunk.com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

INCLUDE(CMakeFindFrameworks)

CMAKE_FIND_FRAMEWORKS(Carbon)

if (Carbon_FRAMEWORKS)
   set(CARBON_LIBRARY "-framework Carbon" CACHE FILEPATH "Carbon framework" FORCE)
   set(CARBON_FOUND 1)
endif (Carbon_FRAMEWORKS)
