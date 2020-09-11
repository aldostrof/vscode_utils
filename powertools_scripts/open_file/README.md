# Open File - VSCode command

This shortcut allows the creation of a button in the lower taskbar of Visual Studio Code that can be used to open a specific file in the
editor, with path given in **settings.json** file.

# Installation & Usage

1. Install the [vscode-powertools](https://marketplace.visualstudio.com/items?itemName=ego-digital.vscode-powertools) extension for VSCode.
2. Go into your settings.json file, and add the following sections:
    ```json
    ...
    "my.file.path": <insert absolute path of your file>,
    "ego.power-tools.user": {
        "commands": {
            "Open My File": {
                "script": "open_file.js",
                "button": {
                    "text": "Open My File"
                }
            }
        }
    }
    ```
3. Go into your-user-folder/.vscode-powertools folder and copy the file **open_file.js** inside that folder.
4. A button with name *Open My File* should appear in the lower taskbar of VSCode.
5. Click the button to open the desired file in the editor.  

**Note**: you can customize the name of the option `my.file.path` in **settings.json** to your liking; if you do so, remember to adjust the reference in **open_file.js** as well.
