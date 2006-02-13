# - Try to find the KDEWIN32 library
# Once done this will define
#
#  KDEWIN32_FOUND - system has KDEWIN32
#  KDEWIN32_INCLUDES - the KDEWIN32 include directories
#  KDEWIN32_LIBRARIES - The libraries needed to use KDEWIN32

IF (WIN32)

INCLUDE(MacroGetenvWinPath)

MACRO_GETENV_WIN_PATH(_program_FILES_DIR PROGRAMFILES)

FIND_PACKAGE(Qt4 REQUIRED)

FIND_PATH(KDEWIN32_INCLUDE_DIR winposix_export.h
   ${_program_FILES_DIR}/kdewin32/include
)


# at first find the kdewin32 library, this has to be compiled and installed before kdelibs/
# search for kdewin32 in the default install directory for applications (default of (n)make install)
FIND_LIBRARY(KDEWIN32_LIBRARY NAMES kdewin32
   PATHS
   ${_program_FILES_DIR}/kdewin32/lib
)


# kdelibs/win/ has to be built before the rest of kdelibs/
# eventually it will be moved out from kdelibs/
IF (KDEWIN32_LIBRARY AND KDEWIN32_INCLUDE_DIR)
   SET(KDEWIN32_FOUND TRUE)
   # add the winsock2 library, using find_library or something like this would probably be better
   SET(KDEWIN32_LIBRARIES ${KDEWIN32_LIBRARY} user32 shell32 ws2_32)

   IF(MINGW)
      #mingw compiler
      SET(KDEWIN32_INCLUDES ${KDEWIN32_INCLUDE_DIR} ${KDEWIN32_INCLUDE_DIR}/mingw ${QT_INCLUDES})
   ELSE(MINGW)
      # msvc compiler
      # add the MS SDK include directory if available
      MACRO_GETENV_WIN_PATH(MSSDK_DIR MSSDK)
      SET(KDEWIN32_INCLUDES ${KDEWIN32_INCLUDE_DIR} ${KDEWIN32_INCLUDE_DIR}/msvc  ${QT_INCLUDES} ${MSSDK_DIR})
   ENDIF(MINGW)
   
ENDIF (KDEWIN32_LIBRARY AND KDEWIN32_INCLUDE_DIR)

IF (KDEWIN32_FOUND)
   IF (NOT KDEWIN32_FIND_QUIETLY)
      MESSAGE(STATUS "Found KDEWIN32: ${KDEWIN32_LIBRARY}")
   ENDIF (NOT KDEWIN32_FIND_QUIETLY)
ELSE (KDEWIN32_FOUND)
   IF (KDEWIN32_FIND_REQUIRED)
      MESSAGE(SEND_ERROR "Could not find KDEWIN32 library\nPlease build and install kdelibs/win/ first")
   ENDIF (KDEWIN32_FIND_REQUIRED)
ENDIF (KDEWIN32_FOUND)

ENDIF (WIN32)
