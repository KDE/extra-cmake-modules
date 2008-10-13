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

if (NOT WIN32)
  include(UsePkgConfig)
  pkgconfig(libstreamanalyzer _STRIGI_INCLUDEDIR _STRIGI_LIBDIR _dummyLinkFlags _dummyCflags)
  #message(STATUS "_STRIGI_INCLUDEDIR=${_STRIGI_INCLUDEDIR} _STRIGI_LIBDIR=${_STRIGI_LIBDIR}")

  if(_dummyLinkFlags)

    exec_program(${PKGCONFIG_EXECUTABLE} ARGS --atleast-version=${STRIGI_MIN_VERSION}
                 libstreamanalyzer RETURN_VALUE _return_VALUE OUTPUT_VARIABLE _pkgconfigDevNull )

    if(NOT _return_VALUE STREQUAL "0")
      message(STATUS "pkg-config query failed. did you set $PKG_CONFIG_PATH to the directory where strigi libstreamanalyzer.pc is installed?")
      message(FATAL_ERROR "Didn't find strigi >= ${STRIGI_MIN_VERSION}")
    else(NOT _return_VALUE STREQUAL "0")
      if(NOT Strigi_FIND_QUIETLY)
        message(STATUS "Found Strigi ${_strigiVersion}")
      endif(NOT Strigi_FIND_QUIETLY)
    endif(NOT _return_VALUE STREQUAL "0")
  else(_dummyLinkFlags)
    message(STATUS "pkgconfig didn't find strigi, couldn't check strigi version")
  endif(_dummyLinkFlags)
endif(NOT WIN32)

if (WIN32)
  file(TO_CMAKE_PATH "$ENV{PROGRAMFILES}" _program_FILES_DIR)
  string(REPLACE "\\" "/" _program_FILES_DIR "${_program_FILES_DIR}")
endif(WIN32)

string(REPLACE "\\" "/" strigi_home "$ENV{STRIGI_HOME}")

find_path(STRIGI_INCLUDE_DIR strigi/streamanalyzer.h
  PATHS
  ${strigi_home}/include
  ${_STRIGI_INCLUDEDIR}
  ${_program_FILES_DIR}/strigi/include
  NO_DEFAULT_PATH
)

find_path(STRIGI_INCLUDE_DIR strigi/streamanalyzer.h)

find_library_with_debug(STRIGI_STREAMANALYZER_LIBRARY
  WIN32_DEBUG_POSTFIX d
  NAMES streamanalyzer
  PATHS
  ${strigi_home}/lib
  ${_STRIGI_LIBDIR}
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
  ${_STRIGI_LIBDIR}
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
  ${_STRIGI_LIBDIR}
  ${_program_FILES_DIR}/strigi/lib
  NO_DEFAULT_PATH
)

find_library_with_debug(STRIGI_STRIGIQTDBUSCLIENT_LIBRARY
                        WIN32_DEBUG_POSTFIX d
                        NAMES strigiqtdbusclient )

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Strigi  
    "Couldn't find Strigi streams and streamanalyzer libraries. Set the environment variable STRIGI_HOME (or CMAKE_PREFIX_PATH if using CMake >=2.6) to the strigi install dir."  
    STRIGI_STREAMS_LIBRARY  STRIGI_STREAMANALYZER_LIBRARY  STRIGI_INCLUDE_DIR)

if (STRIGI_FOUND)

    # Check for the SIC change between 0.5.9 and 0.6.0...

    MACRO(MACRO_CHECK_STRIGI_API_SCREWUP _RETTYPE _RESULT)
    SET (_STRIGI_API_SCREWUP_SOURCE_CODE "
#include <strigi/streamendanalyzer.h>
using namespace Strigi;
    class ScrewupEndAnalyzer : public StreamEndAnalyzer {
public:
    ScrewupEndAnalyzer() {}
    bool checkHeader(const char*, int32_t) const { return false; }
    ${_RETTYPE} analyze(Strigi::AnalysisResult&, InputStream*) {
        return -1;
    }
    const char* name() const { return \"Write 1000 times: I promise to keep source compat next time\"; }
};
int main()
{
    ScrewupEndAnalyzer a;
    return 0;
}
")
    CHECK_CXX_SOURCE_COMPILES("${_STRIGI_API_SCREWUP_SOURCE_CODE}" ${_RESULT})
    ENDMACRO(MACRO_CHECK_STRIGI_API_SCREWUP)

    INCLUDE(CheckCXXSourceCompiles)
    macro_push_required_vars()
    set( CMAKE_REQUIRED_INCLUDES ${CMAKE_REQUIRED_INCLUDES} ${STRIGI_INCLUDE_DIR} )
    set( CMAKE_REQUIRED_LIBRARIES ${CMAKE_REQUIRED_LIBRARIES} ${STRIGI_STREAMS_LIBRARY} ${STRIGI_STREAMANALYZER_LIBRARY} )
    MACRO_CHECK_STRIGI_API_SCREWUP( "signed char" STRIGI_NEEDS_SIGNED_CHAR )
    MACRO_CHECK_STRIGI_API_SCREWUP( "char" STRIGI_NEEDS_CHAR )
    set( STRIGI_NEEDS_SIGNED_CHAR ${STRIGI_NEEDS_SIGNED_CHAR} CACHE BOOL "TRUE if strigi is 0.6.0 or later" )
    if (${STRIGI_NEEDS_SIGNED_CHAR})
        message(STATUS "Strigi API is post-screwup, needs 'signed char'")
    else (${STRIGI_NEEDS_SIGNED_CHAR})
	if (${STRIGI_NEEDS_CHAR})
	    message(STATUS "Strigi API is pre-screwup check, need 'char'")
	else (${STRIGI_NEEDS_CHAR})
	    message(FATAL_ERROR "Strigi was found, but a simple test program does not compile, check CMakeFiles/CMakeError.log")
	endif (${STRIGI_NEEDS_CHAR})
    endif (${STRIGI_NEEDS_SIGNED_CHAR})
    macro_pop_required_vars()
endif (STRIGI_FOUND)


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
   STRIGI_NEEDS_SIGNED_CHAR
)
