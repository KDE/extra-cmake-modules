# - MACRO_APPEND_SOURCE_FILES_PROPERTIES(<file> PROPERTIES key values...)
# MACRO_OPTIONAL_FIND_PACKAGE( <name> [QUIT] )

MACRO(MACRO_APPEND_SOURCE_FILES_PROPERTIES _file _properties _property)
   GET_SOURCE_FILE_PROPERTY(_tmp_FILE_PROPS ${_file} ${_property})
   
   IF (NOT _tmp_FILE_PROPS) # make sure it's empty not e.g. "NOTFOUND" or "FALSE"
      SET(_tmp_FILE_PROPS)
   ENDIF (NOT _tmp_FILE_PROPS)
   
   FOREACH(_value ${ARGN})
      IF (_tmp_FILE_PROPS)
         SET(_tmp_FILE_PROPS ${_tmp_FILE_PROPS} ${_value})
      ELSE (_tmp_FILE_PROPS)
         SET(_tmp_FILE_PROPS ${_value})
      ENDIF (_tmp_FILE_PROPS)
   ENDFOREACH(_value ${ARGN})

   SET_SOURCE_FILES_PROPERTIES(${_file} ${_properties} ${_property} "${_tmp_FILE_PROPS}")
ENDMACRO(MACRO_APPEND_SOURCE_FILES_PROPERTIES)

