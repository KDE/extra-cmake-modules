# SPDX-FileCopyrightText: 2026 Friedrich W. H. Kossebau <kossebau@kde.org>
#
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
ECMInstalledLibraryCheck
------------------------

Generates a check to test artifacts of the library installation, like the
self-containedness of the CMake config files as well as of the official public
headers in the deployed directory layout.

::

  ecm_add_installed_library_check(<library_target>
      [PACKAGE_NAME <package_name>]
      [PACKAGE_VERSION <package_version>]
      {NO_PACKAGE_VERSION]
      [PACKAGE_TARGET_NAMESPACE <package_target_namespace>]
      [NO_PACKAGE_TARGET_NAMESPACE]
      [COMPILE_DEFINITIONS <definition> [...]]
      [EXTRA_DEPENDENCIES <dependency> [<version>] [...]]
      [EXTRA_LINK_LIBRARIES <library> [...]]
  )

The function creates a target ``<library_target>_installed_library_check`` which
can be invoked after the installation to check if the installed library
artifacts are self-contained when used by a consumer.
All these targets are added as dependency to a target
``all_installed_library_check``, which is created at the level where this module
is included, if there is none yet.

The check generates a CMake project with a dummy library which searches the
given package for any specified version, links to the exported target as
imported from the package's CMake config file and as its sources add for each
given include strings a source file with just the content
``#include <include_string>``. Additionally checks are added to the CMake code
and the source files for any CMake variables, compile definitions and
preprocessor macros as configured by the additional functions (see below).
This project then is configured with CMake and all these sources are built. The
check is considered as passed, when the build completes.

``PACKAGE_NAME`` specifies the name of the CMake package to check for.
The default is ``${PROJECT_NAME}``.

``PACKAGE_VERSION`` specifies the version of the CMake package to check for.
The default is ``${PROJECT_VERSION}`` if set and ``NO_PACKAGE_VERSION`` not
being used, otherwise none.

``NO_PACKAGE_VERSION`` defines that the CMake package has no version to check
for.

``PACKAGE_TARGET_NAMESPACE`` specifies what namespace the exported target
name of the library is placed in. The default is the value estimated for
the package name, unless ``NO_PACKAGE_TARGET_NAMESPACE`` is set.

``NO_PACKAGE_TARGET_NAMESPACE`` defines that the library target is exported
in the package without any namespace.

``COMPILE_DEFINITIONS`` can be used to set custom definitions for the test
builds against the headers.

``EXTRA_DEPENDENCIES`` can be used to add custom dependencies to search for
with ``find_package()``. This can be used if the current dependencies declared
in the installed CMake config file are not complete, but can not be changed.

``EXTRA_LINK_LIBRARIES`` can be used to add custom libraries to link to with
``target_link_libraries()``. This can be used if the current list of libraries
in the public interface is not complete, but can not be changed.

::

  ecm_installed_library_check_include_strings(<library_target>
      HEADERS <header> [...]
      [PREFIX <prefix>]
  )

This function registers include strings with the check, by listing files
which will be used as official public headers.

``HEADERS`` specifies the header files whose base names will be available as
public include strings. The actual path of any file listed is ignored, it also
does not need to reference any existing file.

``PREFIX`` specifies a prefix which consumers need to prepend to the base
names of the headers passed to ``HEADERS``. The argument ``<prefix>`` is
specified without a trailing "/". Default is none.

::

  ecm_installed_library_check_cmake_variable(<library_target>
      NAME <name>
      [VALUE <value>]
      [UNDEFINED]
      [TYPE <type>]
  )

This function registers a CMake variable with the check which should be tested
for presence and its value after the library's CMake package has been found.

``NAME`` specifies the name of a variable expected to be set after finding the
package.

``VALUE`` specifies the value expected to be set for the variable. For
variables of the type ``BOOL`` the usual evaluation of CMake to a boolean value
is checked. If this argument is not passed, the variable. is only tested for
being defined.

``UNDEFINED`` specifies if the variable should be tested for being undefined.

