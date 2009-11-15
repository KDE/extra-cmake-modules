# This file is included by FindQt4.cmake, don't include it directly.

#=============================================================================
# Copyright 2005-2009 Kitware, Inc.
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# (To distributed this file outside of CMake, substitute the full
#  License text for the above reference.)


###############################################
#
#       configuration/system dependent settings  
#
###############################################

# for unix add X11 stuff
IF(UNIX)
  # on OS X X11 may not be required
  IF (Q_WS_X11)
    FIND_PACKAGE(X11 REQUIRED)
  ENDIF (Q_WS_X11)
  FIND_PACKAGE(Threads)
  SET(QT_QTCORE_LIBRARY ${QT_QTCORE_LIBRARY} ${CMAKE_THREAD_LIBS_INIT})
ENDIF(UNIX)

