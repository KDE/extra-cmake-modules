# - Function for marking executables as being non-gui
# This module provides the function ECM_MARK_NONGUI_EXECUTABLE().
#
# The ECM_MARK_NONGUI_EXECUTABLE function is used to indicate that an executable
# target should not be part of a MACOSX_BUNDLE, and should not be a WIN32_EXECUTABLE.
#
# ECM_MARK_NONGUI_EXECUTABLE( target1 target2 ... targetN )
#

function(ecm_mark_nongui_executable)
  foreach(_target ${ARGN})
    set_target_properties(${_target}
                            PROPERTIES
                            WIN32_EXECUTABLE FALSE
                            MACOSX_BUNDLE FALSE
                          )
  endforeach()
endfunction()
