# tmux

Config: `tmux/tmux.conf` (linked to `~/.tmux.conf`), scripts in `tmux/scripts/` (linked to `~/.tmux/scripts/`).
Machine-local settings: `~/.tmux.conf.local`.

The prefix is **`Ctrl-a`**: press it, let go, then press the key. Windows and panes count from 1, every new window asks for a name, mouse is on.
With the iTerm2 **tmux** profile, most of these also have a Cmd shortcut (see [iterm2.md](iterm2.md)).

## Sessions

| Keys | Action |
|---|---|
| `tat` (shell) | Session named after the current folder (create or switch) |
| `Ctrl-a R` | Rename session |
| `Ctrl-a s` | Pick a session (tmux default) |
| `Ctrl-a C-u` | Move all windows into another session |
| `Ctrl-a d` | Detach |
| `Ctrl-a D` | Detach the other clients |
| `Ctrl-a Q` | Kill this session (asks) |
| `Ctrl-a $` | Reload environment variables (`SSH_AUTH_SOCK`, ...) in every idle shell pane of the session |
| `Ctrl-a M-s` / `Ctrl-a M-r` | Save / restore all sessions (tmux-resurrect) |

Sessions are also saved every 15 minutes and restored when tmux starts (tmux-continuum).

## Windows

| Keys | Action |
|---|---|
| `Ctrl-a n` | New window in the current folder |
| `Ctrl-a c` | New window (tmux default, home folder) |
| `Ctrl-a r` | Rename window |
| `Ctrl-a 1`…`9` | Go to window n |
| `Ctrl-a C-[` / `Ctrl-a C-]` | Previous / next window (repeatable) |
| `Ctrl-a Tab` | Last used window |
| `Ctrl-a w` | Pick a window or pane in a tree (tmux default) |
| `Ctrl-a X` | Kill window |
| `Ctrl-a C-x` | Kill all other windows (asks) |
| `Ctrl-a T` | Move this pane to its own window |
| `Ctrl-a m` | Toggle: alert on activity in this window |
| `Ctrl-a M` | Toggle: alert after n seconds of silence |

## Panes

| Keys | Action |
|---|---|
| `Ctrl-a \|` | Split side by side (current folder) |
| `Ctrl-a _` | Split top/bottom (current folder) |
| `Ctrl-a [` / `Ctrl-a ]` | Previous / next pane (repeatable) |
| `Ctrl-a ←↑→↓` | Pane in that direction (tmux default) |
| `Ctrl-a h/j/k/l` | Pane left / down / up / right (Vim style) |
| `Ctrl-a C-←↑→↓` | Resize (tmux default) |
| `Ctrl-a z` | Zoom / unzoom pane |
| `Ctrl-a C-o` | Rotate panes |
| `Ctrl-a \` | Swap this pane with pane 1 (the main one) and back |
| `Ctrl-a Space` | Next layout (tmux default) |
| `Ctrl-a x` | Kill pane |
| `Ctrl-a o` | Kill all other panes |
| `Ctrl-a f` | Fuzzy-find any pane in any session (fzf popup) |
| `Ctrl-a F` | Find a window by text (tmux's old `f`) |
| ``Ctrl-a ` `` | Scratch terminal floating over the window; same keys hide it |

## Copy mode (vi keys)

| Keys | Action |
|---|---|
| `Ctrl-a v` or `Alt-Up` | Enter copy mode |
| `v` | Start selection |
| `r` | Toggle rectangle selection |
| `y` | Copy selection (system clipboard) |
| `Y` | Copy the whole line |
| `D` | Copy to end of line |
| `A` | Append selection to the buffer |
| `H` / `L` | Start / end of line |
| `Alt-Up` / `Alt-Down` | Scroll one line |
| `Alt-PageUp` / `Alt-PageDown` | Scroll half a page |
| `PageUp` / `PageDown` | Scroll a page |
| `/` / `?` | Search down / up (vi default) |
| `q` | Leave copy mode |

Mouse: drag to select, it's copied when you let go (copy mode stays open); a click clears the selection; the wheel scrolls 2 lines.

| Keys | Action |
|---|---|
| `Ctrl-a p` | Paste the last copied buffer |
| `Ctrl-a C-p` | Pick a buffer to paste |

## Config and misc

| Keys | Action |
|---|---|
| `Ctrl-a C-e` | Edit `~/.tmux.conf` in a new window, reload when you close it |
| `Ctrl-a C-r` | Reload config |
| `Ctrl-a C-s` | Hide / show the status bar |
| `Ctrl-a ?` | List all keys |
| `F12` | Turn all tmux keys off (to control an inner tmux over ssh); `F12` again turns them back on |
| `Ctrl-a I` / `Ctrl-a U` / `Ctrl-a M-u` | Install / update / remove plugins (tpm) |

## Status bar

Right side: prefix indicator, keys-off and zoom markers, CPU, memory, swap (`SW:0%` when macOS has no swap file), date, battery, online status.

## Plugins

tpm, tmux-prefix-highlight, tmux-online-status, tmux-battery, tmux-plugin-sysstat, tmux-resurrect, tmux-continuum.
`tmux/configure.sh` installs them; if the status bar is empty, run `Ctrl-a I`.
