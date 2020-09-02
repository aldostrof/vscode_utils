#!/bin/bash

# colored output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

USE_EXISTING_INSTALL=0
BASE_FOLDER=".."
VSCODE_PATH="$BASE_FOLDER/VSCode_portable"
#SHORTCUT_NAME="code_shortcut"

# windows-related
WIN_SCRIPT_FOLDER=$BASE_FOLDER/scripts/windows
# TODO: make sure links are always unchanged when new VSCode versions are released
WIN_VSCODE64BIT_DOWNLOAD_LINK="https://go.microsoft.com/fwlink/?Linkid=850641"
#CODE_EXE_NAME="Code.exe"

#TODO: fill for other OS

function print_help() {
    echo "[VsCode portability helper script]"    
    echo ""
    echo ""
    echo -e "Usage:\n"
    echo "    vscode_portable_installer.sh [-h] [-m]"
    echo ""
    echo "    Syntax:"
    echo ""
    echo "        -m USER_DATA_FOLDER"
    echo "           Optional argument, used to specify if you want to copy user-data and extensions folders from an existing VSCode installation on local machine."
    echo "           If not specified, empty user-data and extensions folders will be created."
    echo ""
    echo "        -h"
    echo "           Optional argument, to display this help message."
    echo ""
    echo ""
    echo ""
    echo "    Example usage:"
    echo ""
    echo "        ./vscode_portable_installer.sh"
    echo "        ./vscode_portable_installer.sh -m"
    echo "        ./vscode_portable_installer.sh -h"
    echo ""
    echo ""
    echo ""
}

function print_error() {
    # 1>&2: redirect stdout to stderr
    echo -e "${RED}$1${NC}\n" 1>&2
}

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     ENV=Linux;;
    Darwin*)    ENV=Mac;;
    CYGWIN*)    ENV=Cygwin;;
    MINGW*)     ENV=MinGw;;
    MSYS*)      ENV=MSYS;;
    *)          ENV="UNKNOWN:${unameOut}"
esac

if [ "$ENV" = "UNKNOWN:${unameOut}" ]; then
    print_error "Unsupported environment."
    exit 1
fi

if [ "$ENV" = "Cygwin" ] || [ "$ENV" = "MinGw" ] || [ "$ENV" = "MSYS" ]; then
    MACHINE=WIN
elif [ "$ENV" = "Mac" ]; then
    MACHINE=MAC
elif [ "$ENV" = "Linux" ]; then
    MACHINE=LINUX
fi

while getopts ":hm" opt; do
  case ${opt} in
    m )
        USE_EXISTING_INSTALL=1
        ;;
    h )
        print_help
        exit 0
      ;;
    \? )
        print_error "Invalid option: -$OPTARG\n"
        exit 1
      ;;
    : )
        print_error "Invalid Option: -$OPTARG requires an argument\n"
        exit 1
      ;;
  esac
done
shift $((OPTIND -1))

echo -e "Detected environment: $ENV.\n"
echo -e "Detected OS: $MACHINE.\n"

# abort if the required folder structure is not respectedcd

if [ ! -d "$WIN_SCRIPT_FOLDER" ]; then    
    print_error "Required files are missing, please check your folder structure."
    exit 1
fi

# TODO: add checks for other folders belonging to other OS

if [ "$MACHINE" = "WIN" ]; then
    DOWNLOAD_LINK=$WIN_VSCODE64BIT_DOWNLOAD_LINK
fi

# TODO add checks for other machines

echo -e "Starting VSCode portable zip download.\n"

# download VSCode portable zip in the script parent directory
# TODO: test wget
if [ -x "$(which wget 2>/dev/null)" ] ; then
    wget -q $DOWNLOAD_LINK || ( print_error "Error downloading VSCode.\n" && exit 1 );
elif [ -x "$(which curl 2>/dev/null)" ]; then
    curl $DOWNLOAD_LINK -Ls -O -J || ( print_error "Error downloading VSCode.\n" && exit 1 );
else
    print_error "Could not find curl or wget, please install one of them.\n"
    exit 1
fi

# move VSCode zip to parent directory
VSCODE_DOWNLOADED_ZIP=$(find . -name '*.zip' -print)
mv $VSCODE_DOWNLOADED_ZIP "${BASE_FOLDER}/${VSCODE_DOWNLOADED_ZIP}"

echo -e "${GREEN}Download completed successfully.${NC}\n"

# unzip VSCode.zip file
echo -e "Unzipping ${VSCODE_DOWNLOADED_ZIP} downloaded archive..\n"

if [ -x "$(which unzip)" ] ; then
    unzip "${BASE_FOLDER}/${VSCODE_DOWNLOADED_ZIP}" -d "${VSCODE_PATH}" > /dev/null 2>&1 || ( print_error "Unzip error." && exit 1 );
else
    print_error "Could not find unzip binary, please install it to continue."
    exit 1
fi

echo -e "${GREEN}Unzipped in ${VSCODE_PATH}.${NC}\n"

