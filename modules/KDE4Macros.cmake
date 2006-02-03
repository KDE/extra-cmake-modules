# this file contains the following macros:
# KDE4_ADD_FILE_DEPENDANCY
# KDE4_ADD_DCOP_SKELS
# KDE4_ADD_DCOP_STUBS
# KDE4_ADD_MOC_FILES
# KDE4_ADD_UI_FILES
# KDE4_ADD_KCFG_FILES
# KDE4_AUTOMOC
# KDE4_CREATE_LIBTOOL_FILE
# KDE4_PLACEHOLDER
# KDE4_CREATE_FINAL_FILE
# KDE4_ADD_KPART
# KDE4_ADD_KLM
# KDE4_ADD_EXECUTABLE


#neundorf@kde.org

#this should better be part of cmake:
#add an additional file to the list of files a source file depends on
MACRO(KDE4_ADD_FILE_DEPENDANCY file)

   GET_SOURCE_FILE_PROPERTY(_deps ${file} OBJECT_DEPENDS)
   IF (_deps)
      SET(_deps ${_deps} ${ARGN})
   ELSE (_deps)
      SET(_deps ${ARGN})
   ENDIF (_deps)

   SET_SOURCE_FILES_PROPERTIES(${file} PROPERTIES OBJECT_DEPENDS "${_deps}")

ENDMACRO(KDE4_ADD_FILE_DEPENDANCY)


#create the kidl and skeletion file for dcop stuff
#usage: KDE_ADD_COP_SKELS(foo_SRCS ${dcop_headers})
MACRO(KDE4_ADD_DCOP_SKELS _sources)
   FOREACH (_current_FILE ${ARGN})

      QT4_GET_ABS_PATH(_tmp_FILE ${_current_FILE})

      GET_FILENAME_COMPONENT(_basename ${_tmp_FILE} NAME_WE)

      SET(_skel ${CMAKE_CURRENT_BINARY_DIR}/${_basename}_skel.cpp)
      SET(_kidl ${CMAKE_CURRENT_BINARY_DIR}/${_basename}.kidl)

      IF (NOT HAVE_${_basename}_KIDL_RULE)
        SET(HAVE_${_basename}_KIDL_RULE ON)

        ADD_CUSTOM_COMMAND(OUTPUT ${_kidl}
           COMMAND ${KDE4_DCOPIDL_EXECUTABLE}
           ARGS --srcdir ${KDE4_KALYPTUS_DIR} ${_tmp_FILE} > ${_kidl}
           DEPENDS ${_tmp_FILE}
        )
      ENDIF (NOT HAVE_${_basename}_KIDL_RULE)

      IF (NOT HAVE_${_basename}_SKEL_RULE)
        SET(HAVE_${_basename}_SKEL_RULE ON)

        ADD_CUSTOM_COMMAND(OUTPUT ${_skel}
           COMMAND ${KDE4_DCOPIDL2CPP_EXECUTABLE}
           ARGS --c++-suffix cpp --no-signals --no-stub ${_kidl}
           DEPENDS ${_kidl}
        )

      ENDIF (NOT HAVE_${_basename}_SKEL_RULE)

      SET(${_sources} ${${_sources}} ${_skel})

   ENDFOREACH (_current_FILE)

ENDMACRO(KDE4_ADD_DCOP_SKELS)

MACRO(KDE4_ADD_DCOP_STUBS _sources)
   FOREACH (_current_FILE ${ARGN})

      QT4_GET_ABS_PATH(_tmp_FILE ${_current_FILE})

      GET_FILENAME_COMPONENT(_basename ${_tmp_FILE} NAME_WE)

      SET(_stub_CPP ${CMAKE_CURRENT_BINARY_DIR}/${_basename}_stub.cpp)
