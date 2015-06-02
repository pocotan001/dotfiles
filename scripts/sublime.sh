#!/bin/bash

rm -rf ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User
ln -s ~/.cider/symlinks/sublime/User ~/Library/Application\ Support/Sublime\ Text\ 3/Packages
ln -s /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/local/bin/st
