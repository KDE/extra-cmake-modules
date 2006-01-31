# - OPTIONAL_FIND_PACKAGE() combines FIND_PACKAGE() with an OPTION()
# OPTIONAL_FIND_PACKAGE( <name> [QUIT] )
# This macro is a combination of OPTION() and FIND_PACKAGE(), it
# works like FIND_PACKAGE(), but additionally it automatically creates
# an option name WITH_<name>, which can be disabled via the cmake GUI.
# or via -DWITH_<name>=OFF
# The standard <name>_FOUND variables can be used in the same way
# as when using the normal FIND_PACKAGE()

MACRO(OPTIONAL_FIND_PACKAGE _name )
   OPTION(WITH_${_name} "Search for ${_name} package" ON)
   IF (WITH_${_name})
      FIND_PACKAGE(${_name} ${ARGN})
   ENDIF (WITH_${_name})
ENDMACRO(OPTIONAL_FIND_PACKAGE)

