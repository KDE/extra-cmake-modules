# SPDX-FileCopyrightText: 2022 Albert Astals Cid <aacid@kde.org>
# SPDX-FileCopyrightText: 2024 Carl Schwan <carl.schwan@gnupg.com>
#
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
ECMOptionalPackageProperties
-----------

Convenience function to mark dependencies as required by default.
These dependencies can then be marked explicitely as optional by
using the ECM_FORCE_NOT_REQUIRED_DEPENDENCIES option.

::
  find_package(<package> <version>)
  ecm_set_optional_package_properties(<package> PROPERTIES
      [ URL <url> ]
      [ DESCRIPTION <description> ]
      [ PURPOSE <purpose> ]
  )

Since 6.19.
#]=======================================================================]

set(ECM_FORCE_NOT_REQUIRED_DEPENDENCIES "" CACHE STRING "List (semicolon-separated) of dependencies that will be downgraded from REQUIRED to RECOMMENDED")

function(ecm_set_optional_package_properties _name _props)
    if(NOT "${_props}" STREQUAL "PROPERTIES")
        message(FATAL_ERROR "PROPERTIES keyword is missing in ecm_set_optional_package_properties() call.")
    endif()

    set(options) # none
    set(oneValueArgs DESCRIPTION URL PURPOSE)
    set(multiValueArgs) # none

    CMAKE_PARSE_ARGUMENTS(_SPP "${options}" "${oneValueArgs}" "${multiValueArgs}"  ${ARGN})

    if(_SPP_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Unknown keywords given to ecm_set_optional_package_properties(): \"${_SPP_UNPARSED_ARGUMENTS}\"")
    endif()

    set(DEPENDENCY_TYPE "REQUIRED")
    if (${_name} IN_LIST ECM_FORCE_NOT_REQUIRED_DEPENDENCIES)
        set(DEPENDENCY_TYPE "RECOMMENDED")
    endif()
    set_package_properties(${_name} PROPERTIES
        TYPE ${DEPENDENCY_TYPE}
        DESCRIPTION ${_SPP_DESCRIPTION}
        URL ${_SPP_URL}
        PURPOSE "${_SPP_PURPOSE} You can make the dependency optional adding ${_name} to the ECM_FORCE_NOT_REQUIRED_DEPENDENCIES cmake option"
    )
endfunction()

