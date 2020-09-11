# Custom `git-push` VSCode command

This shortcut allows the creation of a VSCode-styled dialog menu which allows the execution of a custom `git-push` command.  
The command which VSCode issues when you click "Push/Push To.." is:  

    git push <remote> <local_branch>:<remote_branch>   
    
Where the **local_branch** is setup, in .gitconfig file, to be tracking the remote **remote_branch**.  
If you work with [Gerrit](https://www.gerritcodereview.com/) (as I do at my workplace), you usually end up writing a git push command that looks like this:  

    git push <gerrit_remote> HEAD:refs/for/<current_local_branch>   

or:  

    git push <gerrit_remote> HEAD:refs/changes/<changeID>  
    
in order to push the HEAD of your current branch for review.  
Anyway, .gitconfig file cannot be configured in order to have a refspec which allows HEAD of your current branch to be tracking the remote refs/... branch, as stated in [this](https://stackoverflow.com/questions/21946814/git-push-to-gerrit-with-a-tracking-branch) StackOverflow question.  

Since I use VSCode with the [vscode-powertools](https://marketplace.visualstudio.com/items?itemName=ego-digital.vscode-powertools) extensions, I developed a JS script and a bash script that allow to automatize this process.  
The **custom_push.js** script:  
- Asks for remote name
- Asks for branch name (tipically: *refs/for/branch_name* or *refs/changes/change_id*)
- Runs the **custom_push.sh** script to execute the push command with the given inputs.

The **custom_push.sh** bash script just executes the command:  

    git push <remote> HEAD:<remote_branch>
    
where remote and remote_branch are the inputs.  
Furthermore, this script searches the output of the above command for the Gerrit review link, and copies it to the clipboard.

# Installation & Usage

1. Install the [vscode-powertools](https://marketplace.visualstudio.com/items?itemName=ego-digital.vscode-powertools) extension for VSCode.
2. Go into your settings.json file, and add the following sections:
    ```json
    ...
    "bash.path": <insert path to your bash executable>,
    "powertools.scripts.bash": <insert path in which custom_push.sh is stored>,
    "ego.power-tools.user": {
        "commands": {
            "custom_push": {
                "script": "custom_push.js",
                "button": {
                    "text": "Push to custom branch"
                }
            }
        }
    }
    ```
3. Go into your-user-folder/.vscode-powertools folder and copy the file **custom_push.js** inside that folder.
4. A button with name *Push to custom branch* should appear in the lower taskbar of VSCode.
5. Click the button to use the tool.  

**Note**: output (from both stdout/stderr) is shown as a VSCode message in the lower-right corner of the application.
