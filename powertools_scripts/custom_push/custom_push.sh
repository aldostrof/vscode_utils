#!/bin/bash

ROOTPATH=$1
REMOTE=$2
BRANCH=$3
REGEX='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'

echo -e "Pushing current HEAD to remote $REMOTE, branch: $BRANCH \n"
cd $ROOTPATH

# to be sostituted with:
# OUTPUT=$(git push $REMOTE HEAD:refs/for/$BRANCH)
OUTPUT=$(echo -e "Hello\n \
         This is a multiline string\n \
         Containing a URL\n \
         Here it is\n \
         https://gerrit.st.com/c/autosar/STUBS/drv_base/+/174257\n")

echo -e $OUTPUT

if [[ $OUTPUT =~ $REGEX ]]
then 
    echo -e "Gerrit Link found!\n"
    echo $BASH_REMATCH | clip
else
    echo -e "Gerrit link not found!\n"
fi
