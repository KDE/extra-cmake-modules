# SPDX-FileCopyrightText: 2026 Friedrich W. H. Kossebau <kossebau@kde.org>
#
# SPDX-License-Identifier: BSD-3-Clause

install(FILES
    KDEClangFormat.cmake
    clang-format.cmake
    KDECMakeSettings.cmake
    appstreamtest.cmake
    KDECompilerSettings.cmake
    KDEFrameworkCompilerLegacySettings.cmake
    KDEFrameworkCompilerSettings.cmake
    KDEGitCommitHooks.cmake
    KDEInstallDirs5.cmake
    KDEInstallDirs6.cmake
    KDEInstallDirs.cmake
    KDEInstallDirsCommon.cmake
    KDEMetaInfoPlatformCheck.cmake
    KDEPackageAppTemplates.cmake
    KDESetupPrefixScript.cmake
    prefix.sh.cmake
    prefix.sh.fish.cmake

    DESTINATION ${KDE_MODULES_INSTALL_DIR}
)

install(FILES
    kde-git-commit-hooks/combined.schema.json.in
    kde-git-commit-hooks/combined.schema.json.in.license

    DESTINATION ${KDE_MODULES_INSTALL_DIR}/kde-git-commit-hooks
)

# The scripts need to be executable
install(PROGRAMS
    kde-git-commit-hooks/clang-format.sh
    kde-git-commit-hooks/json-schema.py
    kde-git-commit-hooks/pre-commit.in

    DESTINATION ${KDE_MODULES_INSTALL_DIR}/kde-git-commit-hooks
)
