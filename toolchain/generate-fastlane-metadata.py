#!/usr/bin/env python3
#
# SPDX-FileCopyrightText: 2018-2020 Aleix Pol Gonzalez <aleixpol@kde.org>
# SPDX-FileCopyrightText: 2019-2020 Ben Cooksley <bcooksley@kde.org>
# SPDX-FileCopyrightText: 2020 Volker Krause <vkrause@kde.org>
#
# SPDX-License-Identifier: GPL-2.0-or-later
#
# Generates fastlane metadata for Android apps from appstream files.
#

import argparse
import glob
import io
import os
import re
import requests
import shutil
import subprocess
import sys
import tempfile
import xdg.DesktopEntry
import xml.etree.ElementTree as ET
import yaml
import zipfile

# Constants used in this script
languageMap = {
    None: "en-US",
    "ca": "ca-ES"
}

# see https://f-droid.org/en/docs/All_About_Descriptions_Graphics_and_Screenshots/
supportedRichTextTags = { 'li', 'ul', 'ol', 'li', 'b', 'u', 'i' }

# Android appdata.xml textual item parser
# This function handles reading standard text entries within an Android appdata.xml file
# In particular, it handles splitting out the various translations, and converts some HTML to something which F-Droid can make use of
def readText(elem, found):
    # Determine the language this entry is in
    lang = elem.get('{http://www.w3.org/XML/1998/namespace}lang')
    if lang == 'x-test':
        return

    # Do we have any text for this language yet?
    # If not, get everything setup
    if not lang in found:
        found[lang] = ""

    # If there is text available, we'll want to extract it
    # Additionally, if this element has any children, make sure we read those as well
    # It isn't clear if it is possible for an item to not have text, but to have children which do have text
    # The code will currently skip these if they're encountered
    if elem.text:
        if elem.tag in supportedRichTextTags:
            found[lang] += '<' + elem.tag + '>'
        found[lang] += elem.text
        for child in elem:
            readText(child, found)
        if elem.tag in supportedRichTextTags:
            found[lang] += '</' + elem.tag + '>'

    # Finally, if this element is a HTML Paragraph (p) or HTML List Item (li) make sure we add a new line for presentation purposes
    if elem.tag == 'li' or elem.tag == 'p':
        found[lang] += "\n"


# Create the various Fastlane format files per the information we've previously extracted
# These files are laid out following the Fastlane specification (links below)
# https://github.com/fastlane/fastlane/blob/2.28.7/supply/README.md#images-and-screenshots
# https://docs.fastlane.tools/actions/supply/
def createFastlaneFile( applicationName, filenameToPopulate, fileContent ):
    # Go through each language and content pair we've been given
    for lang, text in fileContent.items():
        # First, do we need to amend the language id, to turn the Android language ID into something more F-Droid/Fastlane friendly?
        languageCode = languageMap.get(lang, lang)

        # Next we need to determine the path to the directory we're going to be writing the data into
        repositoryBasePath = arguments.output
        path = os.path.join( repositoryBasePath, 'metadata',  applicationName, languageCode )

        # Make sure the directory exists
        os.makedirs(path, exist_ok=True)

        # Now write out file contents!
        with open(path + '/' + filenameToPopulate, 'w') as f:
            f.write(text)

# Create the summary appname.yml file used by F-Droid to summarise this particular entry in the repository
# see https://f-droid.org/en/docs/Build_Metadata_Reference/
def createYml(appname, data):
    # Prepare to retrieve the existing information
    info = {}

    # Determine the path to the appname.yml file
    repositoryBasePath = arguments.output
    path = os.path.join( repositoryBasePath, 'metadata', appname + '.yml' )

    # Update the categories first
    # Now is also a good time to add 'KDE' to the list of categories as well
    if 'categories' in data:
        info['Categories'] = data['categories'][None] + ['KDE']
    else:
        info['Categories']  = ['KDE']

    # Update the general sumamry as well
    info['Summary'] = data['summary'][None]

    # Check to see if we have a Homepage...
    if 'url-homepage' in data:
        info['WebSite'] = data['url-homepage'][None]

    # What about a bug tracker?
    if 'url-bugtracker' in data:
        info['IssueTracker'] = data['url-bugtracker'][None]

    if 'project_license' in data:
        info["License"] = data['project_license'][None]

    if 'source-repo' in data:
        info['SourceCode'] = data['source-repo']

    # static data
    info['Donate'] = 'https://kde.org/community/donations/'
    info['Translation'] = 'https://l10n.kde.org/'

    # Finally, with our updates completed, we can save the updated appname.yml file back to disk
    with open(path, 'w') as output:
        yaml.dump(info, output, default_flow_style=False)

