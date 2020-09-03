exports.execute = async (args) => {
    // args => https://egodigital.github.io/vscode-powertools/api/interfaces/_contracts_.workspacecommandscriptarguments.html

    // s. https://code.visualstudio.com/api/references/vscode-api
    const vscode = args.require('vscode');
    const { exec } = require('child_process');
    const path = require('path');

    let rootPath = vscode.workspace.rootPath;
    // read the bash.path property from settings.json
    let bashPath = vscode.workspace.getConfiguration("bash").get('path');    
    // read the powertools.scripts.bash from settings.json
    let scriptPath = vscode.workspace.getConfiguration('powertools.scripts').get('bash');
    let scriptName = "custom_push.sh";
    let scriptFull = path.join(scriptPath, scriptName);

    let remote = await vscode.window.showInputBox({ placeHolder: 'Enter remote name...' });
    if(!remote || remote == null || remote == '')
    {   
        vscode.window.showInformationMessage(
            `Insert a valid remote name.`
        );
        return;
    }

    vscode.window.showInformationMessage(
        `Pushing to remote: '${ remote }'!`
    );

    let branch = await vscode.window.showInputBox({ placeHolder: 'Enter remote branch name (refs/for/<your_input>)..' });
    if(branch)
    {
        vscode.window.showInformationMessage(
            `Pushing current HEAD to remote branch: 'refs/for/${ branch }'!`
        );

    }
    else
    {
        vscode.window.showInformationMessage(
            `Insert a valid remote branch.`
        );
        return;
    }
    
    var yourscript = exec(`"${ bashPath }" "${ scriptFull }" '${ rootPath }' '${ remote }' '${ branch }'`,
            (error, stdout, stderr) => {
                vscode.window.showInformationMessage(`Messages from STDOUT: ${stdout}`);
                
                if(stderr != null && stderr != '') {
                    vscode.window.showInformationMessage(`Messages from STDERR: ${stderr}`);
                }               
                
                if (error !== null && error != '') {
                    vscode.window.showInformationMessage(`Exec Error: ${error}`);
                }
            });

};