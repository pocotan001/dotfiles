#!/bin/bash

mkdir ~/.nvm
source ~/.zprofile

nvm install stable
nvm alias default stable

ln -s `which node` /usr/local/bin/node

npm install -g browser-sync
npm install -g eslint
npm install -g gulp
npm install -g http-server
npm install -g npm-check-updates
npm install -g psi
