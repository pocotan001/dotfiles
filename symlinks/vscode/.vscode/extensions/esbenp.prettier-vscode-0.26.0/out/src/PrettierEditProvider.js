"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
const vscode_1 = require("vscode");
const errorHandler_1 = require("./errorHandler");
const utils_1 = require("./utils");
const requirePkg_1 = require("./requirePkg");
const bundledPrettier = require('prettier');
function format(text, { fileName, languageId, uri }, customOptions) {
    return __awaiter(this, void 0, void 0, function* () {
        const vscodeConfig = utils_1.getConfig(uri);
        const localPrettier = requirePkg_1.requireLocalPkg(fileName, 'prettier');
        if (vscodeConfig.disableLanguages.includes(languageId)) {
            return text;
        }
        let trailingComma = vscodeConfig.trailingComma;
        if (trailingComma === true) {
            trailingComma = 'es5';
        }
        else if (trailingComma === false) {
            trailingComma = 'none';
        }
        const dynamicParsers = utils_1.getParsersFromLanguageId(languageId, localPrettier.version);
        let useBundled = false;
        let parser;
        if (!dynamicParsers.length) {
            const bundledParsers = utils_1.getParsersFromLanguageId(languageId, bundledPrettier.version);
            parser = bundledParsers[0] || 'babylon';
            useBundled = true;
        }
        else if (dynamicParsers.includes(vscodeConfig.parser)) {
            parser = vscodeConfig.parser;
        }
        else {
            parser = dynamicParsers[0];
        }
        const doesParserSupportEslint = utils_1.getGroup('JavaScript').some(lang => lang.parsers.includes(parser));
        const fileOptions = yield bundledPrettier.resolveConfig(fileName);
        const prettierOptions = Object.assign({
            printWidth: vscodeConfig.printWidth,
            tabWidth: vscodeConfig.tabWidth,
            singleQuote: vscodeConfig.singleQuote,
            trailingComma,
            bracketSpacing: vscodeConfig.bracketSpacing,
            jsxBracketSameLine: vscodeConfig.jsxBracketSameLine,
            parser: parser,
            semi: vscodeConfig.semi,
            useTabs: vscodeConfig.useTabs,
            proseWrap: vscodeConfig.proseWrap,
        }, customOptions, fileOptions);
        if (vscodeConfig.eslintIntegration && doesParserSupportEslint) {
            return errorHandler_1.safeExecution(() => {
                const prettierEslint = require('prettier-eslint');
                errorHandler_1.setUsedModule('prettier-eslint', 'Unknown', true);
                return prettierEslint({
                    text,
                    filePath: fileName,
                    fallbackPrettierOptions: prettierOptions,
                });
            }, text, fileName);
        }
        if (vscodeConfig.stylelintIntegration && parser === 'postcss') {
            const prettierStylelint = require('prettier-stylelint');
            return errorHandler_1.safeExecution(prettierStylelint.format({
                text,
                filePath: fileName,
                prettierOptions,
            }), text, fileName);
        }
        if (!doesParserSupportEslint && useBundled) {
            return errorHandler_1.safeExecution(() => {
                const warningMessage = `prettier@${localPrettier.version} doesn't support ${languageId}. ` +
                    `Falling back to bundled prettier@${bundledPrettier.version}.`;
                errorHandler_1.addToOutput(warningMessage);
                errorHandler_1.setUsedModule('prettier', bundledPrettier.version, true);
                return bundledPrettier.format(text, prettierOptions);
            }, text, fileName);
        }
        errorHandler_1.setUsedModule('prettier', localPrettier.version, false);
        return errorHandler_1.safeExecution(() => localPrettier.format(text, prettierOptions), text, fileName);
    });
}
function fullDocumentRange(document) {
    const lastLineId = document.lineCount - 1;
    return new vscode_1.Range(0, 0, lastLineId, document.lineAt(lastLineId).text.length);
}
class PrettierEditProvider {
    constructor(_fileIsIgnored) {
        this._fileIsIgnored = _fileIsIgnored;
    }
    provideDocumentRangeFormattingEdits(document, range, options, token) {
        return this._provideEdits(document, {
            rangeStart: document.offsetAt(range.start),
            rangeEnd: document.offsetAt(range.end),
        });
    }
    provideDocumentFormattingEdits(document, options, token) {
        return this._provideEdits(document, {});
    }
    _provideEdits(document, options) {
        if (!document.isUntitled && this._fileIsIgnored(document.fileName)) {
            return Promise.resolve([]);
        }
        return format(document.getText(), document, options).then(code => [
            vscode_1.TextEdit.replace(fullDocumentRange(document), code),
        ]);
    }
}
exports.default = PrettierEditProvider;
//# sourceMappingURL=PrettierEditProvider.js.map