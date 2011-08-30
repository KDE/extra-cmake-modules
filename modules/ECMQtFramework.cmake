
# We need to make sure this file is included before Qt found.
# Otherwise QT_USE_IMPORTED_TARGETS would have no effect.
# ### Temporarily disabled until KDE Frameworks includes this file before finding Qt.
# if (QT4_FOUND)
#   message(SEND_ERROR "This file must be included before finding the Qt package.")
# endif()

cmake_policy(SET CMP0017 NEW)

include(FeatureSummary)
include(GenerateExportHeader)

add_compiler_export_flags()

# create coverage build type
set(CMAKE_CONFIGURATION_TYPES ${CMAKE_CONFIGURATION_TYPES} Coverage )
if (${CMAKE_VERSION} VERSION_GREATER 2.8.2)
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS
                "Debug" "Release" "MinSizeRel" "RelWithDebInfo" "Coverage")
endif()

if(CMAKE_COMPILER_IS_GNUCXX)
  set(CMAKE_CXX_FLAGS_COVERAGE "${CMAKE_CXX_FLAGS_DEBUG} -fprofile-arcs -ftest-coverage")
  set(CMAKE_C_FLAGS_COVERAGE "${CMAKE_C_FLAGS_DEBUG} -fprofile-arcs -ftest-coverage")
  set(CMAKE_EXE_LINKER_FLAGS_COVERAGE "${CMAKE_EXE_LINKER_FLAGS} -fprofile-arcs -ftest-coverage")

  set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -Wno-long-long -std=iso9899:1990 -Wundef -Wcast-align -Werror-implicit-function-declaration -Wchar-subscripts -Wall -W -Wpointer-arith -Wwrite-strings -Wformat-security -Wmissing-format-attribute -fno-common")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wnon-virtual-dtor -Wno-long-long -ansi -Wundef -Wcast-align -Wchar-subscripts -Wall -W -Wpointer-arith -Wformat-security -fno-check-new -fno-common -pedantic-errors")

  if(NOT APPLE)
    set(CMAKE_SHARED_LINKER_FLAGS "-Wl,--fatal-warnings -Wl,--no-undefined ${CMAKE_SHARED_LINKER_FLAGS}")
    set(CMAKE_MODULE_LINKER_FLAGS "-Wl,--fatal-warnings -Wl,--no-undefined ${CMAKE_MODULE_LINKER_FLAGS}")
  endif()
endif()

# Tell FindQt4.cmake to point the QT_QTFOO_LIBRARY targets at the imported targets
# for the Qt libraries, so we get full handling of release and debug versions of the
# Qt libs and are flexible regarding the install location of Qt under Windows
set(QT_USE_IMPORTED_TARGETS TRUE)

add_definitions(-DQT_NO_CAST_TO_ASCII)
add_definitions(-DQT_NO_CAST_FROM_ASCII)
add_definitions(-DQT_STRICT_ITERATORS)
add_definitions(-DQT_NO_URL_CAST_FROM_STRING)
add_definitions(-DQT_NO_CAST_FROM_BYTEARRAY)
add_definitions(-DQT_NO_KEYWORDS)
add_definitions(-DQT_USE_FAST_CONCATENATION)
add_definitions(-DQT_USE_FAST_OPERATOR_PLUS)

# Always include the source and build directories in the include path
# to save doing so manually in every subdirectory.
set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_INCLUDE_DIRECTORIES_PROJECT_BEFORE ON)

set(CMAKE_AUTOMOC ON)

set(LIB_SUFFIX "" CACHE STRING "Define suffix of library directory name (eg. '64')")

set(LIB_INSTALL_DIR lib${LIB_SUFFIX} )
set(BIN_INSTALL_DIR bin )
set(INCLUDE_INSTALL_DIR include )
set(DATA_INSTALL_DIR share/apps )

set(LIBRARY_TYPE SHARED)

set(ECM_TARGET_DEFAULT_ARGS
  EXPORT ${PROJECT_NAME}LibraryTargets
  RUNTIME DESTINATION ${BIN_INSTALL_DIR} COMPONENT ${PROJECT_NAME}
  LIBRARY DESTINATION ${LIB_INSTALL_DIR} COMPONENT ${PROJECT_NAME}
  ARCHIVE DESTINATION ${LIB_INSTALL_DIR} COMPONENT ${PROJECT_NAME}
)

# set up RPATH/install_name_dir
set(CMAKE_INSTALL_NAME_DIR ${CMAKE_INSTALL_PREFIX}/${LIB_INSTALL_DIR})
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

set(CMAKECONFIG_INSTALL_DIR "${LIB_INSTALL_DIR}/cmake/${PROJECT_NAME}" )

file(RELATIVE_PATH relInstallDir ${CMAKE_INSTALL_PREFIX}/${CMAKECONFIG_INSTALL_DIR} ${CMAKE_INSTALL_PREFIX} )

configure_file(
  "${EXTRA_CMAKE_MODULES_MODULE_PATH}/ECMConfig.cmake.in"
  "${CMAKE_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
  @ONLY
)

include (WriteBasicConfigVersionFile)

write_basic_config_version_file("${CMAKE_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
  VERSION ${ECM_VERSION_MAJOR}.${ECM_VERSION_MINOR}.${ECM_VERSION_PATCH}
  COMPATIBILITY AnyNewerVersion
)

configure_file(
  "${EXTRA_CMAKE_MODULES_MODULE_PATH}/ECMQtUseFile.cmake.in"
  "${CMAKE_BINARY_DIR}/${PROJECT_NAME}Use.cmake"
  @ONLY
)

install(FILES
  "${CMAKE_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
  "${CMAKE_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
  DESTINATION "${CMAKECONFIG_INSTALL_DIR}"
  COMPONENT Devel
)

install(EXPORT ${PROJECT_NAME}LibraryTargets
  DESTINATION "${CMAKECONFIG_INSTALL_DIR}"
  FILE ${PROJECT_NAME}Targets.cmake
  COMPONENT Devel
)

install(FILES
  "${CMAKE_BINARY_DIR}/${PROJECT_NAME}Use.cmake"
  DESTINATION "${CMAKECONFIG_INSTALL_DIR}"
  COMPONENT Devel
)

STRING(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPER)

file(WRITE
  "${CMAKE_BINARY_DIR}/${PROJECT_NAME}_version.h"
  "#ifndef ${PROJECT_NAME_UPPER}_VERSION_H\n"
  "#define ${PROJECT_NAME_UPPER}_VERSION_H\n"
  "#define ${PROJECT_NAME_UPPER}_VERSION \"${ECM_VERSION_STRING}\"\n"
  "#endif\n"
)
