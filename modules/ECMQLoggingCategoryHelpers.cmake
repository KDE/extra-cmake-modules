#.rst:
# ECMQLoggingCategoryHelpers
# --------------------------
#
# API prototype version, documentation to follow.
#
# ::
#
#   ecm_declare_qloggingcategory(
#       CATEGORY_NAME <category_name>
#       IDENTIFIER <identifier>
#       DESCRIPTION <description>
#       [OLD_CATEGORY_NAMES <oldest_cat_name> [<second_oldest_cat_name> [...]]]
#       [DEFAULT_SEVERITY <Debug|Info|Warning|Critical|Fatal>]
#       [GROUP <groupid>] # defaults to ${PROJECT_NAME}
#   )
#
# ::
#
#   ecm_generate_qloggingcategories_source(<sources_var_or_target>
#       HEADER <filename>
#       [GROUP <groupid>] # defaults to ${PROJECT_NAME}
#       [CATEGORY_NAMES <category> [<category> [...]]] # defaults to all categories
#   )
#
# ::
#
#   ecm_generate_qloggingcategories_mddoc(
#       FILE <filename>
#       [GROUPS <groupid> [<groupid> [...]] | ALL_GROUPS]  # defaults to GROUPS ${PROJECT_NAME}
#   )
#
# ::
#
#   ecm_install_qloggingcategories_metadata(
#       DESTINATION <install_path>
#       [FILE <filename>] # defaults to <groupid_lowercase>.categories if count(GROUPS)==1
#       [GROUPS <groupid> [<groupid> [...]] | ALL_GROUPS]  # defaults to GROUPS ${PROJECT_NAME}
#       [COMPONENT <component>]
#   )
#
# Since 5.81.0.

#=============================================================================
# SPDX-FileCopyrightText: 2020-21 Friedrich W. H. Kossebau <kossebau@kde.org>
#
# SPDX-License-Identifier: BSD-3-Clause

include(CMakeParseArguments)

