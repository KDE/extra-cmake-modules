from conans import ConanFile, CMake

def getVersion():
    return "5.50.0"

class ExtracmakemodulesConan(ConanFile):
    name = "extra-cmake-modules"
    version = getVersion()
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
