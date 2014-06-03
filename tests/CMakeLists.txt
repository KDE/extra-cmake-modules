# We need to set a language to find CMake packages installed in
# architecture-dependent locations (like /usr/lib64).
# We only set this for the tests, making sure it does not interfere
# with other files (as ECM itself is architecture-independent).
project(ECMTests C)

add_subdirectory(ECMGenerateHeadersTest)
add_subdirectory(ECMSetupVersionTest)

# a macro for tests that have a simple format where the name matches the
# directory and project
macro(ADD_TEST_MACRO NAME COMMAND)
  string(REPLACE "." "/" dir "${NAME}")
  string(REGEX REPLACE "[^.]*\\." "" proj "${NAME}")
  add_test(${NAME} ${CMAKE_CTEST_COMMAND}
    --build-and-test
    "${CMAKE_CURRENT_SOURCE_DIR}/${dir}"
    "${CMAKE_CURRENT_BINARY_DIR}/${dir}"
    --build-two-config
    --build-generator ${CMAKE_GENERATOR}
    --build-makeprogram ${CMAKE_MAKE_PROGRAM}
    --build-project ${proj}
    ${${NAME}_EXTRA_OPTIONS}
    --test-command ${COMMAND} ${ARGN})
endmacro(ADD_TEST_MACRO)

find_package(Qt5LinguistTools CONFIG)

add_test_macro(ExecuteCoreModules dummy)
add_test_macro(ExecuteKDEModules dummy)
add_test_macro(KDEInstallDirsTest.vars_defined dummy)
add_test_macro(KDEInstallDirsTest.not_cache_variable dummy)
add_test_macro(FindModules dummy)
add_test_macro(UseFindModules dummy)

set(ECMInstallIconsTest_EXTRA_OPTIONS
    --build-target install
    --build-options
        "-DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_CURRENT_BINARY_DIR}/ECMInstallIconsTest/InstallDirectory"
)
add_test_macro(ECMInstallIconsTest
    ${CMAKE_COMMAND} -P "${CMAKE_CURRENT_BINARY_DIR}/ECMInstallIconsTest/check_tree.cmake"
)

if (Qt5LinguistTools_FOUND)
    set(ECMPoQmToolsTest_EXTRA_OPTIONS
        --build-target install
        --build-options
            "-DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_CURRENT_BINARY_DIR}/ECMPoQmToolsTest/InstallDirectory"
    )
    add_test_macro(ECMPoQmToolsTest
        ${CMAKE_COMMAND} -P "${CMAKE_CURRENT_BINARY_DIR}/ECMPoQmToolsTest/check_tree.cmake"
    )
endif()
