# iTerm2

Config: `iterm2/settings/profiles.json` (linked as a Dynamic Profile), `iterm2/settings/keys.itermkeymap` (import by hand), `iterm2/colors/`.
Both profiles use Droid Sans Mono Nerd Font. Make one of them the default in Settings → Profiles.

## Both profiles

These send the key codes zsh, tmux and Vim expect:

| Keys | Sends / does |
|---|---|
| `Shift-Enter` / `Ctrl-Enter` | Their own codes (e.g. a new line in Claude Code) |
| `Option-Up` / `Option-Down` | `Alt-Up` / `Alt-Down` (zsh history / completion menus, tmux copy mode) |
| `Ctrl-` / `Shift-` / `Ctrl-Shift-` arrows, `Home`, `End` | xterm modifier codes |
| `Shift-F1`…`F12` | xterm codes |
| `Ctrl-2`…`Ctrl-8`, `Ctrl--` | Classic control codes (`Ctrl-2` = `Ctrl-@`, `Ctrl-3` = Esc, ...) |

## Default profile

| Keys | Action |
|---|---|
| `Cmd-N` / `Cmd-T` | New window / tab with this profile |

## tmux profile

Cmd shortcuts that send the tmux prefix (`Ctrl-a`) plus a key, so tmux feels like tabs. Details in [tmux.md](tmux.md).

| Keys | tmux | Action |
|---|---|---|
| `Cmd-A` | `Ctrl-a` | The prefix itself |
| `Cmd-T` | `Ctrl-a c` | New window |
| `Cmd-N` | `Ctrl-a n` | New window in the current folder |
| `Cmd-1`…`Cmd-9` | `Ctrl-a 1`…`9` | Go to window n |
| `Cmd-Shift-{` / `Cmd-Shift-}` | `Ctrl-a C-[` / `C-]` | Previous / next window |
| `Ctrl-Tab` | `Ctrl-a Tab` | Last used window |
| `Cmd-D` | `Ctrl-a \|` | Split side by side |
| `Cmd-Shift-D` | `Ctrl-a _` | Split top/bottom |
| `Cmd-[` / `Cmd-]` | `Ctrl-a [` / `]` | Previous / next pane |
| `Cmd-Option-arrows` | `Ctrl-a` arrows | Pane in that direction |
| `Cmd-Ctrl-arrows` | `Ctrl-a C-`arrows | Resize pane |
| `Cmd-\` | `Ctrl-a \` | Swap with the main pane |
| `Cmd-Shift-Enter` | `Ctrl-a z` | Zoom pane |
| `Cmd-W` | `Ctrl-a x` | Kill pane |
| `Cmd-Shift-W` | `Ctrl-a X` | Kill window |
| `Cmd-Option-W` | `Ctrl-a C-x` | Kill other windows |
| `Cmd-Up` / `Cmd-Down`, `Cmd-Shift-C` | `Alt-Up` / `Alt-Down` | Copy mode, scroll a line |
| `Cmd-PageUp` / `Cmd-PageDown` | `Alt-PageUp` / `Alt-PageDown` | Scroll half a page in copy mode |

## Key map preset (`keys.itermkeymap`)

Global key mappings, imported by hand (Profiles → Keys → Key Mappings → Presets → Import):

| Keys | Action |
|---|---|
| `Option-Left` / `Option-Right` | Word back / forward |
| `Option-Backspace` / `Option-Delete` | Delete word before / after the cursor |
| `Home` / `End` | Start / end of line |
| `Cmd-Left` / `Cmd-Right` | Previous / next tab |
| `Cmd-Shift-Left` / `Cmd-Shift-Right` | Move tab left / right |
| `Ctrl-Tab` / `Ctrl-Shift-Tab` | Next / previous recently used tab |
| `Cmd-Up` / `Cmd-Down` | Scroll a line |
| `Cmd-PageUp` / `Cmd-PageDown`, `Shift-PageUp` / `Shift-PageDown` | Scroll a page |
| `Cmd-Home` / `Cmd-End` | Scroll to top / bottom |
| `PageUp` / `PageDown` | Sent to the program (e.g. less, Vim) |

The profile key maps take priority over this preset where both define a key (the tmux profile's `Cmd-Up` etc.).
