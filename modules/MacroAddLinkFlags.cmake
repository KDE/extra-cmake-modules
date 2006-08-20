# - MACRO_ADD_LINK_FLAGS(<_target> "flags...")

MACRO (MACRO_ADD_LINK_FLAGS _target _flg)

   GET_TARGET_PROPERTY(_flags ${_target} LINK_FLAGS)
   if (_flags)
      set(_flags "${_flags} ${_flg}")
   else (_flags)
      set(_flags "${_flg}")
   endif (_flags)
   SET_TARGET_PROPERTIES(${_target} PROPERTIES LINK_FLAGS "${_flags}")

ENDMACRO (MACRO_ADD_LINK_FLAGS)
