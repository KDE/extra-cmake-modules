# - Function to generate forward includes for your project
# This module provides the function ECM_GENERATE_HEADERS
#
# The ECM_GENERATE_HEADERS function is used to generate C/C++ forwarding header
# files for your project.
#
# To be more precise, there will be two kinds of headers being generated. Lowercase
# and CamelCase, for convenience. That means that for a class named "ClassA" in a
# module called "Module" we will get 2 different files: Module/ClassA and
# module/classa.h. Both these files will be including a "classa.h" file that is
# expected to be in the headers dir (see HEADERS_DIR argument below).
#
# ECM_GENERATE_HEADERS(camelcase_headers_var
#     HEADER_NAMES ClassA [ClassB [...]]
#     [OUTPUT_DIR output_dir]
#     [PREFIX prefix]
#     [REQUIRED_HEADERS variable]
#     [RELATIVE relative_path])
#
# The paths to the generated CamelCase headers will be appended to
# camelcase_headers_var.
#
# HEADER_NAMES lists the generated CamelCase header names.
#
# PREFIX places the headers in subdirectories.  This should be a CamelCase name
# like KParts, which will cause the CamelCase headers to be placed in the KParts
# directory (eg: KParts/Part).  It will also, for the convenience of code in the
# source distribution, generate forwarding lowercase headers, like
# kparts/part.h.  This allows includes like "#include <kparts/part.h>" to be
# used before installation, as long as the include_directories are set
# appropriately.
#
# The OUTPUT_DIR argument specifies where the files will be generated; this
# should be within the build directory. By default, CMAKE_CURRENT_BINARY_DIR
# will be used.  This option can be used to avoid file conflicts.
#
# The REQUIRED_HEADERS argument specifies an output variable name where all the
# required headers will be appended so that they can be installed together with
# the generated ones.  This is mostly intended as a convenience so that adding a
# new header to a project only requires specifying the CamelCase variant in the
# CMakeLists.txt file; the lowercase variant will then be added to this
# variable.
#
# The RELATIVE argument indicates where the lowercase headers can be found
# relative to CMAKE_CURRENT_SOURCE_DIR.  It does not affect the generated
# CamelCase files, but ECM_GENERATE_HEADERS uses it when checking that the
# lowercase header exists, and to generate lowercase forwarding headers when
# PREFIX is set.
#
# To allow other parts of the source distribution (eg: tests) to use the
# generated headers before installation, it may be desirable to set the
# INCLUDE_DIRECTORIES property for the library target to output_dir.  For
# example, if output_dir is CMAKE_CURRENT_BINARY_DIR (the default), you could do
#   target_include_directories(MyLib
#       PUBLIC "$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>")
#
# Example usage (without PREFIX):
# ecm_generate_headers(
#     MyLib_FORWARDING_HEADERS
#     HEADERS
#         MLFoo
#         MLBar
#         # etc
#     REQUIRED_HEADERS MyLib_HEADERS
# )
# install(FILES ${MyLib_FORWARDING_HEADERS} ${MyLib_HEADERS}
#         DESTINATION ${CMAKE_INSTALL_PREFIX}/include
#         COMPONENT Devel)
#
# Example usage (with PREFIX):
# ecm_generate_headers(
#     MyLib_FORWARDING_HEADERS
#     HEADERS
#         Foo
#         Bar
#         # etc
#     PREFIX MyLib
#     REQUIRED_HEADERS MyLib_HEADERS
# )
# install(FILES ${MyLib_FORWARDING_HEADERS}
#         DESTINATION ${CMAKE_INSTALL_PREFIX}/include/MyLib
#         COMPONENT Devel)
# install(FILES ${MyLib_HEADERS}
#         DESTINATION ${CMAKE_INSTALL_PREFIX}/include/mylib
#         COMPONENT Devel)
#
#
# Copyright 2013 Aleix Pol Gonzalez <aleixpol@blue-systems.com>
# Copyright 2014 Alex Merry <alex.merry@kdemail.net>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#

include(CMakeParseArguments)

