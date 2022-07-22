#!/bin/bash

for f in ~/Dropbox/Development/dotfiles/.[^.]*; do
  [[ $f =~ /.git$ ]] && continue
  [[ $f =~ /.DS_Store$ ]] && continue

  ln -snfv "$f" ~
done
