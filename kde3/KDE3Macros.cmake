# this file contains the following macros:
# ADD_FILE_DEPENDANCY
# KDE3_ADD_DCOP_SKELS
# KDE3_ADD_DCOP_STUBS
# KDE3_ADD_MOC_FILES
# KDE3_ADD_UI_FILES
# KDE3_ADD_KCFG_FILES
# KDE3_AUTOMOC
# KDE3_TARGET_LINK_CONV_LIBRARIES
# KDE3_CREATE_LIBTOOL_FILE
# KDE3_PLACEHOLDER
# KDE3_CREATE_LIBTOOL_FILE
# KDE3_CREATE_FINAL_FILE
# KDE3_ADD_KPART
# KDE3_ADD_KLM
# KDE3_ADD_EXECUTABLE


#neundorf@kde.org

#this should better be part of cmake:
#add an additional file to the list of files a source file depends on
MACRO(ADD_FILE_DEPENDANCY file)
   SET(${file}_deps ${${file}_deps} ${ARGN})
   SET_SOURCE_FILES_PROPERTIES(
      ${file}
      PROPERTIES
      OBJECT_DEPENDS
      "${${file}_deps}"
   )
ENDMACRO(ADD_FILE_DEPENDANCY)


#create the kidl and skeletion file for dcop stuff
#usage: KDE_ADD_COP_SKELS(foo_SRCS ${dcop_headers})
MACRO(KDE3_ADD_DCOP_SKELS _sources)
   FOREACH (_current_FILE ${ARGN})
      GET_FILENAME_COMPONENT(_basename ${_current_FILE} NAME_WE)

      SET(_skel ${CMAKE_CURRENT_BINARY_DIR}/${_basename}_skel_skel.cpp)
      SET(_kidl ${CMAKE_CURRENT_BINARY_DIR}/${_basename}_skel.kidl)

      ADD_CUSTOM_COMMAND(OUTPUT ${_kidl}
         COMMAND ${KDE3_DCOPIDL_EXECUTABLE}
         ARGS ${CMAKE_CURRENT_SOURCE_DIR}/${_current_FILE} > ${_kidl}
         DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/${_current_FILE}
      )

      ADD_CUSTOM_COMMAND(OUTPUT ${_skel}
         COMMAND ${KDE3_DCOPIDL2CPP_EXECUTABLE}
         ARGS --c++-suffix cpp --no-signals --no-stub ${_kidl}
         DEPENDS ${_kidl}
      )

      SET(${_sources} ${${_sources}} ${_skel})

   ENDFOREACH (_current_FILE)

ENDMACRO(KDE3_ADD_DCOP_SKELS)

MACRO(KDE3_ADD_DCOP_STUBS _sources)
   FOREACH (_current_FILE ${ARGN})

      IF(${_current_FILE} MATCHES "^/.+") #abs path
         SET(_tmp_FILE ${_current_FILE})
      ELSE(${_current_FILE} MATCHES "^/.+")
         SET(_tmp_FILE ${CMAKE_CURRENT_SOURCE_DIR}/${_current_FILE})
      ENDIF(${_current_FILE} MATCHES "^/.+")

      GET_FILENAME_COMPONENT(_basename ${_tmp_FILE} NAME_WE)

      SET(_stub_CPP ${CMAKE_CURRENT_BINARY_DIR}/${_basename}_stub.cpp)
#     SET(_stub_H ${CMAKE_CURRENT_BINARY_DIR}/${_basename}_stub.h)
      SET(_kidl ${CMAKE_CURRENT_BINARY_DIR}/${_basename}_stub.kidl)

      ADD_CUSTOM_COMMAND(OUTPUT ${_kidl}
         COMMAND ${KDE3_DCOPIDL_EXECUTABLE}
         ARGS ${tmp_FILE} > ${_kidl}
         DEPENDS ${tmp_FILE}
      )

      ADD_CUSTOM_COMMAND(OUTPUT ${_stub_CPP}
         COMMAND ${KDE3_DCOPIDL2CPP_EXECUTABLE}
         ARGS --c++-suffix cpp --no-signals --no-skel ${_kidl}
         DEPENDS ${_kidl}
      )

      SET(${_sources} ${${_sources}} ${_stub_CPP})

   ENDFOREACH (_current_FILE)

