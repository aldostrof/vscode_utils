#!/bin/bash

echo "Creating and checking-out requested branch: dev/$1 for repo in directory: $2..."

cd $2
git checkout -b dev/$1 >> /dev/null