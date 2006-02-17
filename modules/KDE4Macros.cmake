# this file contains the following macros:
# KDE4_ADD_FILE_DEPENDANCY
# KDE4_ADD_DCOP_SKELS
# KDE4_ADD_DCOP_STUBS
# KDE4_ADD_MOC_FILES
# KDE4_ADD_UI_FILES
# KDE4_ADD_KCFG_FILES
# KDE4_AUTOMOC
# KDE4_INSTALL_LIBTOOL_FILE
# KDE4_PLACEHOLDER
# KDE4_CREATE_FINAL_FILE
# KDE4_ADD_KPART
# KDE4_ADD_KDEINIT_EXECUTABLE
# KDE4_ADD_EXECUTABLE

#neundorf@kde.org

#create the kidl and skeletion file for dcop stuff
#usage: KDE_ADD_COP_SKELS(foo_SRCS ${dcop_headers})
MACRO(KDE4_ADD_DCOP_SKELS _sources)
   foreach (_current_FILE ${ARGN})

      GET_FILENAME_COMPONENT(_tmp_FILE ${_current_FILE} ABSOLUTE)

      GET_FILENAME_COMPONENT(_basename ${_tmp_FILE} NAME_WE)

      set(_skel ${CMAKE_CURRENT_BINARY_DIR}/${_basename}_skel.cpp)
      set(_skel_H ${CMAKE_CURRENT_BINARY_DIR}/${_basename}_skel.h)
      set(_kidl ${CMAKE_CURRENT_BINARY_DIR}/${_basename}.kidl)

      if (NOT HAVE_${_basename}_KIDL_RULE)
        set(HAVE_${_basename}_KIDL_RULE ON)

        ADD_CUSTOM_COMMAND(OUTPUT ${_kidl}
           COMMAND ${KDE4_DCOPIDL_EXECUTABLE}
           ARGS --srcdir ${KDE4_KALYPTUS_DIR} -o ${_kidl} ${_tmp_FILE}
           DEPENDS ${_tmp_FILE}
        )
      endif (NOT HAVE_${_basename}_KIDL_RULE)

      if (NOT HAVE_${_basename}_SKEL_RULE)
        set(HAVE_${_basename}_SKEL_RULE ON)

        ADD_CUSTOM_COMMAND(OUTPUT ${_skel}
           COMMAND ${KDE4_DCOPIDL2CPP_EXECUTABLE}
           ARGS --c++-suffix cpp --no-signals --no-stub ${_kidl}
           DEPENDS ${_kidl} ${_KDE4_DCOPIDL2CPP_DEP} )

        MACRO_ADDITIONAL_CLEAN_FILES( ${_skel_H})

      endif (NOT HAVE_${_basename}_SKEL_RULE)

      set(${_sources} ${${_sources}} ${_skel})

   endforeach (_current_FILE)

ENDMACRO(KDE4_ADD_DCOP_SKELS)


MACRO(KDE4_ADD_DCOP_STUBS _sources)
   foreach (_current_FILE ${ARGN})

      GET_FILENAME_COMPONENT(_tmp_FILE ${_current_FILE} ABSOLUTE)

      GET_FILENAME_COMPONENT(_basename ${_tmp_FILE} NAME_WE)

      set(_stub_CPP ${CMAKE_CURRENT_BINARY_DIR}/${_basename}_stub.cpp)
      set(_stub_H ${CMAKE_CURRENT_BINARY_DIR}/${_basename}_stub.h)
      set(_kidl ${CMAKE_CURRENT_BINARY_DIR}/${_basename}.kidl)

      if (NOT HAVE_${_basename}_KIDL_RULE)
        set(HAVE_${_basename}_KIDL_RULE ON)

        ADD_CUSTOM_COMMAND(OUTPUT ${_kidl}
           COMMAND ${KDE4_DCOPIDL_EXECUTABLE}
           ARGS --srcdir ${KDE4_KALYPTUS_DIR} -o ${_kidl} ${_tmp_FILE}
           DEPENDS ${_tmp_FILE}
        )
      endif (NOT HAVE_${_basename}_KIDL_RULE)

      if (NOT HAVE_${_basename}_STUB_RULE)
        set(HAVE_${_basename}_STUB_RULE ON)

        ADD_CUSTOM_COMMAND(OUTPUT ${_stub_CPP}
           COMMAND ${KDE4_DCOPIDL2CPP_EXECUTABLE}
           ARGS --c++-suffix cpp --no-signals --no-skel ${_kidl}
           DEPENDS ${_kidl} ${_KDE4_DCOPIDL2CPP_DEP} )

        MACRO_ADDITIONAL_CLEAN_FILES( ${_stub_H})

      endif (NOT HAVE_${_basename}_STUB_RULE)

      set(${_sources} ${${_sources}} ${_stub_CPP})

   endforeach (_current_FILE)

