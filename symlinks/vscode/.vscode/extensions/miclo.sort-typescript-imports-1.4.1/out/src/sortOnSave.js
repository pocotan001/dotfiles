"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const isSupportedLanguage_1 = require("./isSupportedLanguage");
const sortImports_1 = require("./sortImports");
function sortOnSave(event) {
    if (isSupportedLanguage_1.default(event.document.languageId)) {
        event.waitUntil(new Promise((resolve, reject) => {
            resolve(sortImports_1.default(event.document));
        }));
    }
}
exports.default = sortOnSave;
//# sourceMappingURL=sortOnSave.js.map