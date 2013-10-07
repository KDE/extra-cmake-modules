include(ECMMarkAsTest)

# This file provides the functions ecm_add_test() and ecm_add_tests().
#
# ecm_add_test(<sources> TEST_NAME <name> NAME_PREFIX <prefix> LINK_LIBRARIES <libraries/targets>)
#
# Add a new unit test using the passed source files. The parameter TEST_NAME is used to set the name
# of the resulting test. It may be omitted if there is exactly one source file. In that case the name of
# the source file (without the file extension) will be used as the test name.
#
# ecm_add_tests(<sources> NAME_PREFIX <prefix> LINK_LIBRARIES <libraries/targets>)
#
# Add a new unit test for every source file passed. The name of the tests will be the name of the
# corresponding source file minus the file extension. If NAME_PREFIX is set, that string will be
# prepended to each of the unit test names. Each of the unit tests will be linked against the
# libraries and/or targets passed in the LINK_LIBRARIES parameter.
#
# Copyright (c) 2013, Alexander Richardson, <arichardson.kde@gmail.com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

function(ecm_add_test)
  set(oneValueArgs TEST_NAME NAME_PREFIX)
  set(multiValueArgs LINK_LIBRARIES)
  cmake_parse_arguments(ECM_ADD_TEST "" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
  set(_sources ${ECM_ADD_TEST_UNPARSED_ARGUMENTS})
  list(LENGTH _sources _sourceCount)
  if(ECM_ADD_TEST_TEST_NAME)
    set(_testname ${ECM_ADD_TEST_TEST_NAME})
  elseif(${_sourceCount} EQUAL "1")
    #use the source file name without extension as the testname
    get_filename_component(_testname ${_sources} NAME_WE)
  else()
    #more than one source file passed, but no test name given -> error
    message(FATAL_ERROR "ecm_add_test() called with multiple source files but without setting \"TEST_NAME\"")
  endif()

  set(_testname "${ECM_ADD_TEST_NAME_PREFIX}${_testname}")
  add_executable(${_testname} ${_sources})
  add_test(${_testname} ${_testname})
  target_link_libraries(${_testname} ${ECM_ADD_TEST_LINK_LIBRARIES})
  ecm_mark_as_test(${_testname})
endfunction()

function(ecm_add_tests)
  set(oneValueArgs NAME_PREFIX)
  set(multiValueArgs LINK_LIBRARIES)
  cmake_parse_arguments(ECM_ADD_TESTS "" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
  foreach(_test_source ${ECM_ADD_TESTS_UNPARSED_ARGUMENTS})
    ecm_add_test(${_test_source}
      NAME_PREFIX ${ECM_ADD_TESTS_NAME_PREFIX}
      LINK_LIBRARIES ${ECM_ADD_TESTS_LINK_LIBRARIES}
    )
  endforeach()
endfunction()
