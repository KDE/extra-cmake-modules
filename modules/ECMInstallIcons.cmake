#.rst:
# ECMInstallIcons
# ---------------
#
# Installs icons, sorting them into the correct directories according to the
# FreeDesktop.org icon naming specification.
#
# ::
#
#   ecm_install_icons(<icon_install_dir> [<l10n_code>])
#
# Installs all icons found in ``CMAKE_CURRENT_SOURCE_DIR`` to the correct
# subdirectory of ``<icon_install_dir>``.  ``<icon_install_dir>`` should
# typically be something like ``share/icons``, although users of the
# :kde-module:`KDEInstallDirs` module would normally do
#
# .. code-block:: cmake
#
#   ecm_install_icons(${ICON_INSTALL_DIR})
#
# The icons must be named in the form::
#
#   <theme><size>-<group>-<name>.<ext>
#
# where ``<theme>`` is one of
# * ``hi`` for hicolor
# * ``lo`` for locolor
# * ``cr`` for the Crystal icon theme
# * ``ox`` for the Oxygen icon theme
#
# ``<size>`` is a numeric pixel size (typically 16, 22, 32, 48, 64, 128 or 256)
# or ``sc`` for scalable (SVG) files, ``<group>`` is one of the standard
# FreeDesktop.org icon groups (actions, animations, apps, categories, devices,
# emblems, emotes, intl, mimetypes, places, status) and ``<ext>`` is one of
# ``.png``, ``.mng`` or ``.svgz``.
#
# For example the file ``hi22-action-menu_new.png`` would be installed into
# ``<icon_install_dir>/hicolor/22x22/actions/menu_new.png``

#=============================================================================
# Copyright 2013 David Edmundson <kde@davidedmundson.co.uk>
# Copyright 2008 Chusslove Illich <caslav.ilic@gmx.net>
# Copyright 2006 Alex Neundorf <neundorf@kde.org>
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file COPYING-CMAKE-SCRIPTS for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# (To distribute this file outside of extra-cmake-modules, substitute the full
#  License text for the above reference.)


# a "map" of short type names to the directories
# unknown names should give empty results
# xdg icon naming specification compatibility
set(_ECM_ICON_GROUP_mimetypes  "mimetypes")
set(_ECM_ICON_GROUP_places     "places")
set(_ECM_ICON_GROUP_devices    "devices")
set(_ECM_ICON_GROUP_apps       "apps")
set(_ECM_ICON_GROUP_actions    "actions")
set(_ECM_ICON_GROUP_categories "categories")
set(_ECM_ICON_GROUP_status     "status")
set(_ECM_ICON_GROUP_emblems    "emblems")
set(_ECM_ICON_GROUP_emotes     "emotes")
set(_ECM_ICON_GROUP_animations "animations")
set(_ECM_ICON_GROUP_intl       "intl")

# FIXME: this is too KDE-specific; we should keep this map for compatibility,
#        but get users to specify the full theme name
# a "map" of short theme names to the theme directory
set(_ECM_ICON_THEME_ox "oxygen")
set(_ECM_ICON_THEME_cr "crystalsvg")
set(_ECM_ICON_THEME_lo "locolor")
set(_ECM_ICON_THEME_hi "hicolor")