``TYPE`` specifies the type of the variable. The options are ``BOOL``,
``STRING``. Default is ``STRING``.

::

  ecm_installed_library_check_compile_definition(<library_target>
      NAME <name>
      [VALUE <value>]
      [UNDEFINED]
  )

This function registers a compile definition with the check which should be
tested for being set on the imported library target.

``NAME`` specifies the name of the compile definition to test.

``VALUE`` specifies the value expected to be set for the compile definition.
If this argument is not passed, the compile definition is only tested for being
defined. Only numeric values are supported.

``UNDEFINED`` specifies if the compile definition should be tested for being
undefined.

::

  ecm_installed_library_check_preprocessor_macro(<library_target>
      NAME <name>
      [VALUE <value>]
      [UNDEFINED]
  )

This function registers a preprocessor macro with the check which should be
tested for being present with all registered include strings.

``NAME`` specifies the name of the macro to test.

``VALUE`` specifies the value expected to be set for the macro. If this argument
is not passed, the macro is only tested for being defined. Only numeric values
are supported.

``UNDEFINED`` specifies if the macro should be tested for being undefined.

::

  ecm_installed_library_check_version_preprocessor_macros(<library_target>
      [PREFIX <prefix>]
      [VERSION <version>]
  )

This function is a convenience utility to register a usual set of preprocessor
macros with the check which should be tested for being present with all
registered include strings and match the given version. Such macros are e.g.
created by the macro ``ecm_setup_version()`` from the module
:module:`ECMSetupVersion` when using the ``VERSION_HEADER`` argument to
generate a version header.

``PREFIX`` specifies the prefix of the version macros to test. The expected
macro names are:

* ``<prefix>_VERSION`` (hexadecimal number in ``0xMMmmpp`` format)
* ``<prefix>_VERSION_MAJOR``
* ``<prefix>_VERSION_MINOR``
* ``<prefix>_VERSION_PATCH``

Default is the library target name in upper case.

``VERSION`` specifies the version string "<major>.<minor>.<patch>" with the
expected version values. The default is any "VERSION" property set on the
target, otherwise any package version defined for the check, or otherwise
``${PROJECT_VERSION}``.

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

Since 6.30
#]=======================================================================]

cmake_policy(VERSION 3.29)

# create global target, at include level
if(NOT TARGET all_installed_library_check)
    add_custom_target(all_installed_library_check)
endif()


