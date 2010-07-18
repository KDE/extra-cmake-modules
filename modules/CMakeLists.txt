## install the cmake files

set(module_install_dir ${DATA_INSTALL_DIR}/cmake/modules )

# maybe FindHUNSPELL.cmake doesn't have to be installed ?
# This variable doesn't actually do anything, but it's probably a good idea
# to have it around, so there is a place where the modules which are not installed
# are listed explicitely:
set(cmakeFilesDontInstall
               FindPolkitQt.cmake
               FindPolkitQt-1.cmake)

# remove once we depend on a newer cmake version:
# FindPackageHandleStandardArgs (2.8.2)

# Explicitely list all files which will be installed.
# We don't use a GLOB anymore so we can have also cmake files here
# which are used inside kdelibs, but which don't have to be installed (and
# so become part of the public interface of kdelibs which has to be kept 
# compatible).
set(cmakeFiles CheckCXXSourceCompiles.cmake
               CheckCXXSourceRuns.cmake
               CheckCXXSymbolExists.cmake
               CheckPointerMember.cmake
               CheckPrototypeExists.cmake
               CheckStructMember.cmake
               FindACL.cmake
               FindAGG.cmake
               FindAkode.cmake
               FindAlsa.cmake
               FindAutomoc4.cmake
               FindAvahi.cmake
               FindBerkeleyDB.cmake
               FindBlitz.cmake
               FindBlueZ.cmake
               FindBoost.cmake
               FindCarbon.cmake
               FindDBusMenuQt.cmake
               FindDNSSD.cmake
               FindENCHANT.cmake
               FindEigen.cmake
               FindEigen2.cmake
               FindExiv2.cmake
               FindFAM.cmake
               FindFFmpeg.cmake
               FindFlac.cmake
               FindFlex.cmake
               FindFontconfig.cmake
               FindFreetype.cmake
               FindGIF.cmake
               FindGLIB2.cmake
               FindGMP.cmake
               FindGObject.cmake
               FindGSSAPI.cmake
               FindGStreamer.cmake
               FindGettext.cmake
               FindGphoto2.cmake
               FindHUNSPELL.cmake
               FindIOKit.cmake
               FindKDE4Internal.cmake
               FindKDE4Workspace.cmake
               FindKDevPlatform.cmake
               FindKDEWIN32.cmake
               FindKDEWIN_Packager.cmake
               FindKDEWin.cmake
               FindKdcraw.cmake
               FindKdeMultimedia.cmake
               FindKdepim.cmake
               FindKdepimLibs.cmake
               FindKexiv2.cmake
               FindKipi.cmake
               FindKopete.cmake
               FindKorundum.cmake
               FindLCMS.cmake
               FindLibArt.cmake
               FindLibAttica.cmake
               FindLibKonq.cmake
               FindLibLZMA.cmake
               FindLibXml2.cmake
               FindLibXslt.cmake
               FindLibintl.cmake
               FindLibraryWithDebug.cmake
               FindLinuxWirelesstools.cmake
               FindMsgfmt.cmake
               FindMusicBrainz.cmake
               FindMySQL.cmake
               FindNepomuk.cmake
               FindNetworkManager.cmake
               FindOggVorbis.cmake
               FindOpenEXR.cmake
               FindOpenSSL.cmake
               FindPCRE.cmake
               FindPhonon.cmake
               FindPkgConfig.cmake
               FindPlasma.cmake
               FindPopplerQt4.cmake
               FindPostgreSQL.cmake
               FindPulseAudio.cmake
               FindPyKDE4.cmake
               FindPyQt4.cmake
               Qt4Macros.cmake
               Qt4ConfigDependentSettings.cmake
               FindPackageHandleStandardArgs.cmake
               FindPythonLibrary.cmake
               FindQCA2.cmake
               FindQImageBlitz.cmake
               FindQt4.cmake
               FindRUBY.cmake
               FindSIP.cmake
               FindSamba.cmake
               FindSane.cmake
               FindSasl2.cmake
               FindSharedMimeInfo.cmake
               FindSharedDesktopOntologies.cmake
               FindSoprano.cmake
               FindSqlite.cmake
               FindStrigi.cmake
               FindTaglib.cmake
               FindUSB.cmake
               FindWcecompat.cmake
               FindX11.cmake
               FindXKB.cmake
               FindXine.cmake
               FindXmms.cmake
               HandleImportedTargetsInCMakeRequiredLibraries.cmake
               KDE4Defaults.cmake
               KDE4Macros.cmake
               MacroAddCompileFlags.cmake
               MacroAddLinkFlags.cmake
               MacroAdditionalCleanFiles.cmake
               MacroAppendIf.cmake
               MacroBoolTo01.cmake
               MacroEnsureOutOfSourceBuild.cmake
               MacroEnsureVersion.cmake
               MacroKAuth.cmake
               MacroLibrary.cmake
               MacroLogFeature.cmake
               MacroOptionalAddSubdirectory.cmake
               MacroOptionalDependPackage.cmake
               MacroOptionalFindPackage.cmake
               MacroPushRequiredVars.cmake
               MacroWriteBasicCMakeVersionFile.cmake
               NepomukMacros.cmake
               NepomukAddOntologyClasses.cmake
               PythonMacros.cmake
               SIPMacros.cmake
               Win32Macros.cmake
               check_installed_exports_file.cmake
               config-alsa.h.cmake
               create_exe_symlink.cmake
               kde4_exec_via_sh.cmake
               kde4uic.cmake
               cmake-modules-styleguide.txt 
               kde4init_dummy.cpp.in 
               kde4init_win32lib_dummy.cpp.in 
               kde4_cmake_uninstall.cmake.in 
               kde4automoc.files.in 
               BasicFindPackageVersion.cmake.in
               FindLibPython.py
               FindPyKDE4.py
               FindPyQt.py
               FindSIP.py
               PythonCompile.py
               )

if (KDE4_ENABLE_UAC_MANIFEST)
   set(cmakeFiles ${cmakeFiles} Win32.Manifest.in )
endif (KDE4_ENABLE_UAC_MANIFEST)

install(FILES ${cmakeFiles}
        DESTINATION ${module_install_dir} )

         
# the files listed here will be removed by remove_obsoleted_cmake_files.cmake, Alex
#set(FILES_TO_REMOVE
#)

#install(SCRIPT ${CMAKE_CURRENT_BINARY_DIR}/remove_files.cmake )

#file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/remove_files.cmake "#generated by cmake, dont edit\n\n")
#foreach ( _current_FILE ${FILES_TO_REMOVE})
#   file(APPEND ${CMAKE_CURRENT_BINARY_DIR}/remove_files.cmake "message(STATUS \"Removing ${_current_FILE}\" )\n" )
#   file(APPEND ${CMAKE_CURRENT_BINARY_DIR}/remove_files.cmake "exec_program( ${CMAKE_COMMAND} ARGS -E remove ${_current_FILE} OUTPUT_VARIABLE _dummy)\n" )
#endforeach ( _current_FILE)

# create and install a man page for the kdelibs cmake modules
add_custom_target(KDECMakeModulesManPage ALL COMMAND ${CMAKE_COMMAND} -DCMAKE_MODULE_PATH=${CMAKE_CURRENT_SOURCE_DIR} --help-custom-modules ${CMAKE_CURRENT_BINARY_DIR}/kdecmake.1)
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/kdecmake.1 DESTINATION "${MAN_INSTALL_DIR}/man1")
