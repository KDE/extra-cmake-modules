# - MACRO_OPTIONAL_FIND_PACKAGE() combines FIND_PACKAGE() with an OPTION()
# MACRO_OPTIONAL_FIND_PACKAGE( <name> [QUIT] )
# This macro is a combination of OPTION() and FIND_PACKAGE(), it
# works like FIND_PACKAGE(), but additionally it automatically creates
# an option name WITH_<name>, which can be disabled via the cmake GUI.
# or via -DWITH_<name>=OFF
# The standard <name>_FOUND variables can be used in the same way
# as when using the normal FIND_PACKAGE()

MACRO(MACRO_OPTIONAL_FIND_PACKAGE _name )
   OPTION(WITH_${_name} "Search for ${_name} package" ON)
   IF (WITH_${_name})
      FIND_PACKAGE(${_name} ${ARGN})
   ELSE (WITH_${_name})
      SET(${_name}_FOUND)
      SET(${_name}_INCLUDE_DIR)
      SET(${_name}_INCLUDES)
      SET(${_name}_LIBRARY)
      SET(${_name}_LIBRARIES)
   ENDIF (WITH_${_name})
ENDMACRO(MACRO_OPTIONAL_FIND_PACKAGE)

