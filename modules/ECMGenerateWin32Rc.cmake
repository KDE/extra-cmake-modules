# SPDX-FileCopyrightText: 2022 The Qt Company Ltd.
# SPDX-FileCopyrightText: 2024 g10 Code GmbH
# SPDX-FileContributor: Carl Schwan <carl.schwan@gnupg.com>
# SPDX-License-Identifier: BSD-3-Clause

#[========================================================================[.rst:
ECMGenerateWin32Rc
------------

Generate Win32 RC files for a target. All entries in the RC file are generated
from target properties:

ECM_TARGET_COMPANY_NAME: RC Company name
ECM_TARGET_DESCRIPTION: RC File Description
ECM_TARGET_VERSION: RC File and Product Version
ECM_TARGET_COPYRIGHT: RC LegalCopyright
ECM_TARGET_PRODUCT_NAME: RC ProductName
ECM_TARGET_COMMENTS: RC Comments
ECM_TARGET_ORIGINAL_FILENAME: RC Original FileName
ECM_TARGET_TRADEMARKS: RC LegalTrademarks
ECM_TARGET_INTERNALNAME: RC InternalName
ECM_TARGET_RC_ICONS: List of paths to icon files

If you do not wish to auto-generate rc files, it's possible to provide your
own RC file by setting the property ECM_TARGET_WINDOWS_RC_FILE with a path to
an existing rc file.

Example usage:

.. code-block:: cmake

    add_execurable(myapp) # also work with add_library()

    if (WIN32)
        set_target_properties(myapp PROPERTIES
            ECM_TARGET_VERSION "${MYAPP_VERSION}"
            ECM_TARGET_COMPANY_NAME "KDE"
            ECM_TARGET_DESCRIPTION "My app"
            ECM_TARGET_COMMENTS "This program is available under the terms of the GNU General Public License, version 3 or any later version."
            ECM_TARGET_COPYRIGHT "\\xA9 KDE Community"
            ECM_TARGET_PRODUCT_NAME "MyApp"
            ECM_TARGET_RC_ICONS ${CMAKE_SOURCE_DIR}/icons/myapp.ico
        )
        ecm_generate_win32_rc_file(myapp)
    endif()

    For KDE projects, it is possible to add common properties with ``ecm_kde_set_target_info_properties`` and for KDE Frameworks with ``ecm_kf_set_target_info_properties``.

.. code-block:: cmake

    ecm_generate_win32_rc_file(<target name> [GENERATE_W32_MANIFEST])

``ecm_kf_set_target_info_properties`` must only be used by a KDE Frameworks and set every relevant properties for its Win32 RC file.

.. code-block:: cmake

    ecm_kf_set_target_info_properties(<target name>
        [TARGET_VERSION <version>]
        [TARGET_PRODUCT <product>]
        [TARGET_DESCRIPTION <description>]
        [TARGET_COMPANY <company>]
        [TARGET_COPYRIGHT <copyright>]
        [TARGET_COMMENTS <comments>]
    )

``ecm_kde_set_target_info_properties`` must only be used by a KDE project and set every relevant properties for its Win32 RC file.

    ecm_kde_set_target_info_properties(<target name>
        [TARGET_VERSION <version>]
        [TARGET_PRODUCT <product>]
        [TARGET_DESCRIPTION <description>]
        [TARGET_COMPANY <company>]
        [TARGET_COPYRIGHT <copyright>]
    )

#]========================================================================]