function(ecm_add_installed_library_check _target)
    set(options NO_PACKAGE_TARGET_NAMESPACE NO_PACKAGE_VERSION)
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
    if(ARG_NO_PACKAGE_VERSION AND ARG_PACKAGE_VERSION)
        message(FATAL_ERROR "ecm_add_installed_library_check cannot be called with both NO_PACKAGE_VERSION and PACKAGE_VERSION args.")
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
        if(NOT ARG_NO_PACKAGE_VERSION AND PROJECT_VERSION)
            set(_package_version ${PROJECT_VERSION})
        else()
            set(_package_version)
        endif()
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

    set(_compiler_propagation)
    foreach(_compiler IN ITEMS CMAKE_C_COMPILER CMAKE_CXX_COMPILER)
        if (${_compiler})
            list(APPEND _compiler_propagation "-D${_compiler}=${${_compiler}}")
        endif()
    endforeach()

    set(_languages)
    if (CMAKE_C_COMPILER)
        list(APPEND _languages "C")
    endif()
    if (CMAKE_CXX_COMPILER)
        list(APPEND _languages "CXX")
    endif()

    set(_installed_library_check_dir "${CMAKE_CURRENT_BINARY_DIR}/${_target}_ECMInstalledLibraryCheck")

    # prepare (generator) expressions, to pick up data for the check set only after this function's call
    set(_include_strings "$<TARGET_PROPERTY:${_target},ECM_INSTALLED_LIBRARY_INCLUDE_STRINGS>")
    set(_include_strings_sorted "$<LIST:SORT,${_include_strings}>")

    set(_exported_target_name "$<TARGET_PROPERTY:${_target},EXPORT_NAME>")
    set(_library_target_name "${_library_target_namespace}$<IF:$<BOOL:${_exported_target_name}>,${_exported_target_name},${_target}>")

    set(_cmake_variables_check_data "$<TARGET_PROPERTY:${_target},ECM_INSTALLED_LIBRARY_CMAKE_VARIABLES_CHECK_DATA>")

    set(_compile_definitions_check_data "$<TARGET_PROPERTY:${_target},ECM_INSTALLED_LIBRARY_COMPILE_DEFINITIONS_CHECK_DATA>")

    set(_preprocessor_macro_check_data "$<TARGET_PROPERTY:${_target},ECM_INSTALLED_LIBRARY_PREPROCESSOR_MACRO_CHECK_DATA>")
    set(_version_check_prefix "$<TARGET_PROPERTY:${_target},ECM_INSTALLED_LIBRARY_VERSION_PREPROCESSOR_MACRO_CHECK_PREFIX>")
    set(_version_check_data "$<TARGET_PROPERTY:${_target},ECM_INSTALLED_LIBRARY_VERSION_PREPROCESSOR_MACRO_CHECK_DATA>")
    set(_version_preprocessor_macro_check_data "$<$<BOOL:${_version_check_data}>:${_version_check_prefix}:>${_version_check_data}$<$<STREQUAL:${_version_check_data},DEFAULT>:|$<TARGET_PROPERTY:${_target},VERSION>|${_package_version}>")

    # prepare non-generator-expression list values for passing as command
    # avoids space being used as list separator when expanding there even inside ""
    list(JOIN _languages $<SEMICOLON> _languages)
    list(JOIN ARG_EXTRA_DEPENDENCIES $<SEMICOLON> _extra_dependencies)
    list(JOIN ARG_EXTRA_LINK_LIBRARIES $<SEMICOLON> _extra_link_libraries)
    list(JOIN ARG_COMPILE_DEFINITIONS $<SEMICOLON> _compile_definitions)

    # prepare dir
    file(MAKE_DIRECTORY ${_installed_library_check_dir})

    set(_check_target_name ${_target}_installed_library_check)

    add_custom_target(${_check_target_name}
        COMMENT "Running installed library check for ${_target}"
        COMMAND ${CMAKE_COMMAND}
            -DOUTPUT_DIR="${_installed_library_check_dir}"
            -DLANGUAGES="${_languages}"
            -DPACKAGE_NAME="${_package_name}"
            -DPACKAGE_VERSION="${_package_version}"
            -DPACKAGE_INSTALL_PREFIX="${CMAKE_INSTALL_PREFIX}"
            -DLIBRARY_TARGET_NAME="${_library_target_name}"
            -DEXTRA_DEPENDENCIES="${_extra_dependencies}"
            -DEXTRA_LINK_LIBRARIES="${_extra_link_libraries}"
            -DEXTRA_COMPILE_DEFINITIONS="${_compile_definitions}"
            -DINCLUDE_STRINGS="${_include_strings_sorted}"
            -DCMAKE_VARIABLES_CHECK_DATA="${_cmake_variables_check_data}"
            -DCOMPILE_DEFINITIONS_CHECK_DATA="${_compile_definitions_check_data}"
            -DPREPROCESSOR_MACRO_CHECK_DATA="${_preprocessor_macro_check_data}"
            -DVERSION_PREPROCESSOR_MACRO_CHECK_DATA="${_version_preprocessor_macro_check_data}"
            -P "${CMAKE_CURRENT_FUNCTION_LIST_DIR}/ecm_create_installed_library_check.cmake"
        COMMAND ${CMAKE_COMMAND}
            # TODO: other options to pass on? e.g. for cross-compilation, tool-chain file?
            -G ${CMAKE_GENERATOR}
            ${_compiler_propagation}
            --fresh
            .
        COMMAND ${CMAKE_COMMAND} --build .
        WORKING_DIRECTORY ${_installed_library_check_dir}
        JOB_SERVER_AWARE
    )

    add_dependencies(all_installed_library_check ${_check_target_name})
endfunction()


