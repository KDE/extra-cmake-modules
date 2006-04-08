
# support for Dart: http://public.kitware.com/dashboard.php?name=kde
enable_testing()
include(CTest)

# Always include srcdir and builddir in include path
set(CMAKE_INCLUDE_CURRENT_DIR ON)

# Use colors
set(CMAKE_COLOR_MAKEFILE ON)

# define the generic version of the libraries here
# this makes it easy to advance it when the next release comes
set(GENERIC_LIB_VERSION "5.0.0")
set(GENERIC_LIB_SOVERSION "5")

