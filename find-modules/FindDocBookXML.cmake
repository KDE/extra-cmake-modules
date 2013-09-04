# Try to find DocBook XML DTDs
# Once done, it will define:
#
#  DocBookXML_FOUND - system has the required DocBook XML DTDs
#  DocBookXML_CURRENTDTD_VERSION - the version of currently used DocBook XML
#     DTD
#  DocBookXML_CURRENTDTD_DIR - the directory containing the definition of
#     the currently used DocBook XML version

# Copyright (c) 2010, Luigi Toscano, <luigi.toscano@tiscali.it>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

set (DocBookXML_CURRENTDTD_VERSION "4.2"
     CACHE INTERNAL "Required version of XML DTDs")

set (DTD_PATH_LIST
    share/xml/docbook/schema/dtd/${DocBookXML_CURRENTDTD_VERSION}
    share/xml/docbook/xml-dtd-${DocBookXML_CURRENTDTD_VERSION}
    share/sgml/docbook/xml-dtd-${DocBookXML_CURRENTDTD_VERSION}
    share/xml/docbook/${DocBookXML_CURRENTDTD_VERSION}
)

find_path (DocBookXML_CURRENTDTD_DIR docbookx.dtd
    PATHS ${CMAKE_SYSTEM_PREFIX_PATH}
    PATH_SUFFIXES ${DTD_PATH_LIST}
)

if (NOT DocBookXML_CURRENTDTD_DIR)
    # hacks for systems that use the package version in the DTD dirs,
    # e.g. Fedora, OpenSolaris
    set (DTD_PATH_LIST)
    foreach (DTD_PREFIX_ITER ${CMAKE_SYSTEM_PREFIX_PATH})
        file(GLOB DTD_SUFFIX_ITER RELATIVE ${DTD_PREFIX_ITER}
            ${DTD_PREFIX_ITER}/share/sgml/docbook/xml-dtd-${DocBookXML_CURRENTDTD_VERSION}-*
        )
        if (DTD_SUFFIX_ITER)
            list (APPEND DTD_PATH_LIST ${DTD_SUFFIX_ITER})
        endif ()
    endforeach ()

    find_path (DocBookXML_CURRENTDTD_DIR docbookx.dtd
        PATHS ${CMAKE_SYSTEM_PREFIX_PATH}
        PATH_SUFFIXES ${DTD_PATH_LIST}
    )
endif ()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args (DocBookXML
    "Could NOT find DocBook XML DTDs (v${DocBookXML_CURRENTDTD_VERSION})"
    DocBookXML_CURRENTDTD_DIR DocBookXML_CURRENTDTD_VERSION)

#maintain backwards compatibility
set(DOCBOOKXML_FOUND ${DocBookXML_FOUND})
set(DOCBOOKXML_CURRENTDTD_DIR ${DocBookXML_CURRENTDTD_DIR})
set(DOCBOOKXML_CURRENTDTD_VERSION ${DocBookXML_CURRENTDTD_VERSION})

mark_as_advanced (DocBookXML_CURRENTDTD_DIR DocBookXML_CURRENTDTD_VERSION)
