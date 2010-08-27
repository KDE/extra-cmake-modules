# - Try to find HUPnP library
#  Once done this will define
#
#  HUPNP_FOUND - system has HUPnP
#  HUPNP_INCLUDE_DIR - the LIBHUpnp include directory
#  HUPNP_LIBS - the LIBHUpnp libraries
#
# Copyright (c) 2010, Paulo Romulo Alves Barros <paulo.romulo@kdemail.net>

find_path( HUPNP_INCLUDE_DIR HUpnp )

find_library( HUPNP_LIBS HUpnp )

include( FindPackageHandleStandardArgs )

find_package_handle_standard_args( HUpnp DEFAULT_MSG HUPNP_INCLUDE_DIR HUPNP_LIBS )

mark_as_advanced( HUPNP_INCLUDE_DIR HUPNP_LIBS )