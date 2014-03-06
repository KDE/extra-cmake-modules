Writing Find Modules           {#writing-find-modules}
====================

The `find_package` macro from CMake has two ways of finding packages.  If the
package Foo provides a `FooConfig.cmake` file in an appropriate place, CMake
will use that to determine all the necessary information to build against the
package.  Otherwise, if there is a `FindFoo.cmake` file somewhere in
`CMAKE_MODULE_PATH`, that will be used to find whether the package exists and
determine the appropriate information about it if it does.  See
[the CMake documentation][cmake:packages] for more information.

The primary task of a `FindFoo.cmake` file is to determine whether the requested
package exists on the system, and set the `Foo_FOUND` variable to reflect this.
If Foo is a library, it typically sets variables such as `Foo_LIBRARIES`,
`Foo_INCLUDE_DIRS` and `Foo_DEFINITIONS` to provide the necessary information to
build and link against that library.  The `FindFoo.cmake` files in
extra-cmake-modules usually provide imported targets to make using the libraries
even simpler.  The files may also provide additional variables and useful CMake
macros.

We will describe a typical CMake module for finding a library.

[cmake:packages]: http://www.cmake.org/cmake/help/git-master/manual/cmake-packages.7.html


Documentation
-------------

The first thing that is needed is documentation.  Start the file with a simple
statement of what the module does.  In the simplest case, this is just

    # Find the Foo library

but more description may be required for some packages.  If there are caveats or
other details users of the module should be aware of, you can add further
paragraphs below this.  Then you need to document what variables and imported
targets are set by the module, such as

    # This will define the following variables:
    #
    #     Foo_FOUND         - True if the system has the Foo library
    #     Foo_VERSION       - The version of the Foo library which was found
    #
    # and the following imported targets:
    #
    #     Foo::Bar
    #
    # The following compatibility variables will also be defined, although
    # the imported targets should be used instead:
    #
    #     Foo_LIBRARIES      - Link to these to use the Foo library
    #     Foo_INCLUDES_DIRS  - Include directory for the Foo library
    #     Foo_DEFINITIONS    - Compiler flags required to link against the Foo library
    #     Foo_VERSION_STRING - The version of the Foo library which was found

Don't forget to add copyright and license notices.  Any module distributed with
extra-cmake-modules must use the BSD 2-clause or 3-clause license:

    # Copyright 2014 Your Name <your@email>
    #
    # Redistribution and use in source and binary forms, with or without
    # modification, are permitted provided that the following conditions
    # are met:
    #
    # 1. Redistributions of source code must retain the copyright
    #    notice, this list of conditions and the following disclaimer.
    # 2. Redistributions in binary form must reproduce the copyright
    #    notice, this list of conditions and the following disclaimer in the
    #    documentation and/or other materials provided with the distribution.
    # 3. The name of the author may not be used to endorse or promote products
    #    derived from this software without specific prior written permission.
    #
    # THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
    # IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
    # OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
    # IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
    # INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
    # NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
    # DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
    # THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
    # (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
    # THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


Version Requirements
--------------------

The modules provided by extra-cmake-modules typically assume a minimum CMake
version.  This is particularly relevant with imported targets, which are not
supported in old CMake versions.  You can (and should) enforce this in the
following way:


    if(CMAKE_VERSION VERSION_LESS 2.8.12)
        message(FATAL_ERROR "CMake 2.8.12 is required by FindFoo.cmake")
    endif()
    if(CMAKE_MINIMUM_REQUIRED_VERSION VERSION_LESS 2.8.12)
        message(AUTHOR_WARNING "Your project should require at least CMake 2.8.12 to use FindFoo.cmake")
    endif()

This provides developers and users with helpful error messages, rather than the
projects failing for mysterious reasons with old CMake versions.


Finding the Package
-------------------

Now the actual libraries and so on have to be found.  The code here will
obviously vary from module to module (that, after all, is the point of the Find
modules), but there tends to be a common pattern for libraries.

First, we try to use `pkg-config` to find the library.  Note that we cannot rely
on this, as it may not be available, but it provides a good starting point.

    find_package(PkgConfig)
    pkg_check_modules(PC_Foo QUIET Foo)

This should define some variables starting `PC_Foo_` that contain the
information from the `.pc` file.  We can use this to set `Foo_DEFINITIONS`:

    set(Foo_DEFINITIONS ${PC_Foo_CFLAGS_OTHER})

Now we need to find the libraries and include files; we use the information from
`pkg-config` to provide hints to CMake about where to look:

    find_path(Foo_INCLUDE_DIR
        NAMES
            foo.h
        PATHS
            ${PC_Foo_INCLUDEDIR}
            ${PC_Foo_INCLUDE_DIRS}
        PATH_SUFFIXES
            Foo # if you need to put #include <Foo/foo.h> in your code
    )
    find_library(Foo_LIBRARY
        NAMES
            foo
        PATHS
            ${PC_Foo_LIBDIR}
            ${PC_Foo_LIBRARY_DIRS}
    )

If you have a good way of getting the version (from a header file, for example),
you can use that information to set `Foo_VERSION`.  Otherwise, attempt to
use the information from `pkg-config`:

    set(Foo_VERSION ${PC_Foo_VERSION})


Finishing Up
------------

Now we can use `FindPackageHandleStandardArgs` to do most of the rest of the
work for us.

    include(FindPackageHandleStandardArgs)
    find_package_handle_standard_args(Foo
        FOUND_VAR Foo_FOUND
        REQUIRED_VARS
            Foo_LIBRARY
            Foo_INCLUDE_DIR
        VERSION_VAR Foo_VERSION
    )

This will check that the `REQUIRED_VARS` contain values (that do not end in
`-NOTFOUND`) and set `Foo_FOUND` appropriately.  It will also cache those
values.  If `Foo_VERSION` is set, and a required version was passed to
`find_package`, it will check the requested version against the one in
`Foo_VERSION`.  It will also print messages as appropriate; note that if
the package was found, it will print the contents of the first required variable
to indicate where it was found.

We add an imported target for the library.  Note that we do this after calling
`find_package_handle_standard_args` so that we can use the `Foo_FOUND` variable.
Imported targets should be namespaced (hence the `Foo::` prefix); CMake will
recognize that values passed to `target_link_libraries` that contain `::` in
their name are supposed to be imported targets (rather than just library names),
and will produce appropriate diagnostic messages if that target does not exist.

    if(Foo_FOUND AND NOT TARGET Foo::Foo)
        add_library(Foo::Foo UNKNOWN IMPORTED)
        set_target_properties(Foo::Foo PROPERTIES
            IMPORTED_LOCATION "${Foo_LIBRARY}"
            INTERFACE_COMPILE_OPTIONS "${Foo_DEFINITIONS}"
            INTERFACE_INCLUDE_DIRECTORIES "${Foo_INCLUDE_DIR}"
        )
    endif()

One thing to note about this is that the `INTERFACE_INCLUDE_DIRECTORIES` and
similar properties should only contain information about the target itself, and
not any of its dependencies.  Instead, those dependencies should also be
targets, and CMake should be told that they are dependencies of this target.
CMake will then combine all the necessary information automatically.

We should also provide some information about the package, such as where to
download it.

    include(FeatureSummary)
    set_package_properties(Foo PROPERTIES
        URL "http://www.foo.example.com/"
        DESCRIPTION "A library for doing useful things")

Most of the cache variables should be hidden in the `ccmake` interface unless
the user explicitly asks to edit them:

    mark_as_advanced(
        Foo_INCLUDE_DIR
        Foo_LIBRARY
    )

If this module replaces an older version, you should set compatibility variables
to cause the least disruption possible.

    # compatibility variables
    set(Foo_LIBRARIES ${Foo_LIBRARY})
    set(Foo_INCLUDE_DIRS ${Foo_INCLUDE_DIR})
    set(Foo_VERSION_STRING ${Foo_VERSION})

Note that we do not wish to pass `Foo_LIBRARIES` to `find_library`, or
`Foo_INCLUDE_DIRS` to `find_path`, as the variables passed to those commands
will be stored in the cache for the user to override.


Components
----------

If your find module has multiple components, such as a package that provides
multiple libraries, the ECMFindModulesHelpers module can do a lot of the work
for you.  First, you need to include the module, and perform the version check.
ECMFindModuleHelpers provides its own version check macro, which specifies the
minimum required CMake version for the other macros in that module.

    include(ECMFindModuleHelpers)
    ecm_find_package_version_check(Foo)

The important macros are `ecm_find_package_parse_components` and
`ecm_find_package_handle_library_components`.  These take a list of components,
and query other variables you provide to find out the information they require.
The documentation for ECMFindModuleHelpers provides more information, but a
simple setup might look like

    set(Foo_known_components Bar Baz)
    set(Foo_Bar_pkg_config "foo-bar")
    set(Foo_Bar_lib "bar")
    set(Foo_Bar_header "foo/bar.h")
    set(Foo_Bar_pkg_config "foo-baz")
    set(Foo_Baz_lib "baz")
    set(Foo_Baz_header "foo/baz.h")

If `Baz` depends on `Bar`, for example, you can specify this with

    set(Foo_Baz_component_deps "Bar")

Then call the macros:

    ecm_find_package_parse_components(Foo
        RESULT_VAR Foo_components
        KNOWN_COMPONENTS ${Foo_known_components}
    )
    ecm_find_package_handle_library_components(Foo
        COMPONENTS ${Foo_components}
    )

Of course, if your components need unusual handling, you may want to replace
`ecm_find_package_handle_library_components` with, for example, a `foreach` loop
over the components (the body of which should implement most of what a normal
find module does, including setting `Foo_<component>_FOUND`).

At this point, you should set `Foo_VERSION` using whatever information you have
available (such as from parsing header files).  Note that
`ecm_find_package_handle_library_components` will set it to the version reported
by pkg-config of the first component found, but this depends on the presence of
pkg-config files, and the version of a component may not be the same as the
version of the whole package.  After that, finish off with

    include(FindPackageHandleStandardArgs)
    find_package_handle_standard_args(Foo
        FOUND_VAR
            Foo_FOUND
        REQUIRED_VARS
            Foo_LIBRARIES
        VERSION_VAR
            Foo_VERSION
        HANDLE_COMPONENTS
    )
    
    include(FeatureSummary)
    set_package_properties(Foo PROPERTIES
        URL "http://www.foo.example.com/"
        DESCRIPTION "A library for doing useful things")


Other Macros
------------

Some Find modules will wish to provide useful macros related to the package.
For example, the FindSharedMimeInfo module provides an `update_xdg_mimetypes`
macro.  The main thing to note is that you should probably make this a function,
rather than a macro, to avoid polluting the global namespace with temporary
variables.