ENDMACRO(KDE3_ADD_DCOP_STUBS)

MACRO(KDE3_ADD_KCFG_FILES _sources)
   FOREACH (_current_FILE ${ARGN})

      IF(${_current_FILE} MATCHES "^/.+") #abs path
         SET(_tmp_FILE ${_current_FILE})
      ELSE(${_current_FILE} MATCHES "^/.+")
         SET(_tmp_FILE ${CMAKE_CURRENT_SOURCE_DIR}/${_current_FILE})
      ENDIF(${_current_FILE} MATCHES "^/.+")

      GET_FILENAME_COMPONENT(_basename ${_tmp_FILE} NAME_WE)

      FILE(READ ${_tmp_FILE} _contents)
      STRING(REGEX REPLACE "^(.*\n)?File=([^\n]+)\n.*$" "\\2"  _kcfg_FILE "${_contents}")

      SET(_src_FILE    ${CMAKE_CURRENT_BINARY_DIR}/${_basename}.cpp)
      SET(_header_FILE ${CMAKE_CURRENT_BINARY_DIR}/${_basename}.h)

      ADD_CUSTOM_COMMAND(OUTPUT ${_src_FILE}
         COMMAND ${KDE3_KCFGC_EXECUTABLE}
         ARGS ${_kcfg_FILE} ${_tmp_FILE}
         DEPENDS ${_tmp_FILE} )

      SET(${_sources} ${${_sources}} ${_src_FILE})

   ENDFOREACH (_current_FILE)

ENDMACRO(KDE3_ADD_KCFG_FILES)


#create the moc files and add them to the list of sources
#usage: KDE_ADD_MOC_FILES(foo_SRCS ${moc_headers})
MACRO(KDE3_ADD_MOC_FILES _sources)
   FOREACH (_current_FILE ${ARGN})
      GET_FILENAME_COMPONENT(_basename ${_current_FILE} NAME_WE)
      GET_FILENAME_COMPONENT(_path ${_current_FILE} PATH)
      SET(_moc ${CMAKE_CURRENT_BINARY_DIR}/${_basename}.moc.cpp)

      ADD_CUSTOM_COMMAND(OUTPUT ${_moc}
         COMMAND ${QT_MOC_EXECUTABLE}
         ARGS ${CMAKE_CURRENT_SOURCE_DIR}/${_current_FILE} -o ${_moc}
         DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/${_current_FILE}
      )

      SET(${_sources} ${${_sources}} ${_moc})

   ENDFOREACH (_current_FILE)
ENDMACRO(KDE3_ADD_MOC_FILES)


#create the implementation files from the ui files and add them to the list of sources
#usage: KDE_ADD_UI_FILES(foo_SRCS ${ui_files})
MACRO(KDE3_ADD_UI_FILES _sources )
   FOREACH (_current_FILE ${ARGN})

      GET_FILENAME_COMPONENT(_basename ${_current_FILE} NAME_WE)
      SET(_header ${CMAKE_CURRENT_BINARY_DIR}/${_basename}.h)
      SET(_src ${CMAKE_CURRENT_BINARY_DIR}/${_basename}.cpp)
      SET(_moc ${CMAKE_CURRENT_BINARY_DIR}/${_basename}.moc.cpp)

      ADD_CUSTOM_COMMAND(OUTPUT ${_header}
         COMMAND ${QT_UIC_EXECUTABLE}
         ARGS  -nounload -o ${_header} ${CMAKE_CURRENT_SOURCE_DIR}/${_current_FILE}
         DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/${_current_FILE}
      )

