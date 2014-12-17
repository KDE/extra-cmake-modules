# We need to set a language to find CMake packages installed in
# architecture-dependent locations (like /usr/lib64).
# We only set this for the tests, making sure it does not interfere
# with other files (as ECM itself is architecture-independent).
project(ECMTests C)

add_subdirectory(ECMGenerateHeadersTest)
add_subdirectory(ECMSetupVersionTest)
add_subdirectory(ECMGeneratePkgConfigFile)

# a macro for tests that have a simple format where the name matches the
# directory and project
macro(add_test_variant NAME BASE COMMAND)
    string(REPLACE "." "/" src_dir "${BASE}")
    string(REPLACE "." "/" build_dir "${NAME}")
    string(REGEX REPLACE "[^.]*\\." "" proj "${NAME}")
    add_test(${NAME} ${CMAKE_CTEST_COMMAND}
        --build-and-test
        "${CMAKE_CURRENT_SOURCE_DIR}/${src_dir}"
        "${CMAKE_CURRENT_BINARY_DIR}/${build_dir}"
        --build-two-config
        --build-generator ${CMAKE_GENERATOR}
        --build-makeprogram ${CMAKE_MAKE_PROGRAM}
        --build-project ${proj}
        ${${NAME}_EXTRA_OPTIONS}
        --test-command ${COMMAND} ${ARGN})
endmacro()
macro(add_test_macro NAME)
    add_test_variant("${NAME}" "${NAME}" ${ARGN})
endmacro()

find_package(Qt5LinguistTools CONFIG)

add_test_macro(ExecuteCoreModules dummy)
add_test_macro(ExecuteKDEModules dummy)

add_test_macro(KDEInstallDirsTest.vars_defined dummy)
add_test_macro(KDEInstallDirsTest.not_cache_variable dummy)

add_test_variant(KDEInstallDirsTest.vars_in_sync_no_args
                 KDEInstallDirsTest.vars_in_sync dummy)

set(KDEInstallDirsTest.vars_in_sync_args_EXTRA_OPTIONS
    --build-options -DCMAKE_INSTALL_DATADIR=altdata
                    -DKDE_INSTALL_BINDIR=altbin
                    -DLIB_INSTALL_DIR=altlib
    )
add_test_variant(KDEInstallDirsTest.vars_in_sync_args
                 KDEInstallDirsTest.vars_in_sync dummy)

set(KDEInstallDirsTest.usr_vars_defined_EXTRA_OPTIONS
    --build-options -DCMAKE_INSTALL_PREFIX=/usr)
add_test_macro(KDEInstallDirsTest.usr_vars_defined dummy)

find_package(Qt5Core QUIET)
if (TARGET Qt5::qmake)
    set(KDEInstallDirsTest.qt_vars_defined_EXTRA_OPTIONS
        --build-options -DKDE_INSTALL_USE_QT_SYS_PATHS=ON)
    add_test_macro(KDEInstallDirsTest.qt_vars_defined dummy)
endif ()

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
