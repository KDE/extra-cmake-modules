# - Try to find Strigi, a fast and small desktop search program (http://strigi.sourceforge.net )
# Once done this will define
#
#  STRIGI_FOUND - system has Strigi
#  STRIGI_INCLUDE_DIR - the Strigi include directory
#  STRIGI_STREAMANALYZER_LIBRARY - Link these to use Strigi streamanalyzer
#  STRIGI_STREAMS_LIBRARY - Link these to use Strigi streams
#  STRIGI_LINE_ANALYZER_PREFIX - strigi plugin prefix
#  STRIGI_THROUGH_ANALYZER_PREFIX - strigi plugin prefix

# at first search only in the specified directories (NO_DEFAULT_PATH)
# only if it wasn't found there, the second call to FIND_PATH/LIBRARY() 
# will actually do something, Alex

include(FindLibraryWithDebug)

if(NOT STRIGI_MIN_VERSION)
  set(STRIGI_MIN_VERSION "0.5.9")
endif(NOT STRIGI_MIN_VERSION)

if (WIN32)
  file(TO_CMAKE_PATH "$ENV{PROGRAMFILES}" _program_FILES_DIR)
  string(REPLACE "\\" "/" _program_FILES_DIR "${_program_FILES_DIR}")
endif(WIN32)

string(REPLACE "\\" "/" strigi_home "$ENV{STRIGI_HOME}")

find_path(STRIGI_INCLUDE_DIR strigi/streamanalyzer.h
  PATHS
  ${strigi_home}/include
  ${_program_FILES_DIR}/strigi/include
  NO_DEFAULT_PATH
)

find_path(STRIGI_INCLUDE_DIR strigi/streamanalyzer.h)

find_library_with_debug(STRIGI_STREAMANALYZER_LIBRARY
  WIN32_DEBUG_POSTFIX d
  NAMES streamanalyzer
  PATHS
  ${strigi_home}/lib
  ${_program_FILES_DIR}/strigi/lib
  NO_DEFAULT_PATH
)

find_library_with_debug(STRIGI_STREAMANALYZER_LIBRARY  
                        WIN32_DEBUG_POSTFIX d  
                        NAMES streamanalyzer )


find_library_with_debug(STRIGI_STREAMS_LIBRARY
  WIN32_DEBUG_POSTFIX d
  NAMES streams
  PATHS
  ${strigi_home}/lib
  ${_program_FILES_DIR}/strigi/lib
  NO_DEFAULT_PATH
)

find_library_with_debug(STRIGI_STREAMS_LIBRARY
                        WIN32_DEBUG_POSTFIX d
                        NAMES streams )

find_library_with_debug(STRIGI_STRIGIQTDBUSCLIENT_LIBRARY
  WIN32_DEBUG_POSTFIX d
  NAMES strigiqtdbusclient
  PATHS
  ${strigi_home}/lib
  ${_program_FILES_DIR}/strigi/lib
  NO_DEFAULT_PATH
)

find_library_with_debug(STRIGI_STRIGIQTDBUSCLIENT_LIBRARY
                        WIN32_DEBUG_POSTFIX d
                        NAMES strigiqtdbusclient )


