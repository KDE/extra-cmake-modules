# Option for build or not MusicBrainz
#
# Copyright (c) 2006,2007 Laurent Montel, <montel@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.



if(MUSICBRAINZ_INCLUDE_DIR AND MUSICBRAINZ_LIBRARIES)
   set(MUSICBRAINZ_FIND_QUIETLY TRUE)
endif(MUSICBRAINZ_INCLUDE_DIR AND MUSICBRAINZ_LIBRARIES)

FIND_PATH(MUSICBRAINZ_INCLUDE_DIR musicbrainz/musicbrainz.h)

FIND_LIBRARY( MUSICBRAINZ_LIBRARIES NAMES musicbrainz)


include(FindPackageHandleStandardArgs)
find_package_handle_standard_args( MusicBrainz DEFAULT_MSG
                                   MUSICBRAINZ_INCLUDE_DIR MUSICBRAINZ_LIBRARIES)

MARK_AS_ADVANCED(MUSICBRAINZ_INCLUDE_DIR MUSICBRAINZ_LIBRARIES)

