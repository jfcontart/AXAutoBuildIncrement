#!/bin/sh

#  AXAutoBuildIncrement.sh
#
#  Created by Jean-François CONTART on 31/12/2015.
#  Copyright © 2015 idéMobi. All rights reserved.

#------------------------------
# idéMobi 2015©
#------------------------------

#------------------------------
#------------------------------
#------------------------------

#------------------------------
# Put build information in info.plist
#------------------------------

# AXPlistPutBuildInformation <project_dir absolute path> <info.plist relative path>

# we will insert information about build in the plist, with autoincrementation of build and git, date and user informations

# example for runs cript in Xcode:
#
#  #get shell source
#  source "${PROJECT_DIR}/${TARGET_NAME}/AXAutoBuildIncrement.sh"
#  #use the first function
#  AXPlistPutBuildInformation "${PROJECT_DIR}" "${INFOPLIST_FILE}"
#

function AXPlistPutBuildInformation {

# documentation https://developer.apple.com/library/mac/documentation/DeveloperTools/Reference/XcodeBuildSettingRef/1-Build_Setting_Reference/build_setting_ref.html

##### GET PARAMS #####

PROJECT_DIR="$1"
echo "PROJECT_DIR = $PROJECT_DIR"

INFOPLIST_FILE="$PROJECT_DIR/$2"
echo "INFOPLIST_FILE = $INFOPLIST_FILE"

##### VERSION WITH BUILD AUTO INCREMENT #####

##### DETERMINE BUILD FROM INFO.PLIST #####

# get build number
BUILDNUM=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "${INFOPLIST_FILE}")
# auto-increment build number
NEWBUILDNUM=$(($BUILDNUM + 1))
# write new build number
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $NEWBUILDNUM" "${INFOPLIST_FILE}"

##### DETERMINE GIT TAG AND REVISION #####

cd "${PROJECT_DIR}"
# get Git Tag
BUILD_GIT_TAG=`git tag | tail -n 1`
# install Git Tag
/usr/libexec/PlistBuddy -c  "Delete GITTag" "${INFOPLIST_FILE}"
/usr/libexec/PlistBuddy -c  "Add GITTag string $BUILD_GIT_TAG" "${INFOPLIST_FILE}"

# get Git Revision
BUILD_GIT_NUMBER=`git log --oneline HEAD^1.. | awk '{print $1 }'`
# install Git Revision
/usr/libexec/PlistBuddy -c  "Delete GITHash" "${INFOPLIST_FILE}"
/usr/libexec/PlistBuddy -c  "Add GITHash string $BUILD_GIT_NUMBER" "${INFOPLIST_FILE}"

##### MODIFY BUILD DATE #####

# get BUILD_DATE
BUILD_DATE=`date`
# install BUILD_DATE
/usr/libexec/PlistBuddy -c  "Delete BUILD_DATE" "${INFOPLIST_FILE}"
/usr/libexec/PlistBuddy -c  "Add BUILD_DATE string $BUILD_DATE" "${INFOPLIST_FILE}"

##### MODIFY BUILD USER #####

# install BUILD_USERNAME
BUILD_USERNAME="$(id -u -n)"
# install BUILD_USERNAME
/usr/libexec/PlistBuddy -c  "Delete BUILD_USERNAME" "${INFOPLIST_FILE}"
/usr/libexec/PlistBuddy -c  "Add BUILD_USERNAME string $BUILD_USERNAME" "${INFOPLIST_FILE}"
}

#------------------------------
#------------------------------
#------------------------------

#------------------------------
# Put build information in launchscreen.strings
#------------------------------

# AXLaunchScreenBuildInformation <TARGET_BUILD_DIR absolute path> <INFOPLIST_PATH relative path from target> <TARGET_NAME>
# example for runs cript in Xcode:
#
#  #get shell source
#  source "${PROJECT_DIR}/${TARGET_NAME}/AXAutoBuildIncrement.sh"
#  #use the second function
#  AXLaunchScreenBuildInformation "${TARGET_BUILD_DIR}" "${INFOPLIST_PATH}" "${TARGET_NAME}"
#

