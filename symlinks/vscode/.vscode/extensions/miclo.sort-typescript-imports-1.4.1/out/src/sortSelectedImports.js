"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const vscode = require("vscode");
const parseImportNodes_1 = require("./parseImportNodes");
const processImports_1 = require("./processImports");
const writeImports_1 = require("./writeImports");
function sortSelectedImports() {
    let editor = vscode.window.activeTextEditor;
    let imports = parseImportNodes_1.default(editor.document);
    imports = processImports_1.default(imports);
    let sortedImportText = writeImports_1.default(imports);
    editor.edit(editBuilder => {
        imports.forEach(importClause => editBuilder.delete(importClause.range));
        editBuilder.insert(new vscode.Position(0, 0), sortedImportText);
    });
}
exports.default = sortSelectedImports;
//# sourceMappingURL=sortSelectedImports.js.map