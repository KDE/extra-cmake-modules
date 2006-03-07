INCLUDE_DIRECTORIES( ${CMAKE_SOURCE_DIR}/kcalc/knumber ${KDE3_INCLUDE_DIR} ${QT_INCLUDE_DIR} ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR}  )


########### next target ###############

SET(knumbertest_SRCS knumbertest.cpp )

KDE3_AUTOMOC(${knumbertest_SRCS})

IF(KDE3_BUILD_TESTS)
KDE3_ADD_EXECUTABLE(knumbertest ${knumbertest_SRCS})

TARGET_LINK_LIBRARIES(knumbertest  ${QT_AND_KDECORE_LIBS} )

ENDIF(KDE3_BUILD_TESTS)

########### install files ###############




#original Makefile.am contents follow:

##    This file is part of the KDE libraries
##    Copyright (C) 1996-1997 Matthias Kalle Dalheimer (kalle@kde.org)
##              (C) 1997-1998 Stephan Kulow (coolo@kde.org)
#
##    This library is free software; you can redistribute it and/or
##    modify it under the terms of the GNU Library General Public
##    License as published by the Free Software Foundation; either
##    version 2 of the License, or (at your option) any later version.
#
##    This library is distributed in the hope that it will be useful,
##    but WITHOUT ANY WARRANTY; without even the implied warranty of
##    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
##    Library General Public License for more details.
#
##    You should have received a copy of the GNU Library General Public License
##    along with this library; see the file COPYING.LIB.  If not, write to
##    the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
##    Boston, MA 02110-1301, USA.
#
#INCLUDES = -I$(top_srcdir)/kcalc/knumber $(all_includes)
#
#check_PROGRAMS = knumbertest
#
#TESTS = knumbertest
#
#noinst_HEADERS = knumbertest.h
#
#METASOURCES = AUTO
#
#knumbertest_SOURCES = knumbertest.cpp
#knumbertest_LDADD = ../libknumber.la $(LIB_QT) $(LIBGMP)
#knumbertest_LDFLAGS = $(all_libraries) $(KDE_RPATH)
