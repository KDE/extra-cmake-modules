# cmake macro to see if we have kdemultimedia installed

# KDEMULTIMEDIA_INCLUDE_DIR
# KDEMULTIMEDIA_FOUND
# Copyright (C) 2007 Laurent Montel <montel@kde.org>
# Copyright (C) 2007 Gerd Fleischer <gerdfleischer@web.de>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.


if (KDEMULTIMEDIA_INCLUDE_DIR)
    # Already in cache, be silent
    set(KDEMULTIMEDIA_FOUND TRUE)
endif (KDEMULTIMEDIA_INCLUDE_DIR)


find_path(KDEMULTIMEDIA_INCLUDE_DIR NAMES libkcddb/kcddb.h libkcompactdisc/kcompactdisc.h
    PATHS
    ${INCLUDE_INSTALL_DIR}
)

find_library(KCDDB_LIBRARY NAMES kcddb
    PATHS
    ${LIB_INSTALL_DIR}
)

find_library(KCOMPACTDISC_LIBRARY NAMES kcompactdisc
    PATHS
    ${LIB_INSTALL_DIR}
)

# audioencoder, audiocdplugins?

set(KDEMULTIMEDIA_LIBRARIES ${KCDDB_LIBRARY} ${KCOMPACTDISC_LIBRARY})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(KdeMultimedia DEFAULT_MSG KDEMULTIMEDIA_LIBRARIES KDEMULTIMEDIA_INCLUDE_DIR )

mark_as_advanced(KDEMULTIMEDIA_INCLUDE_DIR KDEMULTIMEDIA_LIBRARIES)

