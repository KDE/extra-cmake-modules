# SPDX-FileCopyrightText: 2026 Friedrich W. H. Kossebau <kossebau@kde.org>
#
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
ECMInstalledLibraryCheck
------------------------

Generates a check to test artifacts of the library installation, like the
self-containedness of the CMake config files as well as of the official public
headers in the deployed layout.

::

  ecm_add_installed_library_check(<library_target>
      [PACKAGE_NAME <package_name>]
      [PACKAGE_VERSION <package_version>]
      [PACKAGE_TARGET_NAMESPACE <package_target_namespace>]
      [NO_PACKAGE_TARGET_NAMESPACE]
      [COMPILE_DEFINITIONS <definition> [...]]
      [EXTRA_DEPENDENCIES <dependency> [<version>] [...]]
      [EXTRA_LINK_LIBRARIES <library> [...]])

The function creates a target "<library_target>_installed_library_check" which
can be invoked after the installation to check if the installed library artifacts
are self-contained when used from a consumer.
All these targets are added as dependency to a target
"all_installed_library_check", which is created at the level where this module
is first included.
The check generates a CMake project with a dummy library which searches the given
package for any specified version, links to the exported target as imported from
the package's Cmake config file and as its sources for each given include strings
adds a C++ source file with just the content "#include <include_string>".
This project then is configured with cmake and all these sources are built.

``PACKAGE_NAME`` specifies the name of the CMake package to check for.
The default is "${PROJECT_NAME}".

``PACKAGE_VERSION`` specifies the version of the CMake package to check for.
The default is "${PROJECT_VERSION}" if set, otherwise none.

``PACKAGE_TARGET_NAMESPACE`` specifies what namespace the exported target
name of the library is placed in. The default is the value estimated for
the package name, unless ``NO_PACKAGE_TARGET_NAMESPACE`` is set.

``NO_PACKAGE_TARGET_NAMESPACE`` defines that the library target is exported
in the package without any namespace.

``COMPILE_DEFINITIONS`` can be used to set custom definitions for the test
builds against the headers.

``EXTRA_DEPENDENCIES`` can be used to add custom dependencies to search for
with "find_package()`. This can be used if the current dependencies declared
in the installed CMake config are not complete, but can not be changed.

``EXTRA_LINK_LIBRARIES`` can be used to add custom libraries to link to with
"target_link_libraries()`. This can be used if the current list of libraries
in the public interface is not complete, but can not be changed.

::

  ecm_installed_library_check_include_strings(<library_target>
      HEADERS <package_name>
      [PREFIX <prefix>])


``HEADERS`` specifies the header files whose base names will be available as
public include strings.

``PREFIX`` specifies a prefix, which consumers need to append next to the base names
of the headers passed to ``HEADERS``. The argument <prefix> is specified without a
trailing "/". Default is none.


Example usage:

.. code-block:: cmake

  # add a non-default target "MyLib_installed_library_check",
  # which will test for a CMake config file for "MyPackage",
  # at version "1.0",  with the imported library target
  # "MyPackage::MyLib" and whose include strings (headers)
  # can be used self-contained when linking the target
  ecm_add_installed_library_check(MyLib
      PACKAGE_NAME "MyPackage"
      PACKAGE_VERSION "1.0"
  )

  # for any <MLFoo> etc. includes
  ecm_installed_library_check_include_strings(MyLib
      HEADERS
          /absolute/path/MLFoo
          relative/path/MLBar
          # etc
  )

  # for any <ML/Foo> etc. includes
  ecm_installed_library_check_include_strings(MyLib
      HEADERS
          /absolute/path/Foo
          relative/path/Bar
          # etc
      PREFIX ML
  )

Since 6.28
#]=======================================================================]

cmake_policy(VERSION 3.29)

if(NOT TARGET all_installed_library_check)
    add_custom_target(all_installed_library_check)
endif()

