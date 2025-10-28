# SPDX-FileCopyrightText: 2013 Alexander Richardson <arichardson.kde@gmail.com>
# SPDX-FileCopyrightText: 2015 Alex Merry <alex.merry@kde.org>
# SPDX-FileCopyrightText: 2025 Friedrich W. H. Kossebau <kossebau@kde.org>
#
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
ECMAddTests
-----------

Convenience functions for adding tests.

::

  ecm_add_tests(<sources>
      [COMPILE_DEFINITIONS <definition> [<definition> [...]]] # Since 6.13.0
      [ENVIRONMENT <list>]  # Since 6.13.0
      LINK_LIBRARIES <library> [<library> [...]]
      [NAME_PREFIX <prefix> (| NO_NAME_PREFIX] # Since 6.22.0)
      [GUI]
      [TARGET_NAMES_VAR <target_names_var>]
      [TEST_NAMES_VAR <test_names_var>]
      [WORKING_DIRECTORY <dir>] #  Since 5.111
  )

A convenience function for adding multiple tests, each consisting of a
single source file. For each file in <sources>, an executable target is
created (whose name is the base name of the source file) with the compiler
definitions passed with ``COMPILE_DEFINITIONS``. This will be linked
against the libraries given with ``LINK_LIBRARIES``. Each executable will
be added as a test with the same name and can have an environment provided
by ``ENVIRONMENT``.

If ``NAME_PREFIX`` is given, this prefix will be prepended to the test names, but
not the target names. As a result, it will not prevent clashes between tests
with the same name in different parts of the project, but it can be used to
give an indication of where to look for a failing test.
If ``NAME_PREFIX`` is not set, it will default to a value depending on the
strategy as controlled by the variable ``ECM_TEST_NAME_PREFIX_STRATEGY``, if
set in the current scope and ``NO_NAME_PREFIX`` is not set (since 6.22).

If the flag ``GUI`` is passed the test binaries will be GUI executables, otherwise
the resulting binaries will be console applications (regardless of the value
of ``CMAKE_WIN32_EXECUTABLE`` or ``CMAKE_MACOSX_BUNDLE``). Be aware that this changes
the executable entry point on Windows (although some frameworks, such as Qt,
abstract this difference away).

The tests will be build with ``-DQT_FORCE_ASSERTS`` to enable assertions in the
test executable even for release builds.

The ``TARGET_NAMES_VAR`` and ``TEST_NAMES_VAR`` arguments, if given, should specify a
variable name to receive the list of generated target and test names,
respectively. This makes it convenient to apply properties to them as a
whole, for example, using ``set_target_properties()`` or  ``set_tests_properties()``.

The generated target executables will have the effects of ``ecm_mark_as_test()``
(from the :module:`ECMMarkAsTest` module) applied to it.

``WORKING_DIRECTORY`` sets the test property `WORKING_DIRECTORY
<https://cmake.org/cmake/help/latest/prop_test/WORKING_DIRECTORY.html>`_
in which to execute the test. By default the test will be run in
``${CMAKE_CURRENT_BINARY_DIR}``. The working directory can be specified using
generator expressions. Since 5.111.

::

  ecm_add_test(
      <sources>
      [COMPILE_DEFINITIONS <definition> [<definition> [...]]] # Since 6.13.0
      [ENVIRONMENT <list>]  # Since 6.13.0
      LINK_LIBRARIES <library> [<library> [...]]
      [TEST_NAME <name>]
      [NAME_PREFIX <prefix> (| NO_NAME_PREFIX] # Since 6.22.0)
      [GUI]
      [TARGET_NAME_VAR <target_name_var>]
      [TEST_NAME_VAR <test_name_var>]
      [WORKING_DIRECTORY <dir>] #  Since 5.111
  )

This is a single-test form of ``ecm_add_tests`` that allows multiple source files
to be used for a single test. If using multiple source files, ``TEST_NAME`` must
be given; this will be used for both the target and test names.

As with ``ecm_add_tests()``, the ``NAME_PREFIX`` argument will be prepended to
the test name.
If ``NAME_PREFIX`` is not set, it will default to a value depending on the
strategy as controlled by the variable ``ECM_TEST_NAME_PREFIX_STRATEGY``, if
set in the current scope and ``NO_NAME_PREFIX`` is not set (since 6.22).

The ``TARGET_NAME_VAR`` and ``TEST_NAME_VAR`` arguments, if given, should specify a
variable name to receive the generated target and test name,
respectively. This makes it convenient to apply properties to them as a
whole, for example, using ``set_target_properties()`` or  ``set_tests_properties()``.

``WORKING_DIRECTORY`` sets the test property `WORKING_DIRECTORY
<https://cmake.org/cmake/help/latest/prop_test/WORKING_DIRECTORY.html>`_
in which to execute the test. By default the test will be run in
``${CMAKE_CURRENT_BINARY_DIR}``. The working directory can be specified using
generator expressions. Since 5.111.

::

  ecm_test_set_dir_properties( # Since 6.22.0
      [DIR <dir>]
      [PREFIX_NAME <name>]
      [PREFIX_NAME_IGNORE | PREFIX_NAME_NOT_IGNORE]
      [FIRST_PREFIX_NAME]
      [LAST_PREFIX_NAME]
  )


The function can be used to set properties to individual directories to
influence the behaviour of the test functions. The properties will be set to
the current source directory. For source directories which themselves do not
have a CMakeLists.txt file and thus are not added by any `add_subdirectory()
<https://cmake.org/cmake/help/latest/command/add_subdirectory.html>`_ calls,
the ``DIR`` argument can be used to instead set the property to any such
subdirectory ``<dir>``.

``PREFIX_NAME`` can be used to override by ``<name>`` the name derived from
the given directory.

``PREFIX_NAME_IGNORE`` or ``PREFIX_NAME_NOT_IGNORE`` can be used to override
the filtering done by ``ECM_TEST_NAME_PREFIX_IGNORE_DIRS`` for the name of the
given directory.

``FIRST_PREFIX_NAME`` and ``LAST_PREFIX_NAME`` can be used to limit the range
of directories in the path used for deriving the prefix name.

::

  ecm_test_get_name_prefix( # Since 6.22.0
      <name_prefix_var>
  )

The ``name_prefix_var`` argument should specify a variable name to receive the
default test prefix name for the current scope, based on
the value of ``ECM_TEST_NAME_PREFIX_STRATEGY`` and the respective further setup.

::

  ECM_TEST_NAME_PREFIX_STRATEGY # Since 6.22.0

This variable is specifying the strategy to use when estimating the default
test name prefix to use by the macros ``ecm_add_tests()`` and ``ecm_add_test()``
when no explicit ``NAME_PREFIX`` argument is passed. The supported values are:

    * ``VARIABLE``: The default name prefix is taken from the value of the variable
      ``ECM_TEST_NAME_PREFIX`` in the scope where the macros are called.

    * ``PATH``: The default name prefix is derived from the relative path of the
      current source directory where the macros are called, by replacing the
      dir separators with "-".
      See also ``ECM_TEST_NAME_PREFIX_IGNORE_DIRS`` for skipping some directory names.

When unset, the ``VARIABLE`` strategy is used.

::

  ECM_TEST_NAME_PREFIX # Since 6.22.0

When ``ECM_TEST_NAME_PREFIX_STRATEGY`` is set to ``VARIABLE``,
the current value of the variable is used as default for the test name prefix.

::

  ECM_TEST_NAME_PREFIX_IGNORE_DIRS # Since 6.22.0

When ``ECM_TEST_NAME_PREFIX_STRATEGY`` is set to ``PATH``, this variable is used
to filter out directory names in the relative path of the current source directory
when deriving the name prefix. By default the variable is set to
"src", "test", "tests", "autotest", "autotests" when including the ``ECMAddTest`` module,
if not already defined.


Example usage:

.. code-block:: cmake

  set(ECM_TEST_NAME_PREFIX_STRATEGY "PATH")
  list(APPEND ECM_TEST_NAME_PREFIX_IGNORE_DIRS "plugins")

  # Being in subdir "src/plugins/foo" this test will get
  # the test name prefix set to "foo-", next to base name "mytest":
  ecm_add_test(
      mytest.cpp
      LINK_LIBRARIES mylib
  )

Since pre-1.0.0.
#]=======================================================================]

cmake_policy(VERSION 3.16)

include(ECMMarkAsTest)
include(ECMMarkNonGuiExecutable)

# set variable on the include scope, as consumers are supposed to have access to it
if(NOT DEFINED ECM_TEST_NAME_PREFIX_IGNORE_DIRS)
    set(ECM_TEST_NAME_PREFIX_IGNORE_DIRS "src" "test" "tests" "autotest" "autotests")
endif()

function(_ecm_test_name_prefix_from_project_path _name_prefix_varname)
    # estimate names of chain of dirs of current source dir to main dir
    file(RELATIVE_PATH _project_path ${CMAKE_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR})

    if(_project_path MATCHES "^\\.\\./")
        message(FATAL_ERROR "The PATH strategy can not be used with directories outside the root source dir.")
    endif()

    string(REPLACE "/" ";" _dirs ${_project_path})

    # derive prefix names
    set(_names)
    set(_subpath ${CMAKE_SOURCE_DIR})
    set(_lastcmakesubpath ${_subpath}) # path of current including CMakeLists.txt
    set(_relativelastcmakesubpath)
    get_directory_property(_cmakesubdirs DIRECTORY ${_lastcmakesubpath} "SUBDIRECTORIES")
    foreach(_dir ${_dirs})
        string(APPEND _subpath "/${_dir}")

        # subdir with CMakeLists.txt?
        if(_subpath IN_LIST _cmakesubdirs)
            set(_lastcmakesubpath ${_subpath})
            set(_relativelastcmakesubpath)
            set(_property_name_suffix)
            # prepare nexs subdir
            get_directory_property(_cmakesubdirs DIRECTORY ${_lastcmakesubpath} "SUBDIRECTORIES")
        else()
            string(APPEND _relativelastcmakesubpath "/${_dir}")
            # keep in sync with writing the properties in ecm_test_set_dir_properties
            string(SHA1 _relativelastcmakesubpath_hash ${_relativelastcmakesubpath})
            set(_property_name_suffix ":${_relativelastcmakesubpath_hash}")
        endif()

        get_directory_property(_substitute_name DIRECTORY ${_lastcmakesubpath} "ECM_TEST_NAME_PREFIX_DIR_NAME${_property_name_suffix}")

        get_directory_property(_first_name DIRECTORY ${_lastcmakesubpath} "ECM_TEST_NAME_PREFIX_DIR_FIRST${_property_name_suffix}")

        if(_first_name)
            # drop any current names
            set(_names)
        endif()

        if (_substitute_name)
            list(APPEND _names ${_substitute_name})
        else()
            get_directory_property(_ignore_dir DIRECTORY ${_lastcmakesubpath} "ECM_TEST_NAME_PREFIX_DIR_IGNORE${_property_name_suffix}")
            if (_ignore_dir STREQUAL "")
                if(_dir IN_LIST ECM_TEST_NAME_PREFIX_IGNORE_DIRS)
                    set(_ignore_dir TRUE)
                else()
                    set(_ignore_dir FALSE)
                endif()
            endif()
            if(NOT _ignore_dir)
                list(APPEND _names ${_dir})
            endif()
        endif()

        get_directory_property(_last_name DIRECTORY ${_lastcmakesubpath} "ECM_TEST_NAME_PREFIX_DIR_LAST${_property_name_suffix}")
        if(_last_name)
            # finish estimating prefix names
            break()
        endif()
    endforeach()

    # create final prefix name
    string(JOIN "-" _name_prefix ${_names})
    if (_name_prefix)
        string(APPEND _name_prefix "-")
    endif()

    set(${_name_prefix_varname} ${_name_prefix} PARENT_SCOPE)
endfunction()

function(ecm_test_set_dir_properties)
    set(options PREFIX_NAME_IGNORE PREFIX_NAME_NOT_IGNORE FIRST_PREFIX_NAME LAST_PREFIX_NAME)
    set(oneValueArgs PREFIX_NAME DIR)
    set(multiValueArgs)
    cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if(ARG_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Unknown keywords given to ECM_TEST_SET_DIR_PROPERTIES(): \"${ARG_UNPARSED_ARGUMENTS}\"")
    endif()
    if(ARG_PREFIX_NAME_IGNORE AND ARG_PREFIX_NAME_NOT_IGNORE)
        message(FATAL_ERROR "Pass either PREFIX_NAME_IGNORE or PREFIX_NAME_NOT_IGNORE to ECM_TEST_SET_DIR_PROPERTIES.")
    endif()
    set(_subdir)
    if(ARG_DIR)
        get_filename_component(_subdir ${ARG_DIR} REALPATH)
        if(NOT IS_DIRECTORY "${_subdir}")
            message(FATAL_ERROR "DIR argument passed to ECM_TEST_SET_DIR_PROPERTIES is not a directory: \"${ARG_DIR}\"")
        endif()
        if (_subdir STREQUAL ${CMAKE_CURRENT_SOURCE_DIR})
            set(_subdir)
        else()
            file(RELATIVE_PATH _subdir ${CMAKE_CURRENT_SOURCE_DIR} ${_subdir})
            if(_subdir MATCHES "^\\.\\./")
                message(FATAL_ERROR "DIR argument passed to ECM_TEST_SET_DIR_PROPERTIES is not a subdirectory: \"${ARG_DIR}\"")
          endif()
        endif()
    endif()

    if(_subdir)
        # map to a hash, as cmake does not specify allowed property characters
        # keep in sync with reading the properties in _ecm_test_name_prefix_from_project_path
        string(SHA1 _subdir_hash "/${_subdir}")
        set(_property_name_suffix ":${_subdir_hash}")
    else()
        set(_property_name_suffix)
    endif()

    if (ARG_PREFIX_NAME)
        set_directory_properties(PROPERTIES "ECM_TEST_NAME_PREFIX_DIR_NAME${_property_name_suffix}" "${ARG_PREFIX_NAME}")
    endif()
    if (ARG_PREFIX_NAME_IGNORE)
        set_directory_properties(PROPERTIES "ECM_TEST_NAME_PREFIX_DIR_IGNORE${_property_name_suffix}" "TRUE")
    endif()
    if (ARG_PREFIX_NAME_NOT_IGNORE)
        set_directory_properties(PROPERTIES "ECM_TEST_NAME_PREFIX_DIR_IGNORE${_property_name_suffix}" "FALSE")
    endif()
    if (ARG_FIRST_PREFIX_NAME)
        set_directory_properties(PROPERTIES "ECM_TEST_NAME_PREFIX_DIR_FIRST${_property_name_suffix}" "TRUE")
    endif()
    if (ARG_LAST_PREFIX_NAME)
        set_directory_properties(PROPERTIES "ECM_TEST_NAME_PREFIX_DIR_LAST${_property_name_suffix}" "TRUE")
    endif()
endfunction()

function(ecm_test_get_name_prefix _name_prefix_varname)
    if(NOT ECM_TEST_NAME_PREFIX_STRATEGY)
        set(_strategy "VARIABLE")
    else()
        set(_strategies "VARIABLE" "PATH")
        if (NOT ECM_TEST_NAME_PREFIX_STRATEGY IN_LIST _strategies)
            message(FATAL_ERROR "ECM_TEST_NAME_PREFIX_STRATEGY set to unknown value ${ECM_TEST_NAME_PREFIX_STRATEGY}")
        endif()
        set(_strategy ${ECM_TEST_NAME_PREFIX_STRATEGY})
    endif()

    if (${_strategy} STREQUAL "PATH")
        _ecm_test_name_prefix_from_project_path(_name_prefix)
    else()
        set(_name_prefix ${ECM_TEST_NAME_PREFIX})
    endif()
    set(${_name_prefix_varname} ${_name_prefix} PARENT_SCOPE)
endfunction()

function(ecm_add_test)
  set(options GUI NO_NAME_PREFIX)
  set(oneValueArgs TEST_NAME NAME_PREFIX TARGET_NAME_VAR TEST_NAME_VAR WORKING_DIRECTORY)
  set(multiValueArgs COMPILE_DEFINITIONS ENVIRONMENT LINK_LIBRARIES)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
  set(_sources ${ARG_UNPARSED_ARGUMENTS})
  list(LENGTH _sources _sourceCount)
  if(ARG_TEST_NAME)
    set(_targetname ${ARG_TEST_NAME})
  elseif(${_sourceCount} EQUAL "1")
    #use the source file name without extension as the testname
    get_filename_component(_targetname ${_sources} NAME_WE)
  else()
    #more than one source file passed, but no test name given -> error
    message(FATAL_ERROR "ecm_add_test() called with multiple source files but without setting \"TEST_NAME\"")
  endif()

  if (NOT ARG_NAME_PREFIX)
    if(NOT ARG_NO_NAME_PREFIX)
      ecm_test_get_name_prefix(ARG_NAME_PREFIX)
    endif()
  else()
    if(ARG_NO_NAME_PREFIX)
      message(FATAL_ERROR "ecm_add_test() called with both \"NO_NAME_PREFIX\" and \"NAME_PREFIX\"")
    endif()
  endif()
  set(_testname ${ARG_NAME_PREFIX}${_targetname})
  set(gui_args)
  if(ARG_GUI)
      set(gui_args WIN32 MACOSX_BUNDLE)
  endif()
  add_executable(${_targetname} ${gui_args} ${_sources})
  if(NOT ARG_GUI)
    ecm_mark_nongui_executable(${_targetname})
  endif()
  set(test_args)
  if(DEFINED ARG_WORKING_DIRECTORY)
      list(APPEND test_args WORKING_DIRECTORY ${ARG_WORKING_DIRECTORY})
  endif()
  add_test(NAME ${_testname} COMMAND ${_targetname} ${test_args})
  target_link_libraries(${_targetname} ${ARG_LINK_LIBRARIES})
  target_compile_definitions(${_targetname} PRIVATE -DQT_FORCE_ASSERTS ${ARG_COMPILE_DEFINITIONS})
  ecm_mark_as_test(${_targetname})
  if (CMAKE_LIBRARY_OUTPUT_DIRECTORY)
    set(_plugin_path ${CMAKE_LIBRARY_OUTPUT_DIRECTORY})
    if (DEFINED ENV{QT_PLUGIN_PATH})
      if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
        # https://stackoverflow.com/questions/59862894/how-do-i-make-a-list-in-cmake-with-the-semicolon-value
        set(PATHSEP "\\\;") # Don't want cmake to treat it like a list
      else() # e.g. Linux
        set(PATHSEP ":")
      endif()
      set(_plugin_path "${_plugin_path}${PATHSEP}$ENV{QT_PLUGIN_PATH}")
    endif()
    list(APPEND ARG_ENVIRONMENT "QT_PLUGIN_PATH=${_plugin_path}")
  endif()
  if (ARG_ENVIRONMENT)
    list(JOIN ARG_ENVIRONMENT ";" env)
    set_property(TEST ${_testname} PROPERTY ENVIRONMENT "${env}")
  endif()
  if (ARG_TARGET_NAME_VAR)
    set(${ARG_TARGET_NAME_VAR} "${_targetname}" PARENT_SCOPE)
  endif()
  if (ARG_TEST_NAME_VAR)
    set(${ARG_TEST_NAME_VAR} "${_testname}" PARENT_SCOPE)
  endif()
endfunction()

function(ecm_add_tests)
  set(options GUI NO_NAME_PREFIX)
  set(oneValueArgs NAME_PREFIX TARGET_NAMES_VAR TEST_NAMES_VAR WORKING_DIRECTORY)
  set(multiValueArgs COMPILE_DEFINITIONS ENVIRONMENT LINK_LIBRARIES)
  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  set(_name_prefix "")
  if(ARG_NO_NAME_PREFIX)
    if(ARG_NAME_PREFIX)
      message(FATAL_ERROR "ecm_add_tests() called with both \"NO_NAME_PREFIX\" and \"NAME_PREFIX\"")
    endif()
  elseif(ARG_NAME_PREFIX)
    set(_name_prefix "NAME_PREFIX" "${ARG_NAME_PREFIX}")
  endif()

  if(ARG_GUI)
    set(_exe_type GUI)
  else()
    set(_exe_type "")
  endif()
  set(test_args)
  if(DEFINED ARG_WORKING_DIRECTORY)
      list(APPEND test_args WORKING_DIRECTORY ${ARG_WORKING_DIRECTORY})
  endif()
  set(test_names)
  set(target_names)
  foreach(_test_source ${ARG_UNPARSED_ARGUMENTS})
    ecm_add_test(${_test_source}
      ${_name_prefix}
      COMPILE_DEFINITIONS ${ARG_COMPILE_DEFINITIONS}
      ENVIRONMENT ${ARG_ENVIRONMENT}
      LINK_LIBRARIES ${ARG_LINK_LIBRARIES}
      TARGET_NAME_VAR target_name
      TEST_NAME_VAR test_name
      ${_exe_type}
      ${test_args}
    )
    list(APPEND _test_names "${test_name}")
    list(APPEND _target_names "${target_name}")
  endforeach()
  if (ARG_TARGET_NAMES_VAR)
    set(${ARG_TARGET_NAMES_VAR} "${_target_names}" PARENT_SCOPE)
  endif()
  if (ARG_TEST_NAMES_VAR)
    set(${ARG_TEST_NAMES_VAR} "${_test_names}" PARENT_SCOPE)
  endif()
endfunction()
