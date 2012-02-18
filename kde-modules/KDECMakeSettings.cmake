# KDE_SKIP_RPATH_SETTINGS


################# RPATH handling ##################################

if(NOT KDE_SKIP_RPATH_SETTINGS)

   if(NOT LIB_INSTALL_DIR)
      message(FATAL_ERROR "LIB_INSTALL_DIR not set. This is necessary for using the RPATH settings.")
   endif()

   # setup default RPATH/install_name handling, may be overridden by KDE4_HANDLE_RPATH_FOR_EXECUTABLE
   # It sets up to build with full RPATH. When installing, RPATH will be changed to the LIB_INSTALL_DIR
   # and all link directories which are not inside the current build dir.
   if (UNIX)
      # the rest is RPATH handling
      # here the defaults are set
      # which are partly overwritten in kde4_handle_rpath_for_library()
      # and kde4_handle_rpath_for_executable(), both located in KDE4Macros.cmake, Alex
      if (APPLE)
         set(CMAKE_INSTALL_NAME_DIR ${LIB_INSTALL_DIR})
      else ()
         # add our LIB_INSTALL_DIR to the RPATH (but only when it is not one of the standard system link
         # directories listed in CMAKE_PLATFORM_IMPLICIT_LINK_DIRECTORIES) and use the RPATH figured out by cmake when compiling

         list(FIND CMAKE_PLATFORM_IMPLICIT_LINK_DIRECTORIES "${LIB_INSTALL_DIR}" _isSystemLibDir)
         if("${_isSystemLibDir}" STREQUAL "-1")
            set(CMAKE_INSTALL_RPATH "${LIB_INSTALL_DIR}")
         endif()

         set(CMAKE_SKIP_BUILD_RPATH FALSE)
         set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
         set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
      endif ()
   endif (UNIX)

endif()

###################################################################


