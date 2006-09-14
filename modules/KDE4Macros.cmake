
# for documentation look at FindKDE4Internal.cmake
#
# this file contains the following macros:
# KDE4_ADD_UI_FILES
# KDE4_ADD_KCFG_FILES
# KDE4_AUTOMOC
# KDE4_INSTALL_LIBTOOL_FILE
# KDE4_CREATE_FINAL_FILES
# KDE4_ADD_KDEINIT_EXECUTABLE
# KDE4_ADD_EXECUTABLE
# KDE4_ADD_WIDGET_FILES

# Copyright (c) 2006, Alexander Neundorf, <neundorf@kde.org>
# Copyright (c) 2006, Laurent Montel, <montel@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

macro (KDE4_ADD_KCFG_FILES _sources )
   IF( ${ARGV1} STREQUAL "GENERATE_MOC" )
      SET(_kcfg_generatemoc TRUE)
   ENDIF( ${ARGV1} STREQUAL "GENERATE_MOC" )

   foreach (_current_FILE ${ARGN})

     if(NOT ${_current_FILE} STREQUAL "GENERATE_MOC")
       get_filename_component(_tmp_FILE ${_current_FILE} ABSOLUTE)
       get_filename_component(_abs_PATH ${_tmp_FILE} PATH)
       get_filename_component(_basename ${_tmp_FILE} NAME_WE)

       file(READ ${_tmp_FILE} _contents)
       string(REGEX REPLACE "^(.*\n)?File=([^\n]+kcfg).*\n.*$" "\\2"  _kcfg_FILE "${_contents}")
       set(_src_FILE    ${CMAKE_CURRENT_BINARY_DIR}/${_basename}.cpp)
       set(_header_FILE ${CMAKE_CURRENT_BINARY_DIR}/${_basename}.h)
       set(_moc_FILE    ${CMAKE_CURRENT_BINARY_DIR}/${_basename}.moc)

       # the command for creating the source file from the kcfg file
       add_custom_command(OUTPUT ${_header_FILE} ${_src_FILE}
          COMMAND ${KDE4_KCFGC_EXECUTABLE}
          ARGS ${_abs_PATH}/${_kcfg_FILE} ${_tmp_FILE} -d ${CMAKE_CURRENT_BINARY_DIR}
          MAIN_DEPENDENCY ${_tmp_FILE}
          DEPENDS ${_abs_PATH}/${_kcfg_FILE} ${_KDE4_KCONFIG_COMPILER_DEP} )

       if(_kcfg_generatemoc)
         qt4_generate_moc(${_header_FILE} ${_moc_FILE} )
         set_source_files_properties(${_src_FILE} PROPERTIES SKIP_AUTOMOC TRUE)  # dont run automoc on this file
         list(APPEND ${_sources} ${_moc_FILE})
       endif(_kcfg_generatemoc)

       list(APPEND ${_sources} ${_src_FILE} ${_header_FILE})
     endif(NOT ${_current_FILE} STREQUAL "GENERATE_MOC")
   endforeach (_current_FILE)

endmacro (KDE4_ADD_KCFG_FILES)


GET_FILENAME_COMPONENT(KDE4_MODULE_DIR  ${CMAKE_CURRENT_LIST_FILE} PATH)

#create the implementation files from the ui files and add them to the list of sources
#usage: KDE4_ADD_UI_FILES(foo_SRCS ${ui_files})
macro (KDE4_ADD_UI_FILES _sources )
   foreach (_current_FILE ${ARGN})

      get_filename_component(_tmp_FILE ${_current_FILE} ABSOLUTE)
      get_filename_component(_basename ${_tmp_FILE} NAME_WE)
      set(_header ${CMAKE_CURRENT_BINARY_DIR}/ui_${_basename}.h)

      # we need to run uic and replace some things in the generated file
      # this is done by executing the cmake script kde4uic.cmake
      add_custom_command(OUTPUT ${_header}
         COMMAND ${CMAKE_COMMAND}
         ARGS
         -DKDE4_HEADER:BOOL=ON
         -DKDE_UIC_EXECUTABLE:FILEPATH=${QT_UIC_EXECUTABLE}
         -DKDE_UIC_FILE:FILEPATH=${_tmp_FILE}
         -DKDE_UIC_H_FILE:FILEPATH=${_header}
         -DKDE_UIC_BASENAME:STRING=${_basename}
         -P ${KDE4_MODULE_DIR}/kde4uic.cmake
         MAIN_DEPENDENCY ${_tmp_FILE}
      )
      list(APPEND ${_sources} ${_header})
   endforeach (_current_FILE)