#     SET(_stub_H ${CMAKE_CURRENT_BINARY_DIR}/${_basename}_stub.h)
      SET(_kidl ${CMAKE_CURRENT_BINARY_DIR}/${_basename}.kidl)


      IF (NOT HAVE_${_basename}_KIDL_RULE)
        SET(HAVE_${_basename}_KIDL_RULE ON)

        ADD_CUSTOM_COMMAND(OUTPUT ${_kidl}
           COMMAND ${KDE4_DCOPIDL_EXECUTABLE}
           ARGS --srcdir ${KDE4_KALYPTUS_DIR} ${_tmp_FILE} > ${_kidl}
           DEPENDS ${_tmp_FILE}
        )
      ENDIF (NOT HAVE_${_basename}_KIDL_RULE)

      IF (NOT HAVE_${_basename}_STUB_RULE)
        SET(HAVE_${_basename}_STUB_RULE ON)

        ADD_CUSTOM_COMMAND(OUTPUT ${_stub_CPP}
           COMMAND ${KDE4_DCOPIDL2CPP_EXECUTABLE}
           ARGS --c++-suffix cpp --no-signals --no-skel ${_kidl}
           DEPENDS ${_kidl}
        )
      ENDIF (NOT HAVE_${_basename}_STUB_RULE)

      SET(${_sources} ${${_sources}} ${_stub_CPP})

   ENDFOREACH (_current_FILE)

ENDMACRO(KDE4_ADD_DCOP_STUBS)

MACRO(KDE4_ADD_KCFG_FILES _sources)
   FOREACH (_current_FILE ${ARGN})

      QT4_GET_ABS_PATH(_tmp_FILE ${_current_FILE})

      GET_FILENAME_COMPONENT(_basename ${_tmp_FILE} NAME_WE)

      FILE(READ ${_tmp_FILE} _contents)
      STRING(REGEX REPLACE "^(.*\n)?File=([^\n]+)\n.*$" "\\2"  _kcfg_FILE "${_contents}")

      SET(_src_FILE    ${CMAKE_CURRENT_BINARY_DIR}/${_basename}.cpp)
      SET(_header_FILE ${CMAKE_CURRENT_BINARY_DIR}/${_basename}.h)

      ADD_CUSTOM_COMMAND(OUTPUT ${_src_FILE}
         COMMAND ${KDE4_KCFGC_EXECUTABLE}
         ARGS ${CMAKE_CURRENT_SOURCE_DIR}/${_kcfg_FILE} ${_tmp_FILE}
         DEPENDS ${_tmp_FILE} ${CMAKE_CURRENT_SOURCE_DIR}/${_kcfg_FILE} )

      SET(${_sources} ${${_sources}} ${_src_FILE})

   ENDFOREACH (_current_FILE)

ENDMACRO(KDE4_ADD_KCFG_FILES)


#create the moc files and add them to the list of sources
#usage: KDE_ADD_MOC_FILES(foo_SRCS ${moc_headers})
#MACRO(KDE4_ADD_MOC_FILES _sources)
#   FOREACH (_current_FILE ${ARGN})
#      GET_FILENAME_COMPONENT(_basename ${_current_FILE} NAME_WE)
#      GET_FILENAME_COMPONENT(_path ${_current_FILE} PATH)
#      SET(_moc ${CMAKE_CURRENT_BINARY_DIR}/${_basename}.moc.cpp)

#      ADD_CUSTOM_COMMAND(OUTPUT ${_moc}
#         COMMAND ${QT_MOC_EXECUTABLE}
#         ARGS ${CMAKE_CURRENT_SOURCE_DIR}/${_current_FILE} -o ${_moc}
#         DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/${_current_FILE}
#      )
#      SET(${_sources} ${${_sources}} ${_moc})
#   ENDFOREACH (_current_FILE)
#ENDMACRO(KDE4_ADD_MOC_FILES)

IF(EXISTS "${CMAKE_ROOT}/Modules/kde4init_dummy.cpp.in")
   SET(KDE4_MODULE_DIR "${CMAKE_ROOT}/Modules")
ELSE(EXISTS "${CMAKE_ROOT}/Modules/kde4init_dummy.cpp.in")
   SET(KDE4_MODULE_DIR "${CMAKE_SOURCE_DIR}/cmake/modules")
ENDIF(EXISTS "${CMAKE_ROOT}/Modules/kde4init_dummy.cpp.in")


