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
# ECM_GENERATE_HEADERS( ClassA ClassB ...
#     [MODULE_NAME name]
#     [OUTPUT_DIR path]
#     [REQUIRED_HEADERS variable])
#
# The MODULE_NAME argument is used to provide information about where the
# directories will be generated. By default, PROJECT_NAME will be used in both
# CamelCase and lowercase version.
#
# The OUTPUT_DIR argument specifies where the files will be generated; this
# should be within the build directory. By default, CMAKE_CURRENT_BINARY_DIR
# will be used.
#
# The REQUIRED_HEADERS argument will receive an output variable name where all
# the required headers will be appended so that they can be installed together
# with the generated ones.
#
# The RELATIVE argument will specify where are the original headers from the
# current directory.
#
#
# Copyright (c) 2013, Aleix Pol Gonzalez <aleixpol@blue-systems.com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#

include(CMakeParseArguments)

function(ECM_GENERATE_HEADERS)
    set(oneValueArgs MODULE_NAME OUTPUT_DIR REQUIRED_HEADERS RELATIVE)
    cmake_parse_arguments(EGH "" "${oneValueArgs}" "" ${ARGN})
    if(NOT EGH_MODULE_NAME)
        set(EGH_MODULE_NAME ${PROJECT_NAME})
    endif()

    if(NOT EGH_OUTPUT_DIR)
        set(EGH_OUTPUT_DIR ${CMAKE_CURRENT_BINARY_DIR})
    endif()

    string(TOLOWER ${EGH_MODULE_NAME} lowercasemodule)
    foreach(_CLASSNAME ${EGH_UNPARSED_ARGUMENTS})
        string(TOLOWER ${_CLASSNAME} lowercaseclassname)
        set(REGULAR_HEADER_NAME ${EGH_OUTPUT_DIR}/${lowercasemodule}/${lowercaseclassname}.h)
        set(FANCY_HEADER_NAME ${EGH_OUTPUT_DIR}/${EGH_MODULE_NAME}/${_CLASSNAME})
        set(_actualheader "${CMAKE_CURRENT_SOURCE_DIR}/${EGH_RELATIVE}/${lowercaseclassname}.h")
        if (NOT EXISTS ${_actualheader})
            message(FATAL_ERROR "Could not find \"${_actualheader}\"")
        endif()
        if (NOT EXISTS ${REGULAR_HEADER_NAME})
            file(WRITE ${REGULAR_HEADER_NAME} "#include \"${_actualheader}\"\n")
        endif()
        if (NOT EXISTS ${FANCY_HEADER_NAME})
            file(WRITE ${FANCY_HEADER_NAME} "#include \"${lowercasemodule}/${lowercaseclassname}.h\"\n")
        endif()
        list(APPEND REQUIRED_HEADERS "${_actualheader}")
    endforeach()
    if (NOT EGH_REQUIRED_HEADERS STREQUAL "")
        set(${EGH_REQUIRED_HEADERS} ${${EGH_REQUIRED_HEADERS}} ${REQUIRED_HEADERS} PARENT_SCOPE)
    endif ()
endfunction()
