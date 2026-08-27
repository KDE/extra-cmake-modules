# SPDX-FileCopyrightText: 2026 Friedrich W. H. Kossebau <kossebau@kde.org>
#
# SPDX-License-Identifier: BSD-3-Clause

install(FILES
    Android.cmake
    deployment-file.json.in
    deployment-file-qt514.json.in
    deployment-file-qt6.json.in
    deployment-file-qt6.json.in.license
    ECMAndroidDeployQt5.cmake
    ecm-version.gradle.in
    generate-fastlane-metadata.py
    hasMainSymbol.cmake
    specifydependencies.cmake

    DESTINATION ${TOOLCHAIN_MODULES_INSTALL_DIR}
)
