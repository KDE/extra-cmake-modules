# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
# SPDX-License-Identifier: BSD-3-Clause

fn prepend-env [var val &default=""]{
    if (not (has-env $var)) {
        set-env $var $default
    }
    set-env $var $val":"(get-env $var)
}

# LD_LIBRARY_PATH only needed if you are building without rpath
# prepend-env LD_LIBRARY_PATH "@KDE_INSTALL_FULL_LIBDIR@"

prepend-env PATH "@KDE_INSTALL_FULL_BINDIR@"

prepend-env XDG_DATA_DIRS "@KDE_INSTALL_FULL_DATADIR@" &default="/usr/local/share/:/usr/share/"
prepend-env XDG_CONFIG_DIRS "@KDE_INSTALL_FULL_CONFDIR@" &default="/etc/xdg"

prepend-env QT_PLUGIN_PATH "@KDE_INSTALL_FULL_QTPLUGINDIR@"
prepend-env QML2_IMPORT_PATH "@KDE_INSTALL_FULL_QMLDIR@"

prepend-env QT_QUICK_CONTROLS_STYLE_PATH "@KDE_INSTALL_FULL_QMLDIR@/QtQuick/Controls.2/"
