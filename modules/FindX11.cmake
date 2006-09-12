# - Find X11 installation
# Try to find X11 on UNIX systems. The following values are defined
#  X11_FOUND        - True if X11 is available
#  X11_INCLUDE_DIR  - include directories to use X11
#  X11_LIBRARIES    - link against these to use X11

# Copyright (c) 2002 Kitware, Inc., Insight Consortium.  All rights reserved.
# See Copyright.txt or http://www.cmake.org/HTML/Copyright.html for details.

if (UNIX)
  set(X11_FOUND 0)

  set(X11_INC_SEARCH_PATH
    /usr/X11R6/include 
    /usr/local/include 
    /usr/include/X11
    /usr/openwin/include 
    /usr/openwin/share/include 
    /opt/graphics/OpenGL/include
    /usr/include
  )

  set(X11_LIB_SEARCH_PATH
    /usr/X11R6/lib
    /usr/local/lib 
    /usr/openwin/lib 
    /usr/lib 
  )

  FIND_PATH(X11_X11_INCLUDE_PATH X11/X.h ${X11_INC_SEARCH_PATH})
  FIND_PATH(X11_Xlib_INCLUDE_PATH X11/Xlib.h ${X11_INC_SEARCH_PATH})
  FIND_PATH(X11_Xutil_INCLUDE_PATH X11/Xutil.h ${X11_INC_SEARCH_PATH})
  FIND_PATH(X11_Xaccessstr_INCLUDE_PATH X11/extensions/XKBstr.h ${X11_INC_SEARCH_PATH})
