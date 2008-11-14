# run this script via "cmake -P RunAllModuletests.cmake" to
# execute all module tests in one go.
# To see only the results and not the other cmake output,
# you can grep for ">>".

get_filename_component(currentDir "${CMAKE_CURRENT_LIST_FILE}" PATH)

function(execute_one_test name)
   set(workingDir "${currentDir}/${name}/build")
   file(REMOVE_RECURSE "${workingDir}")
   file(MAKE_DIRECTORY "${workingDir}")
   execute_process(COMMAND ${CMAKE_COMMAND} "${currentDir}/${name}"
                   WORKING_DIRECTORY "${workingDir}")
endfunction(execute_one_test)

execute_one_test(Xine)
execute_one_test(Flex)
execute_one_test(QCA2)


