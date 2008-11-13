# - Try to find QCA2 (Qt Cryptography Architecture 2)
# Once done this will define
#
#  QCA2_FOUND - system has QCA2
#  QCA2_INCLUDE_DIR - the QCA2 include directory
#  QCA2_LIBRARIES - the libraries needed to use QCA2
#  QCA2_DEFINITIONS - Compiler switches required for using QCA2
#
# use pkg-config to get the directories and then use these values
# in the FIND_PATH() and FIND_LIBRARY() calls

# Copyright (c) 2006, Michael Larouche, <michael.larouche@kdemail.net>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

include(FindLibraryWithDebug)

if (QCA2_INCLUDE_DIR AND QCA2_LIBRARIES)

  # in cache already
  set(QCA2_FOUND TRUE)

else (QCA2_INCLUDE_DIR AND QCA2_LIBRARIES)


  if (NOT WIN32)
    find_package(PkgConfig)
    pkg_check_modules(QCA2 qca2)

    set(QCA2_DEFINITIONS ${QCA2_CFLAGS})

    # If pkgconfig found QCA2, get the full path to the library using find_library()
    # but only in the path reported by pkgconfig.
    # Otherwise do a normal search.
    if(QCA2_FOUND)
       set(QCA2_INCLUDE_DIR ${QCA2_INCLUDEDIR})
       find_library(QCA2_LIBRARIES NAMES qca
                    PATHS
                    ${QCA2_LIBRARY_DIRS}
                    NO_DEFAULT_PATH
                    )
    else(QCA2_FOUND)
       find_library(QCA2_LIBRARIES NAMES qca )
       find_path(QCA2_INCLUDE_DIR qca.h PATH_SUFFIXES QtCrypto)
    endif(QCA2_FOUND)

  else (NOT WIN32)
    find_library_with_debug(QCA2_LIBRARIES
                    WIN32_DEBUG_POSTFIX d
                    NAMES qca)

    find_path(QCA2_INCLUDE_DIR qca.h PATH_SUFFIXES QtCrypto)
  endif (NOT WIN32)

   include(FindPackageHandleStandardArgs)
   find_package_handle_standard_args(QCA2  DEFAULT_MSG  QCA2_LIBRARIES QCA2_INCLUDE_DIR)

  mark_as_advanced(QCA2_INCLUDE_DIR QCA2_LIBRARIES)

endif (QCA2_INCLUDE_DIR AND QCA2_LIBRARIES)
