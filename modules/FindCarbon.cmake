INCLUDE(CMakeFindFrameworks)

CMAKE_FIND_FRAMEWORKS(Carbon)

if(Carbon_FRAMEWORKS)
	set (CARBON_LIBRARY "-framework Carbon" CACHE FILEPATH "Carbon framework" FORCE)
	set (CARBON_FOUND 1)
endif(Carbon_FRAMEWORKS)
