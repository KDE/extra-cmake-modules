/**
 * SPDX-FileCopyrightText: 2021 Arjen Hiemstra <ahiemstra@heimr.nl>
 *
 * SPDX-License-Identifier: BSD-3-Clause
 */

#include "qmlmodule.h"

#include <QtQml/QQmlEngine>

void QmlModule::registerTypes(const char* uri)
{
    Q_ASSERT(QLatin1String(uri) == QLatin1String("Test"));
}