ENDMACRO(KDE4_ADD_DCOP_STUBS)


MACRO(KDE4_ADD_KCFG_FILES _sources)
   foreach (_current_FILE ${ARGN})

      GET_FILENAME_COMPONENT(_tmp_FILE ${_current_FILE} ABSOLUTE)

      GET_FILENAME_COMPONENT(_basename ${_tmp_FILE} NAME_WE)

      FILE(READ ${_tmp_FILE} _contents)
      STRING(REGEX REPLACE "^(.*\n)?File=([^\n]+)\n.*$" "\\2"  _kcfg_FILE "${_contents}")

      set(_src_FILE    ${CMAKE_CURRENT_BINARY_DIR}/${_basename}.cpp)
      set(_header_FILE ${CMAKE_CURRENT_BINARY_DIR}/${_basename}.h)
      set(_moc_FILE    ${CMAKE_CURRENT_BINARY_DIR}/${_basename}.moc)

      # the command for creating the source file from the kcfg file
      ADD_CUSTOM_COMMAND(OUTPUT ${_src_FILE}
         COMMAND ${KDE4_KCFGC_EXECUTABLE}
         ARGS ${CMAKE_CURRENT_SOURCE_DIR}/${_kcfg_FILE} ${_tmp_FILE}
         DEPENDS ${_tmp_FILE} ${CMAKE_CURRENT_SOURCE_DIR}/${_kcfg_FILE} ${_KDE4_KCONFIG_COMPILER_DEP} )

      # for the case that the header contains signals or slots, it has to be processed by moc
      # since the generated header isn't listed as OUTPUT in the ADD_CUSTOM_COMMAND above, we
      # have to tell cmake explicitly that it is generated, otherwise it will complain that it doesn't
      # exist at cmake time
      # the generated source will then include the moc file, but since the source doesn't exist
      # yet at cmake time, this can't be recognized by KDE4_AUTOMOC, so we have to set the depedency explicitely
      SET_SOURCE_FILES_PROPERTIES(${_header_FILE} PROPERTIES GENERATED TRUE)
      QT4_GENERATE_MOC(${_header_FILE} ${_moc_FILE} )
      MACRO_ADD_FILE_DEPENDENCIES(${_src_FILE} ${_moc_FILE} )

      set(${_sources} ${${_sources}} ${_src_FILE})

   endforeach (_current_FILE)

ENDMACRO(KDE4_ADD_KCFG_FILES)

if(EXISTS "${CMAKE_ROOT}/Modules/kde4init_dummy.cpp.in")
   set(KDE4_MODULE_DIR "${CMAKE_ROOT}/Modules")
else(EXISTS "${CMAKE_ROOT}/Modules/kde4init_dummy.cpp.in")
   set(KDE4_MODULE_DIR "${CMAKE_SOURCE_DIR}/cmake/modules")
endif(EXISTS "${CMAKE_ROOT}/Modules/kde4init_dummy.cpp.in")


#create the implementation files from the ui files and add them to the list of sources
#usage: KDE_ADD_UI_FILES(foo_SRCS ${ui_files})
MACRO(KDE4_ADD_UI_FILES _sources )
   foreach (_current_FILE ${ARGN})

      GET_FILENAME_COMPONENT(_tmp_FILE ${_current_FILE} ABSOLUTE)

      GET_FILENAME_COMPONENT(_basename ${_tmp_FILE} NAME_WE)
      set(_header ${CMAKE_CURRENT_BINARY_DIR}/${_basename}.h)

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
   endforeach (_current_FILE)
