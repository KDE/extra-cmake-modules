# SPDX-FileCopyrightText: 2025 Nicolas Fella <nicolas.fella@gmx.de>
#
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
ECMGenerateQDoc
------------------

This module provides the ``ecm_generate_qdoc`` function for generating API
documentation files for projects based on qdoc.

It allows to generate both online HTML documentation as well as
(installed) QCH files.

::

  ecm_generate_qdoc(<target_name> <qdocconf_file>)

``target_name`` is the library target for which the documentation is generated.

``qdocconf_file`` is the .qdocconf file that controls the documentation generation.

If the project contains multiple libraries with documented APIs ``ecm_generate_qdoc``
should be called for each one.

Example usage:

.. code-block:: cmake

  ecm_add_qch(KF6::CoreAddons kcoreaddons.qdocconf)

Documentation is not built as part of the normal build, it needs to be explicity
invoked using the following build targets:

* ``prepare_docs`` runs the prepare step from qdoc, which processes sources and creates index files
* ``generate_docs`` runs the generate step from qdoc, generating the final documentation from the index files
* ``install_html_docs`` installs the generated HTML documentation into ``KDE_INSTALL_QTQCHDIR`` from :kde-module:`KDEInstallDirs`
* ``generate_qch`` creates QCH files out of the HTML documentation
* ``install_qch_docs`` installs the QCH files into ``KDE_INSTALL_QTQCHDIR`` from :kde-module:`KDEInstallDirs`

The following global parameters are understood:

* ``QDOC_BIN``: This can be used to select another qdoc executable than the one found by find_package. This is useful to test with different versions of the qdoc tool.
* ``DOC_DESTDIR``: This is where the HTML and index files will be generated. This is useful to aggregate results from multiple projects into a single directory.

When combining documentation from multiple projects the recommended procedure is to use a common ``DOC_DESTDIR`` and run the prepare stage for all before running the generate stage for all. This ensures that the index files are all available during the generate phase and cross-linking works as expected.

Since 6.11.0.
#]=======================================================================]

cmake_policy(VERSION 3.16)

add_custom_target(prepare_docs)
add_custom_target(generate_docs)
add_custom_target(install_html_docs)
add_custom_target(generate_qch)
add_custom_target(install_qch_docs)

