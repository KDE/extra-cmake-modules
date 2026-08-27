# SPDX-FileCopyrightText: 2026 Friedrich W. H. Kossebau <kossebau@kde.org>
#
# SPDX-License-Identifier: BSD-3-Clause

install(FILES
    ECMFindModuleHelpersStub.cmake
    Find7z.cmake
    Find7Zip.cmake
    FindCanberra.cmake
    FindEGL.cmake
    Findepoxy.cmake
    FindFFmpeg.cmake
    FindGLIB2.cmake
    FindGperf.cmake
    FindGradle.cmake
    local.properties.cmake
    settings.gradle.cmake
    Findgzip.cmake
    FindIcoTool.cmake
    FindInotify.cmake
    FindIsoCodes.cmake
    FindKF5.cmake
    FindKF6.cmake
    FindLibcap.cmake
    FindLibExiv2.cmake
    FindLibGit2.cmake
    FindLibMount.cmake
    FindOpenEXR.cmake
    FindPhoneNumber.cmake
    FindPoppler.cmake
    FindPulseAudio.cmake
    FindQHelpGenerator.cmake
    FindQtWaylandScanner.cmake
    FindReuseTool.cmake
    FindSasl2.cmake
    FindSeccomp.cmake
    FindSharedMimeInfo.cmake
    FindTaglib.cmake
    FindUDev.cmake
    FindWayland.cmake
    FindWaylandProtocols.cmake
    FindWaylandScanner.cmake
    FindX11_XCB.cmake
    FindXCB.cmake

    DESTINATION ${FIND_MODULES_INSTALL_DIR}
)