ENDMACRO(KDE4_ADD_UI_FILES)


#create the implementation files from the ui files and add them to the list of sources
#usage: KDE_ADD_UI_FILES(foo_SRCS ${ui_files})
MACRO(KDE4_ADD_UI3_FILES _sources )

   QT4_GET_MOC_INC_DIRS(_moc_INCS)

   foreach (_current_FILE ${ARGN})

      GET_FILENAME_COMPONENT(_tmp_FILE ${_current_FILE} ABSOLUTE)

      GET_FILENAME_COMPONENT(_basename ${_tmp_FILE} NAME_WE)
      set(_header ${CMAKE_CURRENT_BINARY_DIR}/${_basename}.h)
      set(_src ${CMAKE_CURRENT_BINARY_DIR}/${_basename}.cpp)
      set(_moc ${CMAKE_CURRENT_BINARY_DIR}/${_basename}.moc.cpp)

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
      set(${_sources} ${${_sources}} ${_src} ${_moc} )

   endforeach (_current_FILE)
ENDMACRO(KDE4_ADD_UI3_FILES)


MACRO(KDE4_AUTOMOC)
   QT4_GET_MOC_INC_DIRS(_moc_INCS)

   set(_matching_FILES )
   foreach (_current_FILE ${ARGN})

      GET_FILENAME_COMPONENT(_tmp_FILE ${_current_FILE} ABSOLUTE)

      if (EXISTS ${_tmp_FILE})

         FILE(READ ${_tmp_FILE} _contents)

         GET_FILENAME_COMPONENT(_abs_FILE ${_tmp_FILE} ABSOLUTE)
         GET_FILENAME_COMPONENT(_abs_PATH ${_abs_FILE} PATH)

         STRING(REGEX MATCHALL "#include +[^ ]+\\.moc[\">]" _match "${_contents}")
         if(_match)
            foreach (_current_MOC_INC ${_match})
               STRING(REGEX MATCH "[^ <\"]+\\.moc" _current_MOC "${_current_MOC_INC}")

               GET_FILENAME_COMPONENT(_basename ${_current_MOC} NAME_WE)
#               set(_header ${CMAKE_CURRENT_SOURCE_DIR}/${_basename}.h)
               set(_header ${_abs_PATH}/${_basename}.h)
               set(_moc    ${CMAKE_CURRENT_BINARY_DIR}/${_current_MOC})
               ADD_CUSTOM_COMMAND(OUTPUT ${_moc}
                  COMMAND ${QT_MOC_EXECUTABLE}
                  ARGS ${_moc_INCS} ${_header} -o ${_moc}
                  DEPENDS ${_header}
               )

               MACRO_ADD_FILE_DEPENDENCIES(${_tmp_FILE} ${_moc})

            endforeach (_current_MOC_INC)
         endif(_match)

      endif (EXISTS ${_tmp_FILE})
   endforeach (_current_FILE)
ENDMACRO(KDE4_AUTOMOC)


MACRO(KDE4_INSTALL_ICONS _theme _defaultpath )
   FILE(WRITE ${CMAKE_CURRENT_BINARY_DIR}/install_icons.cmake "# icon installations rules\n")
   FILE(APPEND ${CMAKE_CURRENT_BINARY_DIR}/install_icons.cmake "set(CMAKE_BACKWARDS_COMPATIBILITY \"2.2\") \n")

   FILE(GLOB _icons *.png)
   foreach(_current_ICON ${_icons} )
      STRING(REGEX REPLACE "^.*/[a-zA-Z]+([0-9]+)\\-([a-z]+)\\-(.+\\.png)$" "\\1" _size  "${_current_ICON}")
      STRING(REGEX REPLACE "^.*/[a-zA-Z]+([0-9]+)\\-([a-z]+)\\-(.+\\.png)$" "\\2" _group "${_current_ICON}")
      STRING(REGEX REPLACE "^.*/[a-zA-Z]+([0-9]+)\\-([a-z]+)\\-(.+\\.png)$" "\\3" _name  "${_current_ICON}")
      # if the string doesn't match the pattern, the result is the full string, so all three have the same content
      if( NOT ${_size} STREQUAL ${_name} )
         set(_icon_GROUP "actions")

         if(${_group} STREQUAL "mime")
            set(_icon_GROUP  "mimetypes")
         endif(${_group} STREQUAL "mime")

         if(${_group} STREQUAL "filesys")
            set(_icon_GROUP  "filesystems")
         endif(${_group} STREQUAL "filesys")

         if(${_group} STREQUAL "device")
            set(_icon_GROUP  "devices")
         endif(${_group} STREQUAL "device")

         if(${_group} STREQUAL "app")
            set(_icon_GROUP  "apps")
         endif(${_group} STREQUAL "app")

         if(${_group} STREQUAL "action")
            set(_icon_GROUP  "actions")
         endif(${_group} STREQUAL "action")