if (NOT WIN32 AND NOT HAVE_STRIGI_VERSION)
  include(UsePkgConfig)
  pkgconfig(libstreamanalyzer _dummyIncDir _dummyLinkDir _dummyLinkFlags _dummyCflags)

  # if pkgconfig found strigi, check the version, otherwise print a warning
  if(_dummyLinkFlags)

    exec_program(${PKGCONFIG_EXECUTABLE} ARGS --atleast-version=${STRIGI_MIN_VERSION}
                 libstreamanalyzer RETURN_VALUE _return_VALUE OUTPUT_VARIABLE _pkgconfigDevNull )

    if(NOT _return_VALUE STREQUAL "0")
      message(STATUS "pkg-config query failed. did you set $PKG_CONFIG_PATH to the directory where strigi libstreamanalyzer.pc is installed?")
      message(FATAL_ERROR "Didn't find strigi >= ${STRIGI_MIN_VERSION}")
    else(NOT _return_VALUE STREQUAL "0")
      set(HAVE_STRIGI_VERSION TRUE)
      set (STRIGI_NEEDS_SIGNED_CHAR FALSE)
      exec_program(${PKGCONFIG_EXECUTABLE} ARGS --modversion libstreamanalyzer RETURN_VALUE _version_return_VALUE OUTPUT_VARIABLE _strigiVersion )
      MACRO_ENSURE_VERSION("0.6.0" ${_strigiVersion} STRIGI_NEEDS_SIGNED_CHAR)
      # message(STATUS "Strigi version is ${_strigiVersion}. Needs signed char: ${STRIGI_NEEDS_SIGNED_CHAR}")

      if(NOT Strigi_FIND_QUIETLY)
        message(STATUS "Found Strigi ${_strigiVersion}")
      endif(NOT Strigi_FIND_QUIETLY)
    endif(NOT _return_VALUE STREQUAL "0")
    if (NOT STRIGI_STREAMANALYZER_LIBRARY)
      find_library(STRIGI_STREAMANALYZER_LIBRARY NAMES streamanalyzer
                   PATHS ${_dummyLinkDir})
    endif(NOT STRIGI_STREAMANALYZER_LIBRARY)
    if( NOT STRIGI_STRIGIQTDBUSCLIENT_LIBRARY)
       find_library(STRIGI_STRIGIQTDBUSCLIENT_LIBRARY NAMES strigiqtdbusclient
                    PATHS ${_dummyLinkDir})
    endif(NOT STRIGI_STRIGIQTDBUSCLIENT_LIBRARY)
    if (NOT STRIGI_STREAMS_LIBRARY)
      find_library(STRIGI_STREAMS_LIBRARY NAMES streams
                   PATHS ${_dummyLinkDir})
    endif(NOT STRIGI_STREAMS_LIBRARY)
    if (NOT STRIGI_INCLUDE_DIR)
      find_path(STRIGI_INCLUDE_DIR strigi/streamanalyzer.h
                PATHS ${_dummyIncDir})
    endif(NOT STRIGI_INCLUDE_DIR)
  else(_dummyLinkFlags)
    message(STATUS "pkgconfig didn't find strigi, couldn't check strigi version")
  endif(_dummyLinkFlags)
endif (NOT WIN32 AND NOT HAVE_STRIGI_VERSION)

if(WIN32)
  # STRIGI_NEEDS_SIGNED_CHAR is only set correct when pkgconfig is available...
  # we don't use strigi < 0.6.0 so assume STRIGI_NEEDS_SIGNED_CHAR is needed
  set(STRIGI_NEEDS_SIGNED_CHAR TRUE)
endif(WIN32)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Strigi  
                                  "Couldn't find Strigi streams and streamanalyzer libraries. Set the environment variable STRIGI_HOME (or CMAKE_PREFIX_PATH if using CMake >=2.6) to the strigi install dir."  
                                  STRIGI_STREAMS_LIBRARY  STRIGI_STREAMANALYZER_LIBRARY  STRIGI_INCLUDE_DIR)

if(WIN32)
  # this is needed to have mingw, cygwin and msvc libs installed in one directory
  if(MSVC)
    set(STRIGI_LINE_ANALYZER_PREFIX msvc_strigila_)
  elseif(CYGWIN)
    set(STRIGI_LINE_ANALYZER_PREFIX cyg_strigila_)
  elseif(MINGW)
    set(STRIGI_LINE_ANALYZER_PREFIX mingw_strigila_)
  endif(MSVC)
else(WIN32)
  set(STRIGI_LINE_ANALYZER_PREFIX strigila_)
endif(WIN32)

if(WIN32)
  # this is needed to have mingw, cygwin and msvc libs installed in one directory
  if(MSVC)
    set(STRIGI_THROUGH_ANALYZER_PREFIX msvc_strigita_)
  elseif(CYGWIN)
    set(STRIGI_THROUGH_ANALYZER_PREFIX cyg_strigita_)
  elseif(MINGW)
    set(STRIGI_THROUGH_ANALYZER_PREFIX mingw_strigita_)
  endif(MSVC)
else(WIN32)
  set(STRIGI_THROUGH_ANALYZER_PREFIX strigita_)
endif(WIN32)

mark_as_advanced(STRIGI_INCLUDE_DIR STRIGI_STREAMANALYZER_LIBRARY STRIGI_STREAMS_LIBRARY STRIGI_STRIGIQTDBUSCLIENT_LIBRARY 
   STRIGI_LINE_ANALYZER_PREFIX
   STRIGI_THROUGH_ANALYZER_PREFIX
)
