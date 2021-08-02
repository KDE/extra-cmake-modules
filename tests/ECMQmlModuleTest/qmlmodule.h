/**
 * SPDX-FileCopyrightText: 2021 Arjen Hiemstra <ahiemstra@heimr.nl>
 *
 * SPDX-License-Identifier: BSD-3-Clause
 */

#ifndef QMLMODULE_H
#define QMLMODULE_H

#include <QtQml/QQmlExtensionPlugin>

class QmlModule : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    void registerTypes(const char* uri) override;
};

#endif
