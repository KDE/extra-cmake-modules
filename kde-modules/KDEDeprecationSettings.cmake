# SPDX-FileCopyrightText: 2021 Alexander Lohnau <alexander.lohnau@gmx.de>
#
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
KDEDeprecationSettings
-----------------------

This module provides the ``ecm_set_deprecation_versions`` function setting the excluding
deprecated API for QT and KF projects.

#]=======================================================================]

function ()
    math(EXPR is_even_number "${ARGC} % 2")
    if (NOT is_even_number EQUAL 0)
        message(FATAL_ERROR "Well fuck ${is_even_number}")
    endif()
    math(EXPR number_pairs "(${ARGC} / 2) - 1")
    foreach (it RANGE ${number_pairs})
        # get values
        math(EXPR current_index "${it} * 2")
        list(GET ARGN ${current_index} DEPRECATION_NAME)
        math(EXPR next_index "(${it} *2) + 1")
        list(GET ARGN ${next_index} DEPRECATION_VERSION)

        # get the string identifier for the target definition
        string(COMPARE EQUAL ${DEPRECATION_NAME} "QT" IS_QT_DEPRECATION)
        if (IS_QT_DEPRECATION)
            set(DEPRECATION_DEFINITION_NAME QT_DISABLE_DEPRECATED_BEFORE)
        else()
            set(DEPRECATION_DEFINITION_NAME ${DEPRECATION_NAME}_DISABLE_DEPRECATED_BEFORE_AND_AT)
        endif()

        # we want to be able to set this version without being forced to edit the CMakeLists.txt file
        if (${${DEPRECATION_DEFINITION_NAME}})
            set(DEPRECATION_VERSION "${${DEPRECATION_DEFINITION_NAME}}")
        endif()

        # make a sanity check to make sure we do not get malformed versions
        _ecm_version_tripel_sanity_check("ecm_set_deprecation_versions" "${DEPRECATION_VERSION}")

        # add the actual compile definition with the given hex value
        _ecm_geh_generate_hex_number(DEPRECATION_HEX_VERSION ${DEPRECATION_VERSION})
        add_definitions(-D${DEPRECATION_NAME}_DISABLE_DEPRECATED_BEFORE_AND_AT=${DEPRECATION_HEX_VERSION})
    endforeach()
endfunction()

# helper method
function(_ecm_geh_generate_hex_number _var_name _version)
    set(_hexnumber 0)

    set(version_regex "^([0-9]+)\\.([0-9]+)\\.([0-9]+)$")
    string(REGEX REPLACE ${version_regex} "\\1" _version_major "${_version}")
    string(REGEX REPLACE ${version_regex} "\\2" _version_minor "${_version}")
    string(REGEX REPLACE ${version_regex} "\\3" _version_patch "${_version}")
    set(_outputformat)
    set(_outputformat OUTPUT_FORMAT HEXADECIMAL)
    math(EXPR _hexnumber "${_version_major}*65536 + ${_version_minor}*256 + ${_version_patch}" ${_outputformat})
    set(${_var_name} ${_hexnumber} PARENT_SCOPE)
endfunction()

function (_ecm_version_tripel_sanity_check message_function_name unchecked_version)
    # helper string
    set(_version_triple_regexp "^([0-9]+)\\.([0-9]+)\\.([0-9]+)$")
    # args sanity check
    if (NOT unchecked_version)
        message(FATAL_ERROR "No VERSION passed when calling ${message_function_name}().")
    elseif(NOT unchecked_version MATCHES ${_version_triple_regexp})
        message(FATAL_ERROR "VERSION ${unchecked_version} expected to be in x.y.z format when calling ${message_function_name}().")
    endif()
endfunction()
