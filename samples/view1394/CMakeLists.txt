FIND_PACKAGE(KDE3 REQUIRED)

MESSAGE(STATUS "module path : ${CMAKE_ROOT}")

SET(CMAKE_VERBOSE_MAKEFILE ON)

ADD_DEFINITIONS(${QT_DEFINITIONS} ${KDE3_DEFINITIONS})

LINK_DIRECTORIES(${KDE3_LIB_DIR})

INCLUDE_DIRECTORIES( ${KDE3_INCLUDE_DIR} ${QT_INCLUDE_DIR} ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR}  )


########### next target ###############

SET(kcm_view1394_PART_SRCS
view1394.cpp
)

KDE3_AUTOMOC(${kcm_view1394_PART_SRCS})

SET( kcm_view1394_UI
view1394widget.ui
)

KDE3_ADD_UI_FILES(kcm_view1394_PART_SRCS ${kcm_view1394_UI} )

KDE3_ADD_KPART(kcm_view1394 ${kcm_view1394_PART_SRCS})

TARGET_LINK_LIBRARIES(kcm_view1394  ${QT_AND_KDECORE_LIBS} raw1394 )

INSTALL_TARGETS(/lib/kde3 kcm_view1394 )


########### install files ###############

INSTALL_FILES( /share/applications/kde FILES kcmview1394.desktop )
INSTALL_FILES( /share/apps/kcmview1394 FILES oui.db )

KDE3_PLACEHOLDER()



#original Makefile.am contents follow:

#kde_module_LTLIBRARIES = kcm_view1394.la
#
#kcm_view1394_la_SOURCES = view1394widget.ui view1394.cpp
#
#kcm_view1394_la_LDFLAGS  = $(all_libraries) -module -avoid-version -no-undefined
#kcm_view1394_la_LIBADD = $(LIB_KDEUI) -lraw1394
#
#AM_CPPFLAGS= $(all_includes) 
#
#METASOURCES = AUTO
#
#messages: rc.cpp
#	$(XGETTEXT) *.cpp -o $(podir)/kcmview1394.pot
#
#xdg_apps_DATA = kcmview1394.desktop
#
#view1394_vendor_DATA = oui.db
#view1394_vendordir = $(kde_datadir)/kcmview1394
#
