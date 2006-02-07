# - MACRO_APPEND_DIRECTORY_PROPERTIES(PROPERTIES key values...)
# MACRO_OPTIONAL_FIND_PACKAGE( <name> [QUIT] )

MACRO(MACRO_APPEND_DIRECTORY_PROPERTIES _properties _property)
   GET_DIRECTORY_PROPERTY(_tmp_DIR_PROPS ${_property} )
   IF (NOT _tmp_DIR_PROPS)
      SET(_tmp_DIR_PROPS)
   ENDIF (NOT _tmp_DIR_PROPS)
   FOREACH(_value ${ARGN})
      IF (_tmp_DIR_PROPS)
         SET(_tmp_DIR_PROPS ${_tmp_DIR_PROPS} ${_value})
      ELSE (_tmp_DIR_PROPS)
         SET(_tmp_DIR_PROPS ${_value})
      ENDIF (_tmp_DIR_PROPS)
   ENDFOREACH(_value ${ARGN})

   SET_DIRECTORY_PROPERTIES(${_properties} ${_property} "${_tmp_DIR_PROPS}")
ENDMACRO(MACRO_APPEND_DIRECTORY_PROPERTIES)