# Integrates locally existing image assets into the metadata
def processLocalImages(applicationName, data):
    if not os.path.exists(os.path.join(arguments.source, 'fastlane')):
        return

    outPath = os.path.abspath(arguments.output);
    oldcwd = os.getcwd()
    os.chdir(os.path.join(arguments.source, 'fastlane'))

    imageFiles = glob.glob('metadata/**/*.png', recursive=True)
    imageFiles.extend(glob.glob('metadata/**/*.jpg', recursive=True))
    for image in imageFiles:
        # noramlize single- vs multi-app layouts
        imageDestName = image.replace('metadata/android', 'metadata/' + applicationName)

        # copy image
        os.makedirs(os.path.dirname(os.path.join(outPath, imageDestName)), exist_ok=True)
        shutil.copy(image, os.path.join(outPath, imageDestName))

        # if the source already contains screenshots, those override whatever we found in the appstream file
        if 'phoneScreenshots' in image:
            data['screenshots'] = {}

    os.chdir(oldcwd)

# Download screenshots referenced in the appstream data
# see https://f-droid.org/en/docs/All_About_Descriptions_Graphics_and_Screenshots/
def downloadScreenshots(applicationName, data):
    if not 'screenshots' in data:
        return

    path = os.path.join(arguments.output, 'metadata',  applicationName, 'en-US', 'images', 'phoneScreenshots')
    os.makedirs(path, exist_ok=True)

    i = 0
    for screenshot in data['screenshots']:
        fileName = str(i) + '-' + screenshot[screenshot.rindex('/') + 1:]
        r = requests.get(screenshot)
        if r.status_code < 400:
            with open(os.path.join(path, fileName), 'wb') as f:
                f.write(r.content)
            i += 1

# Put all metadata for the given application name into an archive
# We need this to easily transfer the entire metadata to the signing machine for integration
# into the F-Droid nightly repository
def createMetadataArchive(applicationName):
    srcPath = os.path.join(arguments.output, 'metadata')
    zipFileName = os.path.join(srcPath, 'fastlane-' + applicationName + '.zip')
    if os.path.exists(zipFileName):
        os.unlink(zipFileName)
    archive = zipfile.ZipFile(zipFileName, 'w')
    archive.write(os.path.join(srcPath, applicationName + '.yml'), applicationName + '.yml')

    oldcwd = os.getcwd()
    os.chdir(srcPath)
    for file in glob.iglob(applicationName + '/**', recursive=True):
        archive.write(file, file)
    os.chdir(oldcwd)

# Main function for extracting metadata from APK files
def processApkFile(apkFilepath):
    # First, determine the name of the application we have here
    # This is needed in order to locate the metadata files within the APK that have the information we need

    # Prepare the aapt (Android SDK command) to inspect the provided APK
    commandToRun = "aapt dump badging %s" % (apkFilepath)
    manifest = subprocess.check_output( commandToRun, shell=True ).decode('utf-8')
    # Search through the aapt output for the name of the application
    result = re.search(' name=\'([^\']*)\'', manifest)
    applicationName = result.group(1)

    # Attempt to look within the APK provided for the metadata information we will need
    with zipfile.ZipFile(apkFilepath, 'r') as contents:
        appdataFile = contents.open("assets/share/metainfo/%s.appdata.xml" % applicationName)
        desktopFileContent = None
        try:
            desktopFileContent = contents.read("assets/share/applications/%s.desktop" % applicationName)
        except:
            None
        processAppstreamData(applicationName, appdataFile.read(), desktopFileContent)

