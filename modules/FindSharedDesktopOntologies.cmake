# - Try to find shared-desktop-ontologies
# The shared-desktop-ontologies package is a direct dependancy of the Nepomuk
# semantic desktop system and provides all necessary ontology files like
# RDF, RDFS, NRL, or NIE.
#
# The package is created by the OSCAF project (http://oscaf.sourceforge.net).
#
# Once done this will define
#
#  SHAREDDESKTOPONTOLOGIES_FOUND         - system has shared-desktop-ontologies
#  SHAREDDESKTOPONTOLOGIES_ROOT_DIR      - Folder where the ontologies are stored
#  SHAREDDESKTOPONTOLOGIES_VERSION_MAJOR - The major version number, i.e. '1' in '1.2'
#  SHAREDDESKTOPONTOLOGIES_VERSION_MINOR - The minor version number, i.e. '2' in '1.2'
#  SHAREDDESKTOPONTOLOGIES_VERSION       - The complete version string, i.e. '1.2'
#

# Copyright (c) 2009, Sebastian Trueg, <trueg@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.


# First try the SharedDesktopOntologiesConfig.cmake from shared-desktop-ontologies 0.2 and newer

# This is to make it work with cmake 2.6.2, since SDO 0.2 installs its config file into 
# the 2.6.3 compatible location only ( share/cmake/SDO/ instead share/SDO/[cmake/] )
if( "${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION}.${CMAKE_PATCH_VERSION}" VERSION_LESS "2.6.3")
  find_path(_SDO_CONFIG_DIR SharedDesktopOntologiesConfig.cmake PATH_SUFFIXES share/cmake/SharedDesktopOntologies/ )
endif( "${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION}.${CMAKE_PATCH_VERSION}" VERSION_LESS "2.6.3")

if(NOT SharedDesktopOntologies_FIND_VERSION)
  set(SharedDesktopOntologies_FIND_VERSION "${SDO_MIN_VERSION}")
endif(NOT SharedDesktopOntologies_FIND_VERSION)

find_package(SharedDesktopOntologies ${SharedDesktopOntologies_FIND_VERSION} QUIET NO_MODULE HINTS "${_SDO_CONFIG_DIR}" )

if (SHAREDDESKTOPONTOLOGIES_ROOT_DIR)
  mark_as_advanced(SHAREDDESKTOPONTOLOGIES_ROOT_DIR)
endif (SHAREDDESKTOPONTOLOGIES_ROOT_DIR)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(SharedDesktopOntologies REQUIRED_VARS SHAREDDESKTOPONTOLOGIES_ROOT_DIR VERSION_VAR SharedDesktopOntologies_VERSION)