endmacro (KDE4_ADD_UI_FILES)


#create the implementation files from the ui files and add them to the list of sources
#usage: KDE4_ADD_UI3_FILES(foo_SRCS ${ui_files})
macro (KDE4_ADD_UI3_FILES _sources )

   qt4_get_moc_inc_dirs(_moc_INCS)

   foreach (_current_FILE ${ARGN})

      get_filename_component(_tmp_FILE ${_current_FILE} ABSOLUTE)
      get_filename_component(_basename ${_tmp_FILE} NAME_WE)
      set(_header ${CMAKE_CURRENT_BINARY_DIR}/${_basename}.h)
      set(_src ${CMAKE_CURRENT_BINARY_DIR}/${_basename}.cpp)
      set(_moc ${CMAKE_CURRENT_BINARY_DIR}/${_basename}.moc.cpp)

      add_custom_command(OUTPUT ${_header}
         COMMAND ${CMAKE_COMMAND}
         -DKDE3_HEADER:BOOL=ON
         -DKDE_UIC_EXECUTABLE:FILEPATH=${QT_UIC3_EXECUTABLE}
         -DKDE_UIC_FILE:FILEPATH=${_tmp_FILE}
         -DKDE_UIC_H_FILE:FILEPATH=${_header}
         -DKDE_UIC_BASENAME:STRING=${_basename}
         -DKDE_UIC_PLUGIN_DIR:FILEPATH="."
         -P ${KDE4_MODULE_DIR}/kde4uic.cmake
         MAIN_DEPENDENCY ${_tmp_FILE}
      )

# we need to run uic3 and replace some things in the generated file
      # this is done by executing the cmake script kde4uic.cmake
      add_custom_command(OUTPUT ${_src}
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
         MAIN_DEPENDENCY ${_header}
      )

      add_custom_command(OUTPUT ${_moc}
         COMMAND ${QT_MOC_EXECUTABLE}
         ARGS ${_moc_INCS} ${_header} -o ${_moc}
         MAIN_DEPENDENCY ${_header}
      )
      list(APPEND ${_sources} ${_src} ${_moc} )

   endforeach (_current_FILE)
endmacro (KDE4_ADD_UI3_FILES)


macro (KDE4_AUTOMOC)
   qt4_get_moc_inc_dirs(_moc_INCS)

   set(_matching_FILES )
   foreach (_current_FILE ${ARGN})

      get_filename_component(_abs_FILE ${_current_FILE} ABSOLUTE)
      # if "SKIP_AUTOMOC" is set to true, we will not handle this file here.
      # here. this is required to make bouic work correctly:
      # we need to add generated .cpp files to the sources (to compile them),
      # but we cannot let automoc handle them, as the .cpp files don't exist yet when
      # cmake is run for the very first time on them -> however the .cpp files might
      # exist at a later run. at that time we need to skip them, so that we don't add two
      # different rules for the same moc file
      get_source_file_property(_skip ${_abs_FILE} SKIP_AUTOMOC)

      if (EXISTS ${_abs_FILE} AND NOT _skip)

         file(READ ${_abs_FILE} _contents)

         get_filename_component(_abs_PATH ${_abs_FILE} PATH)

         string(REGEX MATCHALL "#include +[^ ]+\\.moc[\">]" _match "${_contents}")
         if (_match)
            foreach (_current_MOC_INC ${_match})
               string(REGEX MATCH "[^ <\"]+\\.moc" _current_MOC "${_current_MOC_INC}")

               get_filename_component(_basename ${_current_MOC} NAME_WE)
               set(_header ${_abs_PATH}/${_basename}.h)
               set(_moc    ${CMAKE_CURRENT_BINARY_DIR}/${_current_MOC})

               if (NOT EXISTS ${_abs_PATH}/${_basename}.h)
                  message(FATAL_ERROR "In the file \"${_abs_FILE}\" the moc file \"${_current_MOC}\" is included, but \"${_abs_PATH}/${_basename}.h\" doesn't exist.")
               endif (NOT EXISTS ${_abs_PATH}/${_basename}.h)

               add_custom_command(OUTPUT ${_moc}
                  COMMAND ${QT_MOC_EXECUTABLE}
                  ARGS ${_moc_INCS} ${_header} -o ${_moc}
                  MAIN_DEPENDENCY ${_header}
               )

               macro_add_file_dependencies(${_abs_FILE} ${_moc})

            endforeach (_current_MOC_INC)
         endif (_match)

      endif (EXISTS ${_abs_FILE} AND NOT _skip)
   endforeach (_current_FILE)
