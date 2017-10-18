#!/bin/bash

rm -rf ~/.vscode ~/Library/Application\ Support/Code/User/keybindings.json ~/Library/Application\ Support/Code/User/settings.json ~/Library/Application\ Support/Code/User/snippets
ln -s ~/.cider/symlinks/vscode/.vscode ~
ln -s ~/.cider/symlinks/vscode/User/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
ln -s ~/.cider/symlinks/vscode/User/settings.json ~/Library/Application\ Support/Code/User/settings.json
ln -s ~/.cider/symlinks/vscode/User/snippets ~/Library/Application\ Support/Code/User/snippets
