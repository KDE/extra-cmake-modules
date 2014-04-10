#.rst:
# KDEFrameworkCompilerSettings
# ----------------------------
#
# Set stricter compile and link flags for KDE Frameworks modules.
#
# The KDECompilerSettings module is included and, in addition, various
# defines that affect the Qt libraries are set to enforce certain
# conventions.
#
# For example, constructions like QString("foo") are prohibited, instead
# forcing the use of QLatin1String or QStringLiteral, and some
# Qt-defined keywords like signals and slots will not be defined.

#=============================================================================
# Copyright 2013      Albert Astals Cid <aacid@kde.org>
# Copyright 2007      Matthias Kretz <kretz@kde.org>
# Copyright 2006-2007 Laurent Montel <montel@kde.org>
# Copyright 2006-2013 Alex Neundorf <neundorf@kde.org>
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

include(KDECompilerSettings)

add_definitions(-DQT_NO_CAST_TO_ASCII
                -DQT_NO_CAST_FROM_ASCII
                -DQT_NO_URL_CAST_FROM_STRING
                -DQT_NO_CAST_FROM_BYTEARRAY
                -DQT_NO_SIGNALS_SLOTS_KEYWORDS
                -DQT_USE_FAST_OPERATOR_PLUS
                -DQT_USE_QSTRINGBUILDER
               )
if(NOT MSVC)
    # QT_STRICT_ITERATORS breaks MSVC: it tries to link to QTypedArrayData symbols
    # when using foreach. However these symbols don't actually exist.
    # Not having QT_STRICT_ITERATORS defined fixes this issue.
    # This is fixed by https://codereview.qt-project.org/#change,76311
    # TODO: set QT_STRICT_ITERATORS on all platforms once we depend on Qt 5.3
    add_definitions(-DQT_STRICT_ITERATORS)
endif()
