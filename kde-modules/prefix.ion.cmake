# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
# SPDX-License-Identifier: BSD-3-Clause

export PATH = @KDE_INSTALL_FULL_BINDIR@:$PATH

# LD_LIBRARY_PATH only needed if you are building without rpath
# export LD_LIBRARY_PATH = @KDE_INSTALL_FULL_LIBDIR@:${env::LD_LIBRARY_PATH}

export XDG_DATA_DIRS = @KDE_INSTALL_FULL_DATADIR@:$or($XDG_DATA_DIRS "/usr/local/share/:/usr/share/")
export XDG_CONFIG_DIRS = @KDE_INSTALL_FULL_CONFDIR@:$or($XDG_CONFIG_DIRS "/etc/xdg")

export QT_PLUGIN_PATH = @KDE_INSTALL_FULL_QTPLUGINDIR@:${env::QT_PLUGIN_PATH}
export QML2_IMPORT_PATH = @KDE_INSTALL_FULL_QMLDIR@:${env::QML2_IMPORT_PATH}

export QT_QUICK_CONTROLS_STYLE_PATH = @KDE_INSTALL_FULL_QMLDIR@/QtQuick/Controls.2/:${env::QT_QUICK_CONTROLS_STYLE_PATH}
