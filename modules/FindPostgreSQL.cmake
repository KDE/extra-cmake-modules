# - Find PostgreSQL
# Find the PostgreSQL includes and client library
# This module defines
#  POSTGRESQL_INCLUDE_DIR, where to find POSTGRESQL.h
#  POSTGRESQL_LIBRARIES, the libraries needed to use POSTGRESQL.
#  POSTGRESQL_FOUND, If false, do not try to use PostgreSQL.
#
# Copyright (c) 2006, Jaroslaw Staniek, <js@iidea.pl>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.


if (POSTGRESQL_INCLUDE_DIR AND POSTGRESQL_LIBRARIES)
  # Already in cache, be silent
  set(PostgreSQL_FIND_QUIETLY TRUE)
endif (POSTGRESQL_INCLUDE_DIR AND POSTGRESQL_LIBRARIES)


find_path(POSTGRESQL_INCLUDE_DIR libpq-fe.h
   /usr/include/pgsql
   /usr/local/include/pgsql
)

find_library(POSTGRESQL_LIBRARIES NAMES pq
   PATHS
   /usr/lib
   /usr/local/lib
)

if(POSTGRESQL_INCLUDE_DIR AND POSTGRESQL_LIBRARIES)
   set(POSTGRESQL_FOUND TRUE)
endif(POSTGRESQL_INCLUDE_DIR AND POSTGRESQL_LIBRARIES)

if(POSTGRESQL_FOUND)
   if (NOT PostgreSQL_FIND_QUIETLY)
   	message(STATUS "Found PostgreSQL: ${POSTGRESQL_INCLUDE_DIR}, ${POSTGRESQL_LIBRARIES}")
   endif(NOT PostgreSQL_FIND_QUIETLY)
else(POSTGRESQL_FOUND)
   if (PostgreSQL_FIND_REQUIRED)
	message(FATAL_ERROR "PostgreSQL not found.")
   endif(PostgreSQL_FIND_REQUIRED)
endif(POSTGRESQL_FOUND)

mark_as_advanced(POSTGRESQL_INCLUDE_DIR POSTGRESQL_LIBRARIES)

