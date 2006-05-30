# - Try to find the freetype library
# Once done this defines
#
#  LIBUSB_FOUND - system has libusb
#  LIBUSB_INCLUDE_DIR - the libusb include directory
#  LIBUSB_LIBRARIES - Link these to use libusb

if (LIBUSB_INCLUDE_DIR AND LIBUSB_LIBRARIES)

  # in cache already
  set(LIBUSB_FOUND TRUE)

else (LIBUSB_INCLUDE_DIR AND LIBUSB_LIBRARIES)

  # use pkg-config to get the directories and then use these values
  # in the FIND_PATH() and FIND_LIBRARY() calls
  INCLUDE(UsePkgConfig)

  PKGCONFIG(libUSB _libUSBIncDir _libUSBLinkDir _libUSBLinkFlags _libUSBCflags)

  FIND_PATH(LIBUSB_INCLUDE_DIR usb.h
    /usr/include
    /usr/local/include
  )

  FIND_LIBRARY(LIBUSB_LIBRARY NAMES usb 
    PATHS
    ${_libUSBLinkDir}
    /usr/lib
    /usr/local/lib
  )

  set( LIBUSB_LIBRARIES ${LIBUSB_LIBRARY} CACHE INTERNAL "The libraries for libusb" )

  if (LIBUSB_INCLUDE_DIR AND LIBUSB_LIBRARIES)
     set( LIBUSB_FOUND TRUE)
  endif (LIBUSB_INCLUDE_DIR AND LIBUSB_LIBRARIES)

  if (LIBUSB_FOUND)
    if (NOT libUSB_FIND_QUIETLY)
      message(STATUS "Found LIBUSB: ${LIBUSB_LIBRARIES}")
    endif (NOT libUSB_FIND_QUIETLY)
  else (LIBUSB_FOUND)
    if (libUSB_FIND_REQUIRED)
      message(FATAL_ERROR "Could NOT find LIBUSB")
    endif (libUSB_FIND_REQUIRED)
  endif (LIBUSB_FOUND)

  MARK_AS_ADVANCED(
     LIBUSB_INCLUDE_DIR LIBUSB_LIBRARIES 
  )

endif (LIBUSB_INCLUDE_DIR AND LIBUSB_LIBRARIES)
