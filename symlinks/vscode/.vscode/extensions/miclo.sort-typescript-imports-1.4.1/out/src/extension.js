'use strict';
Object.defineProperty(exports, "__esModule", { value: true });
// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
const vscode = require("vscode");
const sortInsideEditor_1 = require("./sortInsideEditor");
const sortOnSave_1 = require("./sortOnSave");
const options_1 = require("./options");
let sortOnSaveDisposer;
// this method is called when your extension is activated
// your extension is activated the very first time the command is executed
function activate(context) {
    // The command has been defined in the package.json file
    // Now provide the implementation of the command with  registerCommand
    // The commandId parameter must match the command field in package.json
    let sortOnCommandDisposer = vscode.commands.registerCommand('extension.sortTypescriptImports', () => {
        // The code you place here will be executed every time your command is executed
        if (options_1.shouldEnableJavascript() && isFileJavascript() ||
            isFileTypescript()) {
            sortInsideEditor_1.default();
        }
    });
    let configurationWatcher = vscode.workspace.onDidChangeConfiguration(configure);
    configure();
    context.subscriptions.push(sortOnCommandDisposer, configurationWatcher);
}
exports.activate = activate;
function isFileJavascript() {
    return (vscode.window.activeTextEditor.document.languageId === 'javascript' ||
        vscode.window.activeTextEditor.document.languageId === 'javascriptreact');
}
function isFileTypescript() {
    return (vscode.window.activeTextEditor.document.languageId === 'typescript' ||
        vscode.window.activeTextEditor.document.languageId === 'typescriptreact');
}
function configure() {
    if (options_1.shouldSortOnSave()) {
        enableFileWatcher();
    }
    else if (!options_1.shouldSortOnSave()) {
        disableFileWatcher();
    }
}
function enableFileWatcher() {
    if (!sortOnSaveDisposer) {
        sortOnSaveDisposer = vscode.workspace.onWillSaveTextDocument(sortOnSave_1.default);
    }
}
function disableFileWatcher() {
    if (sortOnSaveDisposer) {
        sortOnSaveDisposer.dispose();
        sortOnSaveDisposer = undefined;
    }
}
// this method is called when your extension is deactivated
function deactivate() {
    disableFileWatcher();
}
exports.deactivate = deactivate;
//# sourceMappingURL=extension.js.map