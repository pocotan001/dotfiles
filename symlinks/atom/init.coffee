# Make environment variables available to Atom
process.env.PATH = ["/usr/local/opt/go/libexec/bin", process.env.PATH].join(":")

# Add semi-colon at end of line and return
# https://discuss.atom.io/t/add-semi-colon-at-end-of-line-and-return/12038
atom.workspaceView.command "custom:semicolonize", ->
  editor = atom.workspace.getActiveEditor()
  editorElement = atom.views.getView(editor)
  editor.moveToEndOfLine()
  editor.insertText(";")
  atom.commands.dispatch(editorElement, 'editor:newline-below')
