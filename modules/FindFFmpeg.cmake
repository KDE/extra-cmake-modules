# - Try to find ffmpeg
# Once done this will define
#
#  FFMPEG_FOUND - system has ffmpeg
#  FFMPEG_LIBRARIES - Link these to use ffmpeg
#  FFMPEG_DEFINITIONS - Compiler switches required for using ffmpeg

# Copyright (c) 2006, Matthias Kretz, <kretz@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.


if (FFMPEG_LIBRARIES)# AND FFMPEG_DEFINITIONS)

  # in cache already
  set(FFMPEG_FOUND TRUE)

else (FFMPEG_LIBRARIES)# AND FFMPEG_DEFINITIONS)

if (NOT WIN32)
  # use pkg-config to get the directories and then use these values
  # in the FIND_PATH() and FIND_LIBRARY() calls
  include(UsePkgConfig)

  pkgconfig(libavcodec _FFMPEGIncDir _FFMPEGLinkDir _FFMPEGLinkFlags _FFMPEGCflags)
endif (NOT WIN32)
  #set(FFMPEG_DEFINITIONS ${_FFMPEGCflags})

  #
  # #include <libXXXX/XXXX.h> is the new style for FFMPEG headers
  # This has been verified at least since 0.4.9
  # Please do not change to the old format, since this will break for
  # people who are using newer versions. Instead, upgrade your ffmpeg
  # installation.
  #
  find_path(FFMPEG_INCLUDE_DIR libavcodec/avcodec.h
    PATHS
    ${_FFMPEGIncDir}
    NO_DEFAULT_PATH
  )

  # also search for the old style include dir, just for the purpose
  # of giving a useful error message if an old libavcodec is installed
  # and the user might wonder why it is not found
  find_path(FFMPEG_INCLUDE_DIR_OLD_STYLE ffmpeg/avcodec.h
    PATHS
    ${_FFMPEGIncDir}
    NO_DEFAULT_PATH
  )

  find_library(AVCODEC_LIBRARIES NAMES avcodec
    PATHS
    ${_FFMPEGLinkDir}
    NO_DEFAULT_PATH
  )

  find_library(AVFORMAT_LIBRARIES NAMES avformat
    PATHS
    ${_FFMPEGLinkDir}
    NO_DEFAULT_PATH
  )

  find_library(AVUTIL_LIBRARIES NAMES avutil
    PATHS
    ${_FFMPEGLinkDir}
    NO_DEFAULT_PATH
  )

  set(FFMPEG_LIBRARIES )
  if (AVCODEC_LIBRARIES)
    set(FFMPEG_LIBRARIES ${FFMPEG_LIBRARIES} ${AVCODEC_LIBRARIES})
  endif (AVCODEC_LIBRARIES)

  if (AVFORMAT_LIBRARIES)
    set(FFMPEG_LIBRARIES ${FFMPEG_LIBRARIES} ${AVFORMAT_LIBRARIES})
  endif (AVFORMAT_LIBRARIES)

  if (AVUTIL_LIBRARIES)
    set(FFMPEG_LIBRARIES ${FFMPEG_LIBRARIES} ${AVUTIL_LIBRARIES})
  endif (AVUTIL_LIBRARIES)

  if (FFMPEG_LIBRARIES  AND  FFMPEG_INCLUDE_DIR)
     set(FFMPEG_FOUND TRUE)
  endif (FFMPEG_LIBRARIES  AND  FFMPEG_INCLUDE_DIR)

  if (FFMPEG_FOUND)
    if (NOT FFmpeg_FIND_QUIETLY)
      message(STATUS "Found FFMPEG: ${FFMPEG_LIBRARIES} ${FFMPEG_INCLUDE_DIR}")
    endif (NOT FFmpeg_FIND_QUIETLY)
  else (FFMPEG_FOUND)
    # only an old libavcodec was found ?
    if (FFMPEG_INCLUDE_DIR_OLD_STYLE  AND NOT  FFMPEG_INCLUDE_DIR  AND NOT  FFmpeg_FIND_QUIETLY)
      message(STATUS "Found old version of libavcodec, but a newer version is required.")
    endif (FFMPEG_INCLUDE_DIR_OLD_STYLE  AND NOT  FFMPEG_INCLUDE_DIR  AND NOT  FFmpeg_FIND_QUIETLY)

    if (FFmpeg_FIND_REQUIRED)
      message(FATAL_ERROR "Could NOT find FFMPEG")
    else (FFmpeg_FIND_REQUIRED)
      if (NOT FFmpeg_FIND_QUIETLY)
        message(STATUS "Could NOT find FFMPEG")
      endif (NOT FFmpeg_FIND_QUIETLY)
    endif (FFmpeg_FIND_REQUIRED)
  endif (FFMPEG_FOUND)

  mark_as_advanced(AVCODEC_LIBRARIES 
                   AVFORMAT_LIBRARIES
                   AVUTIL_LIBRARIES
                   FFMPEG_INCLUDE_DIR
                   FFMPEG_INCLUDE_DIR_OLD_STYLE)

endif (FFMPEG_LIBRARIES)# AND FFMPEG_DEFINITIONS)
