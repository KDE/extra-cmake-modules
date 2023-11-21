# SPDX-FileCopyrightText: 2014 Alex Merry <alex.merry@kde.org>
# SPDX-FileCopyrightText: 2014 Ralf Habacker <ralf.habacker@freenet.de>
# SPDX-FileCopyrightText: 2006-2009 Alexander Neundorf <neundorf@kde.org>
# SPDX-FileCopyrightText: 2006, 2007 Laurent Montel <montel@kde.org>
# SPDX-FileCopyrightText: 2007 Matthias Kretz <kretz@kde.org>
#
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
ECMAddAppIcon
-------------

Add icons to executable files and packages.

::

 ecm_add_app_icon(<sources_var_name(|target (since 5.83))>
                  ICONS <icon> [<icon> [...]]
                  [SIDEBAR_ICONS <icon> [<icon> [...]] # Since 5.49
                  [OUTFILE_BASENAME <name>]) # Since 5.49
                  )

The given icons, whose names must match the pattern::

  <size>-<other_text>.png

will be added as platform-specific application icons
to the variable named ``<sources_var_name>`` or, if the first argument
is a target (since 5.83), to the ``SOURCES`` property of ``<target>``.
Any target must be created with add_executable() and not be an alias.

Other icon files are ignored but on Mac SVG files can be supported and
it is thus possible to mix those with png files in a single macro call.

The platforms currently supported are Windows and Mac OS X, on all others
the call has no effect and is ignored.

``<size>`` is a numeric pixel size (typically 16, 32, 48, 64, 128 or 256).
``<other_text>`` can be any other text. See the platform notes below for any
recommendations about icon sizes.

``SIDEBAR_ICONS`` can be used to add Mac OS X sidebar
icons to the generated iconset. They are used when a folder monitored by the
application is dragged into Finder's sidebar. Since 5.49.

``OUTFILE_BASENAME`` will be used as the basename for the icon file. If
you specify it, the icon file will be called ``<OUTFILE_BASENAME>.icns`` on Mac OS X
and ``<OUTFILE_BASENAME>.ico`` on Windows. If you don't specify it, it defaults
to ``<sources_var_name>.<ext>``. Since 5.49.


Windows notes
   * Icons are compiled into the executable using a resource file.
   * Icons may not show up in Windows Explorer if the executable
     target does not have the ``WIN32_EXECUTABLE`` property set.
   * Icotool (see :find-module:`FindIcoTool`) is required.
   * Supported sizes: 16, 24, 32, 48, 64, 128, 256, 512 and 1024.

Mac OS X notes
   * The executable target must have the ``MACOSX_BUNDLE`` property set.
   * Icons are added to the bundle.
   * If the ksvg2icns tool from KIconThemes is available, .svg and .svgz
     files are accepted; the first that is converted successfully to .icns
     will provide the application icon. SVG files are ignored otherwise.
   * The tool iconutil (provided by Apple) is required for bitmap icons.
   * Supported sizes: 16, 32, 64, 128, 256 (and 512, 1024 after OS X 10.9).
   * At least a 128x128px (or an SVG) icon is required.
   * Larger sizes are automatically used to substitute for smaller sizes on
     "Retina" (high-resolution) displays. For example, a 32px icon, if
     provided, will be used as a 32px icon on standard-resolution displays,
     and as a 16px-equivalent icon (with an "@2x" tag) on high-resolution
     displays. That is why you should provide 64px and 1024px icons although
     they are not supported anymore directly. Instead they will be used as
     32px@2x and 512px@2x. If an SVG icon is provided, ksvg2icns will be
     used internally to automatically generate all appropriate sizes,
     including the high-resolution ones.
   * This function sets the ``MACOSX_BUNDLE_ICON_FILE`` variable to the name
     of the generated icns file, so that it will be used as the
     ``MACOSX_BUNDLE_ICON_FILE`` target property when you call
     ``add_executable``.
   * Sidebar icons should typically provided in 16, 32, 64, 128 and 256px.

Since 1.7.0.
#]=======================================================================]