# FIXME: remove when all the frameworks are ported to the new syntax
macro(_ECM_GENERATE_HEADERS_OLD)
    if(NOT EGH_MODULE_NAME)
        set(EGH_MODULE_NAME ${PROJECT_NAME})
    endif()

    string(TOLOWER ${EGH_MODULE_NAME} lowercasemodule)
    foreach(_CLASSNAME ${EGH_UNPARSED_ARGUMENTS})
        string(TOLOWER ${_CLASSNAME} lowercaseclassname)
        set(FANCY_HEADER_NAME ${EGH_OUTPUT_DIR}/${EGH_MODULE_NAME}/${EGH_PREFIX}${_CLASSNAME})
        set(_actualheader "${CMAKE_CURRENT_SOURCE_DIR}/${EGH_RELATIVE}${lowercaseclassname}.h")
        if (NOT EXISTS ${_actualheader})
            message(FATAL_ERROR "Could not find \"${_actualheader}\"")
        endif()
        if (NOT EXISTS ${FANCY_HEADER_NAME})
            file(WRITE ${FANCY_HEADER_NAME} "#include \"${lowercaseprefix}${lowercaseclassname}.h\"\n")
        endif()
        list(APPEND REQUIRED_HEADERS "${_actualheader}")
        if (EGH_PREFIX)
            #local forwarding header, for namespaced headers, e.g. kparts/part.h
            #this should not get installed, so we don't put it under EGH_MODULE_NAME
            set(REGULAR_HEADER_NAME ${EGH_OUTPUT_DIR}/${lowercaseprefix}${lowercaseclassname}.h)
            if (NOT EXISTS ${REGULAR_HEADER_NAME})
                file(WRITE ${REGULAR_HEADER_NAME} "#include \"${_actualheader}\"\n")
            endif()
        endif()
    endforeach()
    if (NOT EGH_REQUIRED_HEADERS STREQUAL "")
        set(${EGH_REQUIRED_HEADERS} ${${EGH_REQUIRED_HEADERS}} ${REQUIRED_HEADERS} PARENT_SCOPE)
    endif ()
endmacro()

function(ECM_GENERATE_HEADERS)
    set(options)
    set(oneValueArgs OUTPUT_DIR PREFIX REQUIRED_HEADERS RELATIVE MODULE_NAME)
    set(multiValueArgs HEADER_NAMES)
    cmake_parse_arguments(EGH "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if(NOT EGH_OUTPUT_DIR)
        set(EGH_OUTPUT_DIR "${CMAKE_CURRENT_BINARY_DIR}")
    endif()

    # Make sure EGH_RELATIVE is /-terminated when it's not empty
    if (EGH_RELATIVE AND NOT "${EGH_RELATIVE}" MATCHES "^.*/$")
        set(EGH_RELATIVE "${EGH_RELATIVE}/")
    endif()

    if (EGH_PREFIX)
        if (NOT "${EGH_PREFIX}" MATCHES "^.*/$")
            set(EGH_PREFIX "${EGH_PREFIX}/")
        endif()
        string(TOLOWER "${EGH_PREFIX}" lowercaseprefix)
    endif()

    if(NOT EGH_HEADER_NAMES)
        message(AUTHOR_WARNING "Please update your usage of ECM_GENERATE_HEADERS to the new syntax")
        _ecm_generate_headers_old()
        return()
    endif()

    if (EGH_MODULE_NAME)
        # this is not a valid argument in the new syntax
        message(FATAL_ERROR "Unexpected MODULE_NAME argument for ECM_GENERATE_HEADERS")
    endif()

    if (NOT EGH_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Missing camelcase_headers_var argument to ECM_GENERATE_HEADERS")
    else()
        list(GET EGH_UNPARSED_ARGUMENTS 0 camelcase_headers_var)
        list(REMOVE_AT EGH_UNPARSED_ARGUMENTS 0)
        if (EGH_UNPARSED_ARGUMENTS)
            message(FATAL_ERROR "Unexpected arguments to ECM_GENERATE_HEADERS: ${EGH_UNPARSED_ARGUMENTS}")
        endif()
    endif()

    foreach(_CLASSNAME ${EGH_HEADER_NAMES})
        string(TOLOWER "${_CLASSNAME}" lowercaseclassname)
        set(FANCY_HEADER_FILE "${EGH_OUTPUT_DIR}/${EGH_PREFIX}${_CLASSNAME}")
        set(_actualheader "${CMAKE_CURRENT_SOURCE_DIR}/${EGH_RELATIVE}${lowercaseclassname}.h")
        if (NOT EXISTS ${_actualheader})
            message(FATAL_ERROR "Could not find \"${_actualheader}\"")
        endif()
        if (NOT EXISTS ${FANCY_HEADER_FILE})
            file(WRITE ${FANCY_HEADER_FILE} "#include \"${lowercaseprefix}${lowercaseclassname}.h\"\n")
        endif()
        list(APPEND ${camelcase_headers_var} "${FANCY_HEADER_FILE}")
        if (EGH_REQUIRED_HEADERS)
            list(APPEND ${EGH_REQUIRED_HEADERS} "${_actualheader}")
        endif()
        if (EGH_PREFIX)
            # Local forwarding header, for namespaced headers, e.g. kparts/part.h
            set(REGULAR_HEADER_NAME ${EGH_OUTPUT_DIR}/${lowercaseprefix}${lowercaseclassname}.h)
            if (NOT EXISTS ${REGULAR_HEADER_NAME})
                file(WRITE ${REGULAR_HEADER_NAME} "#include \"${_actualheader}\"\n")
            endif()
        endif()
    endforeach()

    set(${camelcase_headers_var} ${${camelcase_headers_var}} PARENT_SCOPE)
    if (NOT EGH_REQUIRED_HEADERS STREQUAL "")
        set(${EGH_REQUIRED_HEADERS} ${${EGH_REQUIRED_HEADERS}} PARENT_SCOPE)
    endif ()
endfunction()
