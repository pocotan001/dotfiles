"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const vscode = require("vscode");
function getTabString(editor = vscode.window.activeTextEditor) {
    if (editor.options.insertSpaces) {
        return new Array(editor.options.tabSize + 1).join(' ');
    }
    else {
        return '\t';
    }
}
exports.getTabString = getTabString;
function getMaxNamedImportsPerSingleLine() {
    return getExtensionConfig().get('maxNamedImportsInSingleLine');
}
exports.getMaxNamedImportsPerSingleLine = getMaxNamedImportsPerSingleLine;
function getSortOption() {
    return getExtensionConfig().get('sortMethod');
}
exports.getSortOption = getSortOption;
function getQuoteToken() {
    switch (getExtensionConfig().get('quoteStyle')) {
        case 'double':
            return '"';
        case 'single':
        default:
            return '\'';
    }
}
exports.getQuoteToken = getQuoteToken;
function shouldEnableJavascript() {
    return getExtensionConfig().get('enableJavascript');
}
exports.shouldEnableJavascript = shouldEnableJavascript;
function shouldSortOnSave() {
    return getExtensionConfig().get('sortOnSave');
}
exports.shouldSortOnSave = shouldSortOnSave;
function getPathSortOrdering() {
    return getExtensionConfig().get('pathSortOrder');
}
exports.getPathSortOrdering = getPathSortOrdering;
function getOmitSemicolon() {
    return getExtensionConfig().get('omitSemicolon');
}
exports.getOmitSemicolon = getOmitSemicolon;
function getExtensionConfig() {
    return vscode.workspace.getConfiguration('typescript.extension.sortImports');
}
//# sourceMappingURL=options.js.map