endmacro (KDE4_AUTOMOC)


# only used internally by KDE4_INSTALL_ICONS
MACRO (_KDE4_ADD_ICON_INSTALL_RULE _install_SCRIPT _install_PATH _group _orig_NAME _install_NAME)

   # if the string doesn't match the pattern, the result is the full string, so all three have the same content
   IF (NOT ${_group} STREQUAL ${_install_NAME} )
      SET(_icon_GROUP "actions")

      IF (${_group} STREQUAL "mime")
         SET(_icon_GROUP  "mimetypes")
      ENDIF (${_group} STREQUAL "mime")

      IF (${_group} STREQUAL "filesys")
         SET(_icon_GROUP  "filesystems")
      ENDIF (${_group} STREQUAL "filesys")

      IF (${_group} STREQUAL "device")
         SET(_icon_GROUP  "devices")
      ENDIF (${_group} STREQUAL "device")

      IF (${_group} STREQUAL "app")
         SET(_icon_GROUP  "apps")
      ENDIF (${_group} STREQUAL "app")

      IF (${_group} STREQUAL "action")
         SET(_icon_GROUP  "actions")
      ENDIF (${_group} STREQUAL "action")

#      message(STATUS "icon: ${_current_ICON} size: ${_size} group: ${_group} name: ${_name}" )
   INSTALL(FILES ${_orig_NAME} DESTINATION ${_install_PATH}/${_icon_GROUP}/ RENAME ${_install_NAME} )
   ENDIF (NOT ${_group} STREQUAL ${_install_NAME} )

ENDMACRO (_KDE4_ADD_ICON_INSTALL_RULE)


