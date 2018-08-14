from conans import ConanFile, CMake
import yaml
import re
import os.path

# Fetching the package version from CMakeLists.txt
def getVersion():
    if(os.path.exists("CMakeLists.txt")):
        regx = re.compile(r"^set\(.*VERSION\s(\"|')[0-9.]+(\"|')\)")
        with open("CMakeLists.txt") as f:
            for line in f:
                if regx.match(line):
                    version = re.search("[0-9.]+", line)
                    return version.group()
    return None

def getMetaField(field):
    if(os.path.exists("metainfo.yaml")):
        with open("metainfo.yaml") as f:
            metainfo = yaml.load(f.read())
        return metainfo[field]
    return None

class ExtraCMakeModulesConan(ConanFile):

    name = getMetaField('name')
    version = getVersion()
    license = getMetaField('license')
    url = getMetaField('url')
    description = getMetaField('description')

    settings = "os", "compiler", "build_type", "arch"
    generators = "cmake"
    scm = {
        "type": "git",
        "url": "auto",
        "revision": "auto"
    }

    requires = (
        # sphinx/1.2@foo/bar

        "Qt/5.11.1@bincrafters/stable"
        # "qt-core/5.8.0@foo/bar",
        # "qt-testing/5.8.0@foo/bar",

        # gperf/latest@foo/bar,
    )

    def build(self):
        cmake = CMake(self)
        cmake.configure()
        cmake.build()
        cmake.install()

    def package_info(self):
        self.cpp_info.resdirs = ["share"]
