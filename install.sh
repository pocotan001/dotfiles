#!/bin/bash

for f in ~/Dropbox/Development/dotfiles/.[^.]*; do
  [[ $f =~ /.git$ ]] && continue
  [[ $f =~ /.DS_Store$ ]] && continue
  [[ $f =~ /.idea$ ]] && continue

  ln -snfv "$f" ~
done
