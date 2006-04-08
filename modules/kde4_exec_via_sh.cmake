
file(WRITE "${_filename}" 
"#!/bin/sh
# created by cmake, don't edit, changes will be lost

${_library_path_variable}=\"${_ld_library_path}\":$${_library_path_variable} ${_executable} $@
")

# make it executable
# since this is only executed on UNIX, it is safe to call chmod
exec_program(chmod ARGS 755 "${_filename}" OUTPUT_VARIABLE _dummy )
