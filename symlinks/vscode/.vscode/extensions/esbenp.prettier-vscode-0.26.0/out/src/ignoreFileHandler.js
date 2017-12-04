"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const fs_1 = require("fs");
const path = require("path");
const vscode_1 = require("vscode");
const utils_1 = require("./utils");
const ignore = require('ignore');
const nullIgnorer = { ignores: () => false };
function ignoreFileHandler(disposables) {
    const ignorers = new Map();
    disposables.push({ dispose: () => ignorers.clear() });
    return {
        fileIsIgnored(filePath) {
            return getIgnorerForFile(filePath).ignores(filePath);
        },
    };
    function getIgnorerForFile(fsPath) {
        const absolutePath = getIgnorePathForFile(fsPath, utils_1.getConfig(vscode_1.Uri.file(fsPath)).ignorePath);
        if (!absolutePath) {
            return nullIgnorer;
        }
        if (ignorers.has(absolutePath)) {
            return ignorers.get(absolutePath);
        }
        return loadIgnorer(vscode_1.Uri.file(absolutePath));
    }
    function loadIgnorer(ignoreUri) {
        let ignorer = nullIgnorer;
        if (!ignorers.has(ignoreUri.fsPath)) {
            const fileWatcher = vscode_1.workspace.createFileSystemWatcher(ignoreUri.fsPath);
            disposables.push(fileWatcher);
            fileWatcher.onDidCreate(loadIgnorer, null, disposables);
            fileWatcher.onDidChange(loadIgnorer, null, disposables);
            fileWatcher.onDidDelete(unloadIgnorer, null, disposables);
        }
        if (fs_1.existsSync(ignoreUri.fsPath)) {
            const ignoreFileContents = fs_1.readFileSync(ignoreUri.fsPath, 'utf8');
            ignorer = ignore().add(ignoreFileContents);
        }
        ignorers.set(ignoreUri.fsPath, ignorer);
        return ignorer;
    }
    function unloadIgnorer(ignoreUri) {
        ignorers.set(ignoreUri.fsPath, nullIgnorer);
    }
}
function getIgnorePathForFile(filePath, ignorePath) {
    if (!ignorePath) {
        return null;
    }
    if (vscode_1.workspace.workspaceFolders) {
        const folder = vscode_1.workspace.getWorkspaceFolder(vscode_1.Uri.file(filePath));
        return folder ? getPath(ignorePath, folder.uri.fsPath) : null;
    }
    return null;
}
function getPath(fsPath, relativeTo) {
    return path.isAbsolute(fsPath)
        ? fsPath
        : path.join(relativeTo, fsPath);
}
exports.default = ignoreFileHandler;
//# sourceMappingURL=ignoreFileHandler.js.map