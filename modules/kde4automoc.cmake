# do the automoc handling 

# Copyright (c) 2006, Alexander Neundorf, <neundorf@kde.org>
# Copyright (c) 2007, Matthias Kretz, <kretz@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

macro (generate_moc _moc_source _current_MOC)
   set(_moc ${KDE4_CURRENT_BINARY_DIR}/${_current_MOC})

   if ("${_moc_source}" IS_NEWER_THAN "${_moc}" OR _force_moc)
      if($ENV{VERBOSE})
         message(STATUS "Automoc: Generating ${_moc} from ${_moc_source}")
      else($ENV{VERBOSE})
         message(STATUS "Generating ${_current_MOC}")
      endif($ENV{VERBOSE})
      execute_process(COMMAND ${QT_MOC_EXECUTABLE} ${QT_MOC_INCS} "${_moc_source}" -o "${_moc}")
   endif ("${_moc_source}" IS_NEWER_THAN "${_moc}" OR _force_moc)
endmacro (generate_moc)

STRING(REPLACE "\\ " " " MARK_FILE "${MARK_FILE}")
STRING(REPLACE "\\ " " " MOC_FILES "${MOC_FILES}")
STRING(REPLACE "\\ " " " QT_MOC_INCS "${QT_MOC_INCS}")
if (EXISTS "${MARK_FILE}")
   set(_force_moc FALSE)
else (EXISTS "${MARK_FILE}")
   set(_force_moc TRUE)
endif (EXISTS "${MARK_FILE}")
foreach(_filename ${MOC_FILES})
   get_filename_component(_name "${_filename}" NAME)

   get_filename_component(_abs_PATH "${_filename}" PATH)
   get_filename_component(_basename "${_filename}" NAME_WE)
   set(_moc_source ${_abs_PATH}/${_basename}.h)
   if ("${_filename}" IS_NEWER_THAN "${MARK_FILE}" OR "${_moc_source}" IS_NEWER_THAN "${MARK_FILE}")
      get_filename_component(_suffix "${_filename}" EXT)
      if (".cpp" STREQUAL "${_suffix}" OR ".cc" STREQUAL "${_suffix}" OR ".cxx" STREQUAL "${_suffix}" OR ".C" STREQUAL "${_suffix}")
         #message(STATUS "Automoc: Looking for outdated moc includes in ${_filename}")

         # read the whole file
         file(READ ${_filename} _contents)

         string(REGEX MATCHALL "#include +([\"<]moc_[^ ]+\\.cpp|[^ ]+\\.moc)[\">]" _match "${_contents}")
         if (_match)
            foreach (_current_MOC_INC ${_match})
               string(REGEX MATCH "[^ <\"]+\\.moc" _current_MOC "${_current_MOC_INC}")
               if(_current_MOC)
                  get_filename_component(_basename ${_current_MOC} NAME_WE)

                  # if the .cpp file contains the Q_OBJECT macro we create the .moc file from the .cpp file
                  if (_contents MATCHES "[\n\r][\t ]*Q_OBJECT")
                     set(_moc_source ${_filename})
                  else (_contents MATCHES "[\n\r][\t ]*Q_OBJECT")
                     set(_moc_source ${_abs_PATH}/${_basename}.h)
                  endif (_contents MATCHES "[\n\r][\t ]*Q_OBJECT")
               else(_current_MOC)
                  string(REGEX MATCH "moc_[^ <\"]+\\.cpp" _current_MOC "${_current_MOC_INC}")
                  get_filename_component(_basename ${_current_MOC} NAME_WE)
                  string(REPLACE "moc_" "" _basename "${_basename}")

                  # always create moc_foo.cpp from the .h
                  set(_moc_source ${_abs_PATH}/${_basename}.h)
               endif(_current_MOC)

               if (NOT EXISTS ${_moc_source})
                  message(FATAL_ERROR "In the file \"${_filename}\" the moc file \"${_current_MOC}\" is included, but \"${_moc_source}\" doesn't exist.")
               endif (NOT EXISTS ${_moc_source})

               generate_moc(${_moc_source} ${_current_MOC})
            endforeach (_current_MOC_INC)
         endif (_match)
      else (".cpp" STREQUAL "${_suffix}" OR ".cc" STREQUAL "${_suffix}" OR ".cxx" STREQUAL "${_suffix}" OR ".C" STREQUAL "${_suffix}")
         if (".h" STREQUAL "${_suffix}" OR ".hpp" STREQUAL "${_suffix}" OR ".hxx" STREQUAL "${_suffix}" OR ".H" STREQUAL "${_suffix}")
            get_filename_component(_basename ${_filename} NAME_WE)
            set(_current_MOC "moc_${_basename}.cpp")
            generate_moc(${_filename} ${_current_MOC})
         else (".h" STREQUAL "${_suffix}" OR ".hpp" STREQUAL "${_suffix}" OR ".hxx" STREQUAL "${_suffix}" OR ".H" STREQUAL "${_suffix}")
            if($ENV{VERBOSE})
               message(STATUS "Automoc: ignoring file '${_filename}' with unknown suffix '${_suffix}'")
            endif($ENV{VERBOSE})
         endif (".h" STREQUAL "${_suffix}" OR ".hpp" STREQUAL "${_suffix}" OR ".hxx" STREQUAL "${_suffix}" OR ".H" STREQUAL "${_suffix}")
      endif (".cpp" STREQUAL "${_suffix}" OR ".cc" STREQUAL "${_suffix}" OR ".cxx" STREQUAL "${_suffix}" OR ".C" STREQUAL "${_suffix}")
   endif ("${_filename}" IS_NEWER_THAN "${MARK_FILE}" OR "${_moc_source}" IS_NEWER_THAN "${MARK_FILE}")
endforeach(_filename)

# touch .mark file
#message(STATUS "touch ${MARK_FILE}")
file(WRITE "${MARK_FILE}" "")
