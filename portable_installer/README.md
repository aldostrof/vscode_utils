# VSCode Portable installer

This folder contains utility scripts which can be used to ease the portability of VSCode installation through different platforms.
Directory content:

|-- **scripts**                         => contains the scripts which are actually in this folder.  
|---- **vscode_portable_installer.sh**  => installer script.  
|---- **windows**                       => Windows-specific scripts folder.  
|---- **linux**                         => GNU/Linux-specific scripts folder.  
|---- **mac**                           => MacOS-specific scripts folder.  

The **vscode_portable_installer.sh** script is in charge of handling the whole download and folder setup process.  
This script:  
- Checks the bash platform and the machine on which is being run (i.e. CYGWIN/MinGw on Windows)
- Downloads and unzips the latest VSCode portable version found on [this page](https://code.visualstudio.com/download).
- Configures all the needed folders.
- If requested with the -m argument, copies the extensions and user-data from an existing local machine installation.

# Instructions

1. Clone the repository and go the the **portable_installer/scripts** folder.
2. Run the command:  
    `$ ./vscode_portable_installer.sh`  
   or:  
    `$ ./vscode_portable_installer.sh -m`  
   if you want to re-use user-data and extensions folders from an existing local installation.
3. If the procedure completed correctly, you will have the following folder structure:

|-- **scripts**                         => contains the scripts which are actually in this folder.  
|-- **VSCode_portable**                 => contains VSCode installation files and folders.  
|-- **VSCode-<...>-X.XX.X.zip**         => downloaded zip file.  

Then you can use the VSCode executable found in **VSCode_portable/** folder.  

# Restrictions

Some restrictions for the use of the script:
- The only supported OS is Windows @ MinGw; support for other bash environments/OS is under development.
- The script does not handle the update process; follow the below instructions to do so.

    If you want to update your VSCode installation to a new version:
    1. Go to the [Download page](https://code.visualstudio.com/download) to obtain the latest VSCode portable zip.
    2. Unzip the downloaded file and copy your VSCode_portable/data folder into the unzipped folder.

**NOTE**: future releases of the script will also be equipped with an auto-update feature.  

# TODO
[ ] - Extend and test to other Windows environments   
[ ] - Extend and test to other OS  
[ ] - Test wget download  
[ ] - Implement auto-update feature  
