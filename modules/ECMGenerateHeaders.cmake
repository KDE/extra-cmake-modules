# SPDX-FileCopyrightText: 2013 Aleix Pol Gonzalez <aleixpol@blue-systems.com>
# SPDX-FileCopyrightText: 2014 Alex Merry <alex.merry@kdemail.net>
# SPDX-FileCopyrightText: 2015 Patrick Spendrin <patrick.spendrin@kdab.com>
#
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
ECMGenerateHeaders
------------------

Generate C/C++ CamelCase forwarding headers.

::

  ecm_generate_headers(<camelcase_forwarding_headers_var>
      HEADER_NAMES <CamelCaseName> [<CamelCaseName> [...]]
      [ORIGINAL <CAMELCASE|LOWERCASE>]
      [HEADER_EXTENSION <header_extension>]
      [OUTPUT_DIR <output_dir>]
      [PREFIX <prefix>]
      [SHARED_PREFIX <prefix>] # since 6.19
      [REQUIRED_HEADERS <variable>]
      [COMMON_HEADER <HeaderName>]
      [RELATIVE <relative_path>])

For each CamelCase header name passed to ``HEADER_NAMES``, a file of that name
will be generated that will include a version with ``.h`` or, if set,
``.<header_extension>`` appended.
For example, the generated header ``ClassA`` will include ``classa.h`` (or
``ClassA.h``, see ``ORIGINAL``).
If a CamelCaseName consists of multiple comma-separated files, e.g.
``ClassA,ClassB,ClassC``, then multiple camelcase header files will be
generated which are redirects to the first header file.
The file locations of these generated headers will be stored in
<camelcase_forwarding_headers_var>.

``ORIGINAL`` specifies how the name of the original header is written: lowercased
or also camelcased.  The default is "LOWERCASE". Since 1.8.0.

``HEADER_EXTENSION`` specifies what file name extension is used for the header
files.  The default is "h". Since 5.48.0.

``PREFIX`` places the generated headers in subdirectories.  This should be a
CamelCase name like ``KParts``, which will cause the CamelCase forwarding
headers to be placed in the ``KParts`` directory (e.g. ``KParts/Part``).  It
will also, for the convenience of code in the source distribution, generate
forwarding headers based on the original names (e.g. ``kparts/part.h``).  This
allows includes like ``"#include <kparts/part.h>"`` to be used before
installation, as long as the include_directories are set appropriately.

``SHARED_PREFIX`` works similar to ``PREFIX``. It though assumes the original
headers will be installed in the same subdirectory as the forwarding headers.
So the generated files will include the original ones locally without any prefix.
And the above mentioned pre-installation convenience forwarding headers based on
the original names will be placed in the same subdirectory
(e.g. ``KParts/part.h``), to allow includes like ``"#include <KParts/Part>"`` to
be used before installation and working properly. Since 6.19.0.

``OUTPUT_DIR`` specifies where the files will be generated; this should be within
the build directory. By default, ``${CMAKE_CURRENT_BINARY_DIR}`` will be used.
This option can be used to avoid file conflicts.

``REQUIRED_HEADERS`` specifies an output variable name where all the required
headers will be appended so that they can be installed together with the
generated ones.  This is mostly intended as a convenience so that adding a new
header to a project only requires specifying the CamelCase variant in the
CMakeLists.txt file; the original variant will then be added to this
variable.

``COMMON_HEADER`` generates an additional convenience header which includes all
other header files.

The ``RELATIVE`` argument indicates where the original headers can be found
relative to ``CMAKE_CURRENT_SOURCE_DIR``.  It does not affect the generated
CamelCase forwarding files, but ``ecm_generate_headers()`` uses it when checking
that the original header exists, and to generate originally named forwarding
headers when ``PREFIX`` or ``SHARED_PREFIX`` is set.

To allow other parts of the source distribution (eg: tests) to use the
generated headers before installation, it may be desirable to add to the
``INCLUDE_DIRECTORIES`` property of the library target the output_dir.
If ``OUTPUT_DIR`` is ``CMAKE_CURRENT_BINARY_DIR`` (the default) and
``CMAKE_INCLUDE_CURRENT_DIR_IN_INTERFACE`` is ``ON`` (as set by
:kde-module:`KDECMakeSettings`), this is automatically done.
Otherwise you could do (adapt if ``OUTPUT_DIR`` is something else)

.. code-block:: cmake

  target_include_directories(MyLib PUBLIC "$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>")

Example usage (without ``PREFIX`` pr ``SHARED_PREFIX``):