#     ADD_CUSTOM_COMMAND(OUTPUT ${_src}
#         COMMAND uic
#         ARGS -nounload -tr tr2i18n -o ${_src} -impl ${_header} ${CMAKE_CURRENT_SOURCE_DIR}/${_current_FILE}
#         DEPENDS ${_header}
#      )

      ADD_CUSTOM_COMMAND(OUTPUT ${_src}
         COMMAND ${CMAKE_COMMAND}
         ARGS
         -DKDE_UIC_FILE:STRING=${CMAKE_CURRENT_SOURCE_DIR}/${_current_FILE}
         -DKDE_UIC_CPP_FILE:STRING=${_src}
         -DKDE_UIC_H_FILE:STRING=${_header}
         -P ${CMAKE_ROOT}/Modules/kde3uic.cmake
         DEPENDS ${_header}
      )

      ADD_CUSTOM_COMMAND(OUTPUT ${_moc}
         COMMAND ${QT_MOC_EXECUTABLE}
         ARGS ${_header} -o ${_moc}
         DEPENDS ${_header}
      )

      SET(${_sources} ${${_sources}} ${_src} ${_moc} )

   ENDFOREACH (_current_FILE)
ENDMACRO(KDE3_ADD_UI_FILES)

MACRO(KDE3_AUTOMOC)
   SET(_matching_FILES )
   FOREACH (_current_FILE ${ARGN})
      IF (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/${_current_FILE})

         FILE(READ ${CMAKE_CURRENT_SOURCE_DIR}/${_current_FILE} _contents)

         IF(${_current_FILE} MATCHES "^/.+")
            SET(_tmp_FILE ${_current_FILE})
         ELSE(${_current_FILE} MATCHES "^/.+")
            SET(_tmp_FILE ${CMAKE_CURRENT_SOURCE_DIR}/${_current_FILE})
         ENDIF(${_current_FILE} MATCHES "^/.+")
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
                  ARGS ${_header} -o ${_moc}
                  DEPENDS ${_header}
               )

               ADD_FILE_DEPENDANCY(${CMAKE_CURRENT_SOURCE_DIR}/${_current_FILE} ${_moc})

            ENDFOREACH (_current_MOC_INC)
         ENDIF(_match)

      ENDIF (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/${_current_FILE})
   ENDFOREACH (_current_FILE)
ENDMACRO(KDE3_AUTOMOC)

MACRO(KDE3_INSTALL_ICONS _theme)
   ADD_CUSTOM_TARGET(install_icons )
   SET_TARGET_PROPERTIES(install_icons PROPERTIES POST_INSTALL_SCRIPT ${CMAKE_CURRENT_BINARY_DIR}/install_icons.cmake )
   FILE(WRITE install_icons.cmake "# icon installations rules\n")
   FILE(APPEND install_icons.cmake "SET(CMAKE_BACKWARDS_COMPATIBILITY \"2.2\") \n")

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
      FILE(APPEND install_icons.cmake "MESSAGE(STATUS \"Installing ${_ICON_INSTALL_NAME}\") \n")
      FILE(APPEND install_icons.cmake "CONFIGURE_FILE( ${_current_ICON} ${_ICON_INSTALL_NAME} COPYONLY) \n")

   ENDFOREACH (_current_ICON)
ENDMACRO(KDE3_INSTALL_ICONS _theme)

MACRO(KDE3_PLACEHOLDER)
ENDMACRO(KDE3_PLACEHOLDER)

MACRO(KDE3_CREATE_LIBTOOL_FILE _target)
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
   FILE(APPEND ${_laname} "libdir='${CMAKE_INSTALL_PREFIX}/lib/kde3'\n")

   INSTALL_FILES(/lib/kde3 FILES ${_laname})
ENDMACRO(KDE3_CREATE_LIBTOOL_FILE)


