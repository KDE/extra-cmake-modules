find_package(Qt5Core QUIET)

set(_qmake_executable_default "qmake-qt5")
if (TARGET Qt5::qmake)
    get_target_property(_qmake_executable_default Qt5::qmake LOCATION)
endif()
set(QMAKE_EXECUTABLE "qmake-qt5"
    CACHE FILEPATH "Location of the Qt5 qmake executable")

# This is not public API (yet)!
function(query_qmake result_variable qt_variable)
    execute_process(
        COMMAND ${QMAKE_EXECUTABLE} -query "${qt_variable}"
        RESULT_VARIABLE return_code
        OUTPUT_VARIABLE output
    )
    string(STRIP ${output} output)
    if(return_code EQUAL 0)
        file(TO_CMAKE_PATH "${output}" output_path)
        set(${result_variable} "${output_path}" PARENT_SCOPE)
    else()
        message(FATAL "QMake call failed: ${error}")
    endif()
endfunction()
