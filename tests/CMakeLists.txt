# a macro for tests that have a simple format where the name matches the
# directory and project
macro(ADD_TEST_MACRO NAME COMMAND)
  string(REPLACE "." "/" dir "${NAME}")
  string(REGEX REPLACE "[^.]*\\." "" proj "${NAME}")
  add_test(${NAME} ${CMAKE_CTEST_COMMAND}
    --build-and-test
    "${CMAKE_SOURCE_DIR}/tests/${dir}"
    "${CMAKE_BINARY_DIR}/tests/${dir}"
    --build-two-config
    --build-generator ${CMAKE_GENERATOR}
    --build-makeprogram ${CMAKE_MAKE_PROGRAM}
    --build-project ${proj}
    ${${NAME}_EXTRA_OPTIONS}
    --test-command ${COMMAND} ${ARGN})
#  list(APPEND TEST_BUILD_DIRS "${CMAKE_BINARY_DIR}/tests/${dir}")
endmacro(ADD_TEST_MACRO)


add_test_macro(ExecuteAllModules ExecuteAllModules)