#create the implementation files from the ui files and add them to the list of sources
#usage: KDE_ADD_UI_FILES(foo_SRCS ${ui_files})
MACRO(KDE4_ADD_UI_FILES _sources )
   FOREACH (_current_FILE ${ARGN})

      QT4_GET_ABS_PATH(_tmp_FILE ${_current_FILE})

      GET_FILENAME_COMPONENT(_basename ${_tmp_FILE} NAME_WE)
      SET(_header ${CMAKE_CURRENT_BINARY_DIR}/${_basename}.h)

      # we need to run uic and replace some things in the generated file
      # this is done by executing the cmake script kde4uic.cmake
      ADD_CUSTOM_COMMAND(OUTPUT ${_header}
         COMMAND ${CMAKE_COMMAND}
         ARGS
         -DKDE4_HEADER:BOOL=ON
         -DKDE_UIC_EXECUTABLE:FILEPATH=${QT_UIC_EXECUTABLE}
         -DKDE_UIC_FILE:FILEPATH=${_tmp_FILE}
         -DKDE_UIC_H_FILE:FILEPATH=${_header}
         -DKDE_UIC_BASENAME:STRING=${_basename}
         -P ${KDE4_MODULE_DIR}/kde4uic.cmake
         DEPENDS ${_tmp_FILE}
      )
   ENDFOREACH (_current_FILE)
ENDMACRO(KDE4_ADD_UI_FILES)

#create the implementation files from the ui files and add them to the list of sources
#usage: KDE_ADD_UI_FILES(foo_SRCS ${ui_files})
MACRO(KDE4_ADD_UI3_FILES _sources )

   QT4_GET_MOC_INC_DIRS(_moc_INCS)

   FOREACH (_current_FILE ${ARGN})

      QT4_GET_ABS_PATH(_tmp_FILE ${_current_FILE})

      GET_FILENAME_COMPONENT(_basename ${_tmp_FILE} NAME_WE)
      SET(_header ${CMAKE_CURRENT_BINARY_DIR}/${_basename}.h)
      SET(_src ${CMAKE_CURRENT_BINARY_DIR}/${_basename}.cpp)
      SET(_moc ${CMAKE_CURRENT_BINARY_DIR}/${_basename}.moc.cpp)

#      ADD_CUSTOM_COMMAND(OUTPUT ${_header}
#         COMMAND ${QT_UIC3_EXECUTABLE}
#         ARGS  -nounload -o ${_header} ${_tmp_FILE}
#         DEPENDS ${_tmp_FILE}
#      )

      ADD_CUSTOM_COMMAND(OUTPUT ${_header}
         COMMAND ${CMAKE_COMMAND}
         -DKDE3_HEADER:BOOL=ON
         -DKDE_UIC_EXECUTABLE:FILEPATH=${QT_UIC3_EXECUTABLE}
         -DKDE_UIC_FILE:FILEPATH=${_tmp_FILE}
         -DKDE_UIC_H_FILE:FILEPATH=${_header}
         -DKDE_UIC_BASENAME:STRING=${_basename}
         -DKDE_UIC_PLUGIN_DIR:FILEPATH="."
         -P ${KDE4_MODULE_DIR}/kde4uic.cmake
         DEPENDS ${_tmp_FILE}
      )

# we need to run uic3 and replace some things in the generated file
      # this is done by executing the cmake script kde4uic.cmake
      ADD_CUSTOM_COMMAND(OUTPUT ${_src}
         COMMAND ${CMAKE_COMMAND}
         ARGS
         -DKDE3_IMPL:BOOL=ON
         -DKDE_UIC_EXECUTABLE:FILEPATH=${QT_UIC3_EXECUTABLE}
         -DKDE_UIC_FILE:FILEPATH=${_tmp_FILE}
         -DKDE_UIC_CPP_FILE:FILEPATH=${_src}
         -DKDE_UIC_H_FILE:FILEPATH=${_header}
         -DKDE_UIC_BASENAME:STRING=${_basename}
         -DKDE_UIC_PLUGIN_DIR:FILEPATH="."
         -P ${KDE4_MODULE_DIR}/kde4uic.cmake
         DEPENDS ${_header}
      )

      ADD_CUSTOM_COMMAND(OUTPUT ${_moc}
         COMMAND ${QT_MOC_EXECUTABLE}
         ARGS ${_moc_INCS} ${_header} -o ${_moc}
         DEPENDS ${_header}
      )
      SET(${_sources} ${${_sources}} ${_src} ${_moc} )

   ENDFOREACH (_current_FILE)