function(ecm_generate_win32_rc_file target)
    cmake_parse_arguments(PARSE_ARGV 0 arg "GENERATE_W32_MANIFEST" "" "")

    set(prohibited_target_types INTERFACE_LIBRARY STATIC_LIBRARY OBJECT_LIBRARY)
    get_target_property(target_type ${target} TYPE)
    if(target_type IN_LIST prohibited_target_types)
        return()
    endif()

    get_target_property(target_binary_dir ${target} BINARY_DIR)

    get_target_property(target_rc_file ${target} ECM_TARGET_WINDOWS_RC_FILE)
    get_target_property(target_version ${target} ECM_TARGET_VERSION)
    get_property(INTERNAL_GENERATOR_IS_MULTI_CONFIG GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)

    if (NOT target_rc_file AND NOT target_version)
        return()
    endif()

    if(MSVC)
        set(extra_rc_flags "-c65001 -DWIN32 -nologo")
    else()
        set(extra_rc_flags)
    endif()

    if (target_rc_file)
        # Use the provided RC file
        target_sources(${target} PRIVATE "${target_rc_file}")
        set_property(SOURCE ${target_rc_file} PROPERTY COMPILE_FLAGS "${extra_rc_flags}")
    else()
        # Generate RC and w32-manifest files
        set(rc_file_output "${target_binary_dir}/")
        if(INTERNAL_GENERATOR_IS_MULTI_CONFIG)
            string(APPEND rc_file_output "$<CONFIG>/")
        endif()
        string(APPEND rc_file_output "${target}_resource.rc")
        set(target_rc_file "${rc_file_output}")

        set(original_file_name "$<TARGET_FILE_NAME:${target}>")
        get_target_property(target_original_file_name ${target} ECM_TARGET_ORIGINAL_FILENAME)
        if (target_original_file_name)
            set(original_file_name "${target_original_file_name}")
        endif()

        if (arg_GENERATE_W32_MANIFEST)
            set(manifest_file_output "${target_binary_dir}/")
            if(INTERNAL_GENERATOR_IS_MULTI_CONFIG)
                string(APPEND manifest_file_output "$<CONFIG>/")
            endif()
            string(APPEND manifest_file_output "${original_file_name}.w32-manifest")
            set(target_manifest_file "${manifest_file_output}")
        endif()

        set(company_name "")
        get_target_property(target_company_name ${target} ECM_TARGET_COMPANY_NAME)
        if (target_company_name)
            set(company_name "${target_company_name}")
        endif()

        set(file_description "")
        get_target_property(target_description ${target} ECM_TARGET_DESCRIPTION)
        if (target_description)
            set(file_description "${target_description}")
        endif()

        set(legal_copyright "")
        get_target_property(target_copyright ${target} ECM_TARGET_COPYRIGHT)
        if (target_copyright)
            set(legal_copyright "${target_copyright}")
        endif()

        set(product_name "")
        get_target_property(target_product_name ${target} ECM_TARGET_PRODUCT_NAME)
        if (target_product_name)
            set(product_name "${target_product_name}")
        else()
            set(product_name "${target}")
        endif()

        set(comments "")
        get_target_property(target_comments ${target} ECM_TARGET_COMMENTS)
        if (target_comments)
            set(comments "${target_comments}")
        endif()

        set(legal_trademarks "")
        get_target_property(target_trademarks ${target} ECM_TARGET_TRADEMARKS)
        if (target_trademarks)
            set(legal_trademarks "${target_trademarks}")
        endif()

        set(product_version "")
        if (target_version)
            if(target_version MATCHES "[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+")
                # nothing to do
            elseif(target_version MATCHES "[0-9]+\\.[0-9]+\\.[0-9]+")
                set(target_version "${target_version}.0")
            elseif(target_version MATCHES "[0-9]+\\.[0-9]+")
                set(target_version "${target_version}.0.0")
            elseif (target_version MATCHES "[0-9]+")
                set(target_version "${target_version}.0.0.0")
            else()
                message(FATAL_ERROR "Invalid version format: '${target_version}'")
            endif()
            set(product_version "${target_version}")
        else()
            set(product_version "0.0.0.0")
        endif()

        set(file_version "${product_version}")
        string(REPLACE "." "," version_comma ${product_version})

        set(internal_name "")
        get_target_property(target_internal_name ${target} ECM_TARGET_INTERNALNAME)
        if (target_internal_name)
            set(internal_name "${target_internal_name}")
        endif()

        set(icons "")
        get_target_property(target_icons ${target} ECM_TARGET_RC_ICONS)
        if (target_icons)
            set(index 1)
            foreach( icon IN LISTS target_icons)
                string(APPEND icons "IDI_ICON${index}    ICON    \"${icon}\"\n")
                math(EXPR index "${index} +1")
            endforeach()
        endif()

        set(target_file_type "VFT_DLL")
        if(target_type STREQUAL "EXECUTABLE")
            set(target_file_type "VFT_APP")
        endif()

        string(REGEX REPLACE "[^a-zA-Z0-9-]" "" company_name_normalized "${company_name}")
        string(REGEX REPLACE "[^a-zA-Z0-9-]" "" product_name_normalized "${product_name}" )
        set(unique_name "${company_name_normalized}.${product_name_normalized}")

        set(contents "#include <windows.h>
${icons}
VS_VERSION_INFO VERSIONINFO
FILEVERSION ${version_comma}
PRODUCTVERSION ${version_comma}
FILEFLAGSMASK 0x3fL
#ifdef _DEBUG
    FILEFLAGS VS_FF_DEBUG
#else
    FILEFLAGS 0x0L
#endif
FILEOS VOS_NT_WINDOWS32
FILETYPE ${target_file_type}
FILESUBTYPE VFT2_UNKNOWN
BEGIN
    BLOCK \"StringFileInfo\"
    BEGIN
        BLOCK \"040904b0\"
        BEGIN
            VALUE \"CompanyName\", \"${company_name}\"
            VALUE \"FileDescription\", \"${file_description}\"
            VALUE \"FileVersion\", \"${file_version}\"
            VALUE \"LegalCopyright\", \"${legal_copyright}\"
            VALUE \"OriginalFilename\", \"${original_file_name}\"
            VALUE \"ProductName\", \"${product_name}\"
            VALUE \"ProductVersion\", \"${product_version}\"
            VALUE \"Comments\", \"${comments}\"
            VALUE \"LegalTrademarks\", \"${legal_trademarks}\"
            VALUE \"InternalName\", \"${internal_name}\"
        END
    END
    BLOCK \"VarFileInfo\"
    BEGIN
        VALUE \"Translation\", 0x0409, 1200
    END
END

")

        if (arg_GENERATE_W32_MANIFEST)
            set(contents_manifest "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\" ?>
<assembly xmlns=\"urn:schemas-microsoft-com:asm.v1\" manifestVersion=\"1.0\">
<description>${product_name}</description>
<assemblyIdentity
    type=\"win32\"
    name=\"${unique_name}\"
    version=\"${product_version}\"
    />
<compatibility xmlns=\"urn:schemas-microsoft-com:compatibility.v1\">
  <application>
    <supportedOS Id=\"{8e0f7a12-bfb3-4fe8-b9a5-48fd50a15a9a}\"/><!-- 10 / 11 -->
  </application>
</compatibility>
<trustInfo xmlns=\"urn:schemas-microsoft-com:asm.v2\">
  <security>
    <requestedPrivileges>
      <requestedExecutionLevel level=\"asInvoker\"/>
    </requestedPrivileges>
  </security>
</trustInfo>
</assembly>")
            string(APPEND contents "1 RT_MANIFEST \"${original_file_name}.w32-manifest\"")
        endif()

        # We can't use the output of file generate as source so we work around
        # this by generating the file under a different name and then copying
        # the file in place using add custom command.
        file(GENERATE OUTPUT "${rc_file_output}.tmp"
            CONTENT "${contents}"
        )

        if (arg_GENERATE_W32_MANIFEST)
            file(GENERATE OUTPUT "${manifest_file_output}.tmp"
                CONTENT "${contents_manifest}"
            )
        endif()


        if(INTERNAL_GENERATOR_IS_MULTI_CONFIG)
            set(cfgs ${CMAKE_CONFIGURATION_TYPES})
            set(outputs "")
            foreach(cfg ${cfgs})
                string(REPLACE "$<CONFIG>" "${cfg}" expanded_rc_file_output "${rc_file_output}")
                list(APPEND outputs "${expanded_rc_file_output}")

                if (arg_GENERATE_W32_MANIFEST)
                    string(REPLACE "$<CONFIG>" "${cfg}" expanded_manifest_file_output "${manifest_file_output}")
                    list(APPEND outputs "${expanded_manifest_file_output}")
                endif()
            endforeach()
        else()
            set(cfgs "${CMAKE_BUILD_TYPE}")
            set(outputs "${rc_file_output}")
            if (arg_GENERATE_W32_MANIFEST)
                set(APPEND cfgs "${CMAKE_BUILD_TYPE}")
                set(APPEND outputs "${manifest_file_output}")
            endif()
        endif()

        set(end_target "${target}")
        set(scope_args TARGET_DIRECTORY ${end_target})

        while(outputs)
            list(POP_FRONT cfgs cfg)
            list(POP_FRONT outputs output)
            set(input "${output}.tmp")
            add_custom_command(OUTPUT "${output}"
                DEPENDS "${input}"
                COMMAND ${CMAKE_COMMAND} -E copy_if_different "${input}" "${output}"
                VERBATIM
            )
            # We can't rely on policy CMP0118 since user project controls it
            set_source_files_properties(${output} ${scope_args} PROPERTIES
                GENERATED TRUE
                COMPILE_FLAGS "${extra_rc_flags}"
            )
            target_sources(${end_target} PRIVATE "$<$<CONFIG:${cfg}>:${output}>")
        endwhile()
    endif()
endfunction()

set(__default_target_info_args
    TARGET_VERSION
    TARGET_PRODUCT
    TARGET_DESCRIPTION
    TARGET_COMPANY
    TARGET_COPYRIGHT
    TARGET_COMMENTS
)

# Set common, informational target properties for a KDE project.
function(ecm_kde_set_target_info_properties target)
    cmake_parse_arguments(arg "" "${__default_target_info_args}" "" ${ARGN})
    if(NOT arg_TARGET_VERSION)
        set(arg_TARGET_VERSION "${PROJECT_VERSION}.0")
    endif()
    if(NOT arg_TARGET_COMPANY)
        set(arg_TARGET_COMPANY "KDE")
    endif()
    if(NOT arg_TARGET_COPYRIGHT)
        set(arg_TARGET_COPYRIGHT "Copyright (C) The KDE Community.")
    endif()
    set_target_properties(${target} PROPERTIES
        ECM_TARGET_VERSION "${arg_TARGET_VERSION}"
        ECM_TARGET_COMPANY_NAME "${arg_TARGET_COMPANY}"
        ECM_TARGET_DESCRIPTION "${arg_TARGET_DESCRIPTION}"
        ECM_TARGET_COPYRIGHT "${arg_TARGET_COPYRIGHT}"
        ECM_TARGET_PRODUCT_NAME "${arg_TARGET_PRODUCT}"
        ECM_TARGET_COMMENTS "${arg_TARGET_COMMENTS}"
    )
endfunction()

# Set common, informational target properties for a KDE Frameworks.
function(ecm_kf_set_target_info_properties target)
    cmake_parse_arguments(arg "" "${__default_target_info_args}" "" ${ARGN})
    if(NOT arg_TARGET_PRODUCT)
        set(arg_TARGET_PRODUCT "KF${QT_MAJOR_VERSION}")
    endif()
    if(NOT arg_TARGET_DESCRIPTION)
        set(arg_TARGET_DESCRIPTION "Collection of libraries created by the KDE Community to extend Qt")
    endif()
    if(NOT arg_TARGET_COMMENTS)
        set(arg_TARGET_COMMENTS "This program is available under the terms of the GNU Lesser General Public License, version 2 or any later version.")
    endif()
    ecm_kde_set_target_info_properties(${target}
        TARGET_VERSION "${arg_TARGET_VERSION}"
        TARGET_COMPANY_NAME "${arg_TARGET_COMPANY}"
        TARGET_DESCRIPTION "${arg_TARGET_DESCRIPTION}"
        TARGET_COPYRIGHT "${arg_TARGET_COPYRIGHT}"
        TARGET_PRODUCT_NAME "${arg_TARGET_PRODUCT}"
        TARGET_COMMENTS "${arg_TARGET_COMMENTS}"
    )
endfunction()