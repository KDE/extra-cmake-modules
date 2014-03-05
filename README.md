Extra CMake Modules
===================

Additional functionality for the CMake build system


Introduction
------------

The Extra CMake Modules package, or ECM, adds to the modules provided by CMake,
including both ones used by `find_package()` to find common software and ones
that can be used directly in `CMakeLists.txt` files to perform common tasks.

In addition, it provides common build settings used in software produced by the
KDE community.

While the driving force of this module is to reduce duplication in CMake scripts
across KDE software, it is intended to be useful for any software that uses the
CMake build system.


Usage
-----

To use ECM, add the following to your `CMakeLists.txt`:

    find_package(ECM <ecm-version> REQUIRED NO_MODULE)
    set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

(note that you may want to append `${ECM_MODULE_PATH}` to `CMAKE_MODULE_PATH`
instead).  You can then just include the modules you require, or use
`find_package()` as needed.  For example:

    include(ECMInstallIcons)

Developers of KDE software will often want to use the KDE standard settings
provided by ECM; they can do the following:

    find_package(ECM <ecm-version> REQUIRED NO_MODULE)
    set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${ECM_KDE_MODULE_DIR})
    include(KDEInstallDirs)
    include(KDECompilerSettings)
    include(KDECMakeSettings)

Note that any combination of the above includes can be used if you only want
some of the settings.  Some of the functionality of `KDECMakeSettings` can also
be selectively disabled; see the documentation at the top of
`kde-modules/KDECMakeSettings.cmake` for more details.


Organization
------------

This module is organised as follows:

- `attic/` contains most of the CMake modules shipped with kdelibs 4.  These
  can be used to form the basis of cleaned-up modules, either for inclusion in
  ECM or for private use in a project.
- `find-modules/` contains the modules used by CMake's `find_package()` command.
- `kde-modules/` contains modules that provide some common settings for KDE
  applications and frameworks.
- `modules/` contains the modules that should be included directly by CMake
  scripts, other than those in `kde-modules/`.
- `tests/` contains automated tests for the functionality provided by ECM
  modules.


Creating Modules
----------------

Proposed new modules should be submitted using the
[KDE Review Board instance][RB], and be assigned to the `buildsystem`,
`extracmakemodules` and `kdeframeworks` groups.  You should be able to point to
two separate projects that will make use of the module.  See the `docs/`
directory for more information on writing the modules themselves.

[RB]: https://git.reviewboard.kde.org/


License
-------

All code in this repository is licensed under the [BSD 2-Clause license][1].

[1]: http://opensource.org/licenses/BSD-2-Clause


Links
-----

- Home page: <https://projects.kde.org/projects/kdesupport/extra-cmake-modules>
- Mailing list: <https://mail.kde.org/mailman/listinfo/kde-buildsystem>
- IRC channel: \#kde-devel on Freenode
- Git repository: <https://projects.kde.org/projects/kdesupport/extra-cmake-modules/repository>
