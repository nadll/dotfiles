# Sourced by install.sh (uses its link/run helpers and $DOTFILES, $SHELLRCDIR, $SHELLENVDIR)

link "$DOTFILES/macos/macos.rc.sh" "$SHELLRCDIR/"

# system-wide key bindings for Cocoa text fields (TextEdit, Notes, Mail, Safari...): Home/End go to the
# start/end of the line, Cmd-arrows to paragraph/document. Not used by iTerm2, VS Code or Chrome.
# Apps pick it up when they are restarted.
link "$DOTFILES/macos/DefaultKeyBinding.Dict" "$HOME/Library/KeyBindings/DefaultKeyBinding.dict"
