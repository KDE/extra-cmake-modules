cmake_minimum_required(VERSION 3.5)
project(ECMAddAppIconTest)

set(CMAKE_MODULE_PATH
    ${CMAKE_CURRENT_SOURCE_DIR}/../../modules
    ${CMAKE_CURRENT_SOURCE_DIR}/../../find-modules
)

include(ECMAddAppIcon)

if(WIN32)
    set(icon_extension_to_test "rc")
elseif(APPLE)
    set(icon_extension_to_test "icns")
endif()

#### Test 1: ecm_add_app_icon with only regular icons and no OUTFILE_BASENAME, for sources var ####
set(ICONS_1 16-category-name.png 128-category-name.png)
ecm_add_app_icon(OUT_1 ICONS ${ICONS_1})

list(LENGTH OUT_1 out_count)

if(WIN32 OR APPLE)
    if(out_count EQUAL 0)
        message(FATAL_ERROR "ecm_add_app_icon() hasn't produced anything")
    endif()

    if(NOT OUT_1 MATCHES "OUT_1.${icon_extension_to_test}")
        message(FATAL_ERROR "ecm_add_app_icon() did not fall back to target name for icon name: ${OUT_1}")
    endif()
else()
    if(NOT out_count EQUAL 0)
        message(FATAL_ERROR "ecm_add_app_icon() produced something unexpectedly.")
    endif()
endif()

add_custom_target(t_1 ALL DEPENDS ${OUT_1})
list(APPEND OUT "${OUT_1}")

#### Test 2: ecm_add_app_icon with regular and sidebar icons and OUTFILE_BASENAME set, for sources var ####
set(ICONS_2 16-category-name.png 128-category-name.png)
set(SIDEBAR_ICONS_2 16-category-name-sidebar.png 128-category-name-sidebar.png)

ecm_add_app_icon(OUT_2 ICONS ${ICONS_2} SIDEBAR_ICONS ${SIDEBAR_ICONS_2} OUTFILE_BASENAME "SuperBasename")

list(LENGTH OUT_2 out_count)

if(WIN32 OR APPLE)
    if(out_count EQUAL 0)
        message(FATAL_ERROR "ecm_add_app_icon() hasn't produced anything")
    endif()

    if(NOT OUT_2 MATCHES "SuperBasename.${icon_extension_to_test}")
        message(FATAL_ERROR "ecm_add_app_icon() did not respect OUTFILE_BASENAME: ${OUT_2}")
    endif()
else()
    if(NOT out_count EQUAL 0)
        message(FATAL_ERROR "ecm_add_app_icon() produced something unexpectedly.")
    endif()
endif()

if(APPLE)
    list(APPEND expected_icons "icon_16x16.png" "icon_128x128.png" "sidebar_16x16.png" "sidebar_32x32.png")
    foreach(expected_icon ${expected_icons})
        list(APPEND OUT_2 "${CMAKE_CURRENT_BINARY_DIR}/SuperBasename.iconset/${expected_icon}")
    endforeach()
endif()

add_custom_target(t_2 ALL DEPENDS ${OUT_2})
list(APPEND OUT "${OUT_2}")

#### Test 3: ecm_add_app_icon with only regular icons and no OUTFILE_BASENAME, for target  ####
set(ICONS_3 16-category-name.png 128-category-name.png)

add_executable(app_3)
target_sources(app_3 PRIVATE main.cpp)

ecm_add_app_icon(app_3 ICONS ${ICONS_1})

get_target_property(OUT_3 app_3 SOURCES)
list(REMOVE_ITEM OUT_3 main.cpp)
list(LENGTH OUT_3 out_count)

if(WIN32 OR APPLE)
    if(out_count EQUAL 0)
        message(FATAL_ERROR "ecm_add_app_icon() hasn't produced anything")
    endif()

    if(NOT OUT_3 MATCHES "app_3.${icon_extension_to_test}")
        message(FATAL_ERROR "ecm_add_app_icon() did not fall back to target name for icon name: ${OUT_1}")
    endif()
else()
    if(NOT out_count EQUAL 0)
        message(FATAL_ERROR "ecm_add_app_icon() produced something unexpectedly.")
    endif()
endif()

list(APPEND OUT "${OUT_3}")

#### Test 4: ecm_add_app_icon with regular and sidebar icons and OUTFILE_BASENAME set, for target ####
set(ICONS_4 16-category-name.png 128-category-name.png)
set(SIDEBAR_ICONS_4 16-category-name-sidebar.png 128-category-name-sidebar.png)

add_executable(app_4)
target_sources(app_4 PRIVATE main.cpp)

ecm_add_app_icon(app_4 ICONS ${ICONS_4} SIDEBAR_ICONS ${SIDEBAR_ICONS_4} OUTFILE_BASENAME "SuperBasename4")

get_target_property(OUT_4 app_4 SOURCES)
list(REMOVE_ITEM OUT_4 main.cpp)
list(LENGTH OUT_4 out_count)

if(WIN32 OR APPLE)
    if(out_count EQUAL 0)
        message(FATAL_ERROR "ecm_add_app_icon() hasn't produced anything")
    endif()

    if(NOT OUT_4 MATCHES "SuperBasename4.${icon_extension_to_test}")
        message(FATAL_ERROR "ecm_add_app_icon() did not respect OUTFILE_BASENAME: ${OUT_4}")
    endif()
else()
    if(NOT out_count EQUAL 0)
        message(FATAL_ERROR "ecm_add_app_icon() produced something unexpectedly.")
    endif()
endif()

if(APPLE)
    list(APPEND expected_icons "icon_16x16.png" "icon_128x128.png" "sidebar_16x16.png" "sidebar_32x32.png")
    foreach(expected_icon ${expected_icons})
        list(APPEND OUT_4 "${CMAKE_CURRENT_BINARY_DIR}/SuperBasename4.iconset/${expected_icon}")
    endforeach()
endif()

list(APPEND OUT "${OUT_4}")

#### this will be run by CTest ####
configure_file(check_files.cmake.in "${CMAKE_CURRENT_BINARY_DIR}/check_files.cmake" @ONLY)
