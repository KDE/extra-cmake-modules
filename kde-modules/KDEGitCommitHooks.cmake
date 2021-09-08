# SPDX-FileCopyrightText: 2020 Alexander Lohnau <alexander.lohnau@gmx.de>
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

    if(NOT ARG_CHECKS)
        message(FATAL_ERROR "No checks were specified")
    endif()
    set(GIT_DIR "${CMAKE_SOURCE_DIR}/.git")

    # In case of tarballs there is no .git directory
    if (IS_DIRECTORY ${GIT_DIR})
        # The pre-commit hook is a bash script, consequently it won't work on non-unix platforms
        # git on Windows provides its own bash
        if (UNIX OR WIN32)
            if(KDE_CLANG_FORMAT_EXECUTABLE)
                list(FIND ARG_CHECKS "CLANG_FORMAT" _index)
                if (${_index} GREATER -1)
                    set(CLANG_FORMAT_SCRIPT "./.git/hooks/scripts/clang-format.sh")
                    configure_file(${CLANG_FORMAT_UNIX} "${GIT_DIR}/hooks/scripts/clang-format.sh" @ONLY)
                endif()
            else()
                message(WARNING "No clang-format executable was found, skipping the formatting pre-commit hook")
            endif()

            configure_file(${PRE_COMMIT_HOOK_UNIX} "${GIT_DIR}/hooks/pre-commit")
        endif()
    endif()
endfunction()
