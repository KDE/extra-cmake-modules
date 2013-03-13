
find_package(Qt5Core QUIET)

if (Qt5Core_FOUND)
  if (NOT Qt5Transitional_FIND_COMPONENTS)
    set(_components
        Core
        Gui
        DBus
        Designer
        Declarative
        Script
        ScriptTools
        Network
        Test
        Xml
        Svg
        Sql
        Widgets
        PrintSupport
        Concurrent
        UiTools
        WebKit
        WebKitWidgets
        OpenGL
      )
    foreach(_component ${_components})
      find_package(Qt5${_component})

      list(APPEND QT_LIBRARIES ${Qt5${_component}_LIBRARIES})
    endforeach()
  else()
    set(_components ${Qt5Transitional_FIND_COMPONENTS})
    foreach(_component ${Qt5Transitional_FIND_COMPONENTS})
      find_package(Qt5${_component} REQUIRED)
      if ("${_component}" STREQUAL "WebKit")
        find_package(Qt5WebKitWidgets REQUIRED)
        list(APPEND QT_LIBRARIES ${Qt5WebKitWidgets_LIBRARIES} )
      endif()
      if ("${_component}" STREQUAL "Gui")
        find_package(Qt5Widgets REQUIRED)
        find_package(Qt5PrintSupport REQUIRED)
        find_package(Qt5Svg REQUIRED)
        list(APPEND QT_LIBRARIES ${Qt5Widgets_LIBRARIES}
                                 ${Qt5PrintSupport_LIBRARIES}
                                 ${Qt5Svg_LIBRARIES} )
      endif()
      if ("${_component}" STREQUAL "Core")
        find_package(Qt5Concurrent REQUIRED)
        list(APPEND QT_LIBRARIES ${Qt5Concurrent_LIBRARIES} )
      endif()
    endforeach()
  endif()

  set(Qt5Transitional_FOUND TRUE)
  set(QT5_BUILD TRUE)

  # Temporary until upstream does this:
  foreach(_component ${_components})
    if (TARGET Qt5::${_component})
      set_property(TARGET Qt5::${_component}
        APPEND PROPERTY
          INTERFACE_INCLUDE_DIRECTORIES ${Qt5${_component}_INCLUDE_DIRS})
      set_property(TARGET Qt5::${_component}
        APPEND PROPERTY
          INTERFACE_COMPILE_DEFINITIONS ${Qt5${_component}_COMPILE_DEFINITIONS})
    endif()
  endforeach()

  set_property(TARGET Qt5::Core
        PROPERTY
          INTERFACE_POSITION_INDEPENDENT_CODE ON
  )

  if (WIN32 AND NOT Qt5_NO_LINK_QTMAIN)
      set(_isExe $<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>)
      set(_isWin32 $<BOOL:$<TARGET_PROPERTY:WIN32_EXECUTABLE>>)
      set(_isNotExcluded $<NOT:$<BOOL:$<TARGET_PROPERTY:Qt5_NO_LINK_QTMAIN>>>)
      get_target_property(_configs Qt5::Core IMPORTED_CONFIGURATIONS)
      foreach(_config ${_configs})
          set_property(TARGET Qt5::Core APPEND PROPERTY
              IMPORTED_LINK_INTERFACE_LIBRARIES_${_config}
                  $<$<AND:${_isExe},${_isWin32},${_isNotExcluded}>:Qt5::WinMain>
          )
      endforeach()
      unset(_configs)
      unset(_isExe)
      unset(_isWin32)
      unset(_isNotExcluded)
  endif()
  # End upstreamed stuff.

  get_filename_component(_modules_dir "${CMAKE_CURRENT_LIST_DIR}/../modules" ABSOLUTE)
  include("${_modules_dir}/ECMQt4To5Porting.cmake") # TODO: Port away from this.
  include_directories(${QT_INCLUDES}) # TODO: Port away from this.

  if (Qt5_POSITION_INDEPENDENT_CODE)
    set(CMAKE_POSITION_INDEPENDENT_CODE ON)
  endif()

else()
  foreach(_component ${Qt5Transitional_FIND_COMPONENTS})
    if("${_component}" STREQUAL "Widgets")  # new in Qt5
      set(_component Gui)
    elseif("${_component}" STREQUAL "Concurrent")   # new in Qt5
      set(_component Core)
    endif()
    list(APPEND _components Qt${_component})
  endforeach()
  find_package(Qt4 ${QT_MIN_VERSION} REQUIRED ${_components})
  include_directories(${QT_INCLUDES})

  if(QT4_FOUND)
    set(Qt5Transitional_FOUND TRUE)
  endif()
endif()
