#!/bin/bash

ROOTPATH=$1
REMOTE=$2
BRANCH=$3
REGEX='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'

# check which program to use for copying to clipboard
if [ -x "$(which clip 2>/dev/null)" ] ; then
    COPY="clip" # Available on MinGw (Windows)
elif [ -x "$(which xclip 2>/dev/null)" ]; then
    COPY="xclip" # Available on GNU/Linux
elif [ -x "$(which pbcopy 2>/dev/null)" ]; then
    COPY="pbcopy" # Available on MacOS
else
    echo -e "Could not find utilities to copy to clipboard.\n"
fi

echo -e "Pushing current HEAD to remote ${REMOTE}, branch: ${BRANCH} \n"
cd $ROOTPATH

OUTPUT=$(git push $REMOTE HEAD:refs/for/$BRANCH) && echo -e $OUTPUT

if [[ $OUTPUT =~ $REGEX ]]
then    
    if [ "$COPY" = '' ]; then
        echo -e "Gerrit link found but not copied to clipboard.\n"
    else
        echo $BASH_REMATCH | $COPY
        echo -e "Gerrit link found and copied to clipboard.\n"
    fi
else
    echo -e "Gerrit link not found!\n"
fi
