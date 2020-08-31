exports.execute = async (args) => {
    // args => https://egodigital.github.io/vscode-powertools/api/interfaces/_contracts_.workspacecommandscriptarguments.html

    // s. https://code.visualstudio.com/api/references/vscode-api
    const vscode = args.require('vscode');
    let rootPath = vscode.workspace.rootPath;
    const myRemote = 'asr_gerrit';

    let remote = await vscode.window.showInputBox({ placeHolder: 'Enter remote name, if different from asr_gerrit...' });
    if(!remote || remote == null || remote == '')
    {   
        remote = myRemote;
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

    const { exec } = require('child_process');
    var yourscript = exec(`C:\\git\\Git\\bin\\bash.exe "D:\\strofald\\tools\\VSCode\\scripts\\custom_push.sh" '${ rootPath }' '${ remote }' '${ branch }'`,
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