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
cd "$ROOTPATH"

# NOTE: git redirects output to stderr, even when no error occurred.
# So here we redirect all output (stderr,stdout) to OUTPUT variable, and then if the command
# executed correctly, we print the output to stdout; if command completed with
# errors, we redirect its output to stderr.
OUTPUT=$(git push $REMOTE HEAD:$BRANCH 2>&1)

if [ ! $? -eq 0 ]; then
    >&2 echo "Git push terminated with errors: ${OUTPUT}"
    exit 1
else
    echo "Git push terminated correctly with output: ${OUTPUT}"
fi

# check if the output contains the gerrit review URL and if yes, copy to clipboard
if [[ $OUTPUT =~ $REGEX ]]
then    
    if [ "$COPY" = '' ]; then
        # cannot copy since no binary has been found to do so
        echo -e "Gerrit link found but not copied to clipboard.\n"
    else
        echo $BASH_REMATCH | $COPY
        echo -e "Gerrit link found and copied to clipboard.\n"
    fi
else
    # No gerrit review URL has been found (git-push output did not contain an URL at all)
    echo -e "Gerrit link not found!\n"
fi
