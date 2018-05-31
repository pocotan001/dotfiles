"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator.throw(value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments)).next());
    });
};
const provider_1 = require('./provider');
const import_1 = require("./import");
class CompleteActionProvider {
    provideCodeActions(document, range, context, token) {
        return __awaiter(this, void 0, Promise, function* () {
            try {
                const keyword = document.getText(range);
                const cachedExports = yield provider_1.DefinitionProvider.instance.getCachedExportsAsync();
                if (import_1.exportListContainsItem(cachedExports, keyword)) {
                    return [
                        {
                            arguments: [keyword],
                            command: 'genGetSet.addImport',
                            title: 'Add import for ' + keyword
                        }
                    ];
                }
            }
            catch (err) {
            }
            return [];
        });
    }
}
exports.CompleteActionProvider = CompleteActionProvider;
//# sourceMappingURL=bulb.js.map