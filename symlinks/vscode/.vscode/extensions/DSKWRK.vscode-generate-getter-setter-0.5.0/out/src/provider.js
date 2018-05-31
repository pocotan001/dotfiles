"use strict";
const import_1 = require('./import');
const vscode = require('vscode');
class DefinitionProvider {
    constructor() {
        this._statusBarItem = vscode.window.createStatusBarItem(vscode.StatusBarAlignment.Left);
        this._refreshing = false;
        this._refreshingPromise = undefined;
        if (DefinitionProvider._instance)
            throw new Error("Error: Instantiation failed: Use .instance instead of new.");
        this._statusBarItem.command = 'genGetSet.popup';
        this._statusBarItem.show();
        this.refreshExports();
        const scanOnSave = vscode.workspace.getConfiguration('genGetSet').get('scanOnSave');
        if (scanOnSave) {
            vscode.workspace.onDidSaveTextDocument((event) => {
                this.refreshExports();
            });
        }
        DefinitionProvider._instance = this;
    }
    static get instance() {
        return DefinitionProvider._instance;
    }
    refreshExports() {
        if (!this._refreshing) {
            this._refreshing = true;
            this._statusBarItem.text = '$(eye) $(sync)';
            this._refreshingPromise = new Promise((resolve, reject) => {
                import_1.analyzeWorkspace().then((exports) => {
                    this._refreshing = false;
                    this._cachedExports = exports;
                    resolve();
                    this._refreshingPromise = undefined;
                    this._statusBarItem.text = '$(eye) ' + exports.length;
                }, (err) => {
                    this._refreshing = false;
                    this._statusBarItem.text = '';
                    resolve(); // Never reject. 
                    this._refreshingPromise = undefined;
                });
            });
        }
    }
    get cachedExports() {
        return this._cachedExports;
    }
    getCachedExportsAsync() {
        if (!this._refreshingPromise)
            return Promise.resolve(this._cachedExports);
        else {
            return new Promise((resolve, reject) => {
                this._refreshingPromise.then(() => {
                    resolve(this._cachedExports);
                });
            });
        }
    }
    // public containsItem(name: string): boolean {
    //     for (let i = 0; i < this._cachedExports.length; i++) {
    //         if (this._cachedExports[i].libraryName) {
    //             if (this._cachedExports[i].exported) {
    //                 for (let j = 0; j < this._cachedExports[i].exported.length; j++) {
    //                     if (this._cachedExports[i].exported[j] === name) return true;
    //                 }
    //             } else {
    //                 if (this._cachedExports[i].asName === name) return true;
    //             }
    //         }
    //     }
    //     return false;
    // }
    toQuickPickItemList() {
        return new Promise((resolve, reject) => {
            let quickPickItemList = [];
            for (let i = 0; i < this._cachedExports.length; i++) {
                if (this._cachedExports[i].libraryName) {
                    if (this._cachedExports[i].exported) {
                        for (let j = 0; j < this._cachedExports[i].exported.length; j++) {
                            quickPickItemList.push({
                                label: this._cachedExports[i].exported[j],
                                description: this._cachedExports[i].libraryName
                            });
                        }
                    }
                    else {
                        quickPickItemList.push({
                            label: this._cachedExports[i].asName,
                            description: this._cachedExports[i].libraryName
                        });
                    }
                }
            }
            resolve(quickPickItemList);
        });
    }
}
DefinitionProvider._instance = new DefinitionProvider();
exports.DefinitionProvider = DefinitionProvider;
//# sourceMappingURL=provider.js.map