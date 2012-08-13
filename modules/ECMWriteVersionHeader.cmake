# - Function for generating a version.h file
#
# The ECM_WRITE_VERSION_HEADER() function is used write a simple version header
# which contains macros for the major, minor and patch version numbers of the
# project. This version header then is usually installed.
# As version numbers the one set using ecm_version() is used.
function(ECM_WRITE_VERSION_HEADER _filename)

   string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPER)

   if(IS_ABSOLUTE "${_filename}")
      set(absFilename "${_filename}")
   else()
      set(absFilename "${CMAKE_CURRENT_BINARY_DIR}/${_filename}")
   endif()

   configure_file(
      "${ECM_MODULE_DIR}/ECMVersionHeader.h.in"
      "${absFilename}"
#      "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}_version.h"
   )
endfunction()
