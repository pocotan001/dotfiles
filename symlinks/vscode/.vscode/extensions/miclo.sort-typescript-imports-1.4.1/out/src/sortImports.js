"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const vscode = require("vscode");
const parseImportNodes_1 = require("./parseImportNodes");
const processImports_1 = require("./processImports");
const writeImports_1 = require("./writeImports");
function sortImports(document) {
    let imports = parseImportNodes_1.default(document);
    imports = processImports_1.default(imports);
    let sortedImportText = writeImports_1.default(imports);
    let edits = imports.map(importClause => vscode.TextEdit.delete(importClause.range));
    edits.push(vscode.TextEdit.insert(new vscode.Position(0, 0), sortedImportText));
    return edits;
}
exports.default = sortImports;
//# sourceMappingURL=sortImports.js.map