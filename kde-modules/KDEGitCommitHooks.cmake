# SPDX-FileCopyrightText: 2020 Alexander Lohnau <alexander.lohnau@gmx.de>
# SPDX-FileCopyrightText: 2022 Ahmad Samir <a.samirh78@gmail.com>
#
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
KDEGitCommitHooks
--------------------

This module provides a functionality to enforce formatting
or in the future other QS checks.

This module provides the following function:

::

  kde_configure_pre_commit_hook(
     CHECKS <check1> [<check2> [...]]
  )

This function will create a pre-commit hook which contains all the given checks.

Checks:

- ``CLANG_FORMAT`` With this check enabled the ``git clang-format`` tool will be used to make sure that
  the changed parts are properly formatted. In case the changes are not properly formatted an error
  message with the command to preview the formatting changes and to format the files in place
  will be displayed. This tool will reuse the exsting ``.clang-format`` file, in case you
  want to use the one provided by ECM you can include ``include(KDEClangFormat)`` which will copy
  the file to the source dir. It is also recommended to reformat the entire project before enforcing
  the formatting using this commit hook.

Example usage:

.. code-block:: cmake

  include(KDEGitCommitHooks)
  kde_configure_git_pre_commit_hook(CHECKS CLANG_FORMAT)

Since 5.79
#]=======================================================================]

# try to find clang-format in path
find_program(KDE_CLANG_FORMAT_EXECUTABLE clang-format)
include(CMakeParseArguments)
set(PRE_COMMIT_HOOK_UNIX "${CMAKE_CURRENT_LIST_DIR}/kde-git-commit-hooks/pre-commit.in")
set(CLANG_FORMAT_UNIX "${CMAKE_CURRENT_LIST_DIR}/kde-git-commit-hooks/clang-format.sh")

function(KDE_CONFIGURE_GIT_PRE_COMMIT_HOOK)
    set(_oneValueArgs "")
    set(_multiValueArgs CHECKS)
    cmake_parse_arguments(ARG "" "${_oneValueArgs}" "${_multiValueArgs}" ${ARGN} )

    if(NOT CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
        message(STATUS "Project is not top level project - pre-commit hook not installed")
        return()
    endif()

    if(NOT ARG_CHECKS)
        message(FATAL_ERROR "No checks were specified")
    endif()
    set(GIT_DIR "${CMAKE_SOURCE_DIR}/.git")

    if (NOT IS_DIRECTORY ${GIT_DIR} # In case of tarballs there is no .git directory
        OR NOT (UNIX OR WIN32)
    )
        return()
    endif()
    if (COMMAND KDE_CLANG_FORMAT)
        set(HAS_CLANG_FORMAT_COMMAND_INCLUDED TRUE)
    else()
        set(HAS_CLANG_FORMAT_COMMAND_INCLUDED FALSE)
    endif()

    set(_write_hook FALSE)
    if(KDE_CLANG_FORMAT_EXECUTABLE)
        list(FIND ARG_CHECKS "CLANG_FORMAT" _index)
        if (${_index} GREATER -1)
            set(CLANG_FORMAT_SCRIPT "\"$(git rev-parse --git-common-dir)\"/hooks/scripts/clang-format.sh")
            configure_file(${CLANG_FORMAT_UNIX} "${GIT_DIR}/hooks/scripts/clang-format.sh" @ONLY)
            set(_write_hook TRUE)
        endif()
    else()
        message(WARNING "No clang-format executable was found, skipping the formatting pre-commit hook")
    endif()

    if(NOT _write_hook)
        return()
    endif()

    set(_hook_file "${GIT_DIR}/hooks/pre-commit")
    # Doesn't exist? write away
    if(NOT EXISTS ${_hook_file})
        configure_file(${PRE_COMMIT_HOOK_UNIX} "${GIT_DIR}/hooks/pre-commit")
        return()
    endif()

    file(READ ${_hook_file} _contents)

    # For when CLANG_FORMAT_SCRIPT didn't have the 'git rev-parse --git-common-dir' part
    set(_old_cmd "./.git/hooks/scripts/clang-format.sh")
    string(FIND "${_contents}" "${_old_cmd}" _idx)
    if (${_idx} GREATER -1)
        string(REPLACE "${_old_cmd}" "${CLANG_FORMAT_SCRIPT}" _contents "${_contents}")
        file(WRITE ${_hook_file} "${_contents}")
        return()
    endif()

    string(FIND "${_contents}" "${CLANG_FORMAT_SCRIPT}" _idx)
    # File exists and doesn't have the clang-format.sh line, append it
    # so as to not overwrite users' customisations
    if (_idx EQUAL -1)
        file(APPEND ${_hook_file} "${CLANG_FORMAT_SCRIPT}")
    endif()
endfunction()
