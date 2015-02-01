#.rst:
# ECMCoverageOption
# --------------------
#
# Creates a BUILD_COVERAGE option, so the project can be built with code coverage
# support.
#
# ::
#
#   BUILD_COVERAGE
#
# If it's on, the project will be compiled with code coverage support, using
# gcov. Otherwise, it will be built normally.

#=============================================================================
# Copyright 2014 Aleix Pol Gonzalez <aleixpol@kde.org>
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file COPYING-CMAKE-SCRIPTS for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# (To distribute this file outside of extra-cmake-modules, substitute the full
#  License text for the above reference.)

option(BUILD_COVERAGE "Build the project with gcov support" OFF)

if(BUILD_COVERAGE)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fprofile-arcs -ftest-coverage")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -lgcov")
endif()