function(ecm_generate_qdoc target qdocconf_file)
    find_package(Qt6Tools CONFIG QUIET)
    find_package(Qt6 OPTIONAL_COMPONENTS ToolsTools CONFIG QUIET)

    if (NOT Qt6Tools_FOUND OR NOT Qt6ToolsTools_FOUND)
        message(STATUS "Qt6Tools or Qt6ToolsTools not found, not generating API documentation")
        return()
    endif()

    if (NOT TARGET ${target})
        message(FATAL_ERROR "${target} is not a target")
    endif()

    file(REAL_PATH ${qdocconf_file} full_qdocconf_path)

    if (NOT EXISTS ${full_qdocconf_path})
        message(FATAL_ERROR "Cannot find qdocconf file: ${qdocconf_file}")
    endif()

    set(qdoc_extra_args "")

    if (NOT QDOC_BIN)
        if (NOT TARGET Qt6::qdoc)
            message("qdoc executable not found, not generating API documentation")
            return()
        endif()
        get_target_property(QDOC_BIN Qt6::qdoc LOCATION)
    endif()

    get_target_property(target_type ${target} TYPE)
    get_target_property(target_bin_dir ${target} BINARY_DIR)
    get_target_property(target_source_dir ${target} SOURCE_DIR)
    set(doc_output_dir "${CMAKE_BINARY_DIR}/.doc")

    # Generate include dir list
    set(target_include_dirs_file "${doc_output_dir}/${target}_$<CONFIG>_includes.txt")

    set(include_paths_property "$<TARGET_PROPERTY:${target},INCLUDE_DIRECTORIES>")

    file(GENERATE
        OUTPUT ${target_include_dirs_file}
        CONTENT "$<$<BOOL:${include_paths_property}>:-I$<JOIN:${include_paths_property},\n-I>>\n-I$<TARGET_PROPERTY:${target},BINARY_DIR>"
    )
    set(include_path_args "@${target_include_dirs_file}")

    set(dest_dir ${doc_output_dir})

    if (DOC_DESTDIR)
        set(dest_dir ${DOC_DESTDIR})
    endif()

    ecm_query_qt(docs_dir QT_INSTALL_DOCS)

    set(index_dirs ${dest_dir};${docs_dir})

    foreach(path ${CMAKE_PREFIX_PATH} ${CMAKE_INSTALL_PREFIX})
      if (EXISTS ${path}/${KDE_INSTALL_DATAROOTDIR}/doc)
        list(APPEND ${index_dirs} "${path}/${KDE_INSTALL_DATAROOTDIR}/doc")
      endif()
    endforeach()

    set(index_dir_arg)
    foreach(index_directory ${index_dirs})
        list(APPEND index_dir_arg "--indexdir" ${index_directory})
    endforeach()


    get_filename_component(doc_target "${qdocconf_file}" NAME_WLE)
    set(qdoc_qch_output_dir "${CMAKE_BINARY_DIR}/${INSTALL_DOCDIR}")
    set(index_dir "${CMAKE_BINARY_DIR}/${INSTALL_DOCDIR}")

    # prepare docs target
    set(prepare_qdoc_args
        -outputdir ${dest_dir}/${doc_target}
        "${target_source_dir}/${qdocconf_file}"
        -prepare
        ${index_dir_arg}
        -no-link-errors
        -installdir ${dest_dir}
        "${include_path_args}"
    )

    set(qdoc_env_args
        "QT_VERSION=${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH}"
        "QT_VER=${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}"
        "QT_VERSION_TAG=${PROJECT_VERSION_MAJOR}${PROJECT_VERSION_MINOR}${PROJECT_VERSION_PATCH}"
        "BUILDDIR=${target_bin_dir}"
    )

    add_custom_target(prepare_docs_${target}
        COMMAND ${CMAKE_COMMAND} -E env ${qdoc_env_args}
        ${QDOC_BIN}
        ${prepare_qdoc_args}
    )

    # generate docs target
    set(generate_qdoc_args
        -outputdir ${dest_dir}/${doc_target}
        "${target_source_dir}/${qdocconf_file}"
        -generate
        ${index_dir_arg}
        -installdir ${dest_dir}
        "${include_path_args}"
    )

    add_custom_target(generate_docs_${target}
        COMMAND ${CMAKE_COMMAND} -E env ${qdoc_env_args}
        ${QDOC_BIN}
        ${generate_qdoc_args}
    )

    add_dependencies(prepare_docs prepare_docs_${target})
    add_dependencies(generate_docs generate_docs_${target})

    # generate .qch
    if (TARGET Qt6::qhelpgenerator)
        set(qch_file_name ${doc_target}.qch)
        set(qch_file_path ${dest_dir}/${qch_file_name})
        get_target_property(QHelpGenerator_EXECUTABLE Qt6::qhelpgenerator LOCATION)

        add_custom_target(generate_qch_${target}
            COMMAND ${QHelpGenerator_EXECUTABLE}
            "${dest_dir}/${doc_target}/${doc_target}.qhp"
            -o "${qch_file_path}"
        )

        add_dependencies(generate_qch generate_qch_${target})
        add_dependencies(install_html_docs install_html_docs_${target})
        add_dependencies(install_qch_docs install_qch_docs_${target})

        install(DIRECTORY "${dest_dir}/${doc_target}/"
                DESTINATION "${KDE_INSTALL_QTQCHDIR}/${doc_target}"
                COMPONENT _install_html_docs_${target}
                EXCLUDE_FROM_ALL
        )

        add_custom_target(install_html_docs_${target}
            COMMAND ${CMAKE_COMMAND}
            --install "${CMAKE_BINARY_DIR}"
            --component _install_html_docs_${target}
            COMMENT "Installing html docs for target ${target}"
        )

        install(FILES "${qch_file_path}"
                DESTINATION "${KDE_INSTALL_QTQCHDIR}"
                COMPONENT _install_qch_docs_${target}
                EXCLUDE_FROM_ALL
        )

        add_custom_target(install_qch_docs_${target}
            COMMAND ${CMAKE_COMMAND}
            --install "${CMAKE_BINARY_DIR}"
            --component _install_qch_docs_${target}
            COMMENT "Installing qch docs for target ${target}"
        )
    else()
        message("qhelpgenerator executable not found, not generating API documentation in QCH format")
    endif()
endfunction()
