# - Find LibLZMA
# Find LibLZMA headers and library
#
#  LIBLZMA_FOUND             - True if liblzma is found.
#  LIBLZMA_INCLUDE_DIRS      - Directory where liblzma headers are located.
#  LIBLZMA_LIBRARIES         - Lzma libraries to link against.
#  LIBLZMA_HAS_AUTO_DECODER  - True if lzma_auto_decoder() is found (required).
#  LIBLZMA_HAS_EASY_ENCODER  - True if lzma_easy_encoder() is found (required).
#  LIBLZMA_HAS_LZMA_PRESET   - True if lzma_lzma_preset() is found (required).


# Copyright (c) 2008, Per Øyvind Karlsen, <peroyvind@mandriva.org>
# Copyright (c) 2009, Alexander Neundorf, <neundorf@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.


FIND_PATH(LIBLZMA_INCLUDE_DIR lzmadec.h )
FIND_LIBRARY(LIBLZMA_LIBRARY lzmadec)

SET(LIBLZMA_LIBRARIES ${LIBLZMA_LIBRARY})
SET(LIBLZMA_INCLUDE_DIRS ${LIBLZMA_INCLUDE_DIR})


# what's up with the following tests ?
# I downloaded, built and installed the lzma-4.32.7 source package directly 
# from http://tukaani.org/lzma/download and they resulting library doesn't have 
# these symbols. Also "grep -R auto_decoder *"  gives no results.
# Where should they come frome ? Alex
IF (LIBLZMA_LIBRARIES)
   INCLUDE(CheckLibraryExists)
   CHECK_LIBRARY_EXISTS(${LIBLZMA_LIBRARIES} lzma_auto_decoder "" LIBLZMA_HAS_AUTO_DECODER)
   CHECK_LIBRARY_EXISTS(${LIBLZMA_LIBRARIES} lzma_easy_encoder "" LIBLZMA_HAS_EASY_ENCODER)
   CHECK_LIBRARY_EXISTS(${LIBLZMA_LIBRARIES} lzma_lzma_preset "" LIBLZMA_HAS_LZMA_PRESET)
ENDIF (LIBLZMA_LIBRARIES)

INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(LIBLZMA  DEFAULT_MSG  LIBLZMA_INCLUDE_DIR 
                                                        LIBLZMA_LIBRARY
                                                        LIBLZMA_HAS_AUTO_DECODER
                                                        LIBLZMA_HAS_EASY_ENCODER
                                                        LIBLZMA_HAS_LZMA_PRESET
                                 )

MARK_AS_ADVANCED( LIBLZMA_INCLUDE_DIR LIBLZMA_LIBRARY )
