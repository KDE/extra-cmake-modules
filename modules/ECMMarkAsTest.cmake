# - Function for marking targets as being only for testing
# This module provides the function ECM_MARK_AS_TEST().
#
# The ECM_MARK_AS_TEST function is used to indicate that a target should only
# be built if the BUILD_TESTING option (provided by CTest) is enabled.
#
# ECM_MARK_AS_TEST( target1 target2 ... targetN )
#
# If BUILD_TESTING is False, then targets marked as tests are exluded from
# the ALL target. They are all part of the 'buildtests' target though, so
# even if building with BUILD_TESTING set to False, it is possible to build
# all tests by invoking the 'buildtests' target.

if (NOT BUILD_TESTING)
  get_property(_buildtestsAdded GLOBAL PROPERTY BUILDTESTS_ADDED)
  if(NOT _buildtestsAdded)
    add_custom_target(buildtests)
    set_property(GLOBAL PROPERTY BUILDTESTS_ADDED TRUE)
  endif()
endif()

function(ecm_mark_as_test)
  if (NOT BUILD_TESTING)
    foreach(_target ${ARGN})
      set_target_properties(${_target}
                              PROPERTIES
                              EXCLUDE_FROM_ALL TRUE
                           )
      add_dependencies(buildtests ${_target})
    endforeach()
  endif()
endfunction()
