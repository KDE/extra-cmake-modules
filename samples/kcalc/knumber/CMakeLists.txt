ADD_SUBDIRECTORY( tests )

INCLUDE_DIRECTORIES( ${KDE3_INCLUDE_DIR} ${QT_INCLUDE_DIR} ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR})

INCLUDE_DIRECTORIES(${CMAKE_CURRENT_BINARY_DIR}/.. ) # added manually

ADD_DEFINITIONS(-D_GNU_SOURCE -D_ISOC99_SOURCE ) # added manually

########### next target ###############

SET(knumber_STAT_SRCS
knumber.cpp
knumber_priv.cpp
)

KDE3_AUTOMOC(${knumber_STAT_SRCS})

ADD_LIBRARY(knumber STATIC ${knumber_STAT_SRCS})


########### install files ###############


KDE3_PLACEHOLDER()



#original Makefile.am contents follow:

#AM_CPPFLAGS=-D_GNU_SOURCE -D_ISOC99_SOURCE $(all_includes)
#
#SUBDIRS = tests
#
#bin_PROGRAMS =
#lib_LTLIBRARIES =
#noinst_LTLIBRARIES = libknumber.la
#
#libknumber_la_SOURCES = knumber.cpp knumber_priv.cpp
#libknumber_la_LIBADD = $(LIBGMP) -lm
#
#METASOURCES = AUTO
#
#noinst_HEADERS  = knumber.h knumber_priv.h
#
#include ../../admin/Doxyfile.am
