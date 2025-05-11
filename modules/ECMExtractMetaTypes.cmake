# SPDX-FileCopyrightText: 2025 Nicolas Fella <nicolas.fella@gmx.de>
#
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
ECMExtractMetatypes
-------------------

This module provides the ``ecm_extract_metatypes`` function. It wraps the
``qt_extract_metatypes`` function and adds support for making the metatypes
available to consuming projects.

The generated metatypes file is installed and made available to targets linking
against the target this function is called on.

See https://bugreports.qt.io/browse/QTBUG-123052 for motivation.

::

  ecm_extract_metatypes(<target_name>)

``target_name`` is the library target for which the metatypes are extracted.

Example usage:

.. code-block:: cmake

  ecm_extract_metatypes(KF6CoreAddons)

  # foo automatically has metatypes from KF6CoreAddons available
  target_link_libraries(foo PRIVATE KF6CoreAddons)

Since 6.15.0.
#]=======================================================================]

function(ecm_extract_metatypes target)
    qt_extract_metatypes(${target} OUTPUT_FILES METATYPES_FILE)
    set(METATYPES_INSTALL_DIR "metatypes")
    get_filename_component(METATYPES_FILE_NAME ${METATYPES_FILE} NAME)
    target_sources(${target} INTERFACE $<INSTALL_INTERFACE:${METATYPES_INSTALL_DIR}/${METATYPES_FILE_NAME}>)
    install(FILES ${METATYPES_FILE} DESTINATION ${METATYPES_INSTALL_DIR})
endfunction()