ENDMACRO(KDE4_ADD_UI3_FILES)


MACRO(KDE4_AUTOMOC)
   QT4_GET_MOC_INC_DIRS(_moc_INCS)

   SET(_matching_FILES )
   FOREACH (_current_FILE ${ARGN})

      QT4_GET_ABS_PATH(_tmp_FILE ${_current_FILE})

      IF (EXISTS ${_tmp_FILE})

         FILE(READ ${_tmp_FILE} _contents)

         GET_FILENAME_COMPONENT(_abs_FILE ${_tmp_FILE} ABSOLUTE)
         GET_FILENAME_COMPONENT(_abs_PATH ${_abs_FILE} PATH)

         STRING(REGEX MATCHALL "#include +[^ ]+\\.moc[\">]" _match "${_contents}")
         IF(_match)
            FOREACH (_current_MOC_INC ${_match})
               STRING(REGEX MATCH "[^ <\"]+\\.moc" _current_MOC "${_current_MOC_INC}")

               GET_FILENAME_COMPONENT(_basename ${_current_MOC} NAME_WE)
#               SET(_header ${CMAKE_CURRENT_SOURCE_DIR}/${_basename}.h)
               SET(_header ${_abs_PATH}/${_basename}.h)
               SET(_moc    ${CMAKE_CURRENT_BINARY_DIR}/${_current_MOC})
               ADD_CUSTOM_COMMAND(OUTPUT ${_moc}
                  COMMAND ${QT_MOC_EXECUTABLE}
                  ARGS ${_moc_INCS} ${_header} -o ${_moc}
                  DEPENDS ${_header}
               )

               KDE4_ADD_FILE_DEPENDANCY(${_tmp_FILE} ${_moc})

            ENDFOREACH (_current_MOC_INC)
         ENDIF(_match)

      ENDIF (EXISTS ${_tmp_FILE})
   ENDFOREACH (_current_FILE)
ENDMACRO(KDE4_AUTOMOC)

MACRO(KDE4_INSTALL_ICONS _theme)
   ADD_CUSTOM_TARGET(install_icons )
   SET_TARGET_PROPERTIES(install_icons PROPERTIES POST_INSTALL_SCRIPT ${CMAKE_CURRENT_BINARY_DIR}/install_icons.cmake )
   FILE(WRITE ${CMAKE_CURRENT_BINARY_DIR}/install_icons.cmake "# icon installations rules\n")
   FILE(APPEND ${CMAKE_CURRENT_BINARY_DIR}/install_icons.cmake "SET(CMAKE_BACKWARDS_COMPATIBILITY \"2.2\") \n")

   FILE(GLOB _icons *.png)
   FOREACH(_current_ICON ${_icons} )
      STRING(REGEX REPLACE "^.*/[a-zA-Z]+([0-9]+)\\-([a-z]+)\\-(.+\\.png)$" "\\1" _size "${_current_ICON}")
      STRING(REGEX REPLACE "^.*/[a-zA-Z]+([0-9]+)\\-([a-z]+)\\-(.+\\.png)$" "\\2" _group "${_current_ICON}")
      STRING(REGEX REPLACE "^.*/[a-zA-Z]+([0-9]+)\\-([a-z]+)\\-(.+\\.png)$" "\\3" _name "${_current_ICON}")

      SET(_icon_GROUP "actions")

      IF(${_group} STREQUAL "mime")
         SET(_icon_GROUP  "mimetypes")
      ENDIF(${_group} STREQUAL "mime")

      IF(${_group} STREQUAL "filesys")
         SET(_icon_GROUP  "filesystems")
      ENDIF(${_group} STREQUAL "filesys")

      IF(${_group} STREQUAL "device")
         SET(_icon_GROUP  "devices")
      ENDIF(${_group} STREQUAL "device")

      IF(${_group} STREQUAL "app")
         SET(_icon_GROUP  "apps")
      ENDIF(${_group} STREQUAL "app")

      IF(${_group} STREQUAL "action")
         SET(_icon_GROUP  "actions")
      ENDIF(${_group} STREQUAL "action")

