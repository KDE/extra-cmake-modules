#
# QtDBus macros, documentation see FindQtDBus.cmake
#

macro(qdbus_add_interfaces _sources)
   foreach (_i ${ARGN})
      get_filename_component(_xml_file ${_i} ABSOLUTE)
      string(REGEX REPLACE ".*\\.([^\\.]+)\\.xml$" "\\1" _basename ${_i})
      string(TOLOWER ${_basename} _basename)
      set(_target_base ${CMAKE_CURRENT_BINARY_DIR}/${_basename}interface)

      add_custom_command(OUTPUT ${_target_base}.cpp ${_target_base}.h 
         COMMAND ${QDBUS_IDL2CPP_EXECUTABLE}
         ARGS -m -p ${_target_base} ${_xml_file}
         DEPENDS ${_xml_file}
      )

      qt4_generate_moc(${_target_base}.h ${_target_base}.moc)
      macro_add_file_dependencies(${_target_base}.h ${_target_base}.moc )
      set_source_files_properties(${_target_base}.cpp PROPERTIES SKIP_AUTOMOC true)

      set(${_sources} ${${_sources}} ${_target_base}.cpp)
   endforeach (_i ${ARGN})
endmacro(qdbus_add_interfaces)

macro(qdbus_generate_interface _header)
   get_filename_component(_in_file ${_header} ABSOLUTE)
   get_filename_component(_basename ${_header} NAME_WE)
   set(_target ${CMAKE_CURRENT_BINARY_DIR}/${_basename}.xml)

   add_custom_command(OUTPUT ${_target}
      COMMAND ${QDBUS_CPP2XML_EXECUTABLE}
      ARGS ${_in_file} > ${_target}
      DEPENDS ${_in_file}
   )
endmacro(qdbus_generate_interface)

macro(qdbus_add_adaptors _sources)
   foreach (_i ${ARGN})
      get_filename_component(_xml_file ${_i} ABSOLUTE)
      string(REGEX REPLACE ".*\\.([^\\.]+)\\.xml$" "\\1" _basename ${_i})
      string(TOLOWER ${_basename} _basename)
      set(_target_base ${CMAKE_CURRENT_BINARY_DIR}/${_basename}adaptor)

      add_custom_command(OUTPUT ${_target_base}.cpp ${_target_base}.h
         COMMAND ${QDBUS_IDL2CPP_EXECUTABLE}
         ARGS -m -a ${_basename}adaptor ${_xml_file}
         DEPENDS ${_xml_file}
      )

      qt4_generate_moc(${_target_base}.h ${_target_base}.moc)
      macro_add_file_dependencies(${_target_base}.h ${_target_base}.moc)
      set_source_files_properties(${_target_base}.cpp PROPERTIES SKIP_AUTOMOC true)

      set(${_sources} ${${_sources}} ${_target_base}.cpp)
   endforeach (_i ${ARGN})
endmacro(qdbus_add_adaptors)
