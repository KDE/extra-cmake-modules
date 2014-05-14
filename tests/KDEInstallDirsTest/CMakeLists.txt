file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/not_cache_variable)

add_test(
    NAME KDEInstallDirs_not_cache_variable
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/not_cache_variable
    COMMAND "${CMAKE_COMMAND}" "${CMAKE_CURRENT_SOURCE_DIR}/not_cache_variable"
    )
