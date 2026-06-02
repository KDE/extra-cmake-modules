function(ecm_add_qml_tests)
    find_package(Qt6QuickTest REQUIRED)
    file(REMOVE "${PROJECT_BINARY_DIR}/_qmltest.cpp")
    file(WRITE "${PROJECT_BINARY_DIR}/_qmltest.cpp" "#include <quicktest.h>\nQUICK_TEST_MAIN(_qmltest)")
    add_executable(_qmltest "${PROJECT_BINARY_DIR}/_qmltest.cpp")
    target_link_libraries(_qmltest PRIVATE Qt6::QuickTest)
    foreach(_test ${ARGV})
        add_test(NAME ${_test}
            COMMAND ${PROJECT_BINARY_DIR}/bin/_qmltest
            WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        )
    endforeach()
endfunction()
