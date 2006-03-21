# Try to find Gettext functionality
# Once done this will define
#
#  GETTEXT_FOUND - system has Gettext
#  GETTEXT_INCLUDE_DIR - Gettext include directory
#  GETTEXT_LIBRARIES - Libraries needed to use Gettext

# TODO: This will enable translations only if Gettext functionality is
# present in libc. Must have more robust system for release, where Gettext
# functionality can also reside in standalone Gettext library, or the one
# embedded within kdelibs (cf. gettext.m4 from Gettext source).

INCLUDE(CheckIncludeFiles)
check_include_files(libintl.h HAVE_LIBINTL_H)

set(GETTEXT_INCLUDE_DIR)
set(GETTEXT_LIBRARIES)

if (HAVE_LIBINTL_H)
   set(GETTEXT_FOUND TRUE)
   set(GETTEXT_SOURCE "built in libc (libintl.h present)")
endif (HAVE_LIBINTL_H)

# Check for libintl, and check that it provides libintl_dgettext.
FIND_LIBRARY(LIBINTL_LIBRARY NAMES intl libintl
   PATHS
   /usr/lib
   /usr/local/lib
)
CHECK_LIBRARY_EXISTS(${LIBINTL_LIBRARY} "libintl_dgettext" "" GETTEXT_LIBRARIES)

if (GETTEXT_FOUND)
   if (NOT Gettext_FIND_QUIETLY)
      message(STATUS "Found Gettext: ${GETTEXT_SOURCE}")
   endif (NOT Gettext_FIND_QUIETLY)
else (GETTEXT_FOUND)
   if (Gettext_FIND_REQUIRED)
      message(STATUS "Could NOT find Gettext")
   endif (Gettext_FIND_REQUIRED)
endif (GETTEXT_FOUND)

MARK_AS_ADVANCED(GETTEXT_INCLUDE_DIR GETTEXT_LIBRARIES)
