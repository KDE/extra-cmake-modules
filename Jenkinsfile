pipeline {
    agent none
    environment {
        CONAN_USERNAME = "obogdan"
        CONAN_PASSWORD = "c2bb9e81ad65edde80eefd2074e368dc1df8fa22"
        CONAN_UPLOAD   = "https://api.bintray.com/conan/obogdan/kde-test"
    }
    stages {
        stage ('Build') {
            environment {
                CONAN_DOCKER_USE_SUDO = "False"
                CONAN_USE_DOCKER = 1
            }
            parallel {
                stage("linux-GCC-7-x86-Release") {
                    agent {
                        label "linux"
                    }
                    environment {
                        CONAN_GCC_VERSIONS = "7"
                        CONAN_ARCHS = "x86"
                        CONAN_BUILD_TYPES = "Release"
                    }
                    steps {
                        sh "python3 build.py"
                    }
                }
                stage("linux-GCC-7-x86-Debug") {
                    agent {
                        label "linux"
                    }
                    environment {
                        CONAN_GCC_VERSIONS = "7"
                        CONAN_ARCHS = "x86"
                        CONAN_BUILD_TYPES = "Debug"
                    }
                    steps {
                        sh "python3 build.py"
                    }
                }
            }
        }
    }
}
