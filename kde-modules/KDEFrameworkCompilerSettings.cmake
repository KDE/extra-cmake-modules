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

if (NOT CMAKE_CXX_STANDARD)
    if (ECM_GLOBAL_FIND_VERSION VERSION_GREATER_EQUAL 5.84.0)
        set(CMAKE_CXX_STANDARD 17)
        set(CMAKE_CXX_STANDARD_REQUIRED True)
        set(CMAKE_CXX_EXTENSIONS OFF)
    endif()
endif()

include(KDECompilerSettings NO_POLICY_SCOPE)

# Some non-KF projects make (ab)use of KDEFrameworkCompilerSettings currently,
# let them only hit this when bumping their min. ECM requirement to a newer version.
if (ECM_GLOBAL_FIND_VERSION VERSION_LESS 5.79.0)
    # added by KDECompilerSettings
    remove_definitions(
        -DQT_NO_KEYWORDS
        -DQT_NO_FOREACH
    )
    add_definitions(-DQT_NO_SIGNALS_SLOTS_KEYWORDS)
endif()

add_definitions(
    -DQT_DEPRECATED_WARNINGS_SINCE=0x060000
    -DKF_DEPRECATED_WARNINGS_SINCE=0x060000
)

if (ECM_GLOBAL_FIND_VERSION VERSION_GREATER_EQUAL 5.80.0)
    include(KDEClangFormat)
    # add clang-format target
    file(GLOB_RECURSE ALL_CLANG_FORMAT_SOURCE_FILES *.cpp *.h *.c)
    kde_clang_format(${ALL_CLANG_FORMAT_SOURCE_FILES})
endif ()