macro (KDE4_INSTALL_ICONS _defaultpath )

   # first the png icons
   file(GLOB _icons *.png)
   foreach (_current_ICON ${_icons} )
      string(REGEX REPLACE "^.*/([a-zA-Z]+)([0-9]+)\\-([a-z]+)\\-(.+\\.png)$" "\\1" _type  "${_current_ICON}")
      string(REGEX REPLACE "^.*/([a-zA-Z]+)([0-9]+)\\-([a-z]+)\\-(.+\\.png)$" "\\2" _size  "${_current_ICON}")
      string(REGEX REPLACE "^.*/([a-zA-Z]+)([0-9]+)\\-([a-z]+)\\-(.+\\.png)$" "\\3" _group "${_current_ICON}")
      string(REGEX REPLACE "^.*/([a-zA-Z]+)([0-9]+)\\-([a-z]+)\\-(.+\\.png)$" "\\4" _name  "${_current_ICON}")
      set(_theme_GROUP "nogroup")
      if( ${_type} STREQUAL "cr" )
	set(_theme_GROUP  "crystalsvg")	
      endif(${_type} STREQUAL "cr" )

      if( ${_type} STREQUAL "lo" )
      	set(_theme_GROUP  "locolor")
      endif(${_type} STREQUAL "lo" )

      if( ${_type} STREQUAL "hi" )
 	set(_theme_GROUP  "hicolor")
      endif(${_type} STREQUAL "hi" )
      
      if( NOT ${_theme_GROUP} STREQUAL "nogroup")
      		_KDE4_ADD_ICON_INSTALL_RULE(${CMAKE_CURRENT_BINARY_DIR}/install_icons.cmake
                    ${_defaultpath}/${_theme_GROUP}/${_size}x${_size}
                    ${_group} ${_current_ICON} ${_name})
      endif( NOT ${_theme_GROUP} STREQUAL "nogroup")

   endforeach (_current_ICON)

   # mng icons
   file(GLOB _icons *.mng)
   foreach (_current_ICON ${_icons} )
      STRING(REGEX REPLACE "^.*/([a-zA-Z]+)([0-9]+)\\-([a-z]+)\\-(.+\\.mng)$" "\\1" _type  "${_current_ICON}")
      STRING(REGEX REPLACE "^.*/([a-zA-Z]+)([0-9]+)\\-([a-z]+)\\-(.+\\.mng)$" "\\2" _size  "${_current_ICON}")
      STRING(REGEX REPLACE "^.*/([a-zA-Z]+)([0-9]+)\\-([a-z]+)\\-(.+\\.mng)$" "\\3" _group "${_current_ICON}")
      STRING(REGEX REPLACE "^.*/([a-zA-Z]+)([0-9]+)\\-([a-z]+)\\-(.+\\.mng)$" "\\4" _name  "${_current_ICON}")
      SET(_theme_GROUP "nogroup")
      if( ${_type} STREQUAL "cr" )
	SET(_theme_GROUP  "crystalsvg")
      endif(${_type} STREQUAL "cr" )
      
      if( ${_type} STREQUAL "lo" )
        set(_theme_GROUP  "locolor")
      endif(${_type} STREQUAL "lo" )

      if( ${_type} STREQUAL "hi" )
        set(_theme_GROUP  "hicolor")
      endif(${_type} STREQUAL "hi" )

      if( NOT ${_theme_GROUP} STREQUAL "nogroup")
        	_KDE4_ADD_ICON_INSTALL_RULE(${CMAKE_CURRENT_BINARY_DIR}/install_icons.cmake
                ${_defaultpath}/${_theme_GROUP}/${_size}x${_size}
                ${_group} ${_current_ICON} ${_name})
      endif( NOT ${_theme_GROUP} STREQUAL "nogroup")

   endforeach (_current_ICON)


   # and now the svg icons
   file(GLOB _icons *.svgz)
   foreach (_current_ICON ${_icons} )
	    STRING(REGEX REPLACE "^.*/([a-zA-Z]+)sc\\-([a-z]+)\\-(.+\\.svgz)$" "\\1" _type "${_current_ICON}")
            STRING(REGEX REPLACE "^.*/([a-zA-Z]+)sc\\-([a-z]+)\\-(.+\\.svgz)$" "\\2" _group "${_current_ICON}")
            STRING(REGEX REPLACE "^.*/([a-zA-Z]+)sc\\-([a-z]+)\\-(.+\\.svgz)$" "\\3" _name "${_current_ICON}")
	    SET(_theme_GROUP "nogroup")

	    if(${_type} STREQUAL "lo" )
		SET(_theme_GROUP  "locolor")
	    endif(${_type} STREQUAL "lo" )

            if(${_type} STREQUAL "cr" )
		SET(_theme_GROUP  "crystalsvg")
            endif(${_type} STREQUAL "cr" )
            
            if(${_type} STREQUAL "hi" )
                SET(_theme_GROUP  "hicolor")
            endif(${_type} STREQUAL "hi" )

            if( NOT ${_theme_GROUP} STREQUAL "nogroup")
                	_KDE4_ADD_ICON_INSTALL_RULE(${CMAKE_CURRENT_BINARY_DIR}/install_icons.cmake
                                 ${_defaultpath}/${_theme_GROUP}/scalable
                                 ${_group} ${_current_ICON} ${_name})
            endif( NOT ${_theme_GROUP} STREQUAL "nogroup")

   endforeach (_current_ICON)

endmacro (KDE4_INSTALL_ICONS)


MACRO (KDE4_INSTALL_LIBTOOL_FILE _subdir _target)
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

   INSTALL(FILES ${_laname} DESTINATION ${_subdir})
ENDMACRO (KDE4_INSTALL_LIBTOOL_FILE)


# For all C++ sources a big source file which includes all the files
# is created.
# This is not done for the C sources, they are just gathered in a separate list
# because they are usually not written by KDE and as such not intended to be 
# compiled all-in-one.
macro (KDE4_CREATE_FINAL_FILES _filenameCPP _filesC )
   set(${_filesC})
   file(WRITE ${_filenameCPP} "//autogenerated file\n")
   foreach (_current_FILE ${ARGN})
      string(REGEX MATCH ".+\\.c$" _isCFile ${_current_FILE})
      if (_isCFile)
         list(APPEND ${_filesC} ${_current_FILE})
      else (_isCFile)
         file(APPEND ${_filenameCPP} "#include \"${_current_FILE}\"\n")
      endif (_isCFile)
   endforeach (_current_FILE)

