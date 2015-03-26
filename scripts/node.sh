#!/bin/bash

mkdir ~/.nvm
source ~/.zprofile

nvm install stable
nvm alias default stable

npm install -g browser-sync
npm install -g gulp
npm install -g http-server
npm install -g psi
