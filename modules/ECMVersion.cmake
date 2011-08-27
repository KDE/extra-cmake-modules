
macro(ecm_version _major _minor _patch)
  set(ECM_VERSION_MAJOR ${_major})
  set(ECM_VERSION_MINOR ${_minor})
  set(ECM_VERSION_PATCH ${_patch})
  set(ECM_SOVERSION ${_major})
  set(ECM_VERSION_STRING "${ECM_VERSION_MAJOR}.${ECM_VERSION_MINOR}.${ECM_VERSION_PATCH}")
endmacro()
