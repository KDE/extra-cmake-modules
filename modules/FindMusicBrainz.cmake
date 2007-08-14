# Option for build or not MusicBrainz
#
# Copyright (c) 2006, Laurent Montel, <montel@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.


FIND_PATH(MUSICBRAINZ_INCLUDE_DIR musicbrainz/musicbrainz.h)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args( MusicBrainz DEFAULT_MSG
                                   MUSICBRAINZ_INCLUDE_DIR)

MARK_AS_ADVANCED(MUSICBRAINZ_INCLUDE_DIR)