#      message(STATUS "icon: ${_current_ICON} size: ${_size} group: ${_group} name: ${_name}" )
         set(_ICON_INSTALL_NAME ${CMAKE_INSTALL_PREFIX}/${_defaultpath}/icons/${_theme}/${_size}x${_size}/${_icon_GROUP}/${_name})
         FILE(APPEND ${CMAKE_CURRENT_BINARY_DIR}/install_icons.cmake "message(STATUS \"Installing ${_ICON_INSTALL_NAME}\") \n")
         FILE(APPEND ${CMAKE_CURRENT_BINARY_DIR}/install_icons.cmake "CONFIGURE_FILE( ${_current_ICON} ${_ICON_INSTALL_NAME} COPYONLY) \n")
      endif( NOT ${_size} STREQUAL ${_name} )
   endforeach (_current_ICON)
   FILE(GLOB _icons *.svgz)
   foreach(_current_ICON ${_icons} )
      STRING(REGEX REPLACE "^.*/crsc\\-([a-z]+)\\-(.+\\.svgz)$" "\\1" _group "${_current_ICON}")
      STRING(REGEX REPLACE "^.*/crsc\\-([a-z]+)\\-(.+\\.svgz)$" "\\2" _name "${_current_ICON}")

      set(_icon_GROUP "actions")

      if(${_group} STREQUAL "mime")
         set(_icon_GROUP  "mimetypes")
      endif(${_group} STREQUAL "mime")

      if(${_group} STREQUAL "filesys")
         set(_icon_GROUP  "filesystems")
      endif(${_group} STREQUAL "filesys")

      if(${_group} STREQUAL "device")
         set(_icon_GROUP  "devices")
      endif(${_group} STREQUAL "device")

      if(${_group} STREQUAL "app")
         set(_icon_GROUP  "apps")
      endif(${_group} STREQUAL "app")

      if(${_group} STREQUAL "action")
         set(_icon_GROUP  "actions")
      endif(${_group} STREQUAL "action")

      set(_ICON_INSTALL_NAME ${CMAKE_INSTALL_PREFIX}/${_defaultpath}/icons/${_theme}/scalable/${_icon_GROUP}/${_name})
      FILE(APPEND ${CMAKE_CURRENT_BINARY_DIR}/install_icons.cmake "message(STATUS \"Installing ${_ICON_INSTALL_NAME}\") \n")
      FILE(APPEND ${CMAKE_CURRENT_BINARY_DIR}/install_icons.cmake "CONFIGURE_FILE( ${_current_ICON} ${_ICON_INSTALL_NAME} COPYONLY) \n")

   endforeach (_current_ICON)
   INSTALL(SCRIPT ${CMAKE_CURRENT_BINARY_DIR}/install_icons.cmake )

ENDMACRO(KDE4_INSTALL_ICONS _theme _defaultpath)


# for the case that something should be added to every CMakeLists.txt at the top
MACRO(KDE4_HEADER)
ENDMACRO(KDE4_HEADER)


# same as above, but at the end
MACRO(KDE4_FOOTER)
ENDMACRO(KDE4_FOOTER)