endmacro (KDE4_CREATE_FINAL_FILES)

# This macro sets the RPATH related options for libraries, plugins and kdeinit executables.
# It overrides the defaults set in FindKDE4Internal.cmake.
# If RPATH is not explicitely disabled, libraries and plugins are built without RPATH, in 
# the hope that the RPATH which is compiled into the executable is good enough.
macro (KDE4_HANDLE_RPATH_FOR_LIBRARY _target_NAME)
   if (NOT CMAKE_SKIP_RPATH)
       set_target_properties(${_target_NAME} PROPERTIES SKIP_BUILD_RPATH TRUE BUILD_WITH_INSTALL_RPATH TRUE INSTALL_RPATH "")
   endif (NOT CMAKE_SKIP_RPATH)
endmacro (KDE4_HANDLE_RPATH_FOR_LIBRARY)

# This macro sets the RPATH related options for executables
# and creates wrapper shell scripts for the executables.
# It overrides the defaults set in FindKDE4Internal.cmake.
# For every executable a wrapper script is created, which sets the appropriate
# environment variable for the platform (LD_LIBRARY_PATH on most UNIX systems, 
# DYLD_LIBRARY_PATH on OS X and PATH in Windows) so  that it points to the built
# but not yet installed versions of the libraries. So if RPATH is disabled, the executables
# can be run via these scripts from the build tree and will find the correct libraries.
# If RPATH is not disabled, these scripts are also used but only for consistency, because
# they don't really influence anything then, because the compiled-in RPATH overrides
# the LD_LIBRARY_PATH env. variable.
# Executables with the RUN_UNINSTALLED option will be built with the RPATH pointing to the
# build dir, so that they can be run safely without being installed, e.g. as code generators
# for other stuff during the build. These executables will be relinked during "make install".
# All other executables are built with the RPATH with which they will be installed.
macro (KDE4_HANDLE_RPATH_FOR_EXECUTABLE _target_NAME _type)
   if (UNIX)

      # set the RPATH related properties
      if (NOT CMAKE_SKIP_RPATH)
         if (${_type} STREQUAL "GUI")
            set_target_properties(${_target_NAME} PROPERTIES SKIP_BUILD_RPATH TRUE BUILD_WITH_INSTALL_RPATH TRUE)
         endif (${_type} STREQUAL "GUI")
      
         if (${_type} STREQUAL "NOGUI")
            set_target_properties(${_target_NAME} PROPERTIES SKIP_BUILD_RPATH TRUE BUILD_WITH_INSTALL_RPATH TRUE)
         endif (${_type} STREQUAL "NOGUI")
      
         if (${_type} STREQUAL "RUN_UNINSTALLED")
            set_target_properties(${_target_NAME} PROPERTIES SKIP_BUILD_RPATH FALSE BUILD_WITH_INSTALL_RPATH FALSE)
         endif (${_type} STREQUAL "RUN_UNINSTALLED")
      endif (NOT CMAKE_SKIP_RPATH)

      if (APPLE)
         set(_library_path_variable "DYLD_LIBRARY_PATH")
      else (APPLE)
         set(_library_path_variable "LD_LIBRARY_PATH")
      endif (APPLE)

      set(_ld_library_path "${LIBRARY_OUTPUT_PATH}/${CMAKE_CFG_INTDIR}/:${LIB_INSTALL_DIR}:${KDE4_LIB_DIR}:${QT_LIBRARY_DIR}")
      get_target_property(_executable ${_target_NAME} LOCATION )

      # use add_custom_target() to have the sh-wrapper generated during build time instead of cmake time
      add_custom_command(TARGET ${_target_NAME} POST_BUILD
         COMMAND ${CMAKE_COMMAND}
         -D_filename=${_executable}.shell -D_library_path_variable=${_library_path_variable}
         -D_ld_library_path="${_ld_library_path}" -D_executable=${_executable}
         -P ${KDE4_MODULE_DIR}/kde4_exec_via_sh.cmake
         )

      macro_additional_clean_files(${_executable}.shell)

      # under UNIX, set the property WRAPPER_SCRIPT to the name of the generated shell script
      # so it can be queried and used later on easily
      set_target_properties(${_target_NAME} PROPERTIES WRAPPER_SCRIPT ${_executable}.shell)

   else (UNIX)
      # under windows, set the property WRAPPER_SCRIPT just to the name of the executable
      # maybe later this will change to a generated batch file (for setting the PATH so that the Qt libs are found)
      get_target_property(_executable ${_target_NAME} LOCATION )
      set_target_properties(${_target_NAME} PROPERTIES WRAPPER_SCRIPT ${_executable})
      
      set(_ld_library_path "${LIBRARY_OUTPUT_PATH}/${CMAKE_CFG_INTDIR}/;${LIB_INSTALL_DIR};${KDE4_LIB_DIR};${QT_LIBRARY_DIR}")
      get_target_property(_executable ${_target_NAME} LOCATION )
      
       # use add_custom_target() to have the batch-file-wrapper generated during build time instead of cmake time
      add_custom_command(TARGET ${_target_NAME} POST_BUILD
         COMMAND ${CMAKE_COMMAND}
         -D_filename="${_executable}.bat"
         -D_ld_library_path="${_ld_library_path}" -D_executable="${_executable}"
         -P ${KDE4_MODULE_DIR}/kde4_exec_via_sh.cmake
         )
      
   endif (UNIX)
