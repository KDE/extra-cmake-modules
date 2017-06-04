project(ECMAddAppIconTest)
cmake_minimum_required(VERSION 2.8.12)

set(CMAKE_MODULE_PATH
    ${CMAKE_CURRENT_SOURCE_DIR}/../../modules
    ${CMAKE_CURRENT_SOURCE_DIR}/../../find-modules
)

include(ECMAddAppIcon)

set(ICONS 16-category-name.png 128-category-name.png)

ecm_add_app_icon(OUT ICONS ${ICONS})

if(WIN32 OR APPLE)
    list(LENGTH OUT out_count)
    if(out_count EQUAL 0)
        message(FATAL_ERROR "ecm_add_app_icon() haven't produced anything")
    endif()
endif()

add_custom_target(t ALL DEPENDS ${OUT})

# this will be run by CTest
configure_file(check_files.cmake.in "${CMAKE_CURRENT_BINARY_DIR}/check_files.cmake" @ONLY)
