# SPDX-FileCopyrightText: 2026 Friedrich W. H. Kossebau <kossebau@kde.org>
#
# SPDX-License-Identifier: BSD-3-Clause

cmake_policy(VERSION 3.29)

#TODO: enable VERBOSE mode via some env var
set(_verbose_mode FALSE)

# Expected arguments
set(_expected_arg_names
    LANGUAGES  # languages to set in the project() call
    OUTPUT_DIR # dir where to create the CMakeLists.txt file
    PACKAGE_NAME # package name
    PACKAGE_VERSION # package version
    PACKAGE_INSTALL_PREFIX # package installation prefix
    LIBRARY_TARGET_NAME # library target name
    EXTRA_DEPENDENCIES # extra package dependencies
    EXTRA_LINK_LIBRARIES # extra library targets to link to
    EXTRA_COMPILE_DEFINITIONS # compile definitions to use
    INCLUDE_STRINGS # include strings
    CMAKE_VARIABLES_CHECK_DATA # data about cmake variables to check, list of format B/S:name=value
    COMPILE_DEFINITIONS_CHECK_DATA # data about compile definitions to check, list of format
    PREPROCESSOR_MACRO_CHECK_DATA # data about preprocessor macros to check, list of format
)
set(_missing_arg FALSE)
foreach (_arg_name IN LISTS _expected_arg_names)
    if(NOT DEFINED ${_arg_name})
        set(_missing_arg TRUE)
        message(SEND_ERROR "Missing argument: ${_arg_name}.")
    endif()
endforeach()
if(_missing_arg)
    message(FATAL_ERROR "Aborting over missing arguments.")
endif()


# helper functions
function(_set_extra_deps_code _var_name _extra_deps)
    set(_statements)
    list(LENGTH _extra_deps _deps_count)
    set(_i 0)
    while(${_i} LESS ${_deps_count})
        list(GET _extra_deps ${_i} _extra_package_name)
        math(EXPR _i "${_i} + 1")
        set(_extra_package_version_string)
        # check next arg if it is version and thus to be consumed
        if(${_i} LESS ${_deps_count})
            list(GET _extra_deps ${_i} _extra_package_version)
            if(_extra_package_version MATCHES "^([0-9]+)\\.([0-9]+)(\\.([0-9]+))?$")
                set(_extra_package_version_string " ${_extra_package_version}")
                math(EXPR _i "${_i} + 1")
            endif()
        endif()
        string(APPEND _statements "find_package(${_extra_package_name}${_extra_package_version_string} REQUIRED)\n")
    endwhile()
    set(${_var_name} ${_statements} PARENT_SCOPE)
endfunction()


function(_append_macro_check_data_by_version_checks _var_name _check_data)
    string(REGEX MATCH "^(.+):(.+)$" _match "${_check_data}")
    if(_match STREQUAL "")
        message(FATAL_ERROR "Broken version preprocessor macro argument: ${_check_data}.")
    endif()
    set(_prefix "${CMAKE_MATCH_1}")
    set(_version_data "${CMAKE_MATCH_2}")
    if(_version_data MATCHES "^DEFAULT\\|(.*)\\|(.*)$")
        if (NOT CMAKE_MATCH_1 STREQUAL "")
            set(_version "${CMAKE_MATCH_1}")
        elseif (NOT CMAKE_MATCH_2 STREQUAL "")
            set(_version "${CMAKE_MATCH_2}")
        else()
            message(FATAL_ERROR "ecm_installed_library_check_version_preprocessor_macros() called without VERSION argument, but neither project or library target provide a default.")
        endif()
    else()
        set(_version "${_version_data}")
    endif()

    string(REGEX MATCH  "^0*([0-9]+)\\.0*([0-9]+)\\.0*([0-9]+)$" _match "${_version}")
    if ("${_match}" STREQUAL "")
        message(FATAL_ERROR "Version to use by ecm_installed_library_check_version_preprocessor_macros() not in <major>.<minor>.<patch> format, is: ${_version}")
    endif()
    set(_version_major "${CMAKE_MATCH_1}")
    set(_version_minor "${CMAKE_MATCH_2}")
    set(_version_patch "${CMAKE_MATCH_3}")

    math(
        EXPR _hex_number "${_version_major}*65536 + ${_version_minor}*256 + ${_version_patch}"
        OUTPUT_FORMAT HEXADECIMAL
    )

    list(APPEND ${_var_name}
        "${_prefix}_VERSION=${_hex_number}"
        "${_prefix}_VERSION_MAJOR=${_version_major}"
        "${_prefix}_VERSION_MINOR=${_version_minor}"
        "${_prefix}_VERSION_PATCH=${_version_patch}"
    )
    set(${_var_name} ${${_var_name}} PARENT_SCOPE)