function(ecm_add_app_icon appsources_or_target)
    set(options)
    set(oneValueArgs OUTFILE_BASENAME)
    set(multiValueArgs ICONS SIDEBAR_ICONS)
    cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if(NOT ARG_ICONS)
        message(FATAL_ERROR "No ICONS argument given to ecm_add_app_icon")
    endif()
    if (TARGET ${appsources_or_target})
        get_target_property(target_type ${appsources_or_target} TYPE)
        if (NOT target_type STREQUAL "EXECUTABLE")
            message(FATAL_ERROR "Target argument passed to ecm_add_app_icon is not an executable: ${appsources_or_target}")
        endif()
        get_target_property(aliased_target ${appsources_or_target} ALIASED_TARGET)
        if(aliased_target)
            message(FATAL_ERROR "Target argument passed to ecm_add_app_icon must not be an alias: ${appsources_or_target}")
        endif()
    endif()
    if(ARG_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Unexpected arguments to ecm_add_app_icon: ${ARG_UNPARSED_ARGUMENTS}")
    endif()

    if(APPLE)
        find_program(KSVG2ICNS NAMES ksvg2icns)
        foreach(icon ${ARG_ICONS})
            get_filename_component(icon_full ${icon} ABSOLUTE)
            get_filename_component(icon_type ${icon_full} EXT)
            # do we have ksvg2icns in the path and did we receive an svg (or compressed svg) icon?
            if(KSVG2ICNS AND (${icon_type} STREQUAL ".svg" OR ${icon_type} STREQUAL ".svgz"))
                # convert the svg icon to an icon resource
                execute_process(COMMAND ${KSVG2ICNS} "${icon_full}"
                    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} RESULT_VARIABLE KSVG2ICNS_ERROR)
                if(${KSVG2ICNS_ERROR})
                    message(AUTHOR_WARNING "ksvg2icns could not generate an OS X application icon from ${icon}")
                else()
                    # install the icns file we just created
                    get_filename_component(icon_name ${icon_full} NAME_WE)
                    set(MACOSX_BUNDLE_ICON_FILE ${icon_name}.icns PARENT_SCOPE)
                    if (TARGET ${appsources_or_target})
                        target_sources(${appsources_or_target} PRIVATE "${CMAKE_CURRENT_BINARY_DIR}/${icon_name}.icns")
                    else()
                        set(${appsources_or_target} "${${appsources_or_target}};${CMAKE_CURRENT_BINARY_DIR}/${icon_name}.icns" PARENT_SCOPE)
                    endif()
                    set_source_files_properties(${CMAKE_CURRENT_BINARY_DIR}/${icon_name}.icns PROPERTIES MACOSX_PACKAGE_LOCATION Resources)
                    # we're done now
                    return()
                endif()
            endif()
        endforeach()
    endif()


    _ecm_add_app_icon_categorize_icons("${ARG_ICONS}" "icons" "16;24;32;48;64;128;256;512;1024")
    if(ARG_SIDEBAR_ICONS)
        _ecm_add_app_icon_categorize_icons("${ARG_SIDEBAR_ICONS}" "sidebar_icons" "16;32;64;128;256")
    endif()

    set(mac_icons
                  # Icons: https://developer.apple.com/library/content/documentation/GraphicsAnimation/Conceptual/HighResolutionOSX/Optimizing/Optimizing.html#//apple_ref/doc/uid/TP40012302-CH7-SW4
                  ${icons_at_16px}
                  ${icons_at_32px}
                  ${icons_at_64px}
                  ${icons_at_128px}
                  ${icons_at_256px}
                  ${icons_at_512px}
                  ${icons_at_1024px})

    set(mac_sidebar_icons
                  # Sidebar Icons: https://developer.apple.com/library/content/documentation/General/Conceptual/ExtensibilityPG/Finder.html#//apple_ref/doc/uid/TP40014214-CH15-SW15
                  ${sidebar_icons_at_16px}
                  ${sidebar_icons_at_32px}
                  ${sidebar_icons_at_64px}
                  ${sidebar_icons_at_128px}
                  ${sidebar_icons_at_256px})

    if (NOT (mac_icons OR mac_sidebar_icons))
        message(AUTHOR_WARNING "No icons suitable for use on macOS provided")
    endif()


    set(windows_icons_classic ${icons_at_16px}
                              ${icons_at_24px}
                              ${icons_at_32px}
                              ${icons_at_48px}
                              ${icons_at_64px}
                              ${icons_at_128px})
    set(windows_icons_modern  ${windows_icons_classic}
                              ${icons_at_256px}
                              ${icons_at_512px}
                              ${icons_at_1024px})

    if (NOT (windows_icons_modern OR windows_icons_classic))
        message(AUTHOR_WARNING "No icons suitable for use on Windows provided")
    endif()

    if (ARG_OUTFILE_BASENAME)
        set (_outfilebasename "${ARG_OUTFILE_BASENAME}")
    else()
        set (_outfilebasename "${appsources_or_target}")
    endif()
    set (_outfilename "${CMAKE_CURRENT_BINARY_DIR}/${_outfilebasename}")

    if (WIN32 AND (windows_icons_modern OR windows_icons_classic))
        set(saved_CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}")
        set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_FIND_MODULE_DIR})
        find_package(IcoTool)
        set(CMAKE_MODULE_PATH "${saved_CMAKE_MODULE_PATH}")

        function(create_windows_icon_and_rc command args deps)
                add_custom_command(
                    OUTPUT "${_outfilename}.ico"
                    COMMAND ${command}
                    ARGS ${args}
                    DEPENDS ${deps}
                    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
                )
                # this bit's a little hacky to make the dependency stuff work
                file(WRITE "${_outfilename}.rc.in" "IDI_ICON1        ICON        DISCARDABLE    \"${_outfilename}.ico\"\n")
                add_custom_command(
                    OUTPUT "${_outfilename}.rc"
                    COMMAND ${CMAKE_COMMAND}
                    ARGS -E copy "${_outfilename}.rc.in" "${_outfilename}.rc"
                    DEPENDS "${_outfilename}.ico"
                    WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
                )
        endfunction()

        if (IcoTool_FOUND)
            list(APPEND icotool_args "-c" "-o" "${_outfilename}.ico")

            # According to https://stackoverflow.com/a/40851713/2886832
            # Windows always chooses the first icon above 255px, all other ones will be ignored
            set(maxSize 0)
            foreach(size 256 512 1024)
                if(icons_at_${size}px)
                    set(maxSize "${size}")
                endif()
            endforeach()

            foreach(size 16 24 32 48 64 128 ${maxSize})
                if(NOT icons_at_${size}px)
                    continue()
                endif()

                set(icotool_icon_arg "")
                if(size STREQUAL "${maxSize}")
                    # maxSize icon needs to be included as raw png
                    list(APPEND icotool_args "-r")
                endif()

                foreach(icon ${icons_at_${size}px})
                    list(APPEND icotool_args "${icons_at_${size}px}")
                endforeach()
            endforeach()

            create_windows_icon_and_rc(IcoTool::IcoTool "${icotool_args}" "${windows_icons_modern}")
            if (TARGET ${appsources_or_target})
                target_sources(${appsources_or_target} PRIVATE "${_outfilename}.rc")
            else()
                set(${appsources_or_target} "${${appsources_or_target}};${_outfilename}.rc" PARENT_SCOPE)
            endif()
        else()
            message(WARNING "Unable to find the icotool utilities or icons in matching sizes - application will not have an application icon!")
        endif()
    elseif (APPLE AND (mac_icons OR mac_sidebar_icons))
        # first generate .iconset directory structure, then convert to .icns format using the Mac OS X "iconutil" utility,
        # to create retina compatible icon, you need png source files in pixel resolution 16x16, 32x32, 64x64, 128x128,
        # 256x256, 512x512, 1024x1024
        find_program(ICONUTIL_EXECUTABLE NAMES iconutil)
        if (ICONUTIL_EXECUTABLE)
            add_custom_command(
                OUTPUT "${_outfilename}.iconset"
                COMMAND ${CMAKE_COMMAND}
                ARGS -E make_directory "${_outfilename}.iconset"
            )
            set(iconset_icons)
            macro(copy_icon filename sizename type)
                add_custom_command(
                    OUTPUT "${_outfilename}.iconset/${type}_${sizename}.png"
                    COMMAND ${CMAKE_COMMAND}
                    ARGS -E copy
                         "${filename}"
                         "${_outfilename}.iconset/${type}_${sizename}.png"
                    DEPENDS
                        "${_outfilename}.iconset"
                        "${filename}"
                    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
                )
                list(APPEND iconset_icons
                        "${_outfilename}.iconset/${type}_${sizename}.png")
            endmacro()

            # List of supported sizes and filenames taken from:
            # https://developer.apple.com/library/content/documentation/GraphicsAnimation/Conceptual/HighResolutionOSX/Optimizing/Optimizing.html#//apple_ref/doc/uid/TP40012302-CH7-SW4
            foreach(size 16 32 128 256 512)
                math(EXPR double_size "2 * ${size}")
                foreach(file ${icons_at_${size}px})
                    copy_icon("${file}" "${size}x${size}" "icon")
                endforeach()
                foreach(file ${icons_at_${double_size}px})
                    copy_icon("${file}" "${size}x${size}@2x" "icon")
                endforeach()
            endforeach()

            # List of supported sizes and filenames taken from:
            # https://developer.apple.com/library/content/documentation/General/Conceptual/ExtensibilityPG/Finder.html#//apple_ref/doc/uid/TP40014214-CH15-SW15
            foreach(file ${sidebar_icons_at_16px})
                copy_icon("${file}" "16x16" "sidebar")
            endforeach()
            foreach(file ${sidebar_icons_at_32px})
                copy_icon("${file}" "16x16@2x" "sidebar")
            endforeach()
            foreach(file ${sidebar_icons_at_32px})
                copy_icon("${file}" "18x18" "sidebar")
            endforeach()
            foreach(file ${sidebar_icons_at_64px})
                copy_icon("${file}" "18x18@2x" "sidebar")
            endforeach()
            foreach(file ${sidebar_icons_at_128px})
                copy_icon("${file}" "32x32" "sidebar")
            endforeach()
            foreach(file ${sidebar_icons_at_256px})
                copy_icon("${file}" "32x32@2x" "sidebar")
            endforeach()

            # generate .icns icon file
            add_custom_command(
                OUTPUT "${_outfilename}.icns"
                COMMAND ${ICONUTIL_EXECUTABLE}
                ARGS
                    --convert icns
                    --output "${_outfilename}.icns"
                    "${_outfilename}.iconset"
                DEPENDS "${iconset_icons}"
                WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
            )
            # This will register the icon into the bundle
            set(MACOSX_BUNDLE_ICON_FILE "${_outfilebasename}.icns" PARENT_SCOPE)

            # Append the icns file to the sources list so it will be a dependency to the
            # main target
            if (TARGET ${appsources_or_target})
                target_sources(${appsources_or_target} PRIVATE "${_outfilename}.icns")
            else()
                set(${appsources_or_target} "${${appsources_or_target}};${_outfilename}.icns" PARENT_SCOPE)
            endif()

            # Install the icon into the Resources dir in the bundle
            set_source_files_properties("${_outfilename}.icns" PROPERTIES MACOSX_PACKAGE_LOCATION Resources)
        else()
            message(STATUS "Unable to find the iconutil utility - application will not have an application icon!")
        endif()
    endif()
