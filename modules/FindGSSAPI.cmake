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


if(GSSAPI_LIBS AND GSSAPI_FLAVOR)

  # in cache already
  set(GSSAPI_FOUND TRUE)

else(GSSAPI_LIBS AND GSSAPI_FLAVOR)

  find_program(KRB5_CONFIG NAMES krb5-config PATHS
     /opt/local/bin
     ONLY_CMAKE_FIND_ROOT_PATH               # this is required when cross compiling with cmake 2.6 and ignored with cmake 2.4, Alex
  )
  mark_as_advanced(KRB5_CONFIG)
  
  #reset vars
  set(GSSAPI_INCS)
  set(GSSAPI_LIBS)
  set(GSSAPI_FLAVOR)
  
  if(KRB5_CONFIG)
  
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

    if(GSSAPI_LIBS) # GSSAPI_INCS can be also empty, so don't rely on that
      set(GSSAPI_FOUND TRUE)
      message(STATUS "Found GSSAPI: ${GSSAPI_LIBS}")

      set(GSSAPI_INCS ${GSSAPI_INCS})
      set(GSSAPI_LIBS ${GSSAPI_LIBS})
      set(GSSAPI_FLAVOR ${GSSAPI_FLAVOR})

      mark_as_advanced(GSSAPI_INCS GSSAPI_LIBS GSSAPI_FLAVOR)

    endif(GSSAPI_LIBS)
  
  endif(KRB5_CONFIG)

endif(GSSAPI_LIBS AND GSSAPI_FLAVOR)
