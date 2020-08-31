#!/bin/bash

USE_EXISTING_USERDATA=0
SHORTCUT_NAME="Code_shortcut.lnk"
CODE_EXE_NAME="Code.exe"

function print_help() {
    echo -e "Usage:\n"
    echo "    vscode_portable_installer.sh [-h] -u USER_DATA_FOLDER -e EXTENSIONS_FOLDER"
    echo ""
    echo "    Syntax:"
    echo ""
    echo "        -b"
    echo "           Mandatory argument, used to specify the base path, i.e. the path in which the VSCode-x.x.x folder is located."
    echo ""
    echo "        -e EXTENSIONS_FOLDER"
    echo "           Mandatory argument, used to specify the folder in which extensions are stored (as cygwin path)." 
    echo ""
    echo "        -u USER_DATA_FOLDER"
    echo "           Optional argument, used to specify user-data folder from which to copy user settings and stuff (as cygwin path)."
    echo "           in case VSCode is installed on local machine and you want to copy your settings to the portable version."
    echo "           Default location is /cygdrive/c/Users/<USER>/AppData/Roaming/Code"
    echo ""
    echo "        -h"
    echo "           Optional argument, to display this help message."
    echo ""
    echo ""
    echo "    Example usage:"
    echo ""
    echo "        ./vscode_portable_installer.sh -u -e /cygdrive/d/strofald/tools/VSCode/extensions -b /cygdrive/d/strofald/tools/VSCode"
}

while getopts ":hub:e:" opt; do
  case ${opt} in
    u )
        USE_EXISTING_USERDATA=1
        ;;
    b )
        # BASE_FOLDER should be the one in which the VSCode-x.x.x folder (as extracted from portable ZIP) is present
        # in our case: D:/strofald/tools/VSCode/
        BASE_FOLDER=$OPTARG
        ;;  
    e )
        # where the extensions should be found
        EXTENSIONS_FOLDER=$OPTARG
        ;;  
    h )
        print_help
        exit 0
      ;;
    \? )
        echo -e "Invalid option: -$OPTARG\n" 1>&2        
        exit 1
      ;;
    : )
        echo -e "Invalid Option: -$OPTARG requires an argument\n" 1>&2
        exit 1
      ;;
  esac
done
shift $((OPTIND -1))

if [ -z $BASE_FOLDER ]; then
    
    echo "Base path should be specified using -b option."
    print_help
    exit 1
fi

# find name of the VSCode-X.X.X folder
VSCODE_PATH=$(find $BASE_FOLDER/* -maxdepth 1 -type d -name '*VSCode*' -print -quit)

# create necessary folders
if [ -d ${VSCODE_PATH}/data ]; then
    echo "Found data dir in $(cygpath -w $VSCODE_PATH)."
else
    echo "data dir not found, creating it in $(cygpath -w $VSCODE_PATH)/data."
    mkdir ${VSCODE_PATH}/data
fi

# copy user data, but only if you have VSCode installed on local machine and want to import same data to this copy
if [ "$USE_EXISTING_USERDATA" -eq 1 ]; then
    USERDATA_FOLDER=/cygdrive/c/Users/$USER/AppData/Roaming/Code
    
    if [ -d ${VSCODE_PATH}/data/user-data ]; then
        echo "Found user-data dir in $(cygpath -w $VSCODE_PATH)/data/user-data, deleting it.."
        rm -rf ${VSCODE_PATH}/data/user-data
    else
        echo "user-data dir not found in $(cygpath -w $VSCODE_PATH)/data/user-data."
    fi
    
    echo "Creating user-data dir in $(cygpath -w $VSCODE_PATH)/data/user-data..."
    mkdir ${VSCODE_PATH}/data/user-data
    echo "Copying user-data from $(cygpath -w $USERDATA_FOLDER)..."
    cp -R ${USERDATA_FOLDER}/* ${VSCODE_PATH}/data/user-data
fi

# create a shortcut already setup to start vscode and load extensions from the common extensions folder (on D:/strofald/tools/VSCode/extensions)
if [ -f "$VSCODE_PATH/../$SHORTCUT_NAME" ]; then
    echo "Shortcut $SHORTCUT_NAME already found, deleting.."
    rm $VSCODE_PATH/../$SHORTCUT_NAME
fi

echo "Creating shortcut: $SHORTCUT_NAME..."
powershell -File ./set-shortcut.ps1 "$(cygpath -w $VSCODE_PATH)\Code.exe" "$(cygpath -w $VSCODE_PATH)\..\Code_shortcut.lnk" "$(cygpath -w $EXTENSIONS_FOLDER)"


