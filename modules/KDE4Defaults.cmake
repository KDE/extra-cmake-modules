
enable_testing()

# support for Dart: http://public.kitware.com/dashboard.php?name=kde
if (EXISTS ${CMAKE_SOURCE_DIR}/CTestConfig.cmake)
   include(CTest)
endif (EXISTS ${CMAKE_SOURCE_DIR}/CTestConfig.cmake)

# Always include srcdir and builddir in include path
# This saves typing ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_BINARY} in about every subdir
# since cmake 2.4.0
set(CMAKE_INCLUDE_CURRENT_DIR ON)

# put the include dirs which are in the source or build tree
# before all other include dirs, so the headers in the sources
# are prefered over the already installed ones
# since cmake 2.4.1
set(CMAKE_INCLUDE_DIRECTORIES_PROJECT_BEFORE ON)

# Use colored output
# since cmake 2.4.0
set(CMAKE_COLOR_MAKEFILE ON)

# define the generic version of the libraries here
# this makes it easy to advance it when the next KDE release comes
set(GENERIC_LIB_VERSION "4.0.0")
set(GENERIC_LIB_SOVERSION "4")

