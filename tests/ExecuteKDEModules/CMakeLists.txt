project(ExecuteKDEModules)
cmake_minimum_required(VERSION 2.8.12)

# order is important (install dirs before cmake settings)!
set(all_kde_modules
    KDEInstallDirs
    KDECMakeSettings
    KDECompilerSettings
    KDEFrameworkCompilerSettings
)

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../../kde-modules)

foreach(module ${all_kde_modules})
    message(STATUS "module: ${module}")
    include("${module}")
endforeach()

set(expected_vars
    AUTOSTART_INSTALL_DIR
    BIN_INSTALL_DIR
    CMAKECONFIG_INSTALL_PREFIX
    CMAKE_INSTALL_DEFAULT_COMPONENT_NAME
    CONFIG_INSTALL_DIR
    DATA_INSTALL_DIR
    DBUS_INTERFACES_INSTALL_DIR
    DBUS_SERVICES_INSTALL_DIR
    DBUS_SYSTEM_SERVICES_INSTALL_DIR
    EXEC_INSTALL_PREFIX
    HTML_INSTALL_DIR
    ICON_INSTALL_DIR
    IMPORTS_INSTALL_DIR
    INCLUDE_INSTALL_DIR
    INSTALL_TARGETS_DEFAULT_ARGS
    KCFG_INSTALL_DIR
    KCONF_UPDATE_INSTALL_DIR
    KF5_DATA_INSTALL_DIR
    KF5_INCLUDE_INSTALL_DIR
    KF5_INSTALL_TARGETS_DEFAULT_ARGS
    KF5_LIBEXEC_INSTALL_DIR
    KNOTIFYRC_INSTALL_DIR
    LIBEXEC_INSTALL_DIR
    LIB_INSTALL_DIR
    LOCALE_INSTALL_DIR
    MAN_INSTALL_DIR
    PLUGIN_INSTALL_DIR
    QML_INSTALL_DIR
    QT_PLUGIN_INSTALL_DIR
    SBIN_INSTALL_DIR
    SERVICES_INSTALL_DIR
    SERVICETYPES_INSTALL_DIR
    SHARE_INSTALL_PREFIX
    SOUND_INSTALL_DIR
    SYSCONF_INSTALL_DIR
    TEMPLATES_INSTALL_DIR
    WALLPAPER_INSTALL_DIR
    XDG_APPS_INSTALL_DIR
    XDG_DIRECTORY_INSTALL_DIR
    XDG_MIME_INSTALL_DIR
)
if(APPLE)
    list(APPEND expected_vars
        BUNDLE_INSTALL_DIR
    )
endif()

foreach(variable ${expected_vars})
    if(NOT DEFINED ${variable})
        message(SEND_ERROR "${variable} is not defined.")
    endif()
endforeach()

add_executable(dummy main.c)
