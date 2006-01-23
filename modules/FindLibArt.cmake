INCLUDE(UsePkgConfig)

# use pkg-config to get the directories and then use these values
# in the FIND_PATH() and FIND_LIBRARY() calls
PKGCONFIG(libart-2.0 _libArtIncDir _libArtLinkDir _libArtLinkFlags _libArtCflags)

SET(LIBART_DEFINITIONS ${_libArtCflags})

FIND_PATH(LIBART_INCLUDE_DIR libart_lgpl/libart.h
${_libArtIncDir}/libart-2.0
/usr/include/libart-2.0
/usr/local/include/libart-2.0
)

FIND_LIBRARY(LIBART_LIBRARY NAMES art_lgpl_2
PATHS
${_libArtLinkDir}
/usr/lib
/usr/local/lib
)


IF(LIBART_INCLUDE_DIR AND LIBART_LIBRARY)
   SET(LIBART_FOUND TRUE)
ENDIF(LIBART_INCLUDE_DIR AND LIBART_LIBRARY)


IF(LIBART_FOUND)
   IF(NOT LibArt_FIND_QUIETLY)
      MESSAGE(STATUS "Found libart: ${LIBART_LIBRARY}")
   ENDIF(NOT LibArt_FIND_QUIETLY)
ELSE(LIBART_FOUND)
   IF(LibArt_FIND_REQUIRED)
      MESSAGE(SEND_ERROR "Could not find libart")
   ENDIF(LibArt_FIND_REQUIRED)
ENDIF(LIBART_FOUND)
