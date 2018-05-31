"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const vscode = require("vscode");
const name = `((?!\\d)(?:(?!\\s)[$\\w\\u0080-\\uFFFF]|\\\\u[\\da-fA-F]{4}|\\\\u\\{[\\da-fA-F]+\\})+)`;
const ws = `[\\s\\n\\r]`;
const namespaceToken = `\\*\\s+as\\s+(${name})`;
const defaultImportToken = name;
const destructingImportToken = `(${name})(\\s+as\\s+(${name}))?`;
const destructingImport = `{(${ws}*${destructingImportToken}(,${ws}*${destructingImportToken})*${ws}*)}`;
const defaultAndDestructingImport = `${defaultImportToken}${ws}*,${ws}*${destructingImport}`;
const combinedImportTypes = `(${namespaceToken}|${defaultImportToken}|${destructingImport}|${defaultAndDestructingImport})`;
const importRegexString = `^import\\s+(${combinedImportTypes}\\s+from\\s+)?['"]([@\\w\\\\/\.-]+)['"];?\\r?\\n?`;
// Group 5 || Group 18 - default import
// Group 3 - namespace import
// Group 6 || Group 19 - destructing import group; requires further tokenizing
// Group 31 - file path or package
const importRegex = new RegExp(importRegexString, 'gm');
// Group 1 - importName
// Group 4 - alias
const destructingImportTokenRegex = new RegExp(destructingImportToken);
function parseImportNodes(document) {
    let source = document.getText();
    importRegex.lastIndex = 0;
    let imports = [];
    let match;
    while (match = importRegex.exec(source)) {
        imports.push({
            path: match[31],
            default: match[5] || match[18],
            namedImports: parseDestructiveImports(match[6] || match[19]),
            namespace: match[3],
            range: new vscode.Range(document.positionAt(match.index), document.positionAt(importRegex.lastIndex)),
        });
    }
    return imports;
}
exports.default = parseImportNodes;
function parseDestructiveImports(destructiveImports) {
    if (!destructiveImports) {
        return null;
    }
    return destructiveImports
        .split(',')
        .map(destructiveImport => {
        let match = destructingImportTokenRegex.exec(destructiveImport);
        return {
            importName: match[1],
            alias: match[4],
        };
    });
}
//# sourceMappingURL=parseImportNodes.js.map