#
# SPDX-FileCopyrightText: 2021 Arjen Hiemstra <ahiemstra@heimr.nl>
#
# SPDX-License-Identifier: BSD-3-Clause

#[========================================================================[.rst:
ECMQmlModule
------------

Helper functions to make it easier to create QML modules.

This CMake module lets you create QML-enabled targets, add C++ and QML files
to them, and finalize the module if needed. When using Qt 6, it allows for
`declarative registration of QML types <https://www.qt.io/blog/qml-type-registration-in-qt-5.15>`_.

This CMake module reduces boilerplate and takes care of special
handling of QML modules between shared and static builds:

- When building a static version of a QML module, the relevant QML source
  files are bundled into the static library.

- When using a shared build, the QML plugin and relevant QML files are copied
  to the target's ``RUNTIME_OUTPUT_DIRECTORY`` to make it easier to run things
  directly from the build directory.

Since 6.0.0, when using Qt 6, most functionality of this module has been
implemented by upstream Qt. Most of the functions here will now forward to the
similar Qt functions.

Example usage with an executable as backing target:

.. code-block:: cmake

    add_executable(app)
    ecm_add_qml_module(app
        URI "org.example.Example"
    )

    target_sources(app PRIVATE main.cpp)
    target_link_libraries(app PRIVATE Qt::Quick)

    ecm_target_qml_sources(app SOURCES ExampleItem.qml) # This will have 1.0 as the default version
    ecm_target_qml_sources(app SOURCES AnotherExampleItem.qml VERSION 1.5)

    install(TARGETS app ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})

The above example creates an executable target, modifies the target to allow it
to accept QML files and properties, adds source files to it, and installs it.

The executable is the backing target for the QML module, which in practical
terms means the QML module is "embedded" into the executable, always being
loaded as part of the application, and no plugin library is created.

Example usage with a separate QML module:

.. code-block:: cmake

  add_library(ExampleModule)
  ecm_add_qml_module(ExampleModule
      URI org.example.Example
      GENERATE_PLUGIN_SOURCE
  )

  target_sources(ExampleModule PRIVATE ExamplePlugin.cpp)
  target_link_libraries(ExampleModule PRIVATE Qt::Quick)

  ecm_target_qml_sources(ExampleModule SOURCES ExampleItem.qml)

  ecm_finalize_qml_module(ExampleModule DESTINATION ${KDE_INSTALL_QMLDIR})

  install(TARGETS ExampleModule ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})

The above example creates a library target, modifies the target to allow it to accept QML files and
properties, adds source files to it, and finalizes the target.

The library acts as a plugin that is expected to be linked to an
executable later on, in which case ``GENERATE_PLUGIN_SOURCE`` and
``ecm_finalize_qml_module()`` are both required.

::

    ecm_add_qml_module(<target name>
        URI <module uri>
        [VERSION <module version>]
        [NO_PLUGIN] # Deprecated since 6.0.0 when using Qt 6
        [CLASSNAME <class name>] # Deprecated since 6.0.0 when using Qt 6, use CLASS_NAME instead
        [QT_NO_PLUGIN] # Since 6.0.0, when using Qt 6
        [GENERATE_PLUGIN_SOURCE] # Since 6.0.0, when using Qt 6
        [DEPENDENCIES <dependency> ...] # Since 6.0.0, when using Qt 6, inherited from qt_add_qml_module()
        [IMPORTS <import> ...] # Since 6.0.0, when using Qt 6, inherited from qt_add_qml_module()
    )

This will declare a new CMake target called ``<target name>``. The ``URI``
argument is required and should be a proper QML module URI. The ``URI`` is used,
among others, to generate a subdirectory where the module will be installed to.

If the ``VERSION`` argument is specified, it is used to initialize the default
version that is used by  ``ecm_target_qml_sources`` when adding QML files. If it
is not specified, a  default of 1.0 is used. Additionally, if a version greater
than or equal to 2.0 is specified, the major version is appended to the
Qt5 installation path of the module.
In case you don't specify a version for the module, but specify a version for
the individual sources, the latter will be set as the resulting version for
this module. This will also be used in the ECMFindQmlModule module.

