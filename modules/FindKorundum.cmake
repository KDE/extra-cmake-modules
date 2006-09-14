# - Find Korundum - the KDE Ruby bindings
#
# This module finds if Korundum is installed.
#
# Copyright (c) 2006, Egon Willighagen, <egonw@users.sf.net>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

FIND_PATH(Korumdum_PATH Korundum.rb /usr/lib/ruby/1.8)

IF (Korumdum_PATH)
   SET(Korumdum_FOUND TRUE)
ENDIF (Korumdum_PATH)

IF (Korumdum_FOUND)
   IF (NOT Korumdum_FIND_QUIETLY)
      MESSAGE(STATUS "Found Korumdum: ${Korumdum_PATH}")
   ENDIF (NOT Korumdum_FIND_QUIETLY)
ELSE (Korumdum_FOUND)
   IF (Korumdum_FIND_REQUIRED)
      MESSAGE(FATAL_ERROR "Could not find Korumdum")
   ENDIF (Korumdum_FIND_REQUIRED)
ENDIF (Korumdum_FOUND)