endmacro (KDE4_HANDLE_RPATH_FOR_EXECUTABLE)


macro (KDE4_ADD_PLUGIN _target_NAME _with_PREFIX)
#is the first argument is "WITH_PREFIX" then keep the standard "lib" prefix, otherwise set the prefix empty
   if (${_with_PREFIX} STREQUAL "WITH_PREFIX")
      set(_first_SRC)
   else (${_with_PREFIX} STREQUAL "WITH_PREFIX")
      set(_first_SRC ${_with_PREFIX})
   endif (${_with_PREFIX} STREQUAL "WITH_PREFIX")

   if (KDE4_ENABLE_FINAL)
      kde4_create_final_files(${_target_NAME}_final_cpp.cpp _c_files ${_first_SRC} ${ARGN})
      add_library(${_target_NAME} MODULE  ${_target_NAME}_final_cpp.cpp ${_c_files})
   else (KDE4_ENABLE_FINAL)
      add_library(${_target_NAME} MODULE ${_first_SRC} ${ARGN})
   endif (KDE4_ENABLE_FINAL)

   if (_first_SRC)
      set_target_properties(${_target_NAME} PROPERTIES PREFIX "")
   endif (_first_SRC)

   kde4_handle_rpath_for_library(${_target_NAME})

   if (WIN32)
      # for shared libraries/plugins a -DMAKE_target_LIB is required
      string(TOUPPER ${_target_NAME} _symbol)
      set(_symbol "MAKE_${_symbol}_LIB")
      set_target_properties(${_target_NAME} PROPERTIES DEFINE_SYMBOL ${_symbol})
   endif (WIN32)

endmacro (KDE4_ADD_PLUGIN _target_NAME _with_PREFIX)


# this macro checks is intended to check whether a list of source
# files has the "NOGUI" or "RUN_UNINSTALLED" keywords at the beginning
# in _output_LIST the list of source files is returned with the "NOGUI"
# and "RUN_UNINSTALLED" keywords removed
# if "NOGUI" is in the list of files, the _nogui argument is set to 
# "NOGUI" (which evaluates to TRUE in cmake), otherwise it is set empty
# (which evaluates to FALSE in cmake)
# if "RUN_UNINSTALLED" is in the list of files, the _uninst argument is set to 
# "RUN_UNINSTALLED" (which evaluates to TRUE in cmake), otherwise it is set empty
# (which evaluates to FALSE in cmake)
macro(KDE4_CHECK_EXECUTABLE_PARAMS _output_LIST _nogui _uninst)
   set(${_nogui})  
   set(${_uninst})
   set(${_output_LIST} ${ARGN})
   list(LENGTH ${_output_LIST} count)

   list(GET ${_output_LIST} 0 first_PARAM)

   set(second_PARAM "NOTFOUND")
   if (${count} GREATER 1)
      list(GET ${_output_LIST} 1 second_PARAM)
   endif (${count} GREATER 1)

   set(remove "NOTFOUND")

   if (${first_PARAM} STREQUAL "NOGUI")
      set(${_nogui} "NOGUI")
      set(remove 0)
   endif (${first_PARAM} STREQUAL "NOGUI")

   if (${second_PARAM} STREQUAL "NOGUI")
      set(${_nogui} "NOGUI")
      set(remove 0;1)
   endif (${second_PARAM} STREQUAL "NOGUI")

   if (${first_PARAM} STREQUAL "RUN_UNINSTALLED")
      set(${_uninst} "RUN_UNINSTALLED")
      set(remove 0)   
   endif (${first_PARAM} STREQUAL "RUN_UNINSTALLED")

   if (${second_PARAM} STREQUAL "RUN_UNINSTALLED")
      set(${_uninst} "RUN_UNINSTALLED")
      set(remove 0;1)
   endif (${second_PARAM} STREQUAL "RUN_UNINSTALLED")

   if (NOT "${remove}" STREQUAL "NOTFOUND")
      list(REMOVE_AT ${_output_LIST} ${remove})
   endif (NOT "${remove}" STREQUAL "NOTFOUND")

endmacro(KDE4_CHECK_EXECUTABLE_PARAMS)


macro (KDE4_ADD_KDEINIT_EXECUTABLE _target_NAME )

   kde4_check_executable_params(_SRCS _nogui _uninst ${ARGN})
   configure_file(${KDE4_MODULE_DIR}/kde4init_dummy.cpp.in ${CMAKE_CURRENT_BINARY_DIR}/${_target_NAME}_dummy.cpp)
   #MACRO_ADDITIONAL_CLEAN_FILES(${CMAKE_CURRENT_BINARY_DIR}/${_target_NAME}_dummy.cpp)

#   if (WIN32)
#      # under windows, just build a normal executable
#      KDE4_ADD_EXECUTABLE(${_target_NAME} ${CMAKE_CURRENT_BINARY_DIR}/${_target_NAME}_dummy.cpp ${ARGN} )
#   else (WIN32)
      # under UNIX, create a shared library and a small executable, which links to this library
   if (KDE4_ENABLE_FINAL)
      kde4_create_final_files(${_target_NAME}_final_cpp.cpp _c_files ${_SRCS})
      add_library(kdeinit_${_target_NAME} SHARED  ${_target_NAME}_final_cpp.cpp ${_c_files})

   else (KDE4_ENABLE_FINAL)
      add_library(kdeinit_${_target_NAME} SHARED ${_SRCS} )
   endif (KDE4_ENABLE_FINAL)

   kde4_handle_rpath_for_library(kdeinit_${_target_NAME})

   kde4_add_executable(${_target_NAME} "${_nogui}" "${_uninst}" ${CMAKE_CURRENT_BINARY_DIR}/${_target_NAME}_dummy.cpp)
   target_link_libraries(${_target_NAME} kdeinit_${_target_NAME})
#   endif (WIN32)

endmacro (KDE4_ADD_KDEINIT_EXECUTABLE)

macro (KDE4_ADD_EXECUTABLE _target_NAME)

   kde4_check_executable_params( _SRCS _nogui _uninst ${ARGN})

   set(_add_executable_param)
   set(_type "GUI")

   # determine additional parameters for add_executable()
   if (APPLE)
      set(_add_executable_param MACOSX_BUNDLE)
   endif (APPLE)
# should this be enabled on windows ? Alex
#   if (WIN32)
#      set(_add_executable_param WIN32)
#   endif (WIN32)

   if (_nogui)
      set(_type "NOGUI")
      set(_add_executable_param)
   endif (_nogui)
   
   if (_uninst)
      set(_type "RUN_UNINSTALLED")
   endif (_uninst)

   if (KDE4_ENABLE_FINAL)
      kde4_create_final_files(${_target_NAME}_final_cpp.cpp ${_c_files} ${_SRCS})
      add_executable(${_target_NAME} ${_add_executable_param} ${_target_NAME}_final_cpp.cpp ${_c_files})
   else (KDE4_ENABLE_FINAL)
      add_executable(${_target_NAME} ${_add_executable_param} ${_SRCS} )
   endif (KDE4_ENABLE_FINAL)

   kde4_handle_rpath_for_executable(${_target_NAME} ${_type})

endmacro (KDE4_ADD_EXECUTABLE)


MACRO (KDE4_ADD_LIBRARY _target_NAME _lib_TYPE)
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
      kde4_create_final_files(${_target_NAME}_final_cpp.cpp _c_files ${_first_SRC} ${ARGN})
      add_library(${_target_NAME} ${_add_lib_param}  ${_target_NAME}_final_cpp.cpp ${_c_files})
   else (KDE4_ENABLE_FINAL)
      add_library(${_target_NAME} ${_add_lib_param} ${_first_SRC} ${ARGN})
   endif (KDE4_ENABLE_FINAL)

   kde4_handle_rpath_for_library(${_target_NAME})

   if (WIN32)
      # for shared libraries a -DMAKE_target_LIB is required
      string(TOUPPER ${_target_NAME} _symbol)
      set(_symbol "MAKE_${_symbol}_LIB")
      set_target_properties(${_target_NAME} PROPERTIES DEFINE_SYMBOL ${_symbol})
   endif (WIN32)

ENDMACRO (KDE4_ADD_LIBRARY _target_NAME _lib_TYPE)


macro (KDE4_ADD_WIDGET_FILES _sources)
   foreach (_current_FILE ${ARGN})

      get_filename_component(_input ${_current_FILE} ABSOLUTE)
      get_filename_component(_basename ${_input} NAME_WE)
      set(_source ${CMAKE_CURRENT_BINARY_DIR}/${_basename}widgets.cpp)
      set(_moc ${CMAKE_CURRENT_BINARY_DIR}/${_basename}widgets.moc)

      # create source file from the .widgets file
      add_custom_command(OUTPUT ${_source}
        COMMAND ${KDE4_MAKEKDEWIDGETS_EXECUTABLE}
        ARGS -o ${_source} ${_input}
        MAIN_DEPENDENCY ${_input} DEPENDS ${_KDE4_MAKEKDEWIDGETS_DEP})

      # create moc file
      qt4_generate_moc(${_source} ${_moc} )

      list(APPEND ${_sources} ${_source} ${_moc})

   endforeach (_current_FILE)

endmacro (KDE4_ADD_WIDGET_FILES)

MACRO(KDE4_ADD_DCOP_SKELS)
   MESSAGE(FATAL_ERROR "There is a call to KDE4_ADD_DCOP_SKELS() in the CMakeLists.txt for '${ARGV0}', but DCOP is no longer supported by KDE4.
 Please remove it and port to DBUS.")
ENDMACRO(KDE4_ADD_DCOP_SKELS)

MACRO(KDE4_ADD_DCOP_STUBS)
   MESSAGE(FATAL_ERROR "There is a call to KDE4_ADD_DCOP_STUBS() in the CMakeLists.txt for '${ARGV0}', but DCOP is no longer supported by KDE4.
 Please remove it and port to DBUS.")
ENDMACRO(KDE4_ADD_DCOP_STUBS)

MACRO(KDE4_REMOVE_OBSOLETE_CMAKE_FILES)
# the files listed here will be removed by remove_obsoleted_cmake_files.cmake, Alex
   install(SCRIPT ${CMAKE_CURRENT_BINARY_DIR}/remove_files.cmake )
   set(module_install_dir ${DATA_INSTALL_DIR}/cmake/modules )

   file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/remove_files.cmake "#generated by cmake, dont edit\n\n")
   foreach ( _current_FILE ${ARGN})
      file(APPEND ${CMAKE_CURRENT_BINARY_DIR}/remove_files.cmake "message(STATUS \"Removing ${module_install_dir}/${_current_FILE}\" )\n" )
      file(APPEND ${CMAKE_CURRENT_BINARY_DIR}/remove_files.cmake "exec_program( ${CMAKE_COMMAND} ARGS -E remove ${module_install_dir}/${_current_FILE} OUTPUT_VARIABLE _dummy)\n" )
   endforeach ( _current_FILE)

ENDMACRO(KDE4_REMOVE_OBSOLETE_CMAKE_FILES)