#      MESSAGE(STATUS "icon: ${_current_ICON} size: ${_size} group: ${_group} name: ${_name}" )
      SET(_ICON_INSTALL_NAME ${CMAKE_INSTALL_PREFIX}/share/icons/${_theme}/${_size}x${_size}/${_icon_GROUP}/${_name})
      FILE(APPEND ${CMAKE_CURRENT_BINARY_DIR}/install_icons.cmake "MESSAGE(STATUS \"Installing ${_ICON_INSTALL_NAME}\") \n")
      FILE(APPEND ${CMAKE_CURRENT_BINARY_DIR}/install_icons.cmake "CONFIGURE_FILE( ${_current_ICON} ${_ICON_INSTALL_NAME} COPYONLY) \n")

   ENDFOREACH (_current_ICON)
   FILE(GLOB _icons *.svgz)
   FOREACH(_current_ICON ${_icons} )
      STRING(REGEX REPLACE "^.*/crsc\\-([a-z]+)\\-(.+\\.svgz)$" "\\1" _group "${_current_ICON}")
      STRING(REGEX REPLACE "^.*/crsc\\-([a-z]+)\\-(.+\\.svgz)$" "\\2" _name "${_current_ICON}")

      SET(_icon_GROUP "actions")

      IF(${_group} STREQUAL "mime")
         SET(_icon_GROUP  "mimetypes")
      ENDIF(${_group} STREQUAL "mime")

      IF(${_group} STREQUAL "filesys")
         SET(_icon_GROUP  "filesystems")
      ENDIF(${_group} STREQUAL "filesys")

      IF(${_group} STREQUAL "device")
         SET(_icon_GROUP  "devices")
      ENDIF(${_group} STREQUAL "device")

      IF(${_group} STREQUAL "app")
         SET(_icon_GROUP  "apps")
      ENDIF(${_group} STREQUAL "app")

      IF(${_group} STREQUAL "action")
         SET(_icon_GROUP  "actions")
      ENDIF(${_group} STREQUAL "action")

      SET(_ICON_INSTALL_NAME ${CMAKE_INSTALL_PREFIX}/share/icons/${_theme}/scalable/${_icon_GROUP}/${_name})
      FILE(APPEND ${CMAKE_CURRENT_BINARY_DIR}/install_icons.cmake "MESSAGE(STATUS \"Installing ${_ICON_INSTALL_NAME}\") \n")
      FILE(APPEND ${CMAKE_CURRENT_BINARY_DIR}/install_icons.cmake "CONFIGURE_FILE( ${_current_ICON} ${_ICON_INSTALL_NAME} COPYONLY) \n")

   ENDFOREACH (_current_ICON)
ENDMACRO(KDE4_INSTALL_ICONS _theme)

# for the case that something should be added to every CMakeLists.txt at the top
MACRO(KDE4_HEADER)
ENDMACRO(KDE4_HEADER)

# same as above, but at the end
MACRO(KDE4_FOOTER)
ENDMACRO(KDE4_FOOTER)

MACRO(KDE4_CREATE_LIBTOOL_FILE _target)
   GET_TARGET_PROPERTY(_target_location ${_target} LOCATION)

   GET_FILENAME_COMPONENT(_laname ${_target_location} NAME_WE)
   GET_FILENAME_COMPONENT(_soname ${_target_location} NAME)
   SET(_laname ${_laname}.la)

   FILE(WRITE ${_laname} "# ${_laname} - a libtool library file, generated by cmake \n")
   FILE(APPEND ${_laname} "# The name that we can dlopen(3).\n")
   FILE(APPEND ${_laname} "dlname='${_soname}'\n")
   FILE(APPEND ${_laname} "# Names of this library\n")
   FILE(APPEND ${_laname} "library_names='${_soname} ${_soname} ${_soname}'\n")
   FILE(APPEND ${_laname} "# The name of the static archive\n")
   FILE(APPEND ${_laname} "old_library=''\n")
   FILE(APPEND ${_laname} "# Libraries that this one depends upon.\n")
   FILE(APPEND ${_laname} "dependency_libs=''\n")
