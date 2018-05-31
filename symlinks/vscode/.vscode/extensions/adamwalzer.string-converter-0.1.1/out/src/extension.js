"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const vscode_1 = require("vscode");
const lodash_1 = require("lodash");
const stringFunctions = {
    camelCase: lodash_1.camelCase,
    capitalize: lodash_1.capitalize,
    constantCase: s => lodash_1.toUpper(lodash_1.snakeCase(s)),
    deburr: lodash_1.deburr,
    dotCase: s => lodash_1.replace(lodash_1.kebabCase(s), '-', '.'),
    escape: lodash_1.escape,
    escapeRegExp: lodash_1.escapeRegExp,
    kebabCase: lodash_1.kebabCase,
    lowerCase: lodash_1.lowerCase,
    lowerFirst: lodash_1.lowerFirst,
    pad: lodash_1.pad,
    padEnd: lodash_1.padEnd,
    padStart: lodash_1.padStart,
    parseInt: lodash_1.parseInt,
    pascalCase: s => lodash_1.upperFirst(lodash_1.camelCase(s)),
    pathCase: s => lodash_1.replace(lodash_1.kebabCase(s), '-', '/'),
    repeat: lodash_1.repeat,
    replace: lodash_1.replace,
    snakeCase: lodash_1.snakeCase,
    spaceCase: s => lodash_1.replace(lodash_1.kebabCase(s), '-', ' '),
    split: lodash_1.split,
    startCase: lodash_1.startCase,
    toLower: lodash_1.toLower,
    toUpper: lodash_1.toUpper,
    trim: lodash_1.trim,
    trimEnd: lodash_1.trimEnd,
    trimStart: lodash_1.trimStart,
    unescape: lodash_1.unescape,
    upperCase: lodash_1.upperCase,
    upperFirst: lodash_1.upperFirst,
    words: lodash_1.words,
};
const paramFunctions = {
    pad: resolve => {
        vscode_1.window.showInputBox({ prompt: 'Length' })
            .then(l => {
            vscode_1.window.showInputBox({ prompt: 'Chars' })
                .then(c => {
                resolve([l, c || " "]);
            });
        });
    },
    padEnd: resolve => {
        vscode_1.window.showInputBox({ prompt: 'Length' })
            .then(l => {
            vscode_1.window.showInputBox({ prompt: 'Chars' })
                .then(c => {
                resolve([l, c || " "]);
            });
        });
    },
    padStart: resolve => {
        vscode_1.window.showInputBox({ prompt: 'Length' })
            .then(l => {
            vscode_1.window.showInputBox({ prompt: 'Chars' })
                .then(c => {
                resolve([l, c || " "]);
            });
        });
    },
    repeat: resolve => {
        vscode_1.window.showInputBox({ prompt: 'Number of times to repeat' })
            .then(n => {
            resolve([n]);
        });
    },
    replace: resolve => {
        vscode_1.window.showInputBox({ prompt: 'Pattern' })
            .then(p => {
            vscode_1.window.showInputBox({ prompt: 'Replacement' })
                .then(r => {
                resolve([p, r]);
            });
        });
    },
    split: resolve => {
        vscode_1.window.showInputBox({ prompt: 'Separator' })
            .then(s => {
            resolve([s]);
        });
    }
};
const getParams = function (name) {
    let res;
    const promise = new Promise(resolve => {
        res = params => {
            resolve(params);
        };
    });
    if (!paramFunctions[name]) {
        res([]);
    }
    else {
        paramFunctions[name](res);
    }
    return promise;
};
const convertStrings = function (name) {
    const editor = vscode_1.window.activeTextEditor;
    if (!editor)
        return;
    getParams(name)
        .then((params) => {
        editor.edit(editBuilder => {
            lodash_1.each(editor.selections, selection => {
                editBuilder.replace(selection, stringFunctions[name](editor.document.getText(new vscode_1.Range(selection.start, selection.end)), ...[].concat(params)).toString());
            });
        });
    });
};
function activate(context) {
    lodash_1.each(stringFunctions, (fn, name) => {
        context.subscriptions.push(vscode_1.commands.registerCommand(name, lodash_1.partial(convertStrings, name)));
    });
}
exports.activate = activate;
function deactivate() { }
exports.deactivate = deactivate;
//# sourceMappingURL=extension.js.map