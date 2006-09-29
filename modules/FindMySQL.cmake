# - Find MySQL / MySQL Embedded
# Find the MySQL includes and client library
# This module defines
#  MYSQL_INCLUDE_DIR, where to find mysql.h
#  MYSQL_LIBRARIES, the libraries needed to use MySQL.
#  MYSQL_EMBEDDED_LIBRARIES, the libraries needed to use MySQL Embedded.
#  MYSQL_FOUND, If false, do not try to use MySQL.
#  MYSQL_EMBEDDED_FOUND, If false, do not try to use MySQL Embedded.
#
# Copyright (c) 2006, Jaroslaw Staniek, <js@iidea.pl>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.


find_path(MYSQL_INCLUDE_DIR mysql.h
   /usr/include/mysql
   /usr/local/include/mysql
)

find_library(MYSQL_LIBRARIES NAMES mysqlclient
   PATHS
   /usr/lib/mysql
   /usr/local/lib/mysql
)

find_library(MYSQL_EMBEDDED_LIBRARIES NAMES mysqld
   PATHS
   /usr/lib/mysql
   /usr/local/lib/mysql
   /opt/mysql/lib/mysql
)

if(MYSQL_INCLUDE_DIR AND MYSQL_LIBRARIES)
   set(MYSQL_FOUND TRUE)
   message(STATUS "Found MySQL: ${MYSQL_INCLUDE_DIR}, ${MYSQL_LIBRARIES}")
else(MYSQL_INCLUDE_DIR AND MYSQL_LIBRARIES)
   set(MYSQL_FOUND FALSE)
   message(STATUS "MySQL not found.")
endif(MYSQL_INCLUDE_DIR AND MYSQL_LIBRARIES)

if(MYSQL_INCLUDE_DIR AND MYSQL_EMBEDDED_LIBRARIES)
   set(MYSQL_EMBEDDED_FOUND TRUE)
   message(STATUS "Found MySQL Embedded: ${MYSQL_INCLUDE_DIR}, ${MYSQL_EMBEDDED_LIBRARIES}")
else(MYSQL_INCLUDE_DIR AND MYSQL_EMBEDDED_LIBRARIES)
   set(MYSQL_EMBEDDED_FOUND FALSE)
   message(STATUS "MySQL Embedded not found.")
endif(MYSQL_INCLUDE_DIR AND MYSQL_EMBEDDED_LIBRARIES)

mark_as_advanced(MYSQL_INCLUDE_DIR MYSQL_LIBRARIES MYSQL_EMBEDDED_LIBRARIES)