# create necessary folders
echo -e "Creating necessary folders..\n"

echo -e "Creating data folder in ${VSCODE_PATH}...\n"
mkdir $VSCODE_PATH/data
echo -e "Creating user-data folder in ${VSCODE_PATH}/data...\n"
mkdir ${VSCODE_PATH}/data/user-data

if [ "$USE_EXISTING_INSTALL" -eq 0 ]; then
    echo -e "Creating extensions folder in ${VSCODE_PATH}/data...\n"
    mkdir ${VSCODE_PATH}/data/extensions
fi

echo -e "Creating tmp folder in ${VSCODE_PATH}/data...\n"
mkdir $VSCODE_PATH/data/tmp

# If you have an existing VSCode installation and you specified the -m argument, then $VSCODE_PATH/data/user-data and $VSCODE_PATH/data/extensions folder will be created
# in the root folder, the content of the user-data folder of the local machine installation will be copied to $VSCODE_PATH/data/user-data
# in the same way, the content of the extensions folder of the local machine installation will be copied to $VSCODE_PATH/data/extensions
# if no -m argument is specified, the creation of $VSCODE_PATH/data folder is enough.
if [ "$USE_EXISTING_INSTALL" -eq 1 ]; then

    echo -e "Requested copy from existing installation.\n"
    CURR_USER=$(whoami)

    # TODO: add support for other machines
    if [ "$MACHINE" = "WIN" ]; then
        if [ "$ENV" = "Cygwin" ]; then
            USERDATA_FOLDER="/cygdrive/c/Users/$CURR_USER/AppData/Roaming/Code"
            EXTENSIONS_FOLDER="/cygdrive/c/Users/$CURR_USER/.vscode/extensions"
        else
            USERDATA_FOLDER="/c/Users/$CURR_USER/AppData/Roaming/Code"
            EXTENSIONS_FOLDER="/c/Users/$CURR_USER/.vscode/extensions"
        fi
    fi

    if [ ! -d "$USERDATA_FOLDER" ] || [ ! -d "$EXTENSIONS_FOLDER" ]; then    
        print_error "extensions and/or user-data folders not found on local machine, cannot copy."
        exit 1
    else
        echo -e "Found user-data in: ${USERDATA_FOLDER}\n"
        echo -e "Found extensions in: ${EXTENSIONS_FOLDER}\n"
    fi
    

    echo -e "Copying user-data from ${USERDATA_FOLDER}...\n"
    cp -R "$USERDATA_FOLDER"/* $VSCODE_PATH/data/user-data

    echo -e "Copying extensions from ${EXTENSIONS_FOLDER}...\n"
    cp -R "$EXTENSIONS_FOLDER" $VSCODE_PATH/data
fi

echo -e "${GREEN}Directories created/copied correctly.${NC}\n"

# turn $VSCODE_PATH into absolute path
ROOT=$(pwd)
cd "$VSCODE_PATH"
VSCODE_ABSOLUTE_PATH=$(pwd)
cd "$ROOT"

echo -e "${GREEN}Completed! VSCode executable can be found in ${VSCODE_ABSOLUTE_PATH} ${NC}\n"


# create a shortcut already setup to start the portable VSCode executable and load extensions from the extensions folder
# Temporarily removed, since may be not worth the effort.

# echo -e "Creating shortcut..\n"

# # turn $VSCODE_PATH into absolute path
# ROOT=$(pwd)
# cd "$VSCODE_PATH"
# VSCODE_ABSOLUTE_PATH=$(pwd)
# cd "$ROOT"

# # we're on windows
# if [ "$MACHINE" = "WIN" ]; then
    
#     if [ -f "${BASE_FOLDER}/${SHORTCUT_NAME}.lnk" ]; then
#         echo -e "Shortcut $SHORTCUT_NAME.lnk already found, deleting..\n"
#         rm "${BASE_FOLDER}/${SHORTCUT_NAME}.lnk"
#     fi

#     # make sure paths are well-formed
#     if [ "$ENV" = "Cygwin" ]; then
#         VSCODE_ABSOLUTE_PATH_WIN=$(cygpath -w "$VSCODE_ABSOLUTE_PATH")
#         #$EXTENSIONS_FOLDER_WIN=$(cygpath -w $EXTENSIONS_FOLDER)
#     else
#         VSCODE_ABSOLUTE_PATH_WIN=$(echo "$VSCODE_ABSOLUTE_PATH" | sed 's/^\///' | sed 's/\//\\/g' | sed 's/^./\0:/')
#         #$EXTENSIONS_FOLDER_WIN=$(echo "$EXTENSIONS_FOLDER" | sed -e 's/^\///' -e 's/\//\\/g' -e 's/^./\0:/')
#     fi
#     powershell -File ./windows/set_shortcut.ps1 "$VSCODE_ABS_PATH_WIN\Code.exe" "$VSCODE_ABS_PATH_WIN\..\Code_shortcut.lnk" || print_error "Error while creating shortcut."
# fi

# # TODO: add support for other platforms.