#Solaris lacks this file, so we should skip kxkbd here
  FIND_PATH(X11_Xaccessrules_INCLUDE_PATH X11/extensions/XKBrules.h ${X11_INC_SEARCH_PATH})
  FIND_PATH(X11_Xcomposite_INCLUDE_PATH X11/extensions/Xcomposite.h ${X11_INC_SEARCH_PATH})
  FIND_PATH(X11_Xfixes_INCLUDE_PATH X11/extensions/Xfixes.h ${X11_INC_SEARCH_PATH})
  FIND_PATH(X11_Xrandr_INCLUDE_PATH X11/extensions/Xrandr.h ${X11_INC_SEARCH_PATH})
  FIND_PATH(X11_Xdamage_INCLUDE_PATH X11/extensions/Xdamage.h ${X11_INC_SEARCH_PATH})
  FIND_PATH(X11_Xrender_INCLUDE_PATH X11/extensions/Xrender.h ${X11_INC_SEARCH_PATH})
  FIND_PATH(X11_Xf86misc_INCLUDE_PATH X11/extensions/xf86misc.h ${X11_INC_SEARCH_PATH})
  FIND_PATH(X11_Xinerama_INCLUDE_PATH X11/extensions/Xinerama.h ${X11_INC_SEARCH_PATH})
  FIND_PATH(X11_XTest_INCLUDE_PATH X11/extensions/XTest.h ${X11_INC_SEARCH_PATH})
  FIND_PATH(X11_Xcursor_INCLUDE_PATH X11/Xcursor/Xcursor.h ${X11_INC_SEARCH_PATH})
  FIND_PATH(X11_Xscreensaver_INCLUDE_PATH X11/extensions/scrnsaver.h ${X11_INC_SEARCH_PATH})
  FIND_PATH(X11_dpms_INCLUDE_PATH X11/extensions/dpms.h ${X11_INC_SEARCH_PATH})
  FIND_PATH(X11_Xkb_INCLUDE_PATH X11/extensions/XKB.h ${X11_INC_SEARCH_PATH})
  FIND_PATH(X11_Xshape_INCLUDE_PATH X11/extensions/shape.h ${X11_INC_SEARCH_PATH})
  FIND_PATH(X11_Xkblib_INCLUDE_PATH X11/XKBlib.h ${X11_INC_SEARCH_PATH})
  FIND_PATH(X11_Xdmcp_INCLUDE_PATH X11/Xdmcp.h ${X11_INC_SEARCH_PATH})
  FIND_PATH(X11_Xpm_INCLUDE_PATH X11/xpm.h ${X11_INC_SEARCH_PATH})
  FIND_PATH(X11_Xinput_INCLUDE_PATH X11/extensions/XInput.h ${X11_INC_SEARCH_PATH})
  FIND_PATH(X11_Xft_INCLUDE_PATH X11/Xft/Xft.h ${X11_INC_SEARCH_PATH})
  FIND_PATH(X11_Xv_INCLUDE_PATH X11/extensions/Xvlib.h ${X11_INC_SEARCH_PATH})
  FIND_LIBRARY(X11_Xss_LIB Xss ${X11_LIB_SEARCH_PATH} NO_SYSTEM_PATH)
  FIND_LIBRARY(X11_X11_LIB X11 ${X11_LIB_SEARCH_PATH} NO_SYSTEM_PATH)
  FIND_LIBRARY(X11_Xext_LIB Xext ${X11_LIB_SEARCH_PATH} NO_SYSTEM_PATH)
  FIND_LIBRARY(X11_Xcomposite_LIB Xcomposite ${X11_LIB_SEARCH_PATH} NO_SYSTEM_PATH)
  FIND_LIBRARY(X11_Xfixes_LIB Xfixes ${X11_LIB_SEARCH_PATH} NO_SYSTEM_PATH)
  FIND_LIBRARY(X11_Xrandr_LIB Xrandr ${X11_LIB_SEARCH_PATH} NO_SYSTEM_PATH)
  FIND_LIBRARY(X11_Xrender_LIB Xrender ${X11_LIB_SEARCH_PATH} NO_SYSTEM_PATH)
  FIND_LIBRARY(X11_Xdamage_LIB Xdamage ${X11_LIB_SEARCH_PATH} NO_SYSTEM_PATH)
  FIND_LIBRARY(X11_Xxf86misc_LIB Xxf86misc ${X11_LIB_SEARCH_PATH} NO_SYSTEM_PATH)
  FIND_LIBRARY(X11_Xinerama_LIB Xinerama ${X11_LIB_SEARCH_PATH} NO_SYSTEM_PATH)
  FIND_LIBRARY(X11_XTest_LIB Xtst ${X11_LIB_SEARCH_PATH} NO_SYSTEM_PATH)
  FIND_LIBRARY(X11_Xcursor_LIB Xcursor ${X11_LIB_SEARCH_PATH} NO_SYSTEM_PATH)
  FIND_LIBRARY(X11_Xt_LIB Xt ${X11_LIB_SEARCH_PATH} NO_SYSTEM_PATH)
  FIND_LIBRARY(X11_Xau_LIB Xau ${X11_LIB_SEARCH_PATH} NO_SYSTEM_PATH)
  FIND_LIBRARY(X11_Xdmcp_LIB Xdmcp ${X11_LIB_SEARCH_PATH} NO_SYSTEM_PATH)
  FIND_LIBRARY(X11_Xpm_LIB Xpm ${X11_LIB_SEARCH_PATH} NO_SYSTEM_PATH)
  FIND_LIBRARY(X11_Xinput_LIB Xi ${X11_LIB_SEARCH_PATH} NO_SYSTEM_PATH)
  FIND_LIBRARY(X11_Xft_LIB Xft ${X11_LIB_SEARCH_PATH} NO_SYSTEM_PATH)
  FIND_LIBRARY(X11_Xv_LIB Xv ${X11_LIB_SEARCH_PATH} NO_SYSTEM_PATH)

  if (X11_X11_INCLUDE_PATH)
    set(X11_INCLUDE_DIR ${X11_INCLUDE_DIR} ${X11_X11_INCLUDE_PATH})
  endif (X11_X11_INCLUDE_PATH)

  if (X11_Xlib_INCLUDE_PATH)
    set(X11_INCLUDE_DIR ${X11_INCLUDE_DIR} ${X11_Xlib_INCLUDE_PATH})
 endif (X11_Xlib_INCLUDE_PATH)

  if (X11_Xutil_INCLUDE_PATH)
    set(X11_INCLUDE_DIR ${X11_INCLUDE_DIR} ${X11_Xutil_INCLUDE_PATH})
  endif (X11_Xutil_INCLUDE_PATH)

  if(X11_Xshape_INCLUDE_PATH)
	set(X11_Xshape_FOUND TRUE)
	set(X11_INCLUDE_DIR ${X11_INCLUDE_DIR} ${X11_Xshape_INCLUDE_PATH})
  endif(X11_Xshape_INCLUDE_PATH)		  

  if (X11_X11_LIB)
    set(X11_LIBRARIES ${X11_LIBRARIES} ${X11_X11_LIB})
  endif (X11_X11_LIB)

  if (X11_Xext_LIB)
    set(X11_LIBRARIES ${X11_LIBRARIES} ${X11_Xext_LIB})
  endif (X11_Xext_LIB)

  if(X11_Xft_LIB AND X11_Xft_INCLUDE_PATH)
	set(X11_XFT_FOUND TRUE)
	set(X11_LIBRARIES ${X11_LIBRARIES} ${X11_Xft_LIB})
	set(X11_INCLUDE_DIR ${X11_INCLUDE_DIR} ${X11_Xft_INCLUDE_PATH})
  endif(X11_Xft_LIB AND X11_Xft_INCLUDE_PATH)		  

  if(X11_Xv_LIB AND X11_Xv_INCLUDE_PATH)
    set(X11_XV_FOUND TRUE)
    set(X11_INCLUDE_DIR ${X11_INCLUDE_DIR} ${X11_Xv_INCLUDE_PATH})
  endif(X11_Xv_LIB AND X11_Xv_INCLUDE_PATH)
  
  if (X11_Xau_LIB)
    set(X11_Xau_FOUND TRUE)
    set(X11_LIBRARIES ${X11_LIBRARIES} ${X11_Xau_LIB})
  endif (X11_Xau_LIB)

  if (X11_Xdmcp_INCLUDE_PATH AND X11_Xdmcp_LIB)
      set(X11_Xdmcp_FOUND TRUE)
      set(X11_LIBRARIES ${X11_LIBRARIES} ${X11_Xdmcp_LIB})
      set(X11_INCLUDE_DIR ${X11_INCLUDE_DIR} ${X11_Xdmcp_INCLUDE_PATH})
  endif (X11_Xdmcp_INCLUDE_PATH AND X11_Xdmcp_LIB)

  if (X11_Xaccessrules_INCLUDE_PATH AND X11_Xaccessstr_INCLUDE_PATH)
      set(X11_Xaccess_FOUND TRUE)
      set(X11_Xaccess_INCLUDE_PATH ${X11_Xaccessstr_INCLUDE_PATH})
      set(X11_INCLUDE_DIR ${X11_INCLUDE_DIR} ${X11_Xaccess_INCLUDE_PATH})
  endif (X11_Xaccessrules_INCLUDE_PATH AND X11_Xaccessstr_INCLUDE_PATH)

  if (X11_Xpm_INCLUDE_PATH AND X11_Xpm_LIB)
      set(X11_Xpm_FOUND TRUE)
      set(X11_LIBRARIES ${X11_LIBRARIES} ${X11_Xpm_LIB})
      set(X11_INCLUDE_DIR ${X11_INCLUDE_DIR} ${X11_Xpm_INCLUDE_PATH})
  endif (X11_Xpm_INCLUDE_PATH AND X11_Xpm_LIB)


  if (X11_Xcomposite_INCLUDE_PATH)
     set(X11_Xcomposite_FOUND TRUE)
     set(X11_INCLUDE_DIR ${X11_INCLUDE_DIR} ${X11_Xcomposite_INCLUDE_PATH})
  endif (X11_Xcomposite_INCLUDE_PATH)

  if (X11_Xdamage_INCLUDE_PATH)
     set(X11_Xdamage_FOUND TRUE)
     set(X11_INCLUDE_DIR ${X11_INCLUDE_DIR} ${X11_Xdamage_INCLUDE_PATH})
  endif (X11_Xdamage_INCLUDE_PATH)

  if (X11_XTest_INCLUDE_PATH AND X11_XTest_LIB)
      set(X11_XTest_FOUND TRUE)
      set(X11_INCLUDE_DIR ${X11_INCLUDE_DIR} ${X11_XTest_INCLUDE_PATH})
  endif (X11_XTest_INCLUDE_PATH AND X11_XTest_LIB)

  if (X11_Xinerama_INCLUDE_PATH)
     set(X11_Xinerama_FOUND TRUE)
     set(X11_INCLUDE_DIR ${X11_INCLUDE_DIR} ${X11_Xinerama_INCLUDE_PATH})
  endif (X11_Xinerama_INCLUDE_PATH)

  if (X11_Xfixes_INCLUDE_PATH)
     set(X11_Xfixes_FOUND TRUE)
     set(X11_INCLUDE_DIR ${X11_INCLUDE_DIR} ${X11_Xfixes_INCLUDE_PATH})
  endif (X11_Xfixes_INCLUDE_PATH)

  if (X11_Xrender_INCLUDE_PATH AND X11_Xrender_LIB)
     set(X11_Xrender_FOUND TRUE)
     set(X11_INCLUDE_DIR ${X11_INCLUDE_DIR} ${X11_Xrender_INCLUDE_PATH})
  endif (X11_Xrender_INCLUDE_PATH AND X11_Xrender_LIB)

  if (X11_Xrandr_INCLUDE_PATH)
     set(X11_Xrandr_FOUND TRUE)
     set(X11_INCLUDE_DIR ${X11_INCLUDE_DIR} ${X11_Xrandr_INCLUDE_PATH})
  endif (X11_Xrandr_INCLUDE_PATH)

  if (X11_Xxf86misc_INCLUDE_PATH)
     set(X11_Xxf86misc_FOUND TRUE)
     set(X11_INCLUDE_DIR ${X11_INCLUDE_DIR} ${X11_Xxf86misc_INCLUDE_PATH})
  endif (X11_Xxf86misc_INCLUDE_PATH)

  if (X11_Xcursor_INCLUDE_PATH AND X11_Xcursor_LIB)
     set(X11_Xcursor_FOUND TRUE)
     set(X11_INCLUDE_DIR ${X11_INCLUDE_DIR} ${X11_Xcursor_INCLUDE_PATH})
  endif (X11_Xcursor_INCLUDE_PATH AND X11_Xcursor_LIB)

  if (X11_Xscreensaver_INCLUDE_PATH)
     set(X11_Xscreensaver_FOUND TRUE)
     set(X11_INCLUDE_DIR ${X11_INCLUDE_DIR} ${X11_Xscreensaver_INCLUDE_PATH})
  endif (X11_Xscreensaver_INCLUDE_PATH)

  if (X11_dpms_INCLUDE_PATH)
     set(X11_dpms_FOUND TRUE)
     set(X11_INCLUDE_DIR ${X11_INCLUDE_DIR} ${X11_dpms_INCLUDE_PATH})
  endif (X11_dpms_INCLUDE_PATH)

  if (X11_Xkb_INCLUDE_PATH AND X11_Xkblib_INCLUDE_PATH AND X11_Xlib_INCLUDE_PATH)
     set(X11_Xkb_FOUND TRUE)
     set(X11_INCLUDE_DIR ${X11_INCLUDE_DIR} ${X11_Xkb_INCLUDE_PATH} )
  endif (X11_Xkb_INCLUDE_PATH AND X11_Xkblib_INCLUDE_PATH AND X11_Xlib_INCLUDE_PATH)

  if (X11_Xinput_INCLUDE_PATH AND X11_Xinput_LIB)
     set(X11_Xinput_FOUND TRUE)
     set(X11_INCLUDE_DIR ${X11_INCLUDE_DIR} ${X11_Xinput_INCLUDE_PATH})
  endif (X11_Xinput_INCLUDE_PATH AND X11_Xinput_LIB)

  # Deprecated variable for backwards compatibility with CMake 1.4
  if (X11_X11_INCLUDE_PATH)
    if (X11_LIBRARIES)
      set(X11_FOUND 1)
    endif (X11_LIBRARIES)
  endif (X11_X11_INCLUDE_PATH)

  set(X11_LIBRARY_DIR "")
  if (X11_X11_LIB)
    GET_FILENAME_COMPONENT(X11_LIBRARY_DIR ${X11_X11_LIB} PATH)
  endif (X11_X11_LIB)

  if (X11_FOUND)
    INCLUDE(CheckFunctionExists)
    INCLUDE(CheckLibraryExists)

    # Translated from an autoconf-generated configure script.
    # See libs.m4 in autoconf's m4 directory.
    if ($ENV{ISC} MATCHES "^yes$")
      set(X11_X_EXTRA_LIBS -lnsl_s -linet)
    else ($ENV{ISC} MATCHES "^yes$")
      set(X11_X_EXTRA_LIBS "")

      # See if XOpenDisplay in X11 works by itself.
      CHECK_LIBRARY_EXISTS("${X11_LIBRARIES}" "XOpenDisplay" "${X11_LIBRARY_DIR}" X11_LIB_X11_SOLO)
      if (NOT X11_LIB_X11_SOLO)
        # Find library needed for dnet_ntoa.
        CHECK_LIBRARY_EXISTS("dnet" "dnet_ntoa" "" X11_LIB_DNET_HAS_DNET_NTOA) 
        if (X11_LIB_DNET_HAS_DNET_NTOA)
          set(X11_X_EXTRA_LIBS ${X11_X_EXTRA_LIBS} -ldnet)
        else (X11_LIB_DNET_HAS_DNET_NTOA)
          CHECK_LIBRARY_EXISTS("dnet_stub" "dnet_ntoa" "" X11_LIB_DNET_STUB_HAS_DNET_NTOA) 
          if (X11_LIB_DNET_STUB_HAS_DNET_NTOA)
            set(X11_X_EXTRA_LIBS ${X11_X_EXTRA_LIBS} -ldnet_stub)
          endif (X11_LIB_DNET_STUB_HAS_DNET_NTOA)
        endif (X11_LIB_DNET_HAS_DNET_NTOA)
      endif (NOT X11_LIB_X11_SOLO)

      # Find library needed for gethostbyname.
      CHECK_FUNCTION_EXISTS("gethostbyname" CMAKE_HAVE_GETHOSTBYNAME)
      if (NOT CMAKE_HAVE_GETHOSTBYNAME)
        CHECK_LIBRARY_EXISTS("nsl" "gethostbyname" "" CMAKE_LIB_NSL_HAS_GETHOSTBYNAME) 
        if (CMAKE_LIB_NSL_HAS_GETHOSTBYNAME)
          set(X11_X_EXTRA_LIBS ${X11_X_EXTRA_LIBS} -lnsl)
        else (CMAKE_LIB_NSL_HAS_GETHOSTBYNAME)
          CHECK_LIBRARY_EXISTS("bsd" "gethostbyname" "" CMAKE_LIB_BSD_HAS_GETHOSTBYNAME) 
          if (CMAKE_LIB_BSD_HAS_GETHOSTBYNAME)
            set(X11_X_EXTRA_LIBS ${X11_X_EXTRA_LIBS} -lbsd)
          endif (CMAKE_LIB_BSD_HAS_GETHOSTBYNAME)
        endif (CMAKE_LIB_NSL_HAS_GETHOSTBYNAME)
      endif (NOT CMAKE_HAVE_GETHOSTBYNAME)

      # Find library needed for connect.
      CHECK_FUNCTION_EXISTS("connect" CMAKE_HAVE_CONNECT)
      if (NOT CMAKE_HAVE_CONNECT)
        CHECK_LIBRARY_EXISTS("socket" "connect" "" CMAKE_LIB_SOCKET_HAS_CONNECT) 
        if (CMAKE_LIB_SOCKET_HAS_CONNECT)
          set(X11_X_EXTRA_LIBS -lsocket ${X11_X_EXTRA_LIBS})
        endif (CMAKE_LIB_SOCKET_HAS_CONNECT)
      endif (NOT CMAKE_HAVE_CONNECT)

      # Find library needed for remove.
      CHECK_FUNCTION_EXISTS("remove" CMAKE_HAVE_REMOVE)
      if (NOT CMAKE_HAVE_REMOVE)
        CHECK_LIBRARY_EXISTS("posix" "remove" "" CMAKE_LIB_POSIX_HAS_REMOVE) 
        if (CMAKE_LIB_POSIX_HAS_REMOVE)
          set(X11_X_EXTRA_LIBS ${X11_X_EXTRA_LIBS} -lposix)
        endif (CMAKE_LIB_POSIX_HAS_REMOVE)
      endif (NOT CMAKE_HAVE_REMOVE)

      # Find library needed for shmat.
      CHECK_FUNCTION_EXISTS("shmat" CMAKE_HAVE_SHMAT)
      if (NOT CMAKE_HAVE_SHMAT)
        CHECK_LIBRARY_EXISTS("ipc" "shmat" "" CMAKE_LIB_IPS_HAS_SHMAT) 
        if (CMAKE_LIB_IPS_HAS_SHMAT)
          set(X11_X_EXTRA_LIBS ${X11_X_EXTRA_LIBS} -lipc)
        endif (CMAKE_LIB_IPS_HAS_SHMAT)
      endif (NOT CMAKE_HAVE_SHMAT)
    endif ($ENV{ISC} MATCHES "^yes$")

    CHECK_LIBRARY_EXISTS("ICE" "IceConnectionNumber" "${X11_LIBRARY_DIR}"
                         CMAKE_LIB_ICE_HAS_ICECONNECTIONNUMBER)
    if (CMAKE_LIB_ICE_HAS_ICECONNECTIONNUMBER)
      set(X11_X_PRE_LIBS -lSM -lICE)
    endif (CMAKE_LIB_ICE_HAS_ICECONNECTIONNUMBER)
    # Build the final list of libraries.
    set(X11_LIBRARIES ${X11_X_PRE_LIBS} ${X11_LIBRARIES} ${X11_X_EXTRA_LIBS})
  endif (X11_FOUND)

  MARK_AS_ADVANCED(
    X11_X11_INCLUDE_PATH
    X11_X11_LIB
    X11_Xext_LIB
    X11_Xau_LIB
    X11_Xlib_INCLUDE_PATH
    X11_Xutil_INCLUDE_PATH
    X11_Xcomposite_INCLUDE_PATH
    X11_Xcomposite_LIB
    X11_Xaccess_INCLUDE_PATH
    X11_Xfixes_LIB
    X11_Xfixes_INCLUDE_PATH
    X11_Xrandr_LIB
    X11_Xrandr_INCLUDE_PATH
    X11_Xdamage_LIB
    X11_Xdamage_INCLUDE_PATH
    X11_Xrender_LIB
    X11_Xrender_INCLUDE_PATH
    X11_Xxf86misc_LIB
    X11_Xxf86misc_INCLUDE_PATH
    X11_Xinerama_LIB
    X11_Xinerama_INCLUDE_PATH
    X11_XTest_LIB
    X11_XTest_INCLUDE_PATH
    X11_Xcursor_LIB
    X11_Xcursor_INCLUDE_PATH
    X11_dpms_INCLUDE_PATH
    X11_Xt_LIB
    X11_Xss_LIB
    X11_Xdmcp_LIB
    X11_LIBRARIES
    X11_Xaccessrules_INCLUDE_PATH
    X11_Xaccessstr_INCLUDE_PATH
    X11_Xdmcp_INCLUDE_PATH
    X11_Xf86misc_INCLUDE_PATH
    X11_Xkb_INCLUDE_PATH
    X11_Xkblib_INCLUDE_PATH
    X11_Xscreensaver_INCLUDE_PATH
	X11_Xpm_INCLUDE_PATH
	X11_Xpm_LIB
    X11_Xinput_LIB
    X11_Xinput_INCLUDE_PATH
	X11_Xft_LIB
	X11_Xft_INCLUDE_PATH
	X11_Xshape_INCLUDE_PATH
    X11_Xv_LIB
    X11_Xv_INCLUDE_PATH
  )

endif (UNIX)
