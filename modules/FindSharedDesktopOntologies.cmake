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

if (SHAREDDESKTOPONTOLOGIES_ROOT_DIR)
   # in cache already
   set(SHAREDDESKTOPONTOLOGIES_FIND_QUIETLY TRUE)
endif (SHAREDDESKTOPONTOLOGIES_ROOT_DIR)

# First try the SharedDesktopOntologiesConfig.cmake from shared-desktop-ontologies 0.2 and newer
find_package(SharedDesktopOntologies ${SharedDesktopOntologies_FIND_VERSION} QUIET NO_MODULE)

if (NOT SHAREDDESKTOPONTOLOGIES_ROOT_DIR)
  # Look in the standard dirs
  find_path (SHAREDDESKTOPONTOLOGIES_ROOT_DIR
    nie/nie.trig
    PATHS
    /usr/share
    /usr/local/share
    ${SHARE_INSTALL_PREFIX}
    ENV XDG_DATA_DIRS
    PATH_SUFFIXES ontology)

  # Look in CMAKE_PREFIX_PATH
  find_path(SHAREDDESKTOPONTOLOGIES_ROOT_DIR
    nie/nie.trig
    PATH_SUFFIXES share/ontology)
endif (NOT SHAREDDESKTOPONTOLOGIES_ROOT_DIR)

mark_as_advanced(SHAREDDESKTOPONTOLOGIES_ROOT_DIR)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(SharedDesktopOntologies DEFAULT_MSG SHAREDDESKTOPONTOLOGIES_ROOT_DIR)
