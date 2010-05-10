# Try to find DocBook XML DTDs
# Once done, it will define:
#
#  DOCBOOKXML_FOUND - system has the required DocBook XML DTDs
#  DOCBOOKXML_CURRENTDTD_VERSION - the version of currently used DocBook XML
#     DTD
#  DOCBOOKXML_CURRENTDTD_DIR - the directory containing the definition of
#     the currently used DocBook XML version
#  DOCBOOKXML_CURRENTDTD_VERSION - if defined, the version of previously used
#     DocBook XML DTD
#  DOCBOOKXML_OLDDTD_DIR - if defined and different from
#     DOCBOOKXML_CURRENTDTD_DIR, the directory containing the definition of
#     previously used DocBook XML version
#
# Copyright (c) 2010, Luigi Toscano, <luigi.toscano@tiscali.it>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

set (DOCBOOKXML_CURRENTDTD_VERSION "4.2" 
     CACHE INTERNAL "Required version of XML DTDs")
find_path (DOCBOOKXML_CURRENTDTD_DIR catalog.xml
   PATHS ${CMAKE_SYSTEM_PREFIX_PATH}

   PATH_SUFFIXES
   share/xml/docbook/schema/dtd/${DOCBOOKXML_CURRENTDTD_VERSION}
   share/xml/docbook/xml-dtd-${DOCBOOKXML_CURRENTDTD_VERSION}
   share/sgml/docbook/xml-dtd-${DOCBOOKXML_CURRENTDTD_VERSION}
   share/xml/docbook/${DOCBOOKXML_CURRENTDTD_VERSION}
)

#set (DOCBOOKXML_OLDDTD_DIR ${DOCBOOKXML_CURRENTDTD_DIR})
#set (DOCBOOKXML_OLDDTD_VERSION "4.1.2")
#find_path (DOCBOOKXML_OLDDTD_DIR catalog.xml
#   PATHS ${CMAKE_SYSTEM_PREFIX_PATH}
#   PATH_SUFFIXES
#   share/xml/docbook/schema/dtd/${DOCBOOKXML_OLDDTD_VERSION}
#   share/xml/docbook/xml-dtd-${DOCBOOKXML_OLDDTD_VERSION}
#   share/sgml/docbook/xml-dtd-${DOCBOOKXML_OLDDTD_VERSION}
#   share/xml/docbook/${DOCBOOKXML_OLDDTD_VERSION}
#)

find_package_handle_standard_args (DocBookXML
    "Could NOT find DocBook XML DTDs (v${DOCBOOKXML_CURRENTDTD_VERSION})"
    DOCBOOKXML_CURRENTDTD_VERSION DOCBOOKXML_CURRENTDTD_DIR)

mark_as_advanced (DOCBOOKXML_CURRENTDTD_DIR DOCBOOKXML_CURRENTDTD_VERSION)