function(ecm_declare_qloggingcategory)
    set(options)
    set(oneValueArgs IDENTIFIER CATEGORY_NAME DEFAULT_SEVERITY GROUP DESCRIPTION)
    set(multiValueArgs OLD_CATEGORY_NAMES)
    cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if(ARG_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Unexpected arguments to ecm_declare_qloggingcategory: ${ARG_UNPARSED_ARGUMENTS}")
    endif()
    if(NOT ARG_IDENTIFIER)
        message(FATAL_ERROR "Missing IDENTIFIER argument for ecm_declare_qloggingcategory")
    endif()
    if(NOT ARG_CATEGORY_NAME)
        message(FATAL_ERROR "Missing CATEGORY_NAME argument for ecm_declare_qloggingcategory")
    endif()
    if(NOT ARG_DEFAULT_SEVERITY)
        set(ARG_DEFAULT_SEVERITY Info)
        set(is_explicite_default_severity FALSE)
    else()
        set(acceptible_severities Debug Info Warning Critical Fatal)
        if (NOT ARG_DEFAULT_SEVERITY IN_LIST acceptible_severities)
            message(FATAL_ERROR "Unknown DEFAULT_SEVERITY ${ARG_DEFAULT_SEVERITY}")
        endif()
        set(is_explicite_default_severity TRUE)
    endif()
    if(NOT ARG_DESCRIPTION)
        message(FATAL_ERROR "Missing DESCRIPTION argument for ecm_declare_qloggingcategory.")
    endif()
    if(NOT ARG_GROUP)
        set(ARG_GROUP ${PROJECT_NAME})
    endif()

    get_property(_groups GLOBAL PROPERTY "ECM_QLOGGINGCATEGORIES_GROUPS")
    if (NOT ARG_GROUP IN_LIST _groups)
        set_property(GLOBAL APPEND PROPERTY "ECM_QLOGGINGCATEGORIES_GROUPS" ${ARG_GROUP})
    endif()

    set(_propertyprefix "ECM_QLOGGINGCATEGORIES_${ARG_GROUP}")

    get_property(_categories GLOBAL PROPERTY "${_propertyprefix}_CATEGORIES")
    if (ARG_CATEGORY_NAME IN_LIST _categories)
        message(FATAL_ERROR "Category ${ARG_CATEGORY_NAME} already declared before")
    endif()

    # note data in global properties
    set_property(GLOBAL APPEND PROPERTY "${_propertyprefix}_CATEGORIES" ${ARG_CATEGORY_NAME})
    set_property(GLOBAL PROPERTY "${_propertyprefix}_IDENTIFIER_${ARG_CATEGORY_NAME}" "${ARG_IDENTIFIER}")
    set_property(GLOBAL PROPERTY "${_propertyprefix}_DESCRIPTION_${ARG_CATEGORY_NAME}" "${ARG_DESCRIPTION}")
    set_property(GLOBAL PROPERTY "${_propertyprefix}_OLD_NAMES_${ARG_CATEGORY_NAME}" "${ARG_OLD_CATEGORY_NAMES}")
    if (is_explicite_default_severity)
        set_property(GLOBAL PROPERTY "${_propertyprefix}_DEFAULT_SEVERITY_${ARG_CATEGORY_NAME}" "${ARG_DEFAULT_SEVERITY}")
    endif()
endfunction()


function(_ecm_qloggingcategory_get_namespaces_wrappers namespaced_identifier var_identifier var_open_namespaces var_close_namespaces)
    # split into namespaces and bare identifier
    string(REPLACE "::" ";" _namespaces "${namespaced_identifier}")
    list(LENGTH _namespaces namespaces_length)
    math(EXPR last_pos "${namespaces_length} - 1")
    list(GET _namespaces ${last_pos} _identifier)
    list(REMOVE_AT _namespaces ${last_pos})

    set(_open_namespaces)
    set(_close_namespaces)
    foreach(_namespace ${_namespaces})
        set(_open_namespaces "${_open_namespaces} namespace ${_namespace} {")
        set(_close_namespaces "} ${_close_namespaces}")
    endforeach()

    # set result
    set(${var_identifier} "${_identifier}" PARENT_SCOPE)
    set(${var_open_namespaces} "${_open_namespaces}" PARENT_SCOPE)
    set(${var_close_namespaces} "${_close_namespaces}" PARENT_SCOPE)
endfunction()


function(ecm_generate_qloggingcategories_source sources_or_target_var)
    set(options)
    set(oneValueArgs HEADER GROUP)
    set(multiValueArgs CATEGORY_NAMES)
    cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if(ARG_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Unexpected arguments to ecm_generate_qloggingcategories_source: ${ARG_UNPARSED_ARGUMENTS}")
    endif()
    if(NOT ARG_HEADER)
        message(FATAL_ERROR "Missing HEADER argument for ecm_generate_qloggingcategories_source")
    endif()
    if(NOT ARG_GROUP)
        set(ARG_GROUP ${PROJECT_NAME})
    endif()

    if (NOT IS_ABSOLUTE "${ARG_HEADER}")
        set(ARG_HEADER "${CMAKE_CURRENT_BINARY_DIR}/${ARG_HEADER}")
    endif()

    set(_propertyprefix "ECM_QLOGGINGCATEGORIES_${ARG_GROUP}")
    get_property(_categories GLOBAL PROPERTY "${_propertyprefix}_CATEGORIES")

    if(NOT ARG_CATEGORY_NAMES)
        set(ARG_CATEGORY_NAMES ${_categories})
    else()
        foreach(_category IN LISTS ARG_CATEGORY_NAMES)
            if(NOT _category IN_LIST _categories)
                message(FATAL_ERROR "Unknown category name ${_category}")
            endif()
        endforeach()
    endif()

    # prepare file names
    if (IS_ABSOLUTE "${ARG_HEADER}")
        set(_header_file "${ARG_HEADER}")
    else()
        set(_header_file "${CMAKE_CURRENT_BINARY_DIR}/${ARG_HEADER}")
    endif()

    string(FIND "${_header_file}" "." pos REVERSE)
    if (pos EQUAL -1)
        set(_source_file "${_header_file}.cpp")
    else()
        string(SUBSTRING "${_header_file}" 0 ${pos} _source_file)
        set(_source_file "${_source_file}.cpp")
    endif()

    get_filename_component(_header_filename "${_header_file}" NAME)

    string(REPLACE "::" "_" _guard_prefix "ECM_QLOGGINGCATEGORIES_${ARG_GROUP}")
    string(TOUPPER "${_guard_prefix}_${_header_filename}" _guard_name)
    string(REGEX REPLACE "[^a-zA-Z0-9_]" "_" _guard_name "${_guard_name}")

    # start header file
    set(_header_file_content
"// This file was generated by ECMQLoggingCategoryHelpers: DO NOT EDIT!

#ifndef ${_guard_name}
#define ${_guard_name}

#include <QLoggingCategory>
")

    # start source file
    set(_source_file_content
"// This file was generated by ECMQLoggingCategoryHelpers: DO NOT EDIT!

#include \"${_header_filename}\"

")

    foreach(_category IN LISTS ARG_CATEGORY_NAMES)
        get_property(_identifier GLOBAL PROPERTY "${_propertyprefix}_IDENTIFIER_${_category}")
        get_property(_default_severity GLOBAL PROPERTY "${_propertyprefix}_DEFAULT_SEVERITY_${_category}")
        if(NOT _default_severity)
            set(_default_severity Info)
        endif()

        _ecm_qloggingcategory_get_namespaces_wrappers(${_identifier} _identifier _open_namespaces _close_namespaces)
        if(_open_namespaces)
            string(APPEND _header_file_content "${_open_namespaces}\n")
            string(APPEND _source_file_content "${_open_namespaces}\n")
        endif()
        string(APPEND _header_file_content "Q_DECLARE_LOGGING_CATEGORY(${_identifier})\n")
        string(APPEND _source_file_content "Q_LOGGING_CATEGORY(${_identifier}, \"${_category}\", Qt${_default_severity}Msg)\n")
        if(_close_namespaces)
            string(APPEND _header_file_content "${_close_namespaces}\n")
            string(APPEND _source_file_content "${_close_namespaces}\n")
        endif()
    endforeach()

    # finish header
    string(APPEND _header_file_content
"#endif
")

    file(GENERATE
        OUTPUT ${_header_file}
        CONTENT ${_header_file_content}
    )
    file(GENERATE
        OUTPUT ${_source_file}
        CONTENT ${_source_file_content}
    )
    set_property(SOURCE ${_source_file} ${_header_file} PROPERTY SKIP_AUTOMOC ON)

    if(TARGET ${sources_or_target_var})
        target_sources(${sources_or_target_var} PRIVATE ${_source_file} "${_header_file}")
    else()
        set(sources "${${sources_or_target_var}}")
        list(APPEND sources "${_source_file}")
        set(${sources_or_target_var} "${sources}" PARENT_SCOPE)
    endif()
endfunction()

function(ecm_generate_qloggingcategories_mddoc)
    set(options ALL_GROUPS)
    set(oneValueArgs FILE)
    set(multiValueArgs GROUPS)

    cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if(ARG_ALL_GROUPS AND ARG_GROUPS)
        message(FATAL_ERROR "Conflicting use of ALL_GROUPS and GROUPS arguments for ecm_generate_qloggingcategories_mddoc")
    endif()

    get_property(_all_groups GLOBAL PROPERTY "ECM_QLOGGINGCATEGORIES_GROUPS")
    if(ARG_ALL_GROUPS)
        set(ARG_GROUPS ${_all_groups})
    else()
        if(ARG_GROUPS)
            foreach(_group IN LISTS ARG_GROUPS)
                if(NOT _group IN_LIST _all_groups)
                    message(FATAL_ERROR "Unknown group ${_group} passed to ecm_generate_qloggingcategories_mddoc")
                endif()
            endforeach()
        else()
            set(_default_group ${PROJECT_NAME})
            if(NOT _default_group IN_LIST _all_groups)
                message(FATAL_ERROR "Unknown default group derived from project name ${_default_group} in ecm_generate_qloggingcategories_mddoc")
            endif()
            set(ARG_GROUPS ${_default_group})
        endif()
    endif()

    if(NOT ARG_FILE)
        message(FATAL_ERROR "Missing FILE argument for ecm_generate_qloggingcategories_mddoc")
    endif()

    # generate categories file
    if (NOT IS_ABSOLUTE "${ARG_FILE}")
        set(ARG_FILE "${CMAKE_CURRENT_BINARY_DIR}/${ARG_FILE}")
    endif()

    # using "\n[//]: # (comment)\n" markdown hack to add a comment
    file(WRITE ${ARG_FILE}
"
[//]: # (This file is generated/updated by ECMQLoggingCategoryHelpers. DO NOT EDIT!)

## Logging Categories

The following logging categories exists:
Logging Category | Description
---------------- | -----------
")

    foreach(_group IN LISTS ARG_GROUPS)
        set(_propertyprefix "ECM_QLOGGINGCATEGORIES_${_group}")

        get_property(_categories GLOBAL PROPERTY "${_propertyprefix}_CATEGORIES")
        list(SORT _categories)

        foreach(_category IN LISTS _categories)
            get_property(_description GLOBAL PROPERTY "${_propertyprefix}_DESCRIPTION_${_category}")
            get_property(_identifier GLOBAL PROPERTY "${_propertyprefix}_IDENTIFIER_${_category}")
            file(APPEND ${ARG_FILE} "${_category} | ${_description}\n")
        endforeach()
    endforeach()
endfunction()

function(ecm_install_qloggingcategories_metadata)
    set(options ALL_GROUPS)
    set(oneValueArgs FILE DESTINATION COMPONENT)
    set(multiValueArgs GROUPS)

    cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if(NOT ARG_DESTINATION)
        message(FATAL_ERROR "Missing DESTINATION argument for ecm_install_qloggingcategories_metadata")
    endif()

    if(ARG_ALL_GROUPS AND ARG_GROUPS)
        message(FATAL_ERROR "Conflicting use of ALL_GROUPS and GROUPS arguments for ecm_install_qloggingcategories_metadata")
    endif()

    get_property(_all_groups GLOBAL PROPERTY "ECM_QLOGGINGCATEGORIES_GROUPS")
    if(ARG_ALL_GROUPS)
        set(ARG_GROUPS ${_all_groups})
    else()
        if(ARG_GROUPS)
            foreach(_group IN LISTS ARG_GROUPS)
                if(NOT _group IN_LIST _all_groups)
                    message(FATAL_ERROR "Unknown group ${_group} passed to ecm_install_qloggingcategories_metadata")
                endif()
            endforeach()
        else()
            set(_default_group ${PROJECT_NAME})
            if(NOT _default_group IN_LIST _all_groups)
                message(FATAL_ERROR "Unknown default group derived from project name ${_default_group} in ecm_install_qloggingcategories_metadata")
            endif()
            set(ARG_GROUPS ${_default_group})
        endif()
    endif()

    if(NOT ARG_FILE)
        list(LENGTH ARG_GROUPS _group_count)
        if (_group_count EQUAL 1)
            string(TOLOWER "${ARG_GROUP}.categories" ARG_FILE)
        else()
            message(FATAL_ERROR "Missing FILE argument with multiple groups for ecm_install_qloggingcategories_metadata")
        endif()
    endif()

    set(_renamed_categories)

    # generate categories file
    if (NOT IS_ABSOLUTE "${ARG_FILE}")
        set(ARG_FILE "${CMAKE_CURRENT_BINARY_DIR}/${ARG_FILE}")
    endif()

    set(_categories_content
"# KDebugSettings data file
# This file was generated by ECMQLoggingCategoryHelpers. DO NOT EDIT!

")

    set(has_category FALSE)
    foreach(_group IN LISTS ARG_GROUPS)
        set(_propertyprefix "ECM_QLOGGINGCATEGORIES_${_group}")

        get_property(_categories GLOBAL PROPERTY "${_propertyprefix}_CATEGORIES")
        list(SORT _categories)
        if(_categories)
            set(has_category TRUE)
        endif()

        foreach(_category IN LISTS _categories)
            get_property(_description GLOBAL PROPERTY "${_propertyprefix}_DESCRIPTION_${_category}")
            get_property(_identifier GLOBAL PROPERTY "${_propertyprefix}_IDENTIFIER_${_category}")
            get_property(_default_severity GLOBAL PROPERTY "${_propertyprefix}_DEFAULT_SEVERITY_${_category}")
            if (_default_severity)
                string(TOUPPER "${_default_severity}" _default_severity)
                set(_default_severity "DEFAULT_SEVERITY [${_default_severity}] ") # final space wanted
            endif()
            get_property(_old_category_names GLOBAL PROPERTY "${_propertyprefix}_OLD_NAMES_${_category}")
            if (_old_category_names)
                list(APPEND _renamed_categories ${_category})
            endif()

            # Format:
            # logname<space>description(optional <space> DEFAULT_SEVERITY [DEFAULT_CATEGORY] as WARNING/DEBUG/INFO/CRITICAL) optional IDENTIFIER [...])
            string(APPEND _categories_content "${_category} ${_description} ${_default_severity}IDENTIFIER [${_identifier}]\n")
        endforeach()
    endforeach()

    if (NOT has_category)
        message(AUTHOR_WARNING "No Qt logging categories found declared, generating & installing an empty file ${ARG_FILE}.")
    endif()


    file(GENERATE
        OUTPUT ${ARG_FILE}
        CONTENT ${_categories_content}
    )

    set(_renamed_cats_file)
    if (_renamed_categories)
        get_filename_component(_dir ${ARG_FILE} DIRECTORY)
        get_filename_component(_base_name ${ARG_FILE} NAME_WE)
        set(_renamed_cats_file "${_dir}/${_base_name}.renamecategories")
        set(_renamed_cats_content
"# KDebugSettings data file
# This file was generated by ECMQLoggingCategoryHelpers. DO NOT EDIT!

")

        foreach(_category IN LISTS _renamed_categories)
            get_property(_category_name_history GLOBAL PROPERTY "${_propertyprefix}_OLD_NAMES_${_category}")

            list(APPEND _category_name_history ${_category})
            list(GET _category_name_history 0 _old_category_name)
            list(REMOVE_AT _category_name_history 0)
            foreach(_category_name IN LISTS _category_name_history)
                # Format:
                # oldlogname<space>newlogname
                string(APPEND _renamed_cats_content "${_old_category_name} ${_category_name}\n")
                set(_old_category_name ${_category_name})
            endforeach()
        endforeach()

        file(GENERATE
            OUTPUT ${_renamed_cats_file}
            CONTENT ${_renamed_cats_content}
        )
    endif()

    # install files
    set(_component_install)
    if (ARG_COMPONENT)
        set(_component_install COMPONENT ${ARG_COMPONENT})
    endif()
    install(
        FILES ${ARG_FILE} ${_renamed_cats_file}
        DESTINATION "${ARG_DESTINATION}"
        ${_component_install}
    )
endfunction()
