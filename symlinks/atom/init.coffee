# Make environment variables available to Atom
process.env.PATH = ["/usr/local/opt/go/libexec/bin", process.env.PATH].join(":")

# Terminates the current line with a semi-colon
# https://github.com/extrabacon/atom-turbo-javascript/blob/master/lib/turbo-javascript.coffee
atom.workspaceView.command "custom:semicolonize", ->
  editor = atom.workspace.activePaneItem

  editor.getCursors().forEach((cursor) ->
    editor.moveCursorToEndOfLine()

    if !/;\s*$/.test(cursor.getCurrentBufferLine())
      editor.insertText(';')

    editor.insertNewlineBelow()
  )
