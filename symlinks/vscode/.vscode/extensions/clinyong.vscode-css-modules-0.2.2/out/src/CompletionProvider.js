"use strict";
const vscode_1 = require("vscode");
const path = require("path");
const _ = require("lodash");
const utils_1 = require("./utils");
const utils_2 = require("./utils");
// check if current character or last character is .
function isTrigger(line, position) {
    const i = position.character - 1;
    return line[i] === "." || (i > 1 && line[i - 1] === ".");
}
function getWords(line, position) {
    const text = line.slice(0, position.character);
    const index = text.search(/[a-zA-Z0-9\._]*$/);
    if (index === -1) {
        return "";
    }
    return text.slice(index);
}
class CSSModuleCompletionProvider {
    constructor(camelCaseConfig) {
        this._classTransformer = null;
        switch (camelCaseConfig) {
            case true:
                this._classTransformer = _.camelCase;
                break;
            case "dashes":
                this._classTransformer = utils_2.dashesCamelCase;
                break;
            default: break;
        }
    }
    provideCompletionItems(document, position) {
        const currentLine = utils_1.getCurrentLine(document, position);
        const currentDir = path.dirname(document.uri.fsPath);
        if (!isTrigger(currentLine, position)) {
            return Promise.resolve([]);
        }
        const words = getWords(currentLine, position);
        if (words === "" || words.indexOf(".") === -1) {
            return Promise.resolve([]);
        }
        const [obj, field] = words.split(".");
        const importPath = utils_1.findImportPath(document.getText(), obj, currentDir);
        if (importPath === "") {
            return Promise.resolve([]);
        }
        const classNames = utils_1.getAllClassNames(importPath, field);
        return Promise.resolve(classNames.map(_class => {
            let name = _class;
            if (!!this._classTransformer) {
                name = this._classTransformer(name);
            }
            return new vscode_1.CompletionItem(name, vscode_1.CompletionItemKind.Variable);
        }));
    }
}
exports.CSSModuleCompletionProvider = CSSModuleCompletionProvider;
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = CSSModuleCompletionProvider;
//# sourceMappingURL=CompletionProvider.js.map