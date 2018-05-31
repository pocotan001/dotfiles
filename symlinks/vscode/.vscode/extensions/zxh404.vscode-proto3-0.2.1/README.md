# vscode-proto3

Protobuf 3 support for Visual Studio Code

https://github.com/zxh0/vscode-proto3

## Features

- proto3 support.
- syntax highlighting.
- syntax validation.
- code snippets.
- code completion.
- brace matching.
- line and block commenting.

![gif1](https://github.com/zxh0/vscode-proto3/raw/master/images/gif1.gif)

### Syntax Highlighting

The grammar is written in tmLanguage.
It is written in JSON format and then converted to XML format using 
[vscode-tmlanguage](https://github.com/Togusa09/vscode-tmlanguage) extension.

### Syntax Validation

The validation is triggered when you save the proto file. You need protoc 
compiler to enable syntax validation. You also need a settings.json file 
to tell the extension the full path of protoc if it is not in `path`. 
Bellow is the settings.json file comes from 
[example/.vscode](https://github.com/zxh0/vscode-proto3/tree/master/example/.vscode) folder:
```json
{
    "protoc": {
        "path": "/path/to/protoc",
        "options": [
            "--proto_path=protos/v3",
            "--proto_path=protos/v2",
            "--proto_path=${workspaceRoot}/proto",
            "--proto_path=${env.GOPATH}/src"
            "--java_out=gen/java"
        ]
    }
}
```

Variables

Variable      | Description
------------- | ------------
config.*      | Refer settings items in ``Preferences``.
env.*         | Refer environment variable.
workspaceRoot | Returns current workspace root path.

### Code Completion

A very simple parser is written to support code completion. 

### Code Snippets

prefix| body
----- | -----
sp2   | `syntax = "proto2";`
sp3   | `syntax = "proto3";`
pkg   | `package package.name;`
imp   | `import "path/to/other/protos.proto";`
ojp   | `option java_package = "java.package.name";`
ojoc  | `option java_outer_classname = "ClassName";`
o4s   | `option optimize_for = SPEED;`
o4cs  | `option optimize_for = CODE_SIZE;`
o4lr  | `option optimize_for = LITE_RUNTIME;`
odep  | `option deprecated = true;`
oaa   | `option allow_alias = true;`
msg   | `message MessageName {}`
fbo   | `bool field_name = tag;`
fi32  | `int32 field_name = tag;`
fi64  | `int64 field_name = tag;`
fu32  | `uint32 field_name = tag;`
fu64  | `uint64 field_name = tag;`
fs32  | `sint32 field_name = tag;`
fs64  | `sint64 field_name = tag;`
ff32  | `fixed32 field_name = tag;`
ff64  | `fixed64 field_name = tag;`
fsf32 | `sfixed32 field_name = tag;`
fsf64 | `sfixed64 field_name = tag;`
ffl   | `float field_name = tag;`
fdo   | `double field_name = tag;`
fst   | `string field_name = tag;`
fby   | `bytes field_name = tag;`
fm    | `map<key, val> field_name = tag;`
foo   | `oneof name {}`
en    | `enum EnumName {}`
sv    | `service ServiceName {}`
rpc   | `rpc MethodName (Request) returns (Response);`


## Known Issues

Auto-completion not works in some situations.

## Release Notes

### 0.2.1
- Fixed issue#26

### 0.2.0
- Default to look protoc in path (issue#24).
- Support "Format Document" if clang-format is in path (issue#13).

### 0.1.3
- Fixed some syntax highlighting issues (issue#2, issue#21, issue#42).

### 0.1.2
- Fixed some syntax highlighting issues.

### 0.1.1
- Fixed some syntax highlighting issues.
- Skip the protoc invocation when it's not configured. 

### 0.1.0
- Fixed some syntax highlighting issues.
- Use user and workspace settings instead of a custom settings.json file. 
- (NOTE: Old users should move the settings.json file into .vscode folder!)

### 0.0.7
- Fixed syntax highlighting bug of keyword `stream`.

### 0.0.6
- Fixed some syntax highlighting problems.

### 0.0.5
- Fixed some bugs.

### 0.0.4
- Initial release.
