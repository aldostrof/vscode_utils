exports.execute = async (args) => {
    // args => https://egodigital.github.io/vscode-powertools/api/interfaces/_contracts_.workspacecommandscriptarguments.html

    // s. https://code.visualstudio.com/api/references/vscode-api
    const vscode = args.require('vscode');
    let rootPath = vscode.workspace.rootPath;

    let bz_ID = await vscode.window.showInputBox({ placeHolder: 'Enter BZ ID for the branch to be created...' });
    if(bz_ID)
    {
        vscode.window.showInformationMessage(
            `Creating branch: 'dev/${ bz_ID }'!`
        );

    }
    else
    {
        vscode.window.showInformationMessage(
            `Insert a valid BZ ID for the branch.`
        );
        return;
    }

    const { exec } = require('child_process');
    var yourscript = exec(`C:\\git\\Git\\bin\\bash.exe "D:\\strofald\\tools\\VSCode\\scripts\\create_branch.sh" '${ bz_ID }' '${ rootPath }'`,
            (error, stdout, stderr) => {
                vscode.window.showInformationMessage(
                    `OUTPUT:${stdout}`
                );

                if(stderr != null) {
                    vscode.window.showInformationMessage(`STDERR: ${stderr}`);
                    console.log(`stderr: ${stderr}`);
                }               
                
                if (error !== null) {
                    vscode.window.showInformationMessage(`ERROR: ${error}`);
                    console.log(`exec error: ${error}`);
                }
            });

};