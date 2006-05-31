#
# QtDBus macros, documentation see FindQtDBus.cmake
#

macro(qdbus_add_interfaces _sources)
   foreach (_i ${ARGN})
      get_filename_component(_xml_file ${_i} ABSOLUTE)
      get_filename_component(_basename ${_i} NAME_WE)
      set(_target_base ${CMAKE_CURRENT_BINARY_DIR}/${_basename})

      add_custom_command(OUTPUT ${_target_base}.cpp ${_target_base}.h 
         COMMAND ${QDBUS_IDL2CPP_EXECUTABLE}
         ARGS -m -p ${_basename} ${_xml_file}
         DEPENDS ${_xml_file}
      )

      qt4_generate_moc(${_target_base}.h ${_target_base}.moc)
      macro_add_file_dependencies(${_target_base}.h ${_target_base}.moc )

      set(${_sources} ${${_sources}} ${_target_base}.cpp)
   endforeach (_i ${ARGN})
endmacro(qdbus_add_interfaces)