# Purpose: testing basic self-containedness of public headers and cmake config files
# no testing of actual symbols or template methods
# TODO: support testing with other build metadata formats, like pkgconfig?
function(ecm_add_installed_library_check _target)
    set(options NO_PACKAGE_TARGET_NAMESPACE)
    set(oneValueArgs PACKAGE_NAME PACKAGE_VERSION PACKAGE_TARGET_NAMESPACE)
    set(multiValueArgs EXTRA_DEPENDENCIES EXTRA_LINK_LIBRARIES COMPILE_DEFINITIONS)

    cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    # argument checks
    if(ARG_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Unknown keywords given to ecm_add_installed_library_check(): \"${ARG_UNPARSED_ARGUMENTS}\"")
    endif()
    if(ARG_NO_PACKAGE_TARGET_NAMESPACE AND ARG_PACKAGE_TARGET_NAMESPACE)
        message(FATAL_ERROR "ecm_add_installed_library_check cannot be called with both NO_PACKAGE_TARGET_NAMESPACE and PACKAGE_TARGET_NAMESPACE args.")
    endif()
    set(_library_types "STATIC_LIBRARY" "SHARED_LIBRARY" "INTERFACE_LIBRARY")
    get_target_property(_type ${_target} TYPE)
    if(NOT ${_type} IN_LIST _library_types)
        message(FATAL_ERROR "ecm_add_installed_library_check cannot be called on a target which is not some library. Was: ${_type}")
    endif()

    # setup data
    if(ARG_PACKAGE_NAME)
        set(_package_name "${ARG_PACKAGE_NAME}")
    else()
        set(_package_name "${PROJECT_NAME}")
    endif()
    if(ARG_PACKAGE_VERSION)
        set(_package_version ${ARG_PACKAGE_VERSION})
    else()
        if(PROJECT_VERSION)
            set(_package_version ${PROJECT_VERSION})
        else()
            set(_package_version)
        endif()
    endif()
    if(_package_version)
        set(_package_version_exact "EXACT")
    else()
        set(_package_version_exact)
    endif()
    if(ARG_PACKAGE_TARGET_NAMESPACE)
        set(_library_target_namespace ${ARG_PACKAGE_TARGET_NAMESPACE})
    else()
        if(ARG_NO_PACKAGE_TARGET_NAMESPACE)
            set(_library_target_namespace)
        else()
            set(_library_target_namespace "${_package_name}::")
        endif()
    endif()
    set(_extra_find_packages_statements)
    if(ARG_EXTRA_DEPENDENCIES)
        list(LENGTH ARG_EXTRA_DEPENDENCIES _deps_count)
        set(_i 0)
        while(${_i} LESS ${_deps_count})
            list(GET ARG_EXTRA_DEPENDENCIES ${_i} _extra_package_name)
            math(EXPR _i "${_i} + 1")
            set(_extra_package_version_string)
            # check next arg if it is version and thus to be consumed
            if(${_i} LESS ${_deps_count})
                list(GET ARG_EXTRA_DEPENDENCIES ${_i} _extra_package_version)
                if(_extra_package_version MATCHES "^([0-9]+)\\.([0-9]+)(\\.([0-9]+))?$")
                    set(_extra_package_version_string " ${_extra_package_version}")
                    math(EXPR _i "${_i} + 1")
                endif()
            endif()
            set(_extra_find_packages_statements "find_package(${_extra_package_name}${_extra_package_version_string} REQUIRED)\n")
        endwhile()
    endif()
    set(_extra_link_libraries_list)
    foreach(_link_library IN LISTS ARG_EXTRA_LINK_LIBRARIES)
        string(APPEND _extra_link_libraries_list "\n    ${_link_library}")
    endforeach()
    set(_compile_definitions_statement)
    if(ARG_COMPILE_DEFINITIONS)
        set(_compile_definitions_statement "target_compile_definitions(InstalledLibraryCheck PRIVATE ${ARG_COMPILE_DEFINITIONS})\n")
    endif()
    set(_prefix_path "${CMAKE_INSTALL_PREFIX}")

    # prepare (generator) expressions
    set(_installed_library_check_dir "${CMAKE_CURRENT_BINARY_DIR}/${_target}_ECMInstalledLibraryCheck")
    set(_include_strings "$<TARGET_PROPERTY:${_target},ECM_INSTALLED_LIBRARY_INCLUDE_STRINGS>")
    set(_include_strings_sorted "$<LIST:SORT,${_include_strings}>")
    set(_include_strings_lines "$<JOIN:${_include_strings_sorted},\n    >")
    set(_exported_target_name "$<TARGET_PROPERTY:${_target},EXPORT_NAME>")
    set(_library_target_name "${_library_target_namespace}$<IF:$<BOOL:${_exported_target_name}>,${_exported_target_name},${_target}>")

    file(GENERATE
        OUTPUT "${_installed_library_check_dir}/CMakeLists.txt"
        CONTENT
"# This file was generated by ecm_add_installed_library_check(). DO NOT EDIT!
cmake_minimum_required(VERSION 3.29)

project(InstalledLibraryCheck)

find_package(${_package_name} ${_package_version} ${_package_version_exact} CONFIG PATHS \"${_prefix_path}\" NO_DEFAULT_PATH REQUIRED)
${_extra_find_packages_statements}
include(FeatureSummary)
feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)

add_library(InstalledLibraryCheck MODULE)
target_link_libraries(InstalledLibraryCheck
    ${_library_target_name}${_extra_link_libraries_list}
)
${_compile_definitions_statement}
set(_include_strings
    ${_include_strings_lines}
)

foreach(_include_string IN LISTS _include_strings)
    string(REPLACE \"/\" \"__\" _escaped_include_string \${_include_string})
    set(_source_file \"\${CMAKE_CURRENT_BINARY_DIR}/\${_escaped_include_string}.cpp\")
    file(GENERATE OUTPUT \${_source_file} CONTENT \"#include <\${_include_string}>\\n\")
    target_sources(InstalledLibraryCheck PRIVATE \${_source_file})
endforeach()
"
    )

    set(_check_target_name ${_target}_installed_library_check)
    add_custom_target(${_check_target_name}
        COMMAND ${CMAKE_COMMAND}
            # TODO: other options to pass on? e.g. for cross-compilation, tool-chain file?
            -G ${CMAKE_GENERATOR}
            -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
            -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
            --fresh
            .
        COMMAND ${CMAKE_COMMAND} --build .
        WORKING_DIRECTORY ${_installed_library_check_dir}
    )

    add_dependencies(all_installed_library_check ${_check_target_name})
endfunction()

function(ecm_installed_library_check_include_strings _target)
    set(options)
    set(oneValueArgs PREFIX)
    set(multiValueArgs HEADERS)

    cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    get_target_property(_names ${_target} ECM_INSTALLED_LIBRARY_INCLUDE_STRINGS)
    if(_names STREQUAL "_names-NOTFOUND")
        set(_names)
    endif()

    if(ARG_PREFIX)
        string(APPEND ARG_PREFIX "/")
    endif()
    foreach(_header IN LISTS ARG_HEADERS)
        cmake_path(GET _header FILENAME _name)
        list(APPEND _names "${ARG_PREFIX}${_name}")
    endforeach()

    set_target_properties(${_target} PROPERTIES ECM_INSTALLED_LIBRARY_INCLUDE_STRINGS "${_names}")
endfunction()
