# - Convenience macro for setting version variables.
#
# ECM_SET_VERSION_VARIABLES(<prefix> <major> <minor> <patch>)
#
# This macro sets the following variables:
#  <prefix>_VERSION_MAJOR to <major>
#  <prefix>_VERSION_MINOR to <minor>
#  <prefix>_VERSION_PATCH to <patch>
#  <prefix>_SOVERSION to <major>
#  <prefix>_VERSION_STRING to "<major>.<minor>.<patch>"
#
# It is basically a shortcut, so instead of
#
#  set(FOO_MAJOR_VERSION 0)
#  set(FOO_MINOR_VERSION 0)
#  set(FOO_PATCH_VERSION 1)
#  set(FOO_SOVERSION ${FOO_SOVERSION} )
#  set(FOO_VERSION ${FOO_MAJOR_VERSION}.${FOO_MINOR_VERSION}.${FOO_PATCH_VERSION})
#
# you can simply write
#
#  ecm_set_version_variables(FOO 0 0 1)
#
# You can do with these variables whatever you want, there is no other automagic or
# anything that depends on them.

# Copyright 2011 Alexander Neundorf <neundorf@kde.org>
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.

macro(ecm_set_version_variables _prefix _major _minor _patch)
  set(${_prefix}_VERSION_MAJOR ${_major})
  set(${_prefix}_VERSION_MINOR ${_minor})
  set(${_prefix}_VERSION_PATCH ${_patch})
  set(${_prefix}_SOVERSION ${_major})
  set(${_prefix}_VERSION_STRING "${${_prefix}_VERSION_MAJOR}.${${_prefix}_VERSION_MINOR}.${${_prefix}_VERSION_PATCH}")
endmacro()