endfunction()

macro(_ecm_add_app_icon_categorize_icons icons type known_sizes)
    set(_${type}_known_sizes)
    foreach(size ${known_sizes})
        set(${type}_at_${size}px)
        list(APPEND _${type}_known_sizes ${size})
    endforeach()


    foreach(icon ${icons})
        get_filename_component(icon_full ${icon} ABSOLUTE)
        if (NOT EXISTS "${icon_full}")
            message(AUTHOR_WARNING "${icon_full} does not exist, ignoring")
        else()
            get_filename_component(icon_name ${icon} NAME)
            string(REGEX MATCH "([0-9]+|sc)\\-[^/]+\\.([a-z]+)$"
                               _dummy "${icon_name}")
            set(size  "${CMAKE_MATCH_1}")
            set(ext   "${CMAKE_MATCH_2}")

            if (NOT (ext STREQUAL "svg" OR ext STREQUAL "svgz"))
                if (NOT size)
                    message(AUTHOR_WARNING "${icon_full} is not named correctly for ecm_add_app_icon - ignoring")
                elseif (NOT ext STREQUAL "png")
                    message(AUTHOR_WARNING "${icon_full} is not a png file - ignoring")
                else()
                    list(FIND _${type}_known_sizes ${size} offset)

                    if (offset GREATER -1)
                        list(APPEND ${type}_at_${size}px "${icon_full}")
                    elseif()
                        message(STATUS "not found ${type}_at_${size}px ${icon_full}")
                    endif()
                endif()
            endif()
        endif()
    endforeach()
endmacro()
