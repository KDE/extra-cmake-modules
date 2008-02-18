# - Try to detect the GSSAPI support
# Once done this will define
#
#  GSSAPI_FOUND - system supports GSSAPI
#  GSSAPI_INCS - the GSSAPI include directory
#  GSSAPI_LIBS - the libraries needed to use GSSAPI
#  GSSAPI_FLAVOR - the type of API - MIT or HEIMDAL

# Copyright (c) 2006, Pino Toscano, <toscano.pino@tiscali.it>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.


IF(GSSAPI_LIBS AND GSSAPI_FLAVOR)

  # in cache already
  SET(GSSAPI_FOUND TRUE)

ELSE(GSSAPI_LIBS AND GSSAPI_FLAVOR)

  FIND_PROGRAM(KRB5_CONFIG NAMES krb5-config PATHS
     /opt/local/bin
  )
  
  #reset vars
  set(GSSAPI_INCS)
  set(GSSAPI_LIBS)
  set(GSSAPI_FLAVOR)
  
  IF(KRB5_CONFIG)
  
    SET(HAVE_KRB5_GSSAPI TRUE)
    EXEC_PROGRAM(${KRB5_CONFIG} ARGS --libs gssapi RETURN_VALUE _return_VALUE OUTPUT_VARIABLE GSSAPI_LIBS)
    IF(_return_VALUE)
      MESSAGE(STATUS "GSSAPI configure check failed.")
      SET(HAVE_KRB5_GSSAPI FALSE)
    ENDIF(_return_VALUE)
  
    EXEC_PROGRAM(${KRB5_CONFIG} ARGS --cflags gssapi RETURN_VALUE _return_VALUE OUTPUT_VARIABLE GSSAPI_INCS)
    string(REGEX REPLACE "(\r?\n)+$" "" GSSAPI_INCS "${GSSAPI_INCS}")
    string(REGEX REPLACE " *-I" ";" GSSAPI_INCS "${GSSAPI_INCS}")

    EXEC_PROGRAM(${KRB5_CONFIG} ARGS --vendor RETURN_VALUE _return_VALUE OUTPUT_VARIABLE gssapi_flavor_tmp)
    set(GSSAPI_FLAVOR_MIT)
    IF(gssapi_flavor_tmp MATCHES ".*Massachusetts.*")
      SET(GSSAPI_FLAVOR "MIT")
    ELSE(gssapi_flavor_tmp MATCHES ".*Massachusetts.*")
      SET(GSSAPI_FLAVOR "HEIMDAL")
    ENDIF(gssapi_flavor_tmp MATCHES ".*Massachusetts.*")
  
    IF(NOT HAVE_KRB5_GSSAPI)
      IF (gssapi_flavor_tmp MATCHES "Sun Microsystems.*")
	MESSAGE(STATUS "Solaris Kerberos does not have GSSAPI; this is normal.")
	SET(GSSAPI_LIBS)
	SET(GSSAPI_INCS)
      ELSE(gssapi_flavor_tmp MATCHES "Sun Microsystems.*")
	MESSAGE(WARNING "${KRB5_CONFIG} failed unexpectedly.")
      ENDIF(gssapi_flavor_tmp MATCHES "Sun Microsystems.*")
    ENDIF(NOT HAVE_KRB5_GSSAPI)

    IF(GSSAPI_LIBS) # GSSAPI_INCS can be also empty, so don't rely on that
      SET(GSSAPI_FOUND TRUE)
      message(STATUS "Found GSSAPI: ${GSSAPI_LIBS}")

      set(GSSAPI_INCS ${GSSAPI_INCS} CACHE STRING "The GSSAPI include directory" )
      set(GSSAPI_LIBS ${GSSAPI_LIBS} CACHE STRING "The libraries needed to use GSSAPI" )
      set(GSSAPI_FLAVOR ${GSSAPI_FLAVOR} CACHE STRING "The type of gss api, MIT or HEIMDAL")

      MARK_AS_ADVANCED(GSSAPI_INCS GSSAPI_LIBS GSSAPI_FLAVOR)

    ENDIF(GSSAPI_LIBS)
  
  ENDIF(KRB5_CONFIG)

ENDIF(GSSAPI_LIBS AND GSSAPI_FLAVOR)
