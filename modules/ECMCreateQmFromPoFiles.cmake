#  ecm_create_qm_from_po_files(PO_DIR <po_dir>
#                              POT_NAME <pot_name>
#                              [DATA_INSTALL_DIR <data_install_dir>]
#                              [DATA_INSTALL_SUB_DIR <data_install_sub_dir>]
#                              [CREATE_LOADER <source_file_var>])
#
# ecm_create_qm_from_po_files() creates the necessary rules to compile .po
# files into .qm files, usable by QTranslator. It can also generate a C++ file
# which takes care of automatically loading those translations.
#
# PO_DIR is the path to a directory containing .po files.
#
# POT_NAME is the name of the .pot file for the project. This file must be in
# PO_DIR.
#
# .qm files are installed in "DATA_INSTALL_DIR/DATA_INSTALL_SUB_DIR".
#
# DATA_INSTALL_DIR defaults to ${DATA_INSTALL_DIR} if defined, otherwise it uses
# "share". It must point to a directory which is in the list returned by:
#
#     QStandardPath::standardLocations(QStandardPath::GenericDataLocation)
#
# otherwise the C++ loader will fail to load the translations.
#
# DATA_INSTALL_SUB_DIR defaults to the value of POT_NAME, without the ".pot"
# extension.
#
# ecm_create_qm_from_po_files() creates a "translation" target. This target
# builds all .po files into .qm files.
#
# If ecm_create_qm_from_po_files() is called with the CREATE_LOADER argument,
# it generates a C++ file which ensures translations are automatically loaded
# at startup. The path of the .cpp file is stored in <source_file_var>. This
# variable must be added to the list of sources to build, like this:
#
#   ecm_create_qm_from_po_files(PO_DIR po POT_NAME mylib CREATE_LOADER myloader)
#   set(mylib_SRCS foo.cpp bar.cpp ${myloader})
#   add_library(mylib ${mylib_SRCS})
#
# Copyright (c) 2014, Aurélien Gâteau, <agateau@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

# This gives us Qt5::lrelease and Qt5::lupdate but unfortunately no Qt5::lconvert
# See https://bugreports.qt-project.org/browse/QTBUG-37937
find_package(Qt5LinguistTools CONFIG REQUIRED)

function(_ecm_qm_create_target po_dir pot_name data_install_dir data_install_sub_dir)
    # Find lconvert
    get_target_property(lrelease_location Qt5::lrelease LOCATION)
    get_filename_component(lrelease_path ${lrelease_location} PATH)
    find_program(lconvert_executable
        NAMES lconvert-qt5 lconvert
        PATHS ${lrelease_path}
        )

    file(GLOB po_files "${po_dir}/*.po")
    foreach (it ${po_files})
        # PO files are foo-en_GB.po not foo_en_GB.po like Qt expects. Get a
        # proper filename.
        get_filename_component(it ${it} ABSOLUTE)
        get_filename_component(file_with_dash ${it} NAME_WE)
        string(REPLACE "-" "_" filename_base "${file_with_dash}")

        file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})
        set(tsfile ${CMAKE_CURRENT_BINARY_DIR}/${filename_base}.ts)
        set(qmfile ${CMAKE_CURRENT_BINARY_DIR}/${filename_base}.qm)

        # lconvert from .po to .ts and then run lupdate to generate the correct
        # strings. Finally run lrelease to create the .qm files.
        add_custom_command(OUTPUT ${qmfile}
            COMMAND ${lconvert_executable}
                ARGS -i ${it} -o ${tsfile}
            COMMAND Qt5::lupdate
                ARGS ${CMAKE_SOURCE_DIR}/src -silent -noobsolete -ts ${tsfile}
            COMMAND Qt5::lrelease
                ARGS -compress -removeidentical -silent ${tsfile} -qm ${qmfile}
            DEPENDS ${it}
            )
        set(qmfiles ${qmfiles} ${qmfile})
    endforeach()

    if(NOT TARGET translations)
        add_custom_target(translations ALL)
    endif()
    add_custom_target(translations-${pot_name} DEPENDS ${qmfiles})
    add_dependencies(translations translations-${pot_name})

    install(FILES ${qmfiles} DESTINATION ${data_install_dir}/${data_install_sub_dir})
endfunction()

function(_ecm_qm_create_loader pot_name data_install_sub_dir)
    # data_install_sub_dir is used in ECMQmLoader.cpp.in
    get_filename_component(qm_name ${pot_name} NAME_WE)
    configure_file(${ECM_MODULE_DIR}/ECMQmLoader.cpp.in ECMQmLoader.cpp @ONLY)
endfunction()

function(ECM_CREATE_QM_FROM_PO_FILES)
    set(options)
    set(oneValueArgs PO_DIR POT_NAME DATA_INSTALL_DIR DATA_INSTALL_SUB_DIR CREATE_LOADER)
    set(multiValueArgs)
    cmake_parse_arguments(ARGS "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if(ARGS_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Unknown keywords given to ECM_CREATE_QM_FROM_PO_FILES(): \"${ARGS_UNPARSED_ARGUMENTS}\"")
    endif()

    if(NOT ARGS_PO_DIR)
        message(FATAL_ERROR "Required argument PO_DIR missing in ECM_CREATE_QM_FROM_PO_FILES() call")
    endif()

    if(NOT ARGS_POT_NAME)
        message(FATAL_ERROR "Required argument POT_NAME missing in ECM_CREATE_QM_FROM_PO_FILES() call")
    endif()

    if(NOT ARGS_DATA_INSTALL_DIR)
        if (DATA_INSTALL_DIR)
            set(ARGS_DATA_INSTALL_DIR ${DATA_INSTALL_DIR})
        else()
            set(ARGS_DATA_INSTALL_DIR share)
        endif()
    endif()
    if(NOT ARGS_DATA_INSTALL_SUB_DIR)
        get_filename_component(ARGS_DATA_INSTALL_SUB_DIR "${ARGS_POT_NAME}" NAME_WE)
    endif()

    _ecm_qm_create_target(${ARGS_PO_DIR} ${ARGS_POT_NAME} ${ARGS_DATA_INSTALL_DIR} ${ARGS_DATA_INSTALL_SUB_DIR})
    if (ARGS_CREATE_LOADER)
        _ecm_qm_create_loader(${ARGS_POT_NAME} ${ARGS_DATA_INSTALL_SUB_DIR})
        set(${ARGS_CREATE_LOADER} ${CMAKE_CURRENT_BINARY_DIR}/ECMQmLoader.cpp PARENT_SCOPE)
    endif()
endfunction()