function(ecm_installed_library_check_include_strings _target)
    set(options)
    set(oneValueArgs PREFIX)
    set(multiValueArgs HEADERS)

    cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    # argument checks
    if(ARG_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Unknown keywords given to ecm_installed_library_check_include_strings(): \"${ARG_UNPARSED_ARGUMENTS}\"")
    endif()

    # store data with library target
    get_target_property(_names ${_target} ECM_INSTALLED_LIBRARY_INCLUDE_STRINGS)
    if(_names STREQUAL "_names-NOTFOUND")
        set(_names)
    endif()

    if(ARG_PREFIX)
        string(APPEND ARG_PREFIX "/")
    endif()

    # turn file names into include strings, with optional prefix
    foreach(_header IN LISTS ARG_HEADERS)
        cmake_path(GET _header FILENAME _name)
        list(APPEND _names "${ARG_PREFIX}${_name}")
    endforeach()

    set_target_properties(${_target} PROPERTIES ECM_INSTALLED_LIBRARY_INCLUDE_STRINGS "${_names}")
endfunction()


function(ecm_installed_library_check_cmake_variable _target)
    set(options UNDEFINED)
    set(oneValueArgs NAME TYPE VALUE)
    set(multiValueArgs)

    cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    # argument checks
    if(ARG_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Unknown keywords given to ecm_installed_library_check_cmake_variable(): \"${ARG_UNPARSED_ARGUMENTS}\"")
    endif()
    if(NOT DEFINED ARG_NAME)
        message(FATAL_ERROR "Missing NAME argument to ecm_installed_library_check_cmake_variable().")
    endif()
    if(DEFINED ARG_VALUE AND ARG_UNDEFINED)
        message(FATAL_ERROR "ecm_installed_library_check_cmake_variable cannot be called with both VALUE and UNDEFINED args.")
    endif()
    if(ARG_TYPE)
        set(_variable_types "BOOL" "STRING")
        if(NOT ${ARG_TYPE} IN_LIST _variable_types)
            message(FATAL_ERROR "ecm_installed_library_check_cmake_variable called with unknown type: ${ARG_TYPE}")
        endif()
    else()
        set(ARG_TYPE "STRING")
    endif()

    # store data with library target
    get_target_property(_data ${_target} ECM_INSTALLED_LIBRARY_CMAKE_VARIABLES_CHECK_DATA)
    if(_data STREQUAL "_data-NOTFOUND")
        set(_data)
    endif()

    if(DEFINED ARG_VALUE)
        set(_var_check_data "${ARG_NAME}=${ARG_VALUE}")
    elseif(ARG_UNDEFINED)
        set(_var_check_data "${ARG_NAME}!")
    else() # defined
        set(_var_check_data "${ARG_NAME}?")
    endif()
    if(${ARG_TYPE} STREQUAL "BOOL")
        string(PREPEND _var_check_data "B:")
    else() # STRING
        string(PREPEND _var_check_data "S:")
    endif()

    list(APPEND _data "${_var_check_data}")
    set_target_properties(${_target} PROPERTIES ECM_INSTALLED_LIBRARY_CMAKE_VARIABLES_CHECK_DATA "${_data}")
endfunction()


function(_ecm_installed_library_check_preprocessor_macro_check_data _var_name _name _check_type _value)
    if(_check_type STREQUAL "VALUE")
        set(_var_check_data "${_name}=${_value}")
    elseif(_check_type STREQUAL "UNDEFINED")
        set(_var_check_data "${_name}!")
    else() # "DEFINED"
        set(_var_check_data "${_name}?")
    endif()
    set(${_var_name} "${_var_check_data}" PARENT_SCOPE)
endfunction()


