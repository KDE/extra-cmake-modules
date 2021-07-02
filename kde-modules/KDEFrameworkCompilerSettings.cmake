# SPDX-FileCopyrightText: 2013 Albert Astals Cid <aacid@kde.org>
# SPDX-FileCopyrightText: 2007 Matthias Kretz <kretz@kde.org>
# SPDX-FileCopyrightText: 2006-2007 Laurent Montel <montel@kde.org>
# SPDX-FileCopyrightText: 2006-2013 Alex Neundorf <neundorf@kde.org>
#
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
KDEFrameworkCompilerSettings
----------------------------

Set stricter compile and link flags for KDE Frameworks modules.

.. warning::
   Do not use this module for software which is not part of KDE-Frameworks.
   There is no guarantee for backward-compatibility in newer versions.

The KDECompilerSettings module is included and, in addition, various
defines that affect the Qt libraries are set to enforce certain
conventions.

For example, constructions like QString("foo") are prohibited, instead
forcing the use of QLatin1String or QStringLiteral, and some
Qt-defined keywords like signals and slots will not be defined.

NB: it is recommended to include this module with the NO_POLICY_SCOPE
flag, otherwise you may get spurious warnings with some versions of CMake.

Since pre-1.0.0.
#]=======================================================================]

# No-one else should be using this module, at least by the time when requiring
# ECM 5.85 as minimum, where also settings levels had been introduced for
# KDECompilerSettings to satisfy the needs for stricter out-of-the-box
# settings.
# So making a clear cut here by that condition and providing backward-compat
# support from a separate file with the old code, avoiding the need for
# further if()-else() when changing the settings for current KDE Frameworks.
if (ECM_GLOBAL_FIND_VERSION VERSION_LESS 5.85.0)
    include(KDEFrameworkCompilerLegacySettings NO_POLICY_SCOPE)
    return()
endif()

# set ENABLE_BSYMBOLICFUNCTIONS default to ON
# TODO: find a nice way to set an option default
set(ENABLE_BSYMBOLICFUNCTIONS ON)

# Current defaults
include(KDECompilerSettings NO_POLICY_SCOPE)

# enable warnings for any deprecated Qt/KF API of current 5 series
add_definitions(
    -DQT_DEPRECATED_WARNINGS_SINCE=0x060000
    -DKF_DEPRECATED_WARNINGS_SINCE=0x060000
)

# add clang-format target
include(KDEClangFormat)
file(GLOB_RECURSE ALL_CLANG_FORMAT_SOURCE_FILES *.cpp *.h *.c)
kde_clang_format(${ALL_CLANG_FORMAT_SOURCE_FILES})
