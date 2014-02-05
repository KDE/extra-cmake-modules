# Compatibility hack to make porting frameworks easier
# TODO: remove before releasing 1.0.0

include(${CMAKE_CURRENT_LIST_DIR}/ECMPackageConfigHelpers.cmake)

function(CONFIGURE_PACKAGE_CONFIG_FILE)
    message(AUTHOR_WARNING "Use ecm_configure_package_config_file() from ECMPackageConfigHelpers instead of configure_package_config_file()")
    ecm_configure_package_config_file(${ARGV})
endfunction()
