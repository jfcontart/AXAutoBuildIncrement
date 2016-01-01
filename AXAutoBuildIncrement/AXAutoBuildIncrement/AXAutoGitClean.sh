#!/bin/sh

#  AXAutoGitClean.sh
#
#  Created by Jean-François CONTART on 01/01/2016.
#  Copyright © 2016 idéMobi. All rights reserved.

#------------------------------
# idéMobi 2015©
#------------------------------

#------------------------------
#------------------------------
#------------------------------

#------------------------------
# Git clean
#------------------------------

# AXAutoGitClean <project_dir absolute path>

# sometimes, people forgot to ignore some files at starting project
# we do for them the cleaning!

# example for runs cript in Xcode:
#
#  #get shell source
#  source "${PROJECT_DIR}/${TARGET_NAME}/AXAutoGitClean.sh"
#  #use the first fonction
#  AXAutoGitClean "${PROJECT_DIR}"


AXAutoGitClean () {

##### GET PARAMS #####

PROJECT_DIR="$1"


# remove all user datas

find "${PROJECT_DIR}" -name *.xcuserdatad -print0 | xargs -0 git rm -f -r --ignore-unmatch

find "${PROJECT_DIR}" -name *.xccheckout -print0 | xargs -0 git rm -f -r --ignore-unmatch

find "${PROJECT_DIR}" -name *.moved-aside -print0 | xargs -0 git rm -f -r --ignore-unmatch

find "${PROJECT_DIR}" -name *.xcuserstate -print0 | xargs -0 git rm -f -r --ignore-unmatch

find "${PROJECT_DIR}" -name *.xcscmblueprint -print0 | xargs -0 git rm -f -r --ignore-unmatch

# Obj-C/Swift specific

find "${PROJECT_DIR}" -name *.hmap -print0 | xargs -0 git rm -f -r --ignore-unmatch

find "${PROJECT_DIR}" -name *.ipa -print0 | xargs -0 git rm -f -r --ignore-unmatch

# clean .DS_Store not compiliant with SVN or GIT

find "${PROJECT_DIR}" -name ".DS_Store" -print0 | xargs -0 rm -rf

#------------------------------
# end
#------------------------------

}