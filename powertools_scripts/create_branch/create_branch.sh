#!/bin/bash

BRANCH=$1
ROOT=$2

echo -e "Creating and checking-out requested branch: $1 for repo in directory: $2.\n"
cd $ROOT
git checkout -b $BRANCH || echo -e "Error in branch creation" && exit 1;

echo -e "Completed!"