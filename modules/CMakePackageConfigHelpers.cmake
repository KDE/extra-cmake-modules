
include(${CMAKE_ROOT}/Modules/CMakePackageConfigHelpers.cmake)

# This file is a hack to add the find_dependency macro to config files. It
# will be in a future version of CMake, so we fork the configure_package_config_file
# function until we depend on that version of CMake.

if(NOT CMAKE_MINIMUM_REQUIRED_VERSION VERSION_LESS 2.8.13)
  message(FATAL_ERROR "Remove this file. The find_dependency macro or something
 like it should be in cmake by now.")
endif()

function(CONFIGURE_PACKAGE_CONFIG_FILE _inputFile _outputFile)
  set(options NO_SET_AND_CHECK_MACRO NO_CHECK_REQUIRED_COMPONENTS_MACRO)
  set(oneValueArgs INSTALL_DESTINATION )
  set(multiValueArgs PATH_VARS )

  cmake_parse_arguments(CCF "${options}" "${oneValueArgs}" "${multiValueArgs}"  ${ARGN})

  if(CCF_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "Unknown keywords given to CONFIGURE_PACKAGE_CONFIG_FILE(): \"${CCF_UNPARSED_ARGUMENTS}\"")
  endif()

  if(NOT CCF_INSTALL_DESTINATION)
    message(FATAL_ERROR "No INSTALL_DESTINATION given to CONFIGURE_PACKAGE_CONFIG_FILE()")
  endif()

  if(IS_ABSOLUTE "${CCF_INSTALL_DESTINATION}")
    set(absInstallDir "${CCF_INSTALL_DESTINATION}")
  else()
    set(absInstallDir "${CMAKE_INSTALL_PREFIX}/${CCF_INSTALL_DESTINATION}")
  endif()

  file(RELATIVE_PATH PACKAGE_RELATIVE_PATH "${absInstallDir}" "${CMAKE_INSTALL_PREFIX}" )

  foreach(var ${CCF_PATH_VARS})
    if(NOT DEFINED ${var})
      message(FATAL_ERROR "Variable ${var} does not exist")
    else()
      if(IS_ABSOLUTE "${${var}}")
        string(REPLACE "${CMAKE_INSTALL_PREFIX}" "\${PACKAGE_PREFIX_DIR}"
                        PACKAGE_${var} "${${var}}")
      else()
        set(PACKAGE_${var} "\${PACKAGE_PREFIX_DIR}/${${var}}")
      endif()
    endif()
  endforeach()

  get_filename_component(inputFileName "${_inputFile}" NAME)

  set(PACKAGE_INIT "
####### Expanded from @PACKAGE_INIT@ by configure_package_config_file() #######
####### Any changes to this file will be overwritten by the next CMake run ####
####### The input file was ${inputFileName}                            ########

get_filename_component(PACKAGE_PREFIX_DIR \"\${CMAKE_CURRENT_LIST_DIR}/${PACKAGE_RELATIVE_PATH}\" ABSOLUTE)
")

  if("${absInstallDir}" MATCHES "^(/usr)?/lib(64)?/.+")
    # Handle "/usr move" symlinks created by some Linux distros.
    set(PACKAGE_INIT "${PACKAGE_INIT}
# Use original install prefix when loaded through a \"/usr move\"
# cross-prefix symbolic link such as /lib -> /usr/lib.
get_filename_component(_realCurr \"\${CMAKE_CURRENT_LIST_DIR}\" REALPATH)
get_filename_component(_realOrig \"${absInstallDir}\" REALPATH)
if(_realCurr STREQUAL _realOrig)
  set(PACKAGE_PREFIX_DIR \"${CMAKE_INSTALL_PREFIX}\")
endif()
unset(_realOrig)
unset(_realCurr)
")
  endif()

  if(NOT CCF_NO_SET_AND_CHECK_MACRO)
    set(PACKAGE_INIT "${PACKAGE_INIT}
macro(set_and_check _var _file)
  set(\${_var} \"\${_file}\")
  if(NOT EXISTS \"\${_file}\")
    message(FATAL_ERROR \"File or directory \${_file} referenced by variable \${_var} does not exist !\")
  endif()
endmacro()

macro(find_dependency dep version)
  if (NOT \${dep}_FOUND)

    set(exact_arg)
    if(\${CMAKE_FIND_PACKAGE_NAME}_FIND_VERSION_EXACT)
      set(exact_arg EXACT)
    endif()
    set(quiet_arg)
    if(\${CMAKE_FIND_PACKAGE_NAME}_FIND_QUIETLY)
      set(quiet_arg QUIET)
    endif()
    set(required_arg)
    if(\${CMAKE_FIND_PACKAGE_NAME}_FIND_REQUIRED)
      set(required_arg REQUIRED)
    endif()

    find_package(\${dep} \${version} \${exact_arg} \${quiet_arg} \${required_arg})
    if (NOT \${dep}_FOUND)
      set(\${CMAKE_FIND_PACKAGE_NAME}_NOT_FOUND_MESSAGE \"\${CMAKE_FIND_PACKAGE_NAME} could not be found because dependency \${dep} could not be found.\")
    endif()
    set(required_arg)
    set(quiet_arg)
    set(exact_arg)
  endif()
endmacro()

")
  endif()


  if(NOT CCF_NO_CHECK_REQUIRED_COMPONENTS_MACRO)
    set(PACKAGE_INIT "${PACKAGE_INIT}
macro(check_required_components _NAME)
  foreach(comp \${\${_NAME}_FIND_COMPONENTS})
    if(NOT \${_NAME}_\${comp}_FOUND)
      if(\${_NAME}_FIND_REQUIRED_\${comp})
        set(\${_NAME}_FOUND FALSE)
      endif()
    endif()
  endforeach()
endmacro()
")
  endif()

  set(PACKAGE_INIT "${PACKAGE_INIT}
####################################################################################")

  configure_file("${_inputFile}" "${_outputFile}" @ONLY)

endfunction()
