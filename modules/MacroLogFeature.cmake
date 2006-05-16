# This file defines two macros:
# MACRO_LOG_FEATURE(VAR FEATURE DESCRIPTION URL)
# Logs the information so that it can be displayed at the end
# of the configure run
# VAR : variable which is TRUE or FALSE indicating whether the feature is supported
# FEATURE: name of the feature, e.g. "libjpeg"
# DESCRIPTION: description what this feature provides
# URL: home page
#
# MACRO_DISPLAY_FEATURE_LOG()
# Call this at the end of the toplevel CMakeLists.txt to display the collected results
#
# Example:
#
# INCLUDE(MacroLogFeature)
#
# FIND_PACKAGE(JPEG)
# MACRO_LOG_FEATURE(JPEG_FOUND "libjpeg" "Support JPEG images" "http://www.ijg.org")
# ...
# MACRO_DISPLAY_FEATURE_LOG()



MACRO(MACRO_LOG_FEATURE _var _package _description _url)

   IF (NOT EXISTS "${CMAKE_BINARY_DIR}/EnabledFeatures.txt")
      FILE(WRITE "${CMAKE_BINARY_DIR}/EnabledFeatures.txt" "\n")
   ENDIF (NOT EXISTS "${CMAKE_BINARY_DIR}/EnabledFeatures.txt")

   IF (NOT EXISTS "${CMAKE_BINARY_DIR}/DisabledFeatures.txt")
      FILE(WRITE "${CMAKE_BINARY_DIR}/DisabledFeatures.txt" "\n")
   ENDIF (NOT EXISTS "${CMAKE_BINARY_DIR}/DisabledFeatures.txt")


   IF (${_var})
      SET(_LOGFILENAME ${CMAKE_BINARY_DIR}/EnabledFeatures.txt )
   ELSE (${_var})
      SET(_LOGFILENAME ${CMAKE_BINARY_DIR}/DisabledFeatures.txt)
   ENDIF (${_var})

   FILE(APPEND "${_LOGFILENAME}" "PACKAGE: ${_package}\nDESCRIPTION: ${_description}\nURL: ${_url}\n\n")

ENDMACRO(MACRO_LOG_FEATURE)


MACRO(MACRO_DISPLAY_FEATURE_LOG)
   IF (EXISTS "${CMAKE_BINARY_DIR}/EnabledFeatures.txt")
      FILE(READ ${CMAKE_BINARY_DIR}/EnabledFeatures.txt _features)
      MESSAGE(STATUS "Enabled features:\n${_features}")
      FILE(REMOVE ${CMAKE_BINARY_DIR}/EnabledFeatures.txt)
   ENDIF (EXISTS "${CMAKE_BINARY_DIR}/EnabledFeatures.txt")

   IF (EXISTS "${CMAKE_BINARY_DIR}/DisabledFeatures.txt")
      FILE(READ ${CMAKE_BINARY_DIR}/DisabledFeatures.txt _features)
      MESSAGE(STATUS "Disabled features:\n${_features}")
      FILE(REMOVE ${CMAKE_BINARY_DIR}/DisabledFeatures.txt)
   ENDIF (EXISTS "${CMAKE_BINARY_DIR}/DisabledFeatures.txt")
ENDMACRO(MACRO_DISPLAY_FEATURE_LOG)
