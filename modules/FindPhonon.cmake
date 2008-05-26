# Find libphonon
# Once done this will define
#
#  PHONON_FOUND    - system has Phonon Library
#  PHONON_INCLUDES - the Phonon include directory
#  PHONON_LIBS     - link these to use Phonon

# Copyright (c) 2008, Matthias Kretz <kretz@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

if(PHONON_FOUND)
   # Already found, nothing more to do
else(PHONON_FOUND)
   if(PHONON_INCLUDE_DIR AND PHONON_LIBRARY)
      set(PHONON_FIND_QUIETLY TRUE)
   endif(PHONON_INCLUDE_DIR AND PHONON_LIBRARY)

   find_library(PHONON_LIBRARY NAMES phonon PATHS ${KDE4_LIB_INSTALL_DIR} ${QT_LIBRARY_DIR} ${LIB_INSTALL_DIR} NO_DEFAULT_PATH)
   set(PHONON_LIBS ${phonon_LIB_DEPENDS} ${PHONON_LIBRARY})

   find_path(PHONON_INCLUDE_DIR NAMES phonon/phonon_export.h PATHS ${KDE4_INCLUDE_DIR} ${QT_INCLUDE_DIR} ${INCLUDE_INSTALL_DIR} NO_DEFAULT_PATH)
   mark_as_advanced(PHONON_INCLUDE_DIR PHONON_LIBRARY)

   set(PHONON_INCLUDES ${PHONON_INCLUDE_DIR}/KDE ${PHONON_INCLUDE_DIR})
   message(STATUS "Found Phonon: ${PHONON_LIBRARY})
endif(PHONON_FOUND)