function(ecm_installed_library_check_compile_definition _target)
    set(options UNDEFINED)
    set(oneValueArgs NAME VALUE)
    set(multiValueArgs)

    cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    # argument checks
    if(ARG_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Unknown keywords given to ecm_installed_library_check_compile_definition(): \"${ARG_UNPARSED_ARGUMENTS}\"")
    endif()
    if(NOT DEFINED ARG_NAME)
        message(FATAL_ERROR "Missing NAME argument to ecm_installed_library_check_compile_definition().")
    endif()
    if(DEFINED ARG_VALUE AND ARG_UNDEFINED)
        message(FATAL_ERROR "ecm_installed_library_check_compile_definition cannot be called with both VALUE and UNDEFINED args.")
    endif()

    # store data with library target
    get_target_property(_data ${_target} ECM_INSTALLED_LIBRARY_COMPILE_DEFINITIONS_CHECK_DATA)
    if(_data STREQUAL "_data-NOTFOUND")
        set(_data)
    endif()

    if(DEFINED ARG_VALUE)
        set(_check_type "VALUE")
    elseif(ARG_UNDEFINED)
        set(_check_type "UNDEFINED")
    else()
        set(_check_type "DEFINED")
    endif()

    _ecm_installed_library_check_preprocessor_macro_check_data(_var_check_data ${ARG_NAME} ${_check_type} "${ARG_VALUE}")

    list(APPEND _data "${_var_check_data}")
    set_target_properties(${_target} PROPERTIES ECM_INSTALLED_LIBRARY_COMPILE_DEFINITIONS_CHECK_DATA "${_data}")
endfunction()


function(ecm_installed_library_check_preprocessor_macro _target)
    set(options UNDEFINED)
    set(oneValueArgs NAME VALUE)
    set(multiValueArgs)

    cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    # argument checks
    if(ARG_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Unknown keywords given to ecm_installed_library_check_preprocessor_macro(): \"${ARG_UNPARSED_ARGUMENTS}\"")
    endif()
    if(NOT DEFINED ARG_NAME)
        message(FATAL_ERROR "Missing NAME argument to ecm_installed_library_check_preprocessor_macro().")
    endif()
    if(ARG_VALUE AND ARG_UNDEFINED)
        message(FATAL_ERROR "ecm_installed_library_check_preprocessor_macro cannot be called with both VALUE and UNDEFINED args.")
    endif()

    # store data with library target
    get_target_property(_data ${_target} ECM_INSTALLED_LIBRARY_PREPROCESSOR_MACRO_CHECK_DATA)
    if(_data STREQUAL "_data-NOTFOUND")
        set(_data)
    endif()

    if(DEFINED ARG_VALUE)
        set(_check_type "VALUE")
    elseif(ARG_UNDEFINED)
        set(_check_type "UNDEFINED")
    else()
        set(_check_type "DEFINED")
    endif()

    _ecm_installed_library_check_preprocessor_macro_check_data(_var_check_data ${ARG_NAME} ${_check_type} "${ARG_VALUE}")

    list(APPEND _data "${_var_check_data}")
    set_target_properties(${_target} PROPERTIES ECM_INSTALLED_LIBRARY_PREPROCESSOR_MACRO_CHECK_DATA "${_data}")
endfunction()


function(ecm_installed_library_check_version_preprocessor_macros _target)
    set(options)
    set(oneValueArgs PREFIX VERSION)
    set(multiValueArgs)

    cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    # argument checks
    if(ARG_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Unknown keywords given to ecm_installed_library_check_version_preprocessor_macros(): \"${ARG_UNPARSED_ARGUMENTS}\"")
    endif()

    if(DEFINED ARG_PREFIX)
        set(_prefix "${ARG_PREFIX}")
    else()
        string(TOUPPER "${_target}" _prefix)
    endif()

    # storing separately, as *_DATA will need to be generator-expression-compared to "DEFAULT"
    set_target_properties(${_target} PROPERTIES ECM_INSTALLED_LIBRARY_VERSION_PREPROCESSOR_MACRO_CHECK_PREFIX "${_prefix}")

    if(DEFINED ARG_VERSION)
        set(_version "${ARG_VERSION}")
    else()
        set(_version "DEFAULT")
    endif()
    set_target_properties(${_target} PROPERTIES ECM_INSTALLED_LIBRARY_VERSION_PREPROCESSOR_MACRO_CHECK_DATA "${_version}")
endfunction()
