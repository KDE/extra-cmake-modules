function(ecm_add_qml_tests)
    find_package(Qt6 REQUIRED COMPONENTS QuickTest QmlTools CONFIG QUIET)
    foreach(_test ${ARGV})
        add_test(NAME ${_test}
            COMMAND Qt6::qmltestrunner
            WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        )
    endforeach()
endfunction()
