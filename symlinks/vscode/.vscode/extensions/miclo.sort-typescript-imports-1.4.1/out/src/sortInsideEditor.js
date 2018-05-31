"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const vscode = require("vscode");
const sortImports_1 = require("./sortImports");
function sortInsideEditor() {
    let editor = vscode.window.activeTextEditor;
    let edits = sortImports_1.default(editor.document);
    editor.edit(editBuilder => {
        edits.forEach(edit => {
            editBuilder.replace(edit.range, edit.newText);
        });
    });
}
exports.default = sortInsideEditor;
//# sourceMappingURL=sortInsideEditor.js.map