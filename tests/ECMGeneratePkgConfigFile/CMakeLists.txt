
macro(add_pkgconfig_test NAME)
    file(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/${NAME}")

    add_test(NAME ecm_generate_pkgconfig-${NAME}
        COMMAND ${CMAKE_COMMAND} "${CMAKE_CURRENT_SOURCE_DIR}/${NAME}"
        WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/${NAME}"
    )
endmacro()

add_pkgconfig_test(no_optional_arguments)
add_pkgconfig_test(no_description_parameter_metainfo_with_description-param)
add_pkgconfig_test(no_description_parameter_metainfo_with_empty_description)
add_pkgconfig_test(no_description_parameter_metainfo_without_description)
add_pkgconfig_test(with_public_and_private_dependencies)
add_pkgconfig_test(with_an_URL_parameter)
add_pkgconfig_test(custom_defines)

add_subdirectory(test_imported_targets)
add_subdirectory(test_no_interface_include_dirs)
