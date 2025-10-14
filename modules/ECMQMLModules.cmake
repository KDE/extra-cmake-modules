#
# SPDX-FileCopyrightText: 2021 Arjen Hiemstra <ahiemstra@heimr.nl>
#
# SPDX-License-Identifier: BSD-3-Clause

cmake_policy(VERSION 3.16)

if (${ECM_GLOBAL_FIND_VERSION} VERSION_GREATER_EQUAL 5.88)
    message(DEPRECATION "ECMQMLModules.cmake is deprecated since 5.88.0, please use ECMFindQmlModule.cmake instead")
endif()

include(ECMFindQmlModule)