.. code-block:: cmake

  ecm_generate_headers(
      MyLib_FORWARDING_HEADERS
      HEADERS
          MLFoo
          MLBar
          # etc
      REQUIRED_HEADERS MyLib_HEADERS
      COMMON_HEADER MLGeneral
  )
  install(FILES ${MyLib_FORWARDING_HEADERS} ${MyLib_HEADERS}
          DESTINATION ${CMAKE_INSTALL_PREFIX}/include
          COMPONENT Devel)

Example usage (with ``PREFIX``):

.. code-block:: cmake

  ecm_generate_headers(
      MyLib_FORWARDING_HEADERS
      HEADERS
          Foo
          # several classes are contained in bar.h, so generate
          # additional files
          Bar,BarList
          # etc
      PREFIX MyLib
      REQUIRED_HEADERS MyLib_HEADERS
  )
  install(FILES ${MyLib_FORWARDING_HEADERS}
          DESTINATION ${CMAKE_INSTALL_PREFIX}/include/MyLib
          COMPONENT Devel)
  install(FILES ${MyLib_HEADERS}
          DESTINATION ${CMAKE_INSTALL_PREFIX}/include/mylib
          COMPONENT Devel)

Example usage (with ``SHARED_PREFIX``):

.. code-block:: cmake

  ecm_generate_headers(
      MyLib_FORWARDING_HEADERS
      HEADERS
          Foo
          # several classes are contained in bar.h, so generate
          # additional files
          Bar,BarList
          # etc
      SHARED_PREFIX MyLib
      REQUIRED_HEADERS MyLib_HEADERS
  )
  install(FILES ${MyLib_FORWARDING_HEADERS} ${MyLib_HEADERS}
          DESTINATION ${CMAKE_INSTALL_PREFIX}/include/MyLib
          COMPONENT Devel)

Since pre-1.0.0.
#]=======================================================================]

cmake_policy(VERSION 3.16)

