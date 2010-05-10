# Try to find DocBook XSL stylesheet
# Once done, it will define:
#
#  DOCBOOKXSL_FOUND - system has the required DocBook XML DTDs
#  DOCBOOKXSL_DIR - the directory containing the stylesheets
#  used to process DocBook XML
#
# Copyright (c) 2010, Luigi Toscano, <luigi.toscano@tiscali.it>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

find_path (DOCBOOKXSL_DIR VERSION
   PATHS ${CMAKE_SYSTEM_PREFIX_PATH}
   PATH_SUFFIXES
   share/xml/docbook/stylesheet/docbook-xsl
   share/sgml/docbook/xsl-stylesheets
   share/xml/docbook/stylesheet/nwalsh/current
)

find_package_handle_standard_args (DocBookXSL
                                   "Could NOT find DocBook XSL stylesheets"
                                   DOCBOOKXSL_DIR)

mark_as_advanced (DOCBOOKXSL_DIR)
