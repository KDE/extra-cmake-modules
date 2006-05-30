# Option for build or not MusicBrainz
# Laurent Montel <montel@kde.org> 2006

FIND_PATH(MUSICBRAINZ_INCLUDE_DIR musicbrainz/musicbrainz.h
	/usr/include
	/usr/local/include
	)

if(MUSICBRAINZ_INCLUDE_DIR)
   set(MUSICBRAINZ_FOUND TRUE)
   MESSAGE( STATUS "music brainz found in <${MUSICBRAINZ_INCLUDE_DIR}>")
else(MUSICBRAINZ_INCLUDE_DIR)
   MESSAGE( STATUS "music brainz not found")
endif(MUSICBRAINZ_INCLUDE_DIR)

MARK_AS_ADVANCED(MUSICBRAINZ_INCLUDE_DIR)