#   FILE(APPEND ${_laname} "dependency_libs='${${_target}_LIB_DEPENDS}'\n")
   FILE(APPEND ${_laname} "# Version information.\ncurrent=0\nage=0\nrevision=0\n")
   FILE(APPEND ${_laname} "# Is this an already installed library?\ninstalled=yes\n")
   FILE(APPEND ${_laname} "# Should we warn about portability when linking against -modules?\nshouldnotlink=yes\n")
   FILE(APPEND ${_laname} "# Files to dlopen/dlpreopen\ndlopen=''\ndlpreopen=''\n")
   FILE(APPEND ${_laname} "# Directory that this library needs to be installed in:\n")
   FILE(APPEND ${_laname} "libdir='${CMAKE_INSTALL_PREFIX}/${KDE4_LIB_INSTALL_DIR}/kde4'\n")

   INSTALL_FILES(${KDE4_LIB_INSTALL_DIR}/kde4 FILES ${_laname})
ENDMACRO(KDE4_CREATE_LIBTOOL_FILE)


MACRO(KDE4_CREATE_FINAL_FILES _filenameCPP _filenameC )
   FILE(WRITE ${_filenameCPP} "//autogenerated file\n")
   FILE(WRITE ${_filenameC} "/*autogenerated file*/\n")
   FOREACH (_current_FILE ${ARGN})
      STRING(REGEX MATCH ".+\\.c$" _isCFile ${_current_FILE})
      IF(_isCFile)
         FILE(APPEND ${_filenameC} "#include \"${_current_FILE}\"\n")
      ELSE(_isCFile)
         FILE(APPEND ${_filenameCPP} "#include \"${_current_FILE}\"\n")
      ENDIF(_isCFile)
   ENDFOREACH (_current_FILE)

ENDMACRO(KDE4_CREATE_FINAL_FILES)


OPTION(KDE4_ENABLE_FINAL "Enable final all-in-one compilation")
OPTION(KDE4_BUILD_TESTS  "Build the tests")
OPTION(KDE4_USE_QT_EMB   "link to Qt-embedded, don't use X")

MACRO(KDE4_ADD_PLUGIN _target_NAME _with_PREFIX)
#is the first argument is "WITH_PREFIX" then keep the standard "lib" prefix, otherwise set the prefix empty
   IF (${_with_PREFIX} STREQUAL "WITH_PREFIX")
      SET(_first_SRC)
   ELSE (${_with_PREFIX} STREQUAL "WITH_PREFIX")
      SET(_first_SRC ${_with_PREFIX})
   ENDIF (${_with_PREFIX} STREQUAL "WITH_PREFIX")

   IF (KDE4_ENABLE_FINAL)
      KDE4_CREATE_FINAL_FILES(${_target_NAME}_final_cpp.cpp ${_target_NAME}_final_c.c ${_first_SRC} ${ARGN})
      ADD_LIBRARY(${_target_NAME} MODULE  ${_target_NAME}_final_cpp.cpp ${_target_NAME}_final_c.c)
   ELSE (KDE4_ENABLE_FINAL)
      ADD_LIBRARY(${_target_NAME} MODULE ${_first_SRC} ${ARGN})
   ENDIF (KDE4_ENABLE_FINAL)

   IF(_first_SRC)
      SET_TARGET_PROPERTIES(${_target_NAME} PROPERTIES PREFIX "")
   ENDIF(_first_SRC)

   KDE4_CREATE_LIBTOOL_FILE(${_target_NAME})

ENDMACRO(KDE4_ADD_PLUGIN _target_NAME _with_PREFIX)

