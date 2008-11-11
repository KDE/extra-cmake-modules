# - Try to find Strigi, a fast and small desktop search program (http://strigi.sourceforge.net )

include(FindLibraryWithDebug)
include(MacroPushRequiredVars)

if(NOT STRIGI_MIN_VERSION)
    set(STRIGI_MIN_VERSION "0.5.9")
endif(NOT STRIGI_MIN_VERSION)

if (NOT WIN32)
    find_package(PkgConfig)
    pkg_check_modules(STRIGI libstreamanalyzer>=${STRIGI_MIN_VERSION})
endif(NOT WIN32)

if (WIN32)
    file(TO_CMAKE_PATH "$ENV{PROGRAMFILES}" _program_FILES_DIR)
endif(WIN32)

file(TO_CMAKE_PATH "$ENV{STRIGI_HOME}" strigi_home)

find_library_with_debug(STRIGI_STREAMANALYZER_LIBRARY
  WIN32_DEBUG_POSTFIX d
  NAMES streamanalyzer
  PATHS
  ${strigi_home}/lib
  ${STRIGI_LIBRARY_DIRS}
  ${_program_FILES_DIR}/strigi/lib
)


find_library_with_debug(STRIGI_STREAMS_LIBRARY
  WIN32_DEBUG_POSTFIX d
  NAMES streams
  PATHS
  ${strigi_home}/lib
  ${STRIGI_LIBRARY_DIRS}
  ${_program_FILES_DIR}/strigi/lib
)

find_library_with_debug(STRIGI_STRIGIQTDBUSCLIENT_LIBRARY
  WIN32_DEBUG_POSTFIX d
  NAMES strigiqtdbusclient
  PATHS
  ${strigi_home}/lib
  ${STRIGI_LIBRARY_DIRS}
  ${_program_FILES_DIR}/strigi/lib
)

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
    set( CMAKE_REQUIRED_INCLUDES ${CMAKE_REQUIRED_INCLUDES} ${STRIGI_INCLUDEDIR} )
    set( CMAKE_REQUIRED_LIBRARIES ${CMAKE_REQUIRED_LIBRARIES} ${STRIGI_STREAMS_LIBRARY} ${STRIGI_STREAMANALYZER_LIBRARY} )
    set( STRIGI_INCLUDE_DIR ${STRIGI_INCLUDEDIR} )
    MACRO_CHECK_STRIGI_API_SCREWUP( "signed char" STRIGI_NEEDS_SIGNED_CHAR )
    MACRO_CHECK_STRIGI_API_SCREWUP( "char" STRIGI_NEEDS_CHAR )
    set( STRIGI_NEEDS_SIGNED_CHAR ${STRIGI_NEEDS_SIGNED_CHAR} CACHE BOOL "TRUE if strigi is 0.6.0 or later" )
    set( STRIGI_NEEDS_CHAR ${STRIGI_NEEDS_CHAR} CACHE BOOL "TRUE if strigi is 0.5.9 or before" )
    if (STRIGI_NEEDS_SIGNED_CHAR)
        message(STATUS "Strigi API is post-screwup, needs 'signed char'")
    else (STRIGI_NEEDS_SIGNED_CHAR)
        if (STRIGI_NEEDS_CHAR)
            message(STATUS "Strigi API is pre-screwup check, need 'char'")
        else (STRIGI_NEEDS_CHAR)
            message(FATAL_ERROR "Strigi was found, but a simple test program does not compile, check CMakeFiles/CMakeError.log")
        endif (STRIGI_NEEDS_CHAR)
    endif (STRIGI_NEEDS_SIGNED_CHAR)
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

mark_as_advanced(
    STRIGI_INCLUDE_DIR
    STRIGI_STREAMANALYZER_LIBRARY
    STRIGI_STREAMS_LIBRARY
    STRIGI_STRIGIQTDBUSCLIENT_LIBRARY
    STRIGI_LINE_ANALYZER_PREFIX
    STRIGI_THROUGH_ANALYZER_PREFIX
    STRIGI_NEEDS_SIGNED_CHAR
    STRIGI_NEEDS_CHAR
)
