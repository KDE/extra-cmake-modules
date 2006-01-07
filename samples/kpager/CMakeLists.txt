FIND_PACKAGE(KDE3 REQUIRED)

SET(CMAKE_VERBOSE_MAKEFILE ON)

ADD_DEFINITIONS(${QT_DEFINITIONS} ${KDE3_DEFINITIONS})

LINK_DIRECTORIES(${KDE3_LIB_DIR})

INCLUDE_DIRECTORIES( ${KDE3_INCLUDE_DIR} ${QT_INCLUDE_DIR} ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR}  )


########### next target ###############

SET(kpager_SRCS
desktop.cpp
kpager.cpp
config.cpp
windowdrag.cpp
main.cpp
)

KDE3_AUTOMOC(${kpager_SRCS})

SET( kpager_DCOP_SKEL_SRCS
kpagerIface.h
)

KDE3_ADD_DCOP_SKELS(kpager_SRCS ${kpager_DCOP_SKEL_SRCS})

KDE3_ADD_EXECUTABLE(kpager ${kpager_SRCS})

TARGET_LINK_LIBRARIES(kpager  ${QT_AND_KDECORE_LIBS} kdeui )

INSTALL_TARGETS(/bin kpager )


########### install files ###############

INSTALL_FILES( /share/applications/kde FILES kpager.desktop )

KDE3_INSTALL_ICONS( hicolor )

KDE3_PLACEHOLDER()



#original Makefile.am contents follow:

#INCLUDES= $(all_includes)
#
#bin_PROGRAMS = kpager
#
#kpager_SOURCES = desktop.cpp kpager.cpp config.cpp windowdrag.cpp \
#	kpagerIface.skel main.cpp  
#
#kpager_METASOURCES = AUTO
#kpager_LDFLAGS = $(all_libraries) $(KDE_RPATH)
#
#kpager_LDADD = $(LIB_KDEUI)
#
#KDE_ICON = kpager
#
#xdg_apps_DATA = kpager.desktop
#
#install-data-local: uninstall.desktop
#	$(mkinstalldirs) $(DESTDIR)$(kde_appsdir)/Utilities
#	$(INSTALL_DATA) $(srcdir)/uninstall.desktop $(DESTDIR)$(kde_appsdir)/Utilities/kpager.desktop
#
#messages:
#	$(XGETTEXT) *.cpp *.h -o $(podir)/kpager.pot
