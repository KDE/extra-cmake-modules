
MACRO(MACRO_GETENV_WIN_PATH var name)
   SET(${var} $ENV{${name}})
   STRING( REGEX REPLACE "\\\\" "/" ${var} "${${var}}" )
ENDMACRO(MACRO_GETENV_WIN_PATH var name)