# Extract meta data from appstream/desktop file contents
def processAppstreamData(applicationName, appstreamData, desktopData):
    data = {}
    # Within this file we look at every entry, and where possible try to export it's content so we can use it later
    root = ET.fromstring(appstreamData)
    for child in root:
        # Make sure we start with a blank slate for this entry
        output = {}

        # Grab the name of this particular attribute we're looking at
        # Within the Fastlane specification, it is possible to have several items with the same name but as different types
        # We therefore include this within our extracted name for the attribute to differentiate them
        tag = child.tag
        if 'type' in child.attrib:
            tag += '-' + child.attrib['type']

        # Have we found some information already for this particular attribute?
        if tag in data:
            output = data[tag]

        # Are we dealing with category information here?
        # If so, then we need to look into this items children to find out all the categories this APK belongs in
        if tag == 'categories':
            cats = []
            for x in child:
                cats.append(x.text)
            output = { None: cats }

        # screenshot links
        elif tag == 'screenshots':
            output = []
            for screenshot in child:
                if screenshot.tag == 'screenshot':
                    for image in screenshot:
                        if image.tag == 'image':
                            output.append(image.text)

        # Otherwise this is just textual information we need to extract
        else:
            readText(child, output)

        # Save the information we've gathered!
        data[tag] = output

    # Did we find any categories?
    # Sometimes we don't find any within the Fastlane information, but without categories the F-Droid store isn't of much use
    # In the event this happens, fallback to the *.desktop file for the application to see if it can provide any insight.
    if not 'categories' in data and desktopData:
        # The Python XDG extension/wrapper requires that it be able to read the file itself
        # To ensure it is able to do this, we transfer the content of the file from the APK out to a temporary file to keep it happy
        (fd, path) = tempfile.mkstemp(suffix=applicationName + ".desktop")
        handle = open(fd, "wb")
        handle.write(desktopData)
        handle.close()
        # Parse the XDG format *.desktop file, and extract the categories within it
        desktopFile = xdg.DesktopEntry.DesktopEntry(path)
        data['categories'] = { None: desktopFile.getCategories() }

    # Try to figure out the source repository
    if arguments.source and os.path.exists(os.path.join(arguments.source, '.git')):
        output = subprocess.check_output('git remote show -n origin', shell=True, cwd = arguments.source).decode('utf-8')
        result = re.search(' Fetch URL: (.*)\n', output)
        data['source-repo'] = result.group(1)

    # write meta data
    createFastlaneFile( applicationName, "title.txt", data['name'] )
    createFastlaneFile( applicationName, "short_description.txt", data['summary'] )
    createFastlaneFile( applicationName, "full_description.txt", data['description'] )
    createYml(applicationName, data)

    # cleanup old image files before collecting new ones
    imagePath = os.path.join(arguments.output, 'metadata',  applicationName, 'en-US', 'images')
    shutil.rmtree(imagePath, ignore_errors=True)
    processLocalImages(applicationName, data)
    downloadScreenshots(applicationName, data)

    # put the result in an archive file for easier use by Jenkins
    createMetadataArchive(applicationName)

# Generate metadata for the given appstream and desktop files
def processAppstreamFile(appstreamFileName, desktopFileName):
    appstreamFile = open(appstreamFileName, "rb")
    desktopData = None
    if desktopFileName and os.path.exists(desktopFileName):
        desktopFile = open(desktopFileName, "rb")
        desktopData = desktopFile.read()
    applicationName = os.path.basename(appstreamFileName)[:-12]
    processAppstreamData(applicationName, appstreamFile.read(), desktopData)

# scan source directory for manifests/metadata we can work with
def scanSourceDir():
    files = glob.iglob(arguments.source + "/**/AndroidManifest.xml*", recursive=True)
    for file in files:
        # third-party libraries might contain AndroidManifests which we are not interested in
        if "3rdparty" in file:
            continue

        # find application id from manifest files
        root = ET.parse(file)
        appname = root.getroot().attrib['package']
        is_app = False
        prefix = '{http://schemas.android.com/apk/res/android}'
        for md in root.findall("application/activity/meta-data"):
            if md.attrib[prefix + 'name'] == 'android.app.lib_name':
                is_app = True

        if not appname or not is_app:
            continue

        # now that we have the app id, look for matching appdata/desktop files
        appdataFiles = glob.iglob(arguments.source + "/**/" + appname + ".appdata.xml", recursive=True)
        appdataFile = None
        for f in appdataFiles:
            appdataFile = f
            break
        if not appdataFile:
            continue

        desktopFiles = glob.iglob(arguments.source + "/**/" + appname + ".desktop", recursive=True)
        desktopFile = None
        for f in desktopFiles:
            desktopFile = f
            break

        processAppstreamFile(appdataFile, desktopFile)


### Script Commences

# Parse the command line arguments we've been given
parser = argparse.ArgumentParser(description='Generate fastlane metadata for Android apps from appstream metadata')
parser.add_argument('--apk', type=str, required=False, help='APK file to extract metadata from')
parser.add_argument('--appstream', type=str, required=False, help='Appstream file to extract metadata from')
parser.add_argument('--desktop', type=str, required=False, help='Desktop file to extract additional metadata from')
parser.add_argument('--source', type=str, required=False, help='Source directory to find metadata in')
parser.add_argument('--output', type=str, required=True, help='Path to which the metadata output should be written to')
arguments = parser.parse_args()

# ensure the output path exists
os.makedirs(arguments.output, exist_ok=True)

# if we have an appstream file explicitly specified, let's use that one
if arguments.appstream and os.path.exists(arguments.appstream):
    processAppstreamFile(arguments.appstream, arguments.desktop)
    sys.exit(0)

# else, if we have an APK, try to find the appstream file in there
# this ensures compatibility with the old metadata generation
if arguments.apk and os.path.exists(arguments.apk):
    processApkFile(arguments.apk)
    sys.exit(0)

# else, look in the source dir for appstream/desktop files
# this follows roughly what get-apk-args from binary factory does
if arguments.source and os.path.exists(arguments.source):
    scanSourceDir()
    sys.exit(0)

# else: missing arguments
print("Either one of --appstream, --apk or --source have to be provided!")
sys.exit(1)