MACRO(KDE4_INSTALL_LIBTOOL_FILE _subdir _target)
   GET_TARGET_PROPERTY(_target_location ${_target} LOCATION)

   GET_FILENAME_COMPONENT(_laname ${_target_location} NAME_WE)
   GET_FILENAME_COMPONENT(_soname ${_target_location} NAME)
   set(_laname ${LIBRARY_OUTPUT_PATH}/${_laname}.la)

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
   FILE(APPEND ${_laname} "libdir='${CMAKE_INSTALL_PREFIX}/${_subdir}'\n")

   INSTALL_FILES(${_subdir} FILES ${_laname})
   MACRO_ADDITIONAL_CLEAN_FILES( ${_laname})
ENDMACRO(KDE4_INSTALL_LIBTOOL_FILE)


MACRO(KDE4_CREATE_FINAL_FILES _filenameCPP _filenameC )
   FILE(WRITE ${_filenameCPP} "//autogenerated file\n")
   FILE(WRITE ${_filenameC} "/*autogenerated file*/\n")
   foreach (_current_FILE ${ARGN})
      STRING(REGEX MATCH ".+\\.c$" _isCFile ${_current_FILE})
      if(_isCFile)
         FILE(APPEND ${_filenameC} "#include \"${_current_FILE}\"\n")
      else(_isCFile)
         FILE(APPEND ${_filenameCPP} "#include \"${_current_FILE}\"\n")
      endif(_isCFile)
   endforeach (_current_FILE)

ENDMACRO(KDE4_CREATE_FINAL_FILES)


OPTION(KDE4_ENABLE_FINAL "Enable final all-in-one compilation")
OPTION(KDE4_BUILD_TESTS  "Build the tests")
OPTION(KDE4_USE_QT_EMB   "link to Qt-embedded, don't use X")

MACRO(KDE4_ADD_PLUGIN _target_NAME _with_PREFIX)
#is the first argument is "WITH_PREFIX" then keep the standard "lib" prefix, otherwise set the prefix empty
   if (${_with_PREFIX} STREQUAL "WITH_PREFIX")
      set(_first_SRC)
   else (${_with_PREFIX} STREQUAL "WITH_PREFIX")
      set(_first_SRC ${_with_PREFIX})
   endif (${_with_PREFIX} STREQUAL "WITH_PREFIX")

   if (KDE4_ENABLE_FINAL)
      KDE4_CREATE_FINAL_FILES(${_target_NAME}_final_cpp.cpp ${_target_NAME}_final_c.c ${_first_SRC} ${ARGN})
      ADD_LIBRARY(${_target_NAME} MODULE  ${_target_NAME}_final_cpp.cpp ${_target_NAME}_final_c.c)
   else (KDE4_ENABLE_FINAL)
      ADD_LIBRARY(${_target_NAME} MODULE ${_first_SRC} ${ARGN})
   endif (KDE4_ENABLE_FINAL)

   if(_first_SRC)
      SET_TARGET_PROPERTIES(${_target_NAME} PROPERTIES PREFIX "")
   endif(_first_SRC)

#   if (UNIX)
#   I guess under windows the libtool file are not required
#   KDE4_INSTALL_LIBTOOL_FILE(${_target_NAME})
#   endif (UNIX)

   IF (WIN32)
      # for shared libraries/plugins a -DMAKE_target_LIB is required
      string(TOUPPER ${_target_NAME} _symbol)
      set(_symbol "MAKE_${_symbol}_LIB")
      set_target_properties(${_target_NAME} PROPERTIES DEFINE_SYMBOL ${_symbol})
   ENDIF (WIN32)

ENDMACRO(KDE4_ADD_PLUGIN _target_NAME _with_PREFIX)


MACRO(KDE4_ADD_KDEINIT_EXECUTABLE _target_NAME )

   CONFIGURE_FILE(${KDE4_MODULE_DIR}/kde4init_dummy.cpp.in ${CMAKE_CURRENT_BINARY_DIR}/${_target_NAME}_dummy.cpp)
   MACRO_ADDITIONAL_CLEAN_FILES( ${CMAKE_CURRENT_BINARY_DIR}/${_target_NAME}_dummy.cpp )

