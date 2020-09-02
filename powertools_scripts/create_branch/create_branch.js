exports.execute = async (args) => {
    // args => https://egodigital.github.io/vscode-powertools/api/interfaces/_contracts_.workspacecommandscriptarguments.html

    // s. https://code.visualstudio.com/api/references/vscode-api
    const vscode = args.require('vscode');
    const { exec } = require('child_process');
    const path = require('path');

    let rootPath = vscode.workspace.rootPath;    
    // read the bash.path property from settings.json
    let bashPath = vscode.workspace.getConfiguration("bash.path");    
    // read the powertools.scripts.path from settings.json
    let scriptPath = vscode.workspace.getConfiguration("powertools.scripts.path");    
    let scriptName = "create_branch.sh";
    let scriptFull = path.join(scriptPath, scriptName);

    let branch = await vscode.window.showInputBox({ placeHolder: 'Enter name of the branch to be created...' });
    if(branch)
    {
        vscode.window.showInformationMessage(
            `Creating branch: '${ branch }'.`
        );

    }
    else
    {
        vscode.window.showInformationMessage(
            `Insert a valid name for the branch.`
        );
        return;
    }
    
    var yourscript = exec(`'${ bashPath }' '${ scriptFull }'  '${ branch }' '${ rootPath }'`,
            (error, stdout, stderr) => {
                vscode.window.showInformationMessage(
                    `Messages from STDOUT: ${stdout}`                    
                );

                if(stderr != null && stderr != '') {
                    vscode.window.showInformationMessage(`Messages from STDERR: ${stderr}`);
                    console.log(`stderr:\n${stderr}`);
                }               
                
                if (error !== null && error != '') {
                    vscode.window.showInformationMessage(`Exec Error: ${error}`);
                    console.log(`exec error:\n${error}`);
                }
            });

};