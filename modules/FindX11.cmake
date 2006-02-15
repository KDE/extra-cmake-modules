# - Find X11 installation
# Try to find X11 on UNIX systems. The following values are defined
#  X11_FOUND        - True if X11 is available
#  X11_INCLUDE_DIR  - include directories to use X11
#  X11_LIBRARIES    - link against these to use X11

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
  FIND_LIBRARY(X11_X11_LIB X11 ${X11_LIB_SEARCH_PATH})
  FIND_LIBRARY(X11_Xext_LIB Xext ${X11_LIB_SEARCH_PATH})

  if(X11_X11_INCLUDE_PATH)
    set(X11_INCLUDE_DIR ${X11_INCLUDE_DIR} ${X11_X11_INCLUDE_PATH})
  endif(X11_X11_INCLUDE_PATH)

  if(X11_Xlib_INCLUDE_PATH)
    set(X11_INCLUDE_DIR ${X11_INCLUDE_DIR} ${X11_Xlib_INCLUDE_PATH})
  endif(X11_Xlib_INCLUDE_PATH)

  if(X11_Xutil_INCLUDE_PATH)
    set(X11_INCLUDE_DIR ${X11_INCLUDE_DIR} ${X11_Xutil_INCLUDE_PATH})
  endif(X11_Xutil_INCLUDE_PATH)

  if(X11_X11_LIB)
    set(X11_LIBRARIES ${X11_LIBRARIES} ${X11_X11_LIB})
  endif(X11_X11_LIB)

  if(X11_Xext_LIB)
    set(X11_LIBRARIES ${X11_LIBRARIES} ${X11_Xext_LIB})
  endif(X11_Xext_LIB)

  # Deprecated variable for backwards compatibility with CMake 1.4
  if(X11_X11_INCLUDE_PATH)
    if(X11_LIBRARIES)
      set(X11_FOUND 1)
    endif(X11_LIBRARIES)
  endif(X11_X11_INCLUDE_PATH)

  set(X11_LIBRARY_DIR "")
  if(X11_X11_LIB)
    GET_FILENAME_COMPONENT(X11_LIBRARY_DIR ${X11_X11_LIB} PATH)
  endif(X11_X11_LIB)

  if(X11_FOUND)
    INCLUDE(CheckFunctionExists)
    INCLUDE(CheckLibraryExists)

    # Translated from an autoconf-generated configure script.
    # See libs.m4 in autoconf's m4 directory.
    if($ENV{ISC} MATCHES "^yes$")
      set(X11_X_EXTRA_LIBS -lnsl_s -linet)
    else($ENV{ISC} MATCHES "^yes$")
      set(X11_X_EXTRA_LIBS "")

      # See if XOpenDisplay in X11 works by itself.
      CHECK_LIBRARY_EXISTS("${X11_LIBRARIES}" "XOpenDisplay" "${X11_LIBRARY_DIR}" X11_LIB_X11_SOLO)
      if(not X11_LIB_X11_SOLO)
        # Find library needed for dnet_ntoa.
        CHECK_LIBRARY_EXISTS("dnet" "dnet_ntoa" "" X11_LIB_DNET_HAS_DNET_NTOA) 
        if (X11_LIB_DNET_HAS_DNET_NTOA)
          set (X11_X_EXTRA_LIBS ${X11_X_EXTRA_LIBS} -ldnet)
        else (X11_LIB_DNET_HAS_DNET_NTOA)
          CHECK_LIBRARY_EXISTS("dnet_stub" "dnet_ntoa" "" X11_LIB_DNET_STUB_HAS_DNET_NTOA) 
          if (X11_LIB_DNET_STUB_HAS_DNET_NTOA)
            set (X11_X_EXTRA_LIBS ${X11_X_EXTRA_LIBS} -ldnet_stub)
          endif (X11_LIB_DNET_STUB_HAS_DNET_NTOA)
        endif (X11_LIB_DNET_HAS_DNET_NTOA)
      endif(not X11_LIB_X11_SOLO)

      # Find library needed for gethostbyname.
      CHECK_FUNCTION_EXISTS("gethostbyname" CMAKE_HAVE_GETHOSTBYNAME)
      if(not CMAKE_HAVE_GETHOSTBYNAME)
        CHECK_LIBRARY_EXISTS("nsl" "gethostbyname" "" CMAKE_LIB_NSL_HAS_GETHOSTBYNAME) 
        if (CMAKE_LIB_NSL_HAS_GETHOSTBYNAME)
          set (X11_X_EXTRA_LIBS ${X11_X_EXTRA_LIBS} -lnsl)
        else (CMAKE_LIB_NSL_HAS_GETHOSTBYNAME)
          CHECK_LIBRARY_EXISTS("bsd" "gethostbyname" "" CMAKE_LIB_BSD_HAS_GETHOSTBYNAME) 
          if (CMAKE_LIB_BSD_HAS_GETHOSTBYNAME)
            set (X11_X_EXTRA_LIBS ${X11_X_EXTRA_LIBS} -lbsd)
          endif (CMAKE_LIB_BSD_HAS_GETHOSTBYNAME)
        endif (CMAKE_LIB_NSL_HAS_GETHOSTBYNAME)
      endif(not CMAKE_HAVE_GETHOSTBYNAME)

      # Find library needed for connect.
      CHECK_FUNCTION_EXISTS("connect" CMAKE_HAVE_CONNECT)
      if(not CMAKE_HAVE_CONNECT)
        CHECK_LIBRARY_EXISTS("socket" "connect" "" CMAKE_LIB_SOCKET_HAS_CONNECT) 
        if (CMAKE_LIB_SOCKET_HAS_CONNECT)
          set (X11_X_EXTRA_LIBS -lsocket ${X11_X_EXTRA_LIBS})
        endif (CMAKE_LIB_SOCKET_HAS_CONNECT)
      endif(not CMAKE_HAVE_CONNECT)

      # Find library needed for remove.
      CHECK_FUNCTION_EXISTS("remove" CMAKE_HAVE_REMOVE)
      if(not CMAKE_HAVE_REMOVE)
        CHECK_LIBRARY_EXISTS("posix" "remove" "" CMAKE_LIB_POSIX_HAS_REMOVE) 
        if (CMAKE_LIB_POSIX_HAS_REMOVE)
          set (X11_X_EXTRA_LIBS ${X11_X_EXTRA_LIBS} -lposix)
        endif (CMAKE_LIB_POSIX_HAS_REMOVE)
      endif(not CMAKE_HAVE_REMOVE)

      # Find library needed for shmat.
      CHECK_FUNCTION_EXISTS("shmat" CMAKE_HAVE_SHMAT)
      if(not CMAKE_HAVE_SHMAT)
        CHECK_LIBRARY_EXISTS("ipc" "shmat" "" CMAKE_LIB_IPS_HAS_SHMAT) 
        if (CMAKE_LIB_IPS_HAS_SHMAT)
          set (X11_X_EXTRA_LIBS ${X11_X_EXTRA_LIBS} -lipc)
        endif (CMAKE_LIB_IPS_HAS_SHMAT)
      endif(not CMAKE_HAVE_SHMAT)
    endif($ENV{ISC} MATCHES "^yes$")

    CHECK_LIBRARY_EXISTS("ICE" "IceConnectionNumber" "${X11_LIBRARY_DIR}"
                         CMAKE_LIB_ICE_HAS_ICECONNECTIONNUMBER)
    if(CMAKE_LIB_ICE_HAS_ICECONNECTIONNUMBER)
      set (X11_X_PRE_LIBS -lSM -lICE)
    endif(CMAKE_LIB_ICE_HAS_ICECONNECTIONNUMBER)
    # Build the final list of libraries.
    set (X11_LIBRARIES ${X11_X_PRE_LIBS} ${X11_LIBRARIES} ${X11_X_EXTRA_LIBS})
  endif(X11_FOUND)

  MARK_AS_ADVANCED(
    X11_X11_INCLUDE_PATH
    X11_X11_LIB
    X11_Xext_LIB
    X11_Xlib_INCLUDE_PATH
    X11_Xutil_INCLUDE_PATH
    X11_LIBRARIES
    )

endif (UNIX)