If the option ``NO_PLUGIN`` is set, a target is declared that is not expected to
contain any C++ QML plugin.

If the optional ``CLASSNAME`` argument is supplied, it will be used as class
name in the generated QMLDIR file. If it is not specified, the target name will
be used instead.

You can add C++ and QML source files to the target using ``target_sources`` and
``ecm_target_qml_sources``, respectively.

Since 5.91.0

Since 6.0.0, when used with Qt 6, this will forward to ``qt_add_qml_module``. Any extra arguments will
be forwarded as well. The ``NO_PLUGIN`` argument is deprecated and implies ``GENERATE_PLUGIN_SOURCE``,
since modules in Qt 6 always require a plugin or backing target. If you want to use Qt's behaviour for
``NO_PLUGIN``, use ``QT_NO_PLUGIN`` instead. Additionally, to maintain backward compatibility, by
default we pass ``NO_GENERATE_PLUGIN_SOURCE`` to ``qt_add_qml_module``.

If you are using the executable as backing target for your QML module, the
default behavior should suffice. If you are using a separate QML module,
you will need to have Qt generate the plugin sources, in which case you
should pass ``GENERATE_PLUGIN_SOURCE``.

The ``DEPENDENCIES`` and ``IMPORTS`` options come from ``qt_add_qml_module()``
since Qt 6, and behave as in upstream Qt.

Use ``DEPENDENCIES`` for things like "QtCore", "QtQuick", "your.custom.qmlmodule",
as well as C++ only dependencies. This is required for QML-exposed C++ code, like when subclassing a type or using it as a parameter type in properties and invokables.

Use ``IMPORTS`` to make a type available a part of a module's public interface. In other words, if a QML file imports this module, it also imports all the modules listed under IMPORTS.

See `Declaring module dependencies <https://doc.qt.io/qt-6/qt-add-qml-module.html#declaring-module-dependencies>`_ and `10 Tips to Make Your QML Code Faster and More Maintainable <https://www.kdab.com/10-tips-to-make-your-qml-code-faster-and-more-maintainable/>`_ for details.

::

    ecm_add_qml_module_dependencies(<target> DEPENDS <module string> [<module string> ...])

Adds the list of dependencies specified by the ``DEPENDS`` argument to be listed
as dependencies in the generated QMLDIR file of ``<target>``.

Since 5.91.0

Since 6.0.0, this is deprecated and ignored when using Qt 6, instead use the
``DEPENDENCIES`` and ``IMPORTS`` arguments to ``ecm_add_qml_module``.

::

    ecm_target_qml_sources(<target> SOURCES <source.qml> [<source.qml> ...] [VERSION <version>] [PATH <path>] [PRIVATE])

Adds the list of QML files specified by the ``SOURCES`` argument as source files
to the QML module target ``<target>``.

If the optional ``VERSION`` argument is specified, all QML files will be added
with the specified version. If it is not specified, they will use the version of
the QML module target.

If the optional ``PRIVATE`` argument is specified, the QML files will be
included in the target but not in the generated qmldir file. Any version
argument will be ignored.

The optional ``PATH`` argument declares a subdirectory of the module where the
files should be copied to. By default, files will be copied to the module root.

This function will fail if ``<target>`` is not a QML module target or any of the
specified files do not exist.

Since 5.91.0

Since 6.0.0, when used with Qt 6, this will forward to ``qt_target_qml_sources()``.
The ``SOURCES`` argument will be translated to ``QML_SOURCES``. ``VERSION`` and
``PRIVATE`` will set Qt's ``QT_QML_SOURCE_VERSIONS`` and ``QT_QML_INTERNAL_TYPE``
properties on ``SOURCES`` before calling ``qt_target_qml_sources()``. Since Qt
includes the path relative to the current source dir, for each source file a
resource alias will be generated with the path stripped. If the ``PATH`` argument
is set, it will be prefixed to the alias. Any additional arguments will be passed
to ``qt_target_qml_sources()``.

::

    ecm_finalize_qml_module(<target>
        [DESTINATION <QML install destination>] # Optional since 6.0
        [VERSION <Project Version>] # Added for 6.0 when using Qt 6
        [EXPORT <export-set>] # Added for 6.8 when using Qt 6
    )

Finalizes the specified QML module target.

This is required in case you do not use the executable as backing target.

This must be called after all other setup (like adding sources) on the target
has been done. It will perform a number of tasks:

- It will generate a qmldir file from the QML files added to the target. If the
  module has a C++ plugin, this will also be included in the qmldir file.
- If ``BUILD_SHARED_LIBS`` is off, a QRC file is generated from the QML files
  added to the target. This QRC file will be included when compiling the C++ QML
  module. The built static library will be installed in a subdirectory of
  ``DESTINATION`` based on the QML module's URI. If this value is not set,
  KDE_INSTALL_QMLDIR will be used. Note that if ``NO_PLUGIN`` is set, a C++
  QML plugin will be generated to include the QRC files.
- If ``BUILD_SHARED_LIBS`` is on, all generated files, QML sources and the C++
  plugin will be installed in a subdirectory of ``DESTINATION`` based on the
  QML module's URI. In addition, these files will also be copied to the target's
  ``RUNTIME_OUTPUT_DIRECTORY`` in a similar subdirectory.
- If ``BUILD_SHARED_LIBS`` is off, ``EXPORT`` allows to specify a CMake export set
  all installed targets should be added to.

This function will fail if ``<target>`` is not a QML module target.

Since 5.91.0

Since 6.0.0, when using Qt 6, this will instead install the files generated
by ``qt_add_qml_module``. The optional ``VERSION`` argument was added that will
default to ``PROJECT_VERSION`` and which will write a file that is used by
``ECMFindQmlModule`` to detect the version of the QML module.

Since 6.1.0

Enabling the global option ``VERBOSE_QML_COMPILER`` during CMake configuration
will activate verbose output for qmlcachegen.

Since 6.18.0

Generate code from qmlcachegen is put into the same ``UNITY_GROUP``. Unity builds
using this can either be activated manueally per target or with the ``ECM_QMLCACHE_UNITY_BUILD``
option globally. This can speed up clean builds at the expense of needing more memory
and making incremental builds slower.

#]========================================================================]

include(${CMAKE_CURRENT_LIST_DIR}/QtVersionOption.cmake)

# This is also used by ECMFindQmlModule, so needs to be available for both
# Qt 5 and Qt 6.
macro(_ecm_qmlmodule_uri_to_path ARG_OUTPUT ARG_PATH ARG_VERSION)
    string(REPLACE "." "/" _output "${ARG_PATH}")

    # If the major version of the module is >2.0, Qt expects a ".MajorVersion" suffix on the directory
    # However, we only need to do this in Qt5
    if ("${QT_MAJOR_VERSION}" STREQUAL "5" AND "${ARG_VERSION}" VERSION_GREATER_EQUAL 2.0)
        string(REGEX MATCH "^([0-9]+)" _version_major ${ARG_VERSION})
        set("${ARG_OUTPUT}" "${_output}.${_version_major}")
    else()
        set("${ARG_OUTPUT}" "${_output}")
    endif()
endmacro()

# The implementation for this has diverged significantly between Qt 5 and Qt 6
# so it has been split to separate files.
if ("${QT_MAJOR_VERSION}" STREQUAL "6")
    include(${CMAKE_CURRENT_LIST_DIR}/ECMQmlModule6.cmake)
elseif("${QT_MAJOR_VERSION}" STREQUAL "5")
    include(${CMAKE_CURRENT_LIST_DIR}/ECMQmlModule5.cmake)
else()
    message(FATAL_ERROR "Could not determine Qt major version")
endif()
