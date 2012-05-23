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
#
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
# 13) A version file is created called myspeciallib_version.h, which contains version information usable by
# the preprocessor. The version file must be installed by the user.
#
# 14) The FeatureSummary module is included.
#
# 15) The CMAKE_LINK_INTERFACE_LIBRARIES variable is set to empty. This means that the library targets created
# will have an empty link interface unless the LINK_INTERFACE_LIBRARIES or the LINK_PUBLIC keyword
# to target_link_libraries are used.

# We need to make sure this file is included before Qt found.
# Otherwise QT_USE_IMPORTED_TARGETS would have no effect.
# ### Temporarily disabled until KDE Frameworks includes this file before finding Qt.
# if (QT4_FOUND)
#   message(SEND_ERROR "This file must be included before finding the Qt package.")
# endif()


include(FeatureSummary)

# new in cmake 2.8.9: this is used for all installed files which do not have a component set
set(CMAKE_INSTALL_DEFAULT_COMPONENT_NAME "${PROJECT_NAME}")

set(ECM_TARGET_DEFAULT_ARGS
#   EXPORT ${PROJECT_NAME}LibraryTargets
  ${INSTALL_TARGETS_DEFAULT_ARGS}
)

set(CMAKECONFIG_INSTALL_DIR "${CMAKECONFIG_INSTALL_PREFIX}/${PROJECT_NAME}")


include(CMakePackageConfigHelpers)

configure_package_config_file(
  "${CMAKE_CURRENT_LIST_DIR}/ECMQtFrameworkConfig.cmake.in"
  "${CMAKE_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
  INSTALL_DESTINATION  ${CMAKECONFIG_INSTALL_DIR}
  PATH_VARS  INCLUDE_INSTALL_DIR LIB_INSTALL_DIR CMAKE_INSTALL_PREFIX
)

write_basic_package_version_file("${CMAKE_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
  VERSION ${ECM_VERSION_MAJOR}.${ECM_VERSION_MINOR}.${ECM_VERSION_PATCH}
  COMPATIBILITY AnyNewerVersion
)

install(FILES
  "${CMAKE_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
  "${CMAKE_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
  DESTINATION "${CMAKECONFIG_INSTALL_DIR}"
  COMPONENT Devel
)

# Disabled for now, as long as kdelibs is one big module
#install(EXPORT ${PROJECT_NAME}LibraryTargets
  #DESTINATION "${CMAKECONFIG_INSTALL_DIR}"
  #FILE ${PROJECT_NAME}Targets.cmake
  #COMPONENT Devel
#)

string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPER)

configure_file(
  "${CMAKE_CURRENT_LIST_DIR}/ECMVersionHeader.h.in"
  "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}_version.h"
)
