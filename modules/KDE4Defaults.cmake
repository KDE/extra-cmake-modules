
# support for Dart: http://public.kitware.com/dashboard.php?name=kde
enable_testing()
include(CTest)

# Always include srcdir and builddir in include path
set(CMAKE_INCLUDE_CURRENT_DIR ON)

# Use colors
set(CMAKE_COLOR_MAKEFILE ON)

