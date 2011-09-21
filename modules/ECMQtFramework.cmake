#- Automatic configuration of a project as a Qt framework.
#
# This module can be used to simplify creation of quality frameworks written in Qt.
# It sets compiler flags, Qt definitions and CMake options which make sense to use when creating
# A Qt based framework.
#
#  project(myspeciallib)
#  ecm_framework_version(5 0 0)
#  include(ECMQtFramework)
#
# This will set myspeciallib to be a Qt framework, that is, the name of the project is
# relevant and used (see below). The version of the project is 5.0.0. It is important to
# include ECMQtFramework before finding Qt itself.
#
# Specifically being an ECM Qt framework means:
#
# 1) The compiler is configured with export flags. With GCC and clang, this means enabling
# the -hidden-visibility flags. See the GenerateExportHeader module for more on generating
# and installing export headers.
#
# 2) A Coverage build type is created and made available in the cmake-gui. This means that
# running
#
#  cmake $SRCDIR -DCMAKE_BUILD_TYPE=Coverage
#
# Will enable the use of the -fprofile-arcs -ftest-coverage flags on GCC. The Coverage type is also
# available through the cmake-gui program.
#
# 3) Sensible compiler warnings are enabled. These are the flags determined to be useful through
# a history in KDE buildsystem.
#
# 4) Qt build flags are defined.
# These include

# * Disabling automatic ascii casts provided by Qt (so for example QLatin1String must be used). This is
# relevant to prevent encoding errors, and makes conversion to QString potentially faster or avoidable.
#
# * Disabling Qt keywords such as signals and slots so that Q_SIGNALS and Q_SLOTS must be used instead. This
# is relevant if using the framework together with boost signals.
#
# * Enabling the use of fast concatenation. This makes it possible to create strings from multiple pieces
# with one memory allocation.
#
# 5) CMake will use imported targets for Qt. This is relevant on windows because it is easier
# to build both debug and release versions of the framework.
#
# 6) CMake will include the current source and binary directories automatically while preprocessing. The
# source and binary directories of the current project will be used before others.
#
# 7) CMake will use built in automatic moc support.
#
# 8) A LIB_SUFFIX variable is made available. This is used to install libraries optionally
# to for example /lib64 instead of /lib
#
# 9) The ECM_TARGET_DEFAULT_ARGS variable is made available for use by targets in the framework. This is
# used in install(TARGETS) calls to install components of targets to the configured binary and library directories,
# to create an export target for the framework, and to put them in a component for use with CPack. The name of the
# component is the same as the argument to the project call (myspeciallib above).
#
# 10) The use of RPATH is enabled. (TODO RUNPATH?)
#
# 11) A CMake config file and config version are created and installed. The config file uses the project name so that:
#
# * The file is called myspeciallibConfig.cmake. A companion file myspeciallibVersionConfig is also created.
#
# * The variables myspeciallib_VERSION_MAJOR, myspeciallib_VERSION_MINOR, myspeciallib_VERSION_PATCH are defined
# as specified by the use of ecm_framework_version.
#
# * Standard variables are set for linking to the library and including the directories of its headers.
#
# 12) The targets file is installed. This means that myspeciallib can be used as an imported target.
#
# 13) A USE file is installed. This means that consumers of myspeciallib can
#
#  include(${myspeciallib_USE_FILE})
#
# which will include the Qt USE file, and add the header directories for myspeciallib to include_directories()
#
# 14) A version file is created called myspeciallib_version.h, which contains version information usable by
# the preprocessor. The version file must be installed by the user.
#
# 15) The FeatureSummary module is included.

# We need to make sure this file is included before Qt found.
# Otherwise QT_USE_IMPORTED_TARGETS would have no effect.
# ### Temporarily disabled until KDE Frameworks includes this file before finding Qt.
# if (QT4_FOUND)
#   message(SEND_ERROR "This file must be included before finding the Qt package.")
# endif()


include(FeatureSummary)
include(GenerateExportHeader)

add_compiler_export_flags()

# create coverage build type
set(CMAKE_CONFIGURATION_TYPES ${CMAKE_CONFIGURATION_TYPES} Coverage)
if(${CMAKE_VERSION} VERSION_GREATER 2.8.2)
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

add_definitions(-DQT_NO_CAST_TO_ASCII)
add_definitions(-DQT_NO_CAST_FROM_ASCII)
add_definitions(-DQT_STRICT_ITERATORS)
add_definitions(-DQT_NO_URL_CAST_FROM_STRING)
add_definitions(-DQT_NO_CAST_FROM_BYTEARRAY)
add_definitions(-DQT_NO_KEYWORDS)
add_definitions(-DQT_USE_FAST_CONCATENATION)
add_definitions(-DQT_USE_FAST_OPERATOR_PLUS)


# Tell FindQt4.cmake to point the QT_QTFOO_LIBRARY targets at the imported targets
# for the Qt libraries, so we get full handling of release and debug versions of the
# Qt libs and are flexible regarding the install location of Qt under Windows
set(QT_USE_IMPORTED_TARGETS TRUE)

# Always include the source and build directories in the include path
# to save doing so manually in every subdirectory.
set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_INCLUDE_DIRECTORIES_PROJECT_BEFORE ON)

set(CMAKE_AUTOMOC ON)

set(LIB_SUFFIX "" CACHE STRING "Define suffix of library directory name (eg. '64')")

set(LIB_INSTALL_DIR lib${LIB_SUFFIX})
set(BIN_INSTALL_DIR bin)
set(INCLUDE_INSTALL_DIR include)
set(DATA_INSTALL_DIR share/apps)

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

set(CMAKECONFIG_INSTALL_DIR "${LIB_INSTALL_DIR}/cmake/${PROJECT_NAME}")

file(RELATIVE_PATH relInstallDir ${CMAKE_INSTALL_PREFIX}/${CMAKECONFIG_INSTALL_DIR} ${CMAKE_INSTALL_PREFIX})

configure_file(
  "${EXTRA_CMAKE_MODULES_MODULE_PATH}/ECMConfig.cmake.in"
  "${CMAKE_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
  @ONLY
)

include(WriteBasicConfigVersionFile)

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

string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPER)

configure_file(
  "${EXTRA_CMAKE_MODULES_MODULE_PATH}/ECMVersionHeader.h.in"
  "${CMAKE_BINARY_DIR}/${PROJECT_NAME}_version.h"
)