function AXLaunchScreenBuildInformation {

VERSIONTEXT="Version "
BUILDTEXT="Build "
GITHASHTEXT="Git Hash "

##### GET PARAMS #####

TARGET_BUILD_DIR="$1"
echo "TARGET_BUILD_DIR = $TARGET_BUILD_DIR"

INFOPLIST_PATH="$2"
echo "INFOPLIST_PATH = $INFOPLIST_PATH"

TARGET_NAME="$3"
echo "TARGET_NAME = $TARGET_NAME"



# documentation https://developer.apple.com/library/mac/documentation/DeveloperTools/Reference/XcodeBuildSettingRef/1-Build_Setting_Reference/build_setting_ref.html

# we need to change some text in the lproj's file of launchscreen

##### VERSION AND BUID IN LAUNCHSCREEN #####

##### DETERMINE VERSION AND BUILD FROM INFO.PLIST #####

VERSIONNUM=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "${TARGET_BUILD_DIR}/${INFOPLIST_PATH}")

BUILDNUM=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "${TARGET_BUILD_DIR}/${INFOPLIST_PATH}")

GITHASHNUM=$(/usr/libexec/PlistBuddy -c "Print GITHash" "${TARGET_BUILD_DIR}/${INFOPLIST_PATH}")

##### DETERMINE STORYBOARDNAME FROM INFO.PLIST #####

STORYBOARDNAME=$(/usr/libexec/PlistBuddy -c "Print UILaunchStoryboardName" "${TARGET_BUILD_DIR}/${INFOPLIST_PATH}")

##### MODIFY LANGUAGE STRING FOR LAUNCHSCREEN #####
LAUNCHSCREEN="${TARGET_BUILD_DIR}/${TARGET_NAME}.app/Base.lproj/$STORYBOARDNAME.storyboardc"
echo $LAUNCHSCREEN
# TRY TO FIND FILE LaunchScreen.storyboardc
if [ -e $LAUNCHSCREEN ];
then
echo "file $LAUNCHSCREEN found"
else
echo "file $LAUNCHSCREEN not found"
fi

cd "${TARGET_BUILD_DIR}/${TARGET_NAME}.app/"

for LPROJ in *.lproj
do
echo $LPROJ
LAUNCHSCREENSTRING=${TARGET_BUILD_DIR}/${TARGET_NAME}.app/$LPROJ/$STORYBOARDNAME.strings
if [ -e $LAUNCHSCREENSTRING ];
then
echo "file $LAUNCHSCREENSTRING found will change version for $VERSIONNUM"
# WE CHANGE VALUE OF "__VERSION__"
# first we tag the original file
perl -i -pe "s/(\.text\" = \")(__VERSION__)(\";)/\1 1.0 \3\/\/__VERSION__/gm" $LAUNCHSCREENSTRING
# second we insert the goog value by ereg the preview tag
perl -i -pe "s/\"([^\"]*)\";\/\/__VERSION__/\"$VERSIONTEXT$VERSIONNUM\";\/\/__VERSION__/gm" $LAUNCHSCREENSTRING
# WE CHANGE VALUE OF "__BUILD__"
# first we tag the original file
perl -i -pe "s/(\.text\" = \")(__BUILD__)(\";)/\1 1.0 \3\/\/__BUILD__/gm" $LAUNCHSCREENSTRING
# second we insert the goog value by ereg the preview tag
perl -i -pe "s/\"([^\"]*)\";\/\/__BUILD__/\"$BUILDTEXT$BUILDNUM\";\/\/__BUILD__/gm" $LAUNCHSCREENSTRING
# WE CHANGE VALUE OF "__GITHASH__"
# first we tag the original file
perl -i -pe "s/(\.text\" = \")(__GITHASH__)(\";)/\1 1.0 \3\/\/__GITHASH__/gm" $LAUNCHSCREENSTRING
# second we insert the goog value by ereg the preview tag
perl -i -pe "s/\"([^\"]*)\";\/\/__GITHASH__/\"$GITHASHTEXT$GITHASHNUM\";\/\/__GITHASH__/gm" $LAUNCHSCREENSTRING
else
echo "file $LAUNCHSCREENSTRING not found"
# WE DON'T CHANGE THE VALUE BECAUSE FILE NOT EXIST
fi
done

}

#------------------------------
#------------------------------
#------------------------------

#------------------------------
# end
#------------------------------