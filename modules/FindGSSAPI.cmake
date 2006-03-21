# - Try to detect the GSSAPI support
# Once done this will define
#
#  GSSAPI_FOUND - system supports GSSAPI
#  GSSAPI_INCS - the CSSAPI include directory
#  GSSAPI_LIBS - the libraries needed to use GSSAPI
#  GSSAPI_RPATH - the rpath for GSSAPI

# TODO: RPATH

FIND_PROGRAM(KRB5_CONFIG NAMES krb5-config PATHS
   /usr/bin
   /usr/local/bin
   /opt/local/bin
)

#reset vars
set(GSSAPI_INCS)
set(GSSAPI_LIBS)
set(GSSAPI_FLAVOR)

IF(KRB5_CONFIG)

  EXEC_PROGRAM(${KRB5_CONFIG} ARGS --libs gssapi RETURN_VALUE _return_VALUE OUTPUT_VARIABLE GSSAPI_LIBS)

  EXEC_PROGRAM(${KRB5_CONFIG} ARGS --cflags gssapi RETURN_VALUE _return_VALUE OUTPUT_VARIABLE GSSAPI_INCS)
  STRING(REGEX REPLACE "(\r?\n)+$" "" GSSAPI_INCS "${GSSAPI_INCS}")

  EXEC_PROGRAM(${KRB5_CONFIG} ARGS --vendor RETURN_VALUE _return_VALUE OUTPUT_VARIABLE gssapi_flavor_tmp)
  set(GSSAPI_FLAVOR_MIT)
  IF(gssapi_flavor_tmp MATCHES ".*Massachusetts.*")
    SET(GSSAPI_FLAVOR "MIT")
  ELSE(gssapi_flavor_tmp MATCHES ".*Massachusetts.*")
    SET(GSSAPI_FLAVOR "HEIMDAL")
  ENDIF(gssapi_flavor_tmp MATCHES ".*Massachusetts.*")

  IF(GSSAPI_LIBS) # GSSAPI_INCS can be also empty, so don't rely on that
    SET(GSSAPI_FOUND TRUE)
    message(STATUS "Found GSSAPI: ${GSSAPI_LIBS}")
  ENDIF(GSSAPI_LIBS)

#ELSE(KRB5_CONFIG)

# TODO...

ENDIF(KRB5_CONFIG)

MARK_AS_ADVANCED(GSSAPI_INCS GSSAPI_LIBS GSSAPI_FLAVOR)
