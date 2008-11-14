# run this script via "cmake -P RunAllModuletests.cmake" to
# execute all module tests in one go.
# To see only the results and not the other cmake output,
# you can grep for "::".
# To have it delete the previous test build dirs, run it with -DCLEAN_DIRS=TRUE

get_filename_component(currentDir "${CMAKE_CURRENT_LIST_FILE}" PATH)

function(execute_one_test name)
   set(workingDir "${currentDir}/${name}/build")
   if(CLEAN_DIRS)
      file(REMOVE_RECURSE "${workingDir}")
   endif(CLEAN_DIRS)
   file(MAKE_DIRECTORY "${workingDir}")
   execute_process(COMMAND ${CMAKE_COMMAND} "${currentDir}/${name}"
                   WORKING_DIRECTORY "${workingDir}")
endfunction(execute_one_test)

execute_one_test(Blitz)
execute_one_test(Eigen2)
execute_one_test(Flex)
execute_one_test(Flac)
execute_one_test(QCA2)
execute_one_test(Xine)
