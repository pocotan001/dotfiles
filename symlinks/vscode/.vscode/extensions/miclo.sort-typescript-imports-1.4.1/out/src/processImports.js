"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const options = require("./options");
function processImports(importClauses) {
    return importClauses
        .map(importClause => {
        if (importClause.namedImports) {
            importClause.namedImports.sort((a, b) => a.importName.localeCompare(b.importName, 'en', { sensitivity: 'base' }));
        }
        return importClause;
    })
        .sort(compareImportClauses);
}
exports.default = processImports;
function compareImportClauses(a, b) {
    if (options.getSortOption() === 'path') {
        return comparePath(a, b)
            || compareCaseInsensitive(a.path, b.path);
    }
    else {
        return compareImportType(a, b)
            || (a.namespace && compareCaseInsensitive(a.namespace, b.namespace))
            || (a.default && compareCaseInsensitive(a.default, b.default))
            || (a.namedImports && compareCaseInsensitive(a.namedImports[0].importName, b.namedImports[0].importName))
            || comparePath(a, b);
    }
}
function compareCaseInsensitive(a, b) {
    return a.localeCompare(b, 'en', { sensitivity: 'base' });
}
function comparePath(a, b) {
    return getPathPriority(a.path) - getPathPriority(b.path);
}
function getPathPriority(path) {
    let sortOrder = options.getPathSortOrdering();
    if (/^\.\//.test(path)) {
        return sortOrder.indexOf('relativeDownLevel');
    }
    else if (/^\.\.\//.test(path)) {
        return sortOrder.indexOf('relativeUpLevel');
    }
    else {
        return sortOrder.indexOf('package');
    }
}
function compareImportType(a, b) {
    return getImportTypePriority(a) - getImportTypePriority(b);
}
function getImportTypePriority(importClause) {
    if (importClause.namespace) {
        return 0;
    }
    else if (importClause.default) {
        return 1;
    }
    else if (importClause.namedImports) {
        return 2;
    }
    else {
        return 3;
    }
}
//# sourceMappingURL=processImports.js.map