exports.execute = async (args) => {
    // args => https://egodigital.github.io/vscode-powertools/api/interfaces/_contracts_.workspacecommandscriptarguments.html

    // s. https://code.visualstudio.com/api/references/vscode-api
    
    // Opens a specific file whose path is fetched from settings.json.
    const vscode = args.require('vscode');

    // read the file absolute path from settings.json, using property: my.file.path (or use your own and change accordingly)
    let filePath = vscode.workspace.getConfiguration('my.file').get('path');
    var openPath = vscode.Uri.parse("file:///" + filePath);
    vscode.workspace.openTextDocument(openPath).then(doc => {
      vscode.window.showTextDocument(doc);
    });
};
