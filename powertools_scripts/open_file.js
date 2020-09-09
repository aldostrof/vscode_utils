exports.execute = async (args) => {
    // args => https://egodigital.github.io/vscode-powertools/api/interfaces/_contracts_.workspacecommandscriptarguments.html

    // s. https://code.visualstudio.com/api/references/vscode-api
    const vscode = args.require('vscode');
    const path = require('path');

    let rootPath = vscode.workspace.rootPath;
    // read the file path from settings.json
    let filePath = vscode.workspace.getConfiguration('my.file').get('path');
    let fileName = "your_file_name";
    let fileFull = path.join(filePath, fileName);
    var openPath = vscode.Uri.parse("file:///" + fileFull);
    vscode.workspace.openTextDocument(openPath).then(doc => {
      vscode.window.showTextDocument(doc);
    });
};
