#=============================================================================
# CMake - Cross Platform Makefile Generator
# Copyright 2000-2013 Kitware, Inc., Insight Software Consortium
# Copyright 2014 Alex Merry <alex.merry@kde.org>
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================

# Distros sometimes rename Python executables to allow for parallel
# installation of Python2 and Python3 versions
message(STATUS "Looking for Sphinx Documentation Builder...")
find_program(SPHINX_EXECUTABLE
    NAMES
        sphinx-build
        sphinx-build2
        sphinx-build3
    DOC "Sphinx Documentation Builder (http://sphinx-doc.org/)"
)
if(SPHINX_EXECUTABLE)
    message(STATUS "Sphinx Documentation Builder found at ${SPHINX_EXECUTABLE} - building documentation")
    set(build_docs_default ON)
else()
    message(STATUS "Sphinx Documentation Builder not found - documentation will not be built (see http://sphinx-doc.org/)")
    set(build_docs_default OFF)
endif()

option(BUILD_HTML_DOCS "Build html help with Sphinx" ${build_docs_default})
option(BUILD_MAN_DOCS "Build man pages with Sphinx" ${build_docs_default})
option(BUILD_QTHELP_DOCS "Build Qt help with Sphinx" OFF)

if(NOT BUILD_HTML_DOCS AND NOT BUILD_MAN_DOCS AND NOT BUILD_QTHELP_DOCS)
    return()
elseif(NOT SPHINX_EXECUTABLE)
    message(FATAL_ERROR "SPHINX_EXECUTABLE (sphinx-build) was not found!")
endif()

# the docs/ directory
set(conf_docs "${CMAKE_CURRENT_SOURCE_DIR}")
# where cmake.py and other sphinx files are
set(conf_path "${CMAKE_CURRENT_SOURCE_DIR}/sphinx")
set(conf_version "${extra-cmake-modules_VERSION_MAJOR}.${extra-cmake-modules_VERSION_MINOR}.${extra-cmake-modules_VERSION_PATCH}")
set(conf_release "${extra-cmake-modules_VERSION}")
configure_file(sphinx/conf.py.in conf.py @ONLY)

set(doc_formats "")
if(BUILD_HTML_DOCS)
    list(APPEND doc_formats html)
endif()
if(BUILD_MAN_DOCS)
    list(APPEND doc_formats man)
endif()
if(BUILD_QTHELP_DOCS)
    find_program(QCOLLECTIONGENERATOR_EXECUTABLE
        NAMES qcollectiongenerator
        DOC "qcollectiongenerator tool"
    )
    if (NOT QCOLLECTIONGENERATOR_EXECUTABLE)
        message(FATAL_ERROR "QCOLLECTIONGENERATOR_EXECUTABLE (qcollectiongenerator) not found!")
    endif()
    list(APPEND doc_formats qthelp)

    set(qthelp_extra_commands
        COMMAND
            qcollectiongenerator
            ${CMAKE_CURRENT_BINARY_DIR}/qthelp/extra-cmake-modules.qhcp
    )
endif()


set(doc_format_outputs "")
set(doc_format_last "")
foreach(format ${doc_formats})
    set(doc_format_output "doc_format_${format}")
    set(doc_format_log "build-${format}.log")
    add_custom_command(
        OUTPUT ${doc_format_output}
        COMMAND
            ${SPHINX_EXECUTABLE}
            -c ${CMAKE_CURRENT_BINARY_DIR}
            -d ${CMAKE_CURRENT_BINARY_DIR}/doctrees
            -b ${format}
            ${CMAKE_CURRENT_SOURCE_DIR}
            ${CMAKE_CURRENT_BINARY_DIR}/${format}
            > ${doc_format_log} # log stdout, pass stderr
        DEPENDS ${doc_format_last}
        COMMENT "sphinx-build ${format}: see ${CMAKE_CURRENT_BINARY_DIR}/${doc_format_log}"
        VERBATIM
    )
    set_property(SOURCE ${doc_format_output} PROPERTY SYMBOLIC 1)
    list(APPEND doc_format_outputs ${doc_format_output})
    set(doc_format_last ${doc_format_output})
endforeach()

add_custom_target(documentation ALL DEPENDS ${doc_format_outputs})

if(BUILD_MAN_DOCS)
    file(GLOB man_rst RELATIVE ${extra-cmake-modules_SOURCE_DIR}/docs/manual
    ${extra-cmake-modules_SOURCE_DIR}/docs/manual/*.[1-9].rst)
    foreach(m ${man_rst})
        if("x${m}" MATCHES "^x(.+)\\.([1-9])\\.rst$")
            set(name "${CMAKE_MATCH_1}")
            set(sec "${CMAKE_MATCH_2}")
            install(
                FILES ${CMAKE_CURRENT_BINARY_DIR}/man/${name}.${sec}
                DESTINATION ${MAN_INSTALL_DIR}/man${sec}
            )
        endif()
    endforeach()
endif()
if(BUILD_HTML_DOCS)
    install(
        DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/html
        DESTINATION ${DOC_INSTALL_DIR}
        PATTERN .buildinfo EXCLUDE
        PATTERN objects.inv EXCLUDE
    )
endif()
if(BUILD_QTHELP_DOCS)
    install(
        FILES ${CMAKE_CURRENT_BINARY_DIR}/qthelp/extra-cmake-modules.qch
        DESTINATION ${DOC_INSTALL_DIR}
    )
endif()
