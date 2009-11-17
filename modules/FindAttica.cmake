# Try to find the Attica library
# Once done this will define
#
#   ATTICA_FOUND          Indicates that Attica was found
#   ATTICA_LIBRARIES      Libraries needed to use Attica
#   ATTICA_LIBRARY_DIRS   Paths needed for linking against Attica
#   ATTICA_INCLUDE_DIRS   Paths needed for finding Attica include files
#
# Copyright (c) 2009 Frederik Gladhorn <gladhorn@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.


if (NOT WIN32)
   include(FindPkgConfig)
   pkg_check_modules(ATTICA REQUIRED libattica)
endif (NOT WIN32)