function(ECM_GENERATE_HEADERS camelcase_forwarding_headers_var)
    set(options)
    set(oneValueArgs ORIGINAL HEADER_EXTENSION OUTPUT_DIR PREFIX SHARED_PREFIX REQUIRED_HEADERS COMMON_HEADER RELATIVE)
    set(multiValueArgs HEADER_NAMES)
    cmake_parse_arguments(EGH "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if (EGH_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Unexpected arguments to ECM_GENERATE_HEADERS: ${EGH_UNPARSED_ARGUMENTS}")
    endif()

    if(EGH_PREFIX AND EGH_SHARED_PREFIX)
       message(FATAL_ERROR "Cannot pass both PREFIX and SHARED_PREFIX arguments to ECM_GENERATE_HEADERS")
    endif()

    if(NOT EGH_HEADER_NAMES)
       message(FATAL_ERROR "Missing header_names argument to ECM_GENERATE_HEADERS")
    endif()

    if(NOT EGH_ORIGINAL)
        # default
        set(EGH_ORIGINAL "LOWERCASE")
    endif()
    if(NOT EGH_ORIGINAL STREQUAL "LOWERCASE" AND NOT EGH_ORIGINAL STREQUAL "CAMELCASE")
        message(FATAL_ERROR "Unexpected value for original argument to ECM_GENERATE_HEADERS: ${EGH_ORIGINAL}")
    endif()

    if(NOT EGH_HEADER_EXTENSION)
        set(EGH_HEADER_EXTENSION "h")
    endif()

    if(NOT EGH_OUTPUT_DIR)
        set(EGH_OUTPUT_DIR "${CMAKE_CURRENT_BINARY_DIR}")
    endif()

    # Make sure EGH_RELATIVE is /-terminated when it's not empty
    if (EGH_RELATIVE AND NOT "${EGH_RELATIVE}" MATCHES "^.*/$")
        set(EGH_RELATIVE "${EGH_RELATIVE}/")
    endif()

    set(prefix)
    if (EGH_SHARED_PREFIX)
        set(prefix "${EGH_SHARED_PREFIX}")
    elseif (EGH_PREFIX)
        set(prefix "${EGH_PREFIX}")
    endif()
    if (prefix AND NOT "${prefix}" MATCHES "^.*/$")
        string(APPEND prefix "/")
    endif()

    set(originalprefix) # prefix used in the include by the forwarding header
    set(buildoriginalprefix) # prefix used in the build to place the convenience forwarding headers
    if (EGH_SHARED_PREFIX)
        set(buildoriginalprefix "${prefix}")
    elseif (EGH_PREFIX)
        if (EGH_ORIGINAL STREQUAL "CAMELCASE")
            set(originalprefix "${prefix}")
        else()
            string(TOLOWER "${prefix}" originalprefix)
        endif()
        set(buildoriginalprefix "${originalprefix}")
    endif()

    foreach(_classnameentry ${EGH_HEADER_NAMES})
        string(REPLACE "," ";" _classnames ${_classnameentry})
        list(GET _classnames 0 _baseclass)

        if (EGH_ORIGINAL STREQUAL "CAMELCASE")
            set(originalbasename "${_baseclass}")
        else()
            string(TOLOWER "${_baseclass}" originalbasename)
        endif()

        set(_actualheader "${CMAKE_CURRENT_SOURCE_DIR}/${EGH_RELATIVE}${originalbasename}.${EGH_HEADER_EXTENSION}")
        get_source_file_property(_generated "${_actualheader}" GENERATED)
        if (NOT _generated AND NOT EXISTS ${_actualheader})
            message(FATAL_ERROR "Could not find \"${_actualheader}\"")
        endif()

        foreach(_CLASSNAME ${_classnames})
            set(FANCY_HEADER_FILE "${EGH_OUTPUT_DIR}/${prefix}${_CLASSNAME}")
            if (NOT EXISTS ${FANCY_HEADER_FILE})
                set(_content "#include \"${originalprefix}${originalbasename}.${EGH_HEADER_EXTENSION}\" // IWYU pragma: export\n")
                if (prefix AND "${originalprefix}" STREQUAL "")
                    # Here a relative include is created, without the namespace prefix.
                    # This results in some potentially non-unique file content, when other relative forwarding
                    # headers exist for the same base name (e.g. Prison/Barcode vs. KPkPass/Barcode, which both
                    # would simply include "barcode.h").
                    # Some filesystems automatically hardlink files which are identical by the content checksum
                    # (e.g. for RPM-provided files under /usr, to save storage space).
                    # This collides with Clang seemingly doing optimization by looking at the inodes of the
                    # to-be included files, and reusing content from the inode as found with any first path.
                    # So for a compilation unit which includes multiple forwarding headers with different
                    # namespaces but same basename, so having same inode with those systems, the latter ones will
                    # not result in the actual relative original headers being included.
                    # See https://github.com/llvm/llvm-project/issues/26953
                    # As counter-measure some unique content is added below, serving some double purpose by giving
                    # instructions how to use the file, in case someone looks at it.
                    string(PREPEND _content "// Forwarding header, use by: #include <${prefix}${_CLASSNAME}>\n")
                endif()
                file(WRITE ${FANCY_HEADER_FILE} "${_content}")
            endif()
            list(APPEND ${camelcase_forwarding_headers_var} "${FANCY_HEADER_FILE}")
            if (prefix)
                # Build-local convenience forwarding header, for namespaced headers, e.g. kparts/part.h
                # Ensures either the prefixed forwarding include works ("kparts/part.h"), or the unnamespaced
                # local relative ("part.h") will pick up the correct header, not some consumer one.
                if(EGH_ORIGINAL STREQUAL "CAMELCASE")
                    set(originalclassname "${_CLASSNAME}")
                else()
                    string(TOLOWER "${_CLASSNAME}" originalclassname)
                endif()
                set(REGULAR_HEADER_NAME ${EGH_OUTPUT_DIR}/${buildoriginalprefix}${originalclassname}.${EGH_HEADER_EXTENSION})
                if (NOT EXISTS ${REGULAR_HEADER_NAME})
                    file(RELATIVE_PATH _actualheader_relative "${EGH_OUTPUT_DIR}/${buildoriginalprefix}" "${_actualheader}")
                    file(WRITE ${REGULAR_HEADER_NAME} "#include \"${_actualheader_relative}\" // IWYU pragma: export\n")
                endif()
            endif()
        endforeach()

        list(APPEND _REQUIRED_HEADERS "${_actualheader}")
    endforeach()

    if(EGH_COMMON_HEADER)
        #combine required headers into 1 big convenience header
        set(COMMON_HEADER ${EGH_OUTPUT_DIR}/${prefix}${EGH_COMMON_HEADER})
        file(WRITE ${COMMON_HEADER} "// convenience header\n")
        foreach(_header ${_REQUIRED_HEADERS})
            get_filename_component(_base ${_header} NAME)
            file(APPEND ${COMMON_HEADER} "#include \"${_base}\"\n")
        endforeach()
        list(APPEND ${camelcase_forwarding_headers_var} "${COMMON_HEADER}")
    endif()

    set(${camelcase_forwarding_headers_var} ${${camelcase_forwarding_headers_var}} PARENT_SCOPE)
    if (EGH_REQUIRED_HEADERS)
        set(${EGH_REQUIRED_HEADERS} ${${EGH_REQUIRED_HEADERS}} ${_REQUIRED_HEADERS} PARENT_SCOPE)
    endif ()
endfunction()
