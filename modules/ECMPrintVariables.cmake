# - Convenience macro for printing the values of cmake variables, useful e.g. while debugging.
#
# ECM_PRINT_VARIABLES(var1 var2 .. varN)
#
# This macro will print the name of each variable followed by its value.
# Example:
#   ecm_print_variables(CMAKE_C_COMPILER CMAKE_MAJOR_VERSION THIS_ONE_DOES_NOT_EXIST)
# Gives:
#   -- CMAKE_C_COMPILER="/usr/bin/gcc" ; CMAKE_MAJOR_VERSION="2" ; THIS_ONE_DOES_NOT_EXIST=""

# Copyright 2011 Alexander Neundorf <neundorf@kde.org>
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.

function(ECM_PRINT_VARIABLES)
   set(msg "")
   foreach(var ${ARGN})
      if(msg)
         set(msg "${msg} ; ")
      endif()
      set(msg "${msg}${var}=\"${${var}}\"")
   endforeach()
   message(STATUS "${msg}")
endfunction()
