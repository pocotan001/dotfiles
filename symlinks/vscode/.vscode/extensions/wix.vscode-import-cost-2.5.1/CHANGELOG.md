# Changes

## 2.5.1

Fix issue with imports that don't have semicolons in typescript

## 2.5.0

Add a configuration to control the presentation of the "calculating" decoration

## 2.4.0

Add lodash to externals list

## 2.3.0

Support languageId detection + react components now consider react & react-dom as externals

## 2.2.1

Allow config changes without restarting vscode

## 2.2.0

Added configuration param to control which bundle size (minfied/gzipped/both) to display in the decoration

## 2.1.0

Added gzip size to decorations

## 2.0.0

- Split the project into two packages:
  - `vscode-import-cost`: VSCode specific extension
  - `import-cost`: The logic of the extension

  The split was done in order to ease the consumption of the logic from IDEs other than VSCode.

- Various bug fixes

## 1.3.1

Fix breakage on backticks

## 1.3.0

Add a way to configure the file extensions that will be parsed

## 1.2.1

Bug fix for a small webpack issue with node

## 1.2.0

Add the ability to configure different colored decocrations for different sized packages.

## 1.1.7

Bug fix for scoped packages (i.e. @angular/router)

## 1.1.6

reworked import reconstruction a bit in order to support `import React, {Component} from 'react';`

## 1.1.5

Bug fix for Typescript on Windows

## 1.1.4

Bug fix for disappearing decorators on incorrect syntax

## 1.1.3

Bug fixes and prettifying output

## 1.1.2

Fix typo

## 1.1.1

Fix cache location

## 1.1.0

Add back cross-session cache with support for library version

## 1.0.15

Update readme

## 1.0.13

- Calculate cost as-you-type
- Support multiple windows
- Remove the .importcost folder
- Add support for monorepo
- Calculations are done in parallel
- Temporarily remove cross-session cache
- Bug fixes

## 1.0.12

Fix cache bug

## 1.0.11

Switch from uglifyjs-webpack-plugin to babili-webpack-plugin

## 1.0.10

Display calculation results as they arrive

## 1.0.9

Update font theme

## 1.0.8

Add cross session cache

## 1.0.6

Initial release