endfunction()


function(_set_macro_check_init_code _var_name _subject_name)
    set(_check_code)
    if (_verbose_mode)
        string(APPEND _check_code "#pragma message(\\\"Checking ${_subject_name}\\\")\n")
    endif()
    string(APPEND _check_code
"#define _ECM_INSTALLED_LIBRARY_CHECK_VALUE_TO_STRING(x) #x
#define _ECM_INSTALLED_LIBRARY_CHECK_VALUE(x) _ECM_INSTALLED_LIBRARY_CHECK_VALUE_TO_STRING(x)
")
    set(${_var_name} ${_check_code} PARENT_SCOPE)
endfunction()


function(_set_macro_value_check_code _var_name _name _value)
    set(_check_code
"#if !defined(${_name})
    #error(\\\"${_name}: not defined\\\")
#else
    #if ${_name} != ${_value}
        #pragma message(\\\"${_name}: is '\\\" _ECM_INSTALLED_LIBRARY_CHECK_VALUE(${_name}) \\\"'\\\")
        #error(\\\"${_name}: expecting '${_value}'\\\")
")
    if (_verbose_mode)
        string(APPEND _check_code
"    #else
       #pragma message(\\\"${_name}: as expected matches '${_value}'\\\")
")
    endif()
    string(APPEND _check_code
"    #endif
#endif
")
    set(${_var_name} ${_check_code} PARENT_SCOPE)
endfunction()


function(_set_macro_defined_check_code _var_name _name)
    set(_check_code
"#if !defined(${_name})
    #error(\\\"${_name}: is undefined, expecting defined\\\")
")
    if (_verbose_mode)
        string(APPEND _check_code
"#else
    #pragma message(\\\"${_name}: as expected defined\\\")
")
    endif()
    string(APPEND _check_code
"#endif
")
    set(${_var_name} ${_check_code} PARENT_SCOPE)
endfunction()


function(_set_macro_undefined_check_code _var_name _name)
    set(_check_code
"#if defined(${_name})
    #error(\\\"${_name}: is defined, expecting undefined\\\")
")
    if (_verbose_mode)
        string(APPEND _check_code
"#else
    #pragma message(\\\"${_name}: as expected undefined\\\")
")
    endif()
    string(APPEND _check_code
"#endif
")
    set(${_var_name} ${_check_code} PARENT_SCOPE)
endfunction()


function(_set_preprocessor_macro_check_statements _var_name _arg_type_name _check_data)
    set(_check_statements)
    foreach(_definition_data IN LISTS _check_data)
        string(REGEX MATCH "^([A-Za-z0-9_]+)([\!\?\=])(.*)$" _match "${_definition_data}")
        if(_match STREQUAL "")
            message(FATAL_ERROR "Broken ${_arg_type_name} argument: ${_definition_data}.")
        endif()

        set(_macro_var_name "${CMAKE_MATCH_1}")
        if (CMAKE_MATCH_2 STREQUAL "=")
            _set_macro_value_check_code(_check_code ${_macro_var_name} ${CMAKE_MATCH_3})
        elseif (CMAKE_MATCH_2 STREQUAL "!")
            _set_macro_undefined_check_code(_check_code ${_macro_var_name})
        else()
            _set_macro_defined_check_code(_check_code ${_macro_var_name})
        endif()
        string(APPEND _check_statements "${_check_code}")
    endforeach()

    set(${_var_name} ${_check_statements} PARENT_SCOPE)
endfunction()


function(_set_compile_definitions_check_code _var_name _check_data)
    _set_preprocessor_macro_check_statements(_check_statements "compile definition" "${_check_data}")

    _set_macro_check_init_code(_init_check_code "compile definitions" FALSE)

    set(_source_file "ecm_installed_library_check_compile_definitions.cpp")
    set(_definitions_check_code "
file(GENERATE OUTPUT ${_source_file} CONTENT
\"${_init_check_code}${_check_statements}\")\n
target_sources(InstalledLibraryCheck PRIVATE ${_source_file})\n")

    set(${_var_name} ${_definitions_check_code} PARENT_SCOPE)
endfunction()


function(_set_preprocessor_macro_check_code _var_name _check_data)
    _set_preprocessor_macro_check_statements(_check_statements "preprocessor macro" "${_check_data}")

    _set_macro_check_init_code(_init_check_code "preprocessor macros")

    set(_macros_check_code "\n\"\n${_init_check_code}${_check_statements}\"")

    set(${_var_name} ${_macros_check_code} PARENT_SCOPE)
endfunction()


function(_set_cmake_variable_defined_check_code _var_name _name)
    set(_check_code
"if(NOT DEFINED ${_name})
    message(SEND_ERROR \"${_name}: is undefined, expecting defined\")
")
    if (_verbose_mode)
        string(APPEND _check_code
"else()
    message(STATUS \"${_name}: as expected defined\")
")
    endif()
    string(APPEND _check_code
"endif()
")
    set(${_var_name} ${_check_code} PARENT_SCOPE)
endfunction()


function(_set_cmake_variable_undefined_check_code _var_name _name)
    set(_check_code
"if(DEFINED ${_name})
    message(SEND_ERROR \"${_name}: is defined, expecting undefined\")
")
    if (_verbose_mode)
        string(APPEND _check_code
"else()
    message(STATUS \"${_name}: as expected undefined\")
")
    endif()
    string(APPEND _check_code
"endif()
")
    set(${_var_name} ${_check_code} PARENT_SCOPE)
endfunction()


function(_set_cmake_variable_check_code _var_name _name _type _value)
    if (_type STREQUAL "BOOL")
        # test boolean type by code evaluating the variable
        if (${_value})
            set(_value_error_condition_code "NOT \${${_name}}")
            set(_value_error_report "is FALSE, expecting TRUE")
        else()
            set(_value_error_condition_code "\${${_name}}")
            set(_value_error_report "is TRUE, expecting FALSE")
        endif()
    else() # STRING
        set(_value_error_condition_code "NOT \${${_name}} STREQUAL \"${_value}\"")
        set(_value_error_report "is '\${${_name}}', expecting '${_value}'")
    endif()

    set(_check_code
"if(NOT DEFINED ${_name})
    message(SEND_ERROR \"${_name}: not defined\")
else()
    if (${_value_error_condition_code})
        message(SEND_ERROR \"${_name}: ${_value_error_report}\")
")
    if (_verbose_mode)
        string(APPEND _check_code
"    else()
        message(STATUS \"${_name}: as expected matches '${_value}'\")
")
    endif()
    string(APPEND _check_code
"    endif()
endif()
")
    set(${_var_name} ${_check_code} PARENT_SCOPE)
endfunction()


function(_set_cmake_variables_check_code _var_name _check_data)
    set(_check_code)
    if (_verbose_mode)
        string(APPEND _check_code "message(STATUS \"Checking CMake variables\")\n")
    endif()

    foreach(_cmake_variable_data IN LISTS _check_data)
        string(REGEX MATCH "^([SB]):([A-Za-z0-9_]+)([\!\?\=])(.*)$" _match "${_cmake_variable_data}")
        if(_match STREQUAL "")
            message(SEND_ERROR "Broken cmake variable argument: ${_cmake_variable_data}.")
        endif()
        set(_cmake_var_name "${CMAKE_MATCH_2}")
        if (CMAKE_MATCH_1 STREQUAL "B")
            set(_type "BOOL")
        else()
            set(_type "STRING")
        endif()

        if (CMAKE_MATCH_3 STREQUAL "=")
            _set_cmake_variable_check_code(_var_check_code ${_cmake_var_name} ${_type} "${CMAKE_MATCH_4}" )
        elseif (CMAKE_MATCH_3 STREQUAL "!")
            _set_cmake_variable_undefined_check_code(_var_check_code ${_cmake_var_name})
        else()
            _set_cmake_variable_defined_check_code(_var_check_code ${_cmake_var_name})
        endif()

        string(APPEND _check_code "${_var_check_code}")
    endforeach()
    set(${_var_name} ${_check_code} PARENT_SCOPE)
endfunction()


# process arguments
set(_languages)
if (LANGUAGES)
    string(REPLACE ";" " " _languages "${LANGUAGES}")
    string(PREPEND _languages " LANGUAGES ")
endif()
if(PACKAGE_VERSION)
    set(_package_version_exact " EXACT ")
else()
    set(_package_version_exact " ")
endif()
set(_extra_find_packages_statements)
if(EXTRA_DEPENDENCIES)
    _set_extra_deps_code(_extra_find_packages_statements "${EXTRA_DEPENDENCIES}")
endif()
set(_extra_link_libraries_list)
foreach(_link_library IN LISTS EXTRA_LINK_LIBRARIES)
    string(APPEND _extra_link_libraries_list "\n    ${_link_library}")
endforeach()
set(_compile_definitions_statement)
if(EXTRA_COMPILE_DEFINITIONS)
    set(_compile_definitions_statement "target_compile_definitions(InstalledLibraryCheck PRIVATE ${EXTRA_COMPILE_DEFINITIONS})\n")
endif()
string(JOIN "\n    " _include_strings_lines ${INCLUDE_STRINGS})

set(_cmake_variables_check_code)
if (CMAKE_VARIABLES_CHECK_DATA)
    _set_cmake_variables_check_code(_cmake_variables_check_code "${CMAKE_VARIABLES_CHECK_DATA}")
    string(PREPEND _cmake_variables_check_code "\n")
endif()

set(_compile_definitions_check_code)
if(COMPILE_DEFINITIONS_CHECK_DATA)
    _set_compile_definitions_check_code(_compile_definitions_check_code "${COMPILE_DEFINITIONS_CHECK_DATA}")
endif()

if(VERSION_PREPROCESSOR_MACRO_CHECK_DATA)
    _append_macro_check_data_by_version_checks(PREPROCESSOR_MACRO_CHECK_DATA "${VERSION_PREPROCESSOR_MACRO_CHECK_DATA}")
endif()

set(_preprocessor_macro_check_code)
if(PREPROCESSOR_MACRO_CHECK_DATA)
    _set_preprocessor_macro_check_code(_preprocessor_macro_check_code "${PREPROCESSOR_MACRO_CHECK_DATA}")
endif()


# create CMakeLists.txt file
file(CONFIGURE
     OUTPUT "${OUTPUT_DIR}/CMakeLists.txt"
     CONTENT
"# This file was generated by ecm_add_installed_library_check(). DO NOT EDIT!
cmake_minimum_required(VERSION 3.29)

project(InstalledLibraryCheck@_languages@)

find_package(@PACKAGE_NAME@ @PACKAGE_VERSION@@_package_version_exact@CONFIG REQUIRED NO_DEFAULT_PATH
    PATHS \"@PACKAGE_INSTALL_PREFIX@\"
)
@_extra_find_packages_statements@
include(FeatureSummary)
feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)
@_cmake_variables_check_code@
add_library(InstalledLibraryCheck MODULE)
target_link_libraries(InstalledLibraryCheck
    @LIBRARY_TARGET_NAME@@_extra_link_libraries_list@
)
@_compile_definitions_statement@
set(_include_strings
    @_include_strings_lines@
)
@_compile_definitions_check_code@
set(_preprocessor_macro_check_statements@_preprocessor_macro_check_code@)

foreach(_include_string IN LISTS _include_strings)
    string(REPLACE \"/\" \"__\" _escaped_include_string \${_include_string})
    set(_source_file \"\${CMAKE_CURRENT_BINARY_DIR}/\${_escaped_include_string}.cpp\")
    file(GENERATE OUTPUT \${_source_file} CONTENT \"#include <\${_include_string}>\\n\${_preprocessor_macro_check_statements}\")
    target_sources(InstalledLibraryCheck PRIVATE \${_source_file})
endforeach()
"
    @ONLY
)
