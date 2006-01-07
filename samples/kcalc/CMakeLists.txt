FIND_PACKAGE(KDE3 REQUIRED)

SET(CMAKE_VERBOSE_MAKEFILE ON)

ADD_DEFINITIONS(${QT_DEFINITIONS} ${KDE3_DEFINITIONS})

LINK_DIRECTORIES(${KDE3_LIB_DIR})

ADD_SUBDIRECTORY( knumber )

INCLUDE_DIRECTORIES( ${KDE3_INCLUDE_DIR} ${QT_INCLUDE_DIR} ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR}  )

INCLUDE_DIRECTORIES( ${CMAKE_CURRENT_SOURCE_DIR}/knumber ) # added manually

# configure checks, added manually

INCLUDE(CheckIncludeFiles)  #module to test for headers, coming with cmake

CHECK_INCLUDE_FILES( unistd.h HAVE_UNISTD_H)
CHECK_INCLUDE_FILES( string.h HAVE_STRING_H)
CHECK_INCLUDE_FILES( ieeefp.h HAVE_IEEEFP_H)

INCLUDE(CheckFunctionExists) #module to test for existence of functions, coming with cmake

CHECK_FUNCTION_EXISTS( isinf HAVE_FUNC_ISINF)

CONFIGURE_FILE(${CMAKE_SOURCE_DIR}/config.h.cmake ${CMAKE_BINARY_DIR}/config.h)


########### next target ###############

SET(kcalc_KDEINIT_SRCS
kcalc.cpp
kcalc_button.cpp
kcalc_const_button.cpp
kcalc_const_menu.cpp
kcalc_core.cpp
kcalcdisplay.cpp
dlabel.cpp
stats.cpp
)

KDE3_AUTOMOC(${kcalc_KDEINIT_SRCS})

SET( kcalc_UI
colors.ui
general.ui
constants.ui
)

KDE3_ADD_UI_FILES(kcalc_KDEINIT_SRCS ${kcalc_UI} )

SET( kcalc_KCFG_SRCS
kcalc_settings.kcfgc
)

KDE3_ADD_KCFG_FILES(kcalc_KDEINIT_SRCS ${kcalc_KCFG_SRCS})

KDE3_ADD_KLM( kcalc ${kcalc_KDEINIT_SRCS})

# gmp, knumber and kdeui added manually
TARGET_LINK_LIBRARIES(kdeinit_kcalc  ${QT_AND_KDECORE_LIBS} kdeui knumber gmp)

INSTALL_TARGETS(/lib kdeinit_kcalc )

TARGET_LINK_LIBRARIES( kcalc kdeinit_kcalc )
INSTALL_TARGETS(/bin kcalc )

########### install files ###############

INSTALL_FILES( /share/applications/kde FILES kcalc.desktop )
INSTALL_FILES(  /share/config.kcfg FILES kcalc.kcfg )
INSTALL_FILES( /share/apps/kcalc FILES kcalcui.rc )
INSTALL_FILES( /share/apps/kconf_update FILES kcalcrc.upd )

KDE3_INSTALL_ICONS( hicolor )

KDE3_PLACEHOLDER()



#original Makefile.am contents follow:

#AM_CPPFLAGS= -I$(srcdir)/knumber -D_ISOC99_SOURCE $(all_includes)
#
#SUBDIRS = knumber
#
#bin_PROGRAMS =
#lib_LTLIBRARIES =
#kdeinit_LTLIBRARIES = kcalc.la
#
#kcalc_la_SOURCES = kcalc.cpp kcalc_button.cpp kcalc_const_button.cpp \
#			kcalc_const_menu.cpp kcalc_core.cpp kcalcdisplay.cpp \
#			dlabel.cpp stats.cpp colors.ui general.ui \
#			constants.ui kcalc_settings.kcfgc
#
#
#METASOURCES = AUTO
#
#noinst_HEADERS  = kcalc.h kcalc_button.h kcalc_const_button.h \
#			kcalc_const_menu.h kcalc_core.h kcalcdisplay.h \
#			kcalctype.h dlabel.h stats.h
#
#kcalc_la_LDFLAGS = $(all_libraries) -module -avoid-version
#kcalc_la_LIBADD = $(LIB_KDEUI) knumber/libknumber.la
#
#KDE_ICON = kcalc
#
#xdg_apps_DATA = kcalc.desktop
#kde_kcfg_DATA = kcalc.kcfg
#
#rcdir = $(kde_datadir)/kcalc
#rc_DATA = kcalcui.rc
#
#messages: rc.cpp
#	$(XGETTEXT) *.cpp -o $(podir)/kcalc.pot
#
#updatedir = $(kde_datadir)/kconf_update
#update_DATA = kcalcrc.upd
#
#DOXYGEN_EMPTY = YES
#include $(top_srcdir)/admin/Doxyfile.am
#
