add_custom_target(prepare_docs)
add_custom_target(generate_docs)
add_custom_target(install_html_docs)
add_custom_target(generate_qch)
add_custom_target(install_qch_docs)

function(ecm_generate_qdoc)
    find_package(Qt6Tools CONFIG REQUIRED)
    find_package(Qt6 COMPONENTS ToolsTools CONFIG REQUIRED)

    set(target ${ARGV0})
    set(doc_project ${ARGV1})
    set(qdoc_extra_args "")

    if (NOT QDOC_BIN)
        get_target_property(QDOC_BIN Qt6::qdoc LOCATION)
    endif()

    get_target_property(target_type ${target} TYPE)
    get_target_property(target_bin_dir ${target} BINARY_DIR)
    get_target_property(target_source_dir ${target} SOURCE_DIR)
    set(doc_output_dir "${target_bin_dir}/.doc")

    # Generate include dir list
    set(target_include_dirs_file "${doc_output_dir}/$<CONFIG>/includes.txt")

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


    get_filename_component(doc_target "${doc_project}" NAME_WLE)
    set(qdoc_qch_output_dir "${CMAKE_BINARY_DIR}/${INSTALL_DOCDIR}")
    set(index_dir "${CMAKE_BINARY_DIR}/${INSTALL_DOCDIR}")

    # prepare docs target
    set(prepare_qdoc_args
        -outputdir ${dest_dir}/${doc_target}
        "${target_source_dir}/${doc_project}"
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
        "${target_source_dir}/${doc_project}"
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

    # generate .qch
    set(qch_file_name ${doc_target}.qch)
    set(qch_file_path ${dest_dir}/${doc_target}/${qch_file_name})

    get_target_property(QHelpGenerator_EXECUTABLE Qt6::qhelpgenerator LOCATION)

    add_custom_target(generate_qch_${target}
        COMMAND ${QHelpGenerator_EXECUTABLE}
        "${dest_dir}/${doc_target}/${doc_target}.qhp"
        -o "${qch_file_path}"
    )

    add_dependencies(prepare_docs prepare_docs_${target})
    add_dependencies(generate_docs generate_docs_${target})
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
endfunction()