MACRO(KDE4_ADD_KLM _target_NAME )

   IF (KDE4_ENABLE_FINAL)
      KDE4_CREATE_FINAL_FILES(${_target_NAME}_final_cpp.cpp ${_target_NAME}_final_c.c ${ARGN})
      ADD_LIBRARY(kdeinit_${_target_NAME} SHARED  ${_target_NAME}_final_cpp.cpp ${_target_NAME}_final_c.c)
   ELSE (KDE4_ENABLE_FINAL)
      ADD_LIBRARY(kdeinit_${_target_NAME} SHARED ${ARGN} )
#      MESSAGE(STATUS "klm: kdeinit_${_target_NAME}")
   ENDIF (KDE4_ENABLE_FINAL)

   CONFIGURE_FILE(${KDE4_MODULE_DIR}/kde4init_dummy.cpp.in ${CMAKE_CURRENT_BINARY_DIR}/${_target_NAME}_dummy.cpp)

   ADD_EXECUTABLE( ${_target_NAME} ${CMAKE_CURRENT_BINARY_DIR}/${_target_NAME}_dummy.cpp )
   TARGET_LINK_LIBRARIES( ${_target_NAME} kdeinit_${_target_NAME} )

ENDMACRO(KDE4_ADD_KLM _target_NAME)


MACRO(KDE4_ADD_EXECUTABLE _target_NAME )

   IF (KDE4_ENABLE_FINAL)
      KDE4_CREATE_FINAL_FILES(${_target_NAME}_final_cpp.cpp ${_target_NAME}_final_c.c ${ARGN})
      ADD_EXECUTABLE(${_target_NAME} ${_target_NAME}_final_cpp.cpp ${_target_NAME}_final_c.c)
   ELSE (KDE4_ENABLE_FINAL)
      ADD_EXECUTABLE(${_target_NAME} ${ARGN} )
   ENDIF (KDE4_ENABLE_FINAL)

ENDMACRO(KDE4_ADD_EXECUTABLE _target_NAME)

MACRO(KDE4_ADD_LIBRARY _target_NAME _lib_TYPE)
#is the first argument is "WITH_PREFIX" then keep the standard "lib" prefix, otherwise set the prefix empty

   SET(_first_SRC ${_lib_TYPE})
   SET(_add_lib_param)

   IF (${_lib_TYPE} STREQUAL "STATIC")
      SET(_first_SRC)
      SET(_add_lib_param STATIC)
   ENDIF (${_lib_TYPE} STREQUAL "STATIC")
   IF (${_lib_TYPE} STREQUAL "SHARED")
      SET(_first_SRC)
      SET(_add_lib_param SHARED)
   ENDIF (${_lib_TYPE} STREQUAL "SHARED")
   IF (${_lib_TYPE} STREQUAL "MODULE")
      SET(_first_SRC)
      SET(_add_lib_param MODULE)
   ENDIF (${_lib_TYPE} STREQUAL "MODULE")

   IF (KDE4_ENABLE_FINAL)
      KDE4_CREATE_FINAL_FILES(${_target_NAME}_final_cpp.cpp ${_target_NAME}_final_c.c ${_first_SRC} ${ARGN})
      ADD_LIBRARY(${_target_NAME} ${_add_lib_param}  ${_target_NAME}_final_cpp.cpp ${_target_NAME}_final_c.c)
   ELSE (KDE4_ENABLE_FINAL)
      ADD_LIBRARY(${_target_NAME} ${_add_lib_param} ${_first_SRC} ${ARGN})
   ENDIF (KDE4_ENABLE_FINAL)

   IF (WIN32)
      # for shared libraries a -DMAKE_target_LIB is required
      string(TOUPPER ${_target_NAME} _symbol)
      set(_symbol "MAKE_${_symbol}_LIB")
      set_target_properties(${_target_NAME} PROPERTIES DEFINE_SYMBOL ${_symbol})
   ENDIF (WIN32)

ENDMACRO(KDE4_ADD_LIBRARY _target_NAME _lib_TYPE)


MACRO(KDE4_CREATE_DOXYGEN_DOCS)
ENDMACRO(KDE4_CREATE_DOXYGEN_DOCS)