MACRO(KDE3_CREATE_FINAL_FILE _filename)
   FILE(WRITE ${_filename} "//autogenerated file\n")
   FOREACH (_current_FILE ${ARGN})
      FILE(APPEND ${_filename} "#include \"${_current_FILE}\"\n")
   ENDFOREACH (_current_FILE)

ENDMACRO(KDE3_CREATE_FINAL_FILE _filename)


OPTION(KDE3_ENABLE_FINAL "Enable final all-in-one compilation")
OPTION(KDE3_BUILD_TESTS  "Build the tests")

MACRO(KDE3_ADD_KPART _target_NAME _with_PREFIX)
#is the first argument is "WITH_PREFIX" then keep the standard "lib" prefix, otherwise set the prefix empty
   IF (${_with_PREFIX} STREQUAL "WITH_PREFIX")
      SET(_first_SRC)
   ELSE (${_with_PREFIX} STREQUAL "WITH_PREFIX")
      SET(_first_SRC ${_with_PREFIX})
   ENDIF (${_with_PREFIX} STREQUAL "WITH_PREFIX")

   IF (KDE3_ENABLE_FINAL)
      KDE3_CREATE_FINAL_FILE(${_target_NAME}_final.cpp ${_first_SRC} ${ARGN})
      ADD_LIBRARY(${_target_NAME} MODULE  ${_target_NAME}_final.cpp)
   ELSE (KDE3_ENABLE_FINAL)
      ADD_LIBRARY(${_target_NAME} MODULE ${_first_SRC} ${ARGN})
   ENDIF (KDE3_ENABLE_FINAL)

   MESSAGE(STATUS "firstSrc: ${_first_SRC}")
   IF(_first_SRC)
      MESSAGE(STATUS "setting empty prefix for ${_target_NAME}")
      SET_TARGET_PROPERTIES(${_target_NAME} PROPERTIES PREFIX "")
   ENDIF(_first_SRC)

   KDE3_CREATE_LIBTOOL_FILE(${_target_NAME})

ENDMACRO(KDE3_ADD_KPART _target_NAME _with_PREFIX)

MACRO(KDE3_ADD_KLM _target_NAME )

   IF (KDE3_ENABLE_FINAL)
      KDE3_CREATE_FINAL_FILE(${_target_NAME}_final.cpp ${ARGN})
      ADD_LIBRARY(kdeinit_${_target_NAME} SHARED  ${_target_NAME}_final.cpp)
   ELSE (KDE3_ENABLE_FINAL)
      ADD_LIBRARY(kdeinit_${_target_NAME} SHARED ${ARGN} )
      MESSAGE(STATUS "klm: kdeinit_${_target_NAME}")
   ENDIF (KDE3_ENABLE_FINAL)

   CONFIGURE_FILE(${CMAKE_ROOT}/Modules/kde3init_dummy.cpp.in ${CMAKE_CURRENT_BINARY_DIR}/${_target_NAME}_dummy.cpp)

   ADD_EXECUTABLE( ${_target_NAME} ${CMAKE_CURRENT_BINARY_DIR}/${_target_NAME}_dummy.cpp )
   TARGET_LINK_LIBRARIES( ${_target_NAME} kdeinit_${_target_NAME} )

ENDMACRO(KDE3_ADD_KLM _target_NAME)


MACRO(KDE3_ADD_EXECUTABLE _target_NAME )

   IF (KDE3_ENABLE_FINAL)
      KDE3_CREATE_FINAL_FILE(${_target_NAME}_final.cpp ${ARGN})
      ADD_EXECUTABLE(${_target_NAME} ${_target_NAME}_final.cpp)
   ELSE (KDE3_ENABLE_FINAL)
      ADD_EXECUTABLE(${_target_NAME} ${ARGN} )
   ENDIF (KDE3_ENABLE_FINAL)

ENDMACRO(KDE3_ADD_EXECUTABLE _target_NAME)


