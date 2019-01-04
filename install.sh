#!/bin/bash

for f in .??*; do
    [ "$f" = ".git" ] && continue
    [ "$f" = ".DS_Store" ] && continue
    [ "$f" = ".idea" ] && continue

    ln -snfv ~/Dropbox/Development/dotfiles/"$f" ~
done
