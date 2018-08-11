from conans import ConanFile, CMake

class ExtracmakemodulesConan(ConanFile):
    name = "extra-cmake-modules"
    version = "5.48.0"
    license = "GPLv2"
    url = "https://api.kde.org/ecm/"
    description = "KDE's CMake modules"

    settings = "os", "compiler", "build_type", "arch"
    generators = "cmake"
    scm = {
        "type": "git",
        "url": "auto",
        "revision": "auto"
     }

    def build(self):
        cmake = CMake(self)
        cmake.configure()
        cmake.build()
        cmake.install()

    def package_info(self):
        self.cpp_info.resdirs = ["share"]