#   if (WIN32)
#      # under windows, just build a normal executable
#      KDE4_ADD_EXECUTABLE(${_target_NAME} ${CMAKE_CURRENT_BINARY_DIR}/${_target_NAME}_dummy.cpp ${ARGN} )
#   else (WIN32)
      # under UNIX, create a shared library and a small executable, which links to this library
      if (KDE4_ENABLE_FINAL)
         KDE4_CREATE_FINAL_FILES(${_target_NAME}_final_cpp.cpp ${_target_NAME}_final_c.c ${ARGN})
         ADD_LIBRARY(kdeinit_${_target_NAME} SHARED  ${_target_NAME}_final_cpp.cpp ${_target_NAME}_final_c.c)
      else (KDE4_ENABLE_FINAL)
         ADD_LIBRARY(kdeinit_${_target_NAME} SHARED ${ARGN} )
#      message(STATUS "klm: kdeinit_${_target_NAME}")
      endif (KDE4_ENABLE_FINAL)


      ADD_EXECUTABLE( ${_target_NAME} ${CMAKE_CURRENT_BINARY_DIR}/${_target_NAME}_dummy.cpp )
      TARGET_LINK_LIBRARIES( ${_target_NAME} kdeinit_${_target_NAME} )
#   endif (WIN32)

ENDMACRO(KDE4_ADD_KDEINIT_EXECUTABLE _target_NAME)


MACRO(KDE4_ADD_EXECUTABLE _target_NAME )

   if (KDE4_ENABLE_FINAL)
      KDE4_CREATE_FINAL_FILES(${_target_NAME}_final_cpp.cpp ${_target_NAME}_final_c.c ${ARGN})
      ADD_EXECUTABLE(${_target_NAME} ${_target_NAME}_final_cpp.cpp ${_target_NAME}_final_c.c)
   else (KDE4_ENABLE_FINAL)
      ADD_EXECUTABLE(${_target_NAME} ${ARGN} )
   endif (KDE4_ENABLE_FINAL)

ENDMACRO(KDE4_ADD_EXECUTABLE _target_NAME)


MACRO(KDE4_ADD_LIBRARY _target_NAME _lib_TYPE)
#is the first argument is "WITH_PREFIX" then keep the standard "lib" prefix, otherwise set the prefix empty

   set(_first_SRC ${_lib_TYPE})
   set(_add_lib_param)

   if (${_lib_TYPE} STREQUAL "STATIC")
      set(_first_SRC)
      set(_add_lib_param STATIC)
   endif (${_lib_TYPE} STREQUAL "STATIC")
   if (${_lib_TYPE} STREQUAL "SHARED")
      set(_first_SRC)
      set(_add_lib_param SHARED)
   endif (${_lib_TYPE} STREQUAL "SHARED")
   if (${_lib_TYPE} STREQUAL "MODULE")
      set(_first_SRC)
      set(_add_lib_param MODULE)
   endif (${_lib_TYPE} STREQUAL "MODULE")

   if (KDE4_ENABLE_FINAL)
      KDE4_CREATE_FINAL_FILES(${_target_NAME}_final_cpp.cpp ${_target_NAME}_final_c.c ${_first_SRC} ${ARGN})
      ADD_LIBRARY(${_target_NAME} ${_add_lib_param}  ${_target_NAME}_final_cpp.cpp ${_target_NAME}_final_c.c)
   else (KDE4_ENABLE_FINAL)
      ADD_LIBRARY(${_target_NAME} ${_add_lib_param} ${_first_SRC} ${ARGN})
   endif (KDE4_ENABLE_FINAL)

   if (WIN32)
      # for shared libraries a -DMAKE_target_LIB is required
      string(TOUPPER ${_target_NAME} _symbol)
      set(_symbol "MAKE_${_symbol}_LIB")
      set_target_properties(${_target_NAME} PROPERTIES DEFINE_SYMBOL ${_symbol})
   endif (WIN32)

ENDMACRO(KDE4_ADD_LIBRARY _target_NAME _lib_TYPE)


MACRO(KDE4_CREATE_DOXYGEN_DOCS)
ENDMACRO(KDE4_CREATE_DOXYGEN_DOCS)