macro (ECM_INSTALL_ICONS _defaultpath )

   # the l10n-subdir if language given as second argument (localized icon)
   set(_lang ${ARGV1})
   if(_lang)
      set(_l10n_SUBDIR l10n/${_lang})
   else(_lang)
      set(_l10n_SUBDIR ".")
   endif(_lang)

   # first the png icons
   file(GLOB _icons *.png)
   foreach (_current_ICON ${_icons} )
      # since CMake 2.6 regex matches are stored in special variables CMAKE_MATCH_x, if it didn't match, they are empty
      string(REGEX MATCH "^.*/([a-zA-Z]+)([0-9]+)\\-([a-z]+)\\-(.+\\.png)$" _dummy  "${_current_ICON}")
      set(_type  "${CMAKE_MATCH_1}")
      set(_size  "${CMAKE_MATCH_2}")
      set(_group "${CMAKE_MATCH_3}")
      set(_name  "${CMAKE_MATCH_4}")

      # FIXME: don't use map
      set(_theme_GROUP ${_ECM_ICON_THEME_${_type}})
      if( _theme_GROUP)
         _ECM_ADD_ICON_INSTALL_RULE(${CMAKE_CURRENT_BINARY_DIR}/install_icons.cmake
                    ${_defaultpath}/${_theme_GROUP}/${_size}x${_size}
                    ${_group} ${_current_ICON} ${_name} ${_l10n_SUBDIR})
      endif( _theme_GROUP)
   endforeach (_current_ICON)

   # mng icons
   file(GLOB _icons *.mng)
   foreach (_current_ICON ${_icons} )
      # since CMake 2.6 regex matches are stored in special variables CMAKE_MATCH_x, if it didn't match, they are empty
      string(REGEX MATCH "^.*/([a-zA-Z]+)([0-9]+)\\-([a-z]+)\\-(.+\\.mng)$" _dummy  "${_current_ICON}")
      set(_type  "${CMAKE_MATCH_1}")
      set(_size  "${CMAKE_MATCH_2}")
      set(_group "${CMAKE_MATCH_3}")
      set(_name  "${CMAKE_MATCH_4}")

      set(_theme_GROUP ${_ECM_ICON_THEME_${_type}})
      if( _theme_GROUP)
         _ECM_ADD_ICON_INSTALL_RULE(${CMAKE_CURRENT_BINARY_DIR}/install_icons.cmake
                ${_defaultpath}/${_theme_GROUP}/${_size}x${_size}
                ${_group} ${_current_ICON} ${_name} ${_l10n_SUBDIR})
      endif( _theme_GROUP)
   endforeach (_current_ICON)

   # and now the svg icons
   file(GLOB _icons *.svgz)
   foreach (_current_ICON ${_icons} )
      # since CMake 2.6 regex matches are stored in special variables CMAKE_MATCH_x, if it didn't match, they are empty
      string(REGEX MATCH "^.*/([a-zA-Z]+)sc\\-([a-z]+)\\-(.+\\.svgz)$" _dummy "${_current_ICON}")
      set(_type  "${CMAKE_MATCH_1}")
      set(_group "${CMAKE_MATCH_2}")
      set(_name  "${CMAKE_MATCH_3}")

      set(_theme_GROUP ${_ECM_ICON_THEME_${_type}})
      if( _theme_GROUP)
          _ECM_ADD_ICON_INSTALL_RULE(${CMAKE_CURRENT_BINARY_DIR}/install_icons.cmake
                            ${_defaultpath}/${_theme_GROUP}/scalable
                            ${_group} ${_current_ICON} ${_name} ${_l10n_SUBDIR})
      endif( _theme_GROUP)
   endforeach (_current_ICON)

   ecm_update_iconcache()

endmacro (ECM_INSTALL_ICONS)

# only used internally by ECM_INSTALL_ICONS
macro (_ECM_ADD_ICON_INSTALL_RULE _install_SCRIPT _install_PATH _group _orig_NAME _install_NAME _l10n_SUBDIR)

   # if the string doesn't match the pattern, the result is the full string, so all three have the same content
   if (NOT ${_group} STREQUAL ${_install_NAME} )
      set(_icon_GROUP  ${_ECM_ICON_GROUP_${_group}})
      if(NOT _icon_GROUP)
         # FIXME: print warning if not in map (and not "actions")
         set(_icon_GROUP "actions")
      endif(NOT _icon_GROUP)
#      message(STATUS "icon: ${_current_ICON} size: ${_size} group: ${_group} name: ${_name} l10n: ${_l10n_SUBDIR}")
      install(FILES ${_orig_NAME} DESTINATION ${_install_PATH}/${_icon_GROUP}/${_l10n_SUBDIR}/ RENAME ${_install_NAME} )
   endif (NOT ${_group} STREQUAL ${_install_NAME} )

endmacro (_ECM_ADD_ICON_INSTALL_RULE)

macro (ECM_UPDATE_ICONCACHE)
    # Update mtime of hicolor icon theme dir.
    # We don't always have touch command (e.g. on Windows), so instead create
    #  and delete a temporary file in the theme dir.
   install(CODE "
    set(DESTDIR_VALUE \"\$ENV{DESTDIR}\")
    if (NOT DESTDIR_VALUE)
        file(WRITE \"${ICON_INSTALL_DIR}/hicolor/temp.txt\" \"update\")
        file(REMOVE \"${ICON_INSTALL_DIR}/hicolor/temp.txt\")
    endif (NOT DESTDIR_VALUE)
    ")
endmacro (ECM_UPDATE_ICONCACHE)
