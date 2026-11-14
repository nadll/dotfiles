# zsh key bindings

Config: `shell/zsh/.zshrc`, `fzf/fzf.rc.sh`. Emacs-style line editing (the zsh default).

## Command line

| Keys | Action |
|---|---|
| `Up` / `Down` | Previous / next history entry containing what you've typed (history-substring-search) |
| `Alt-Up` | History menu (zsh-autocomplete) |
| `Alt-Down` | Completion menu (zsh-autocomplete) |
| `Ctrl-O` | Copy the whole command line to the clipboard |
| `Home` / `End` | Start / end of line |
| `Esc h` | `run-help`: man page for the command you're typing |
| `Ctrl-A` / `Ctrl-E` | Start / end of line (zsh default) |
| `Ctrl-W` / `Alt-Backspace` | Delete word before the cursor |
| `Ctrl-U` | Delete the whole line (zsh default) |
| `Ctrl-X /` | Recent folders (from zoxide) |
| `Ctrl-S` / `Ctrl-Q` | Free: terminal flow control (XON/XOFF) is turned off |

In iTerm2, `Option-Left` / `Option-Right` jump by word and `Option-Backspace` deletes a word (see [iterm2.md](iterm2.md)).

Every command you run starts at the top of a cleared screen (the old output stays in the scrollback).

## Completion menu

| Keys | Action |
|---|---|
| `Tab` | Insert the part common to all matches, then open the menu |
| `Shift-Tab` | Open the menu / go back one entry |
| `Tab` (in the menu) | Next entry |
| `/` / `?` (in the menu) | Search forward / backward in the menu |
| `Esc` (in the menu) | Close the menu, undo the insertion |

Completion skips `.`, `..` and `.DS_Store`, and uses `LS_COLORS` colors.

## fzf

| Keys | Action |
|---|---|
| `Ctrl-T` | Pick files (git files, else `fd`) and paste them on the command line |
| `Ctrl-R` | Search history; in the list `Ctrl-Y` copies the command |
| `Alt-C` | Pick a folder and cd into it |
| `cd` (no argument) | Same, with a `tree` preview (`cd <dir>` works as usual) |
| `**<Tab>` | Fuzzy completion, e.g. `vim **<Tab>`, `cd **<Tab>`, `ssh **<Tab>`, `export **<Tab>` |

Inside any fzf list:

| Keys | Action |
|---|---|
| `Tab` / `Shift-Tab` | Mark / unmark (multi-select) |
| `Ctrl-D` / `Ctrl-U` | Half page down / up |
| `Ctrl-L` | Clear the query |
| `Ctrl-Y` | Copy the selection to the clipboard and close |
| `Ctrl-X` | Delete the selected files (asks for each) |
| `F3` | View the file in `bat` |
| `F4` | Open the file in `$EDITOR` |
| `Alt-W` | Toggle line wrap in the preview |
| `Ctrl-\` | Preview: hidden / bottom / right |

## fzf-git (`Ctrl-G` then a key)

From `vendor/fzf-git.sh`. Each one pastes what you pick onto the command line.

| Keys | Pick from |
|---|---|
| `Ctrl-G Ctrl-F` | Changed files |
| `Ctrl-G Ctrl-B` | Branches |
| `Ctrl-G Ctrl-T` | Tags |
| `Ctrl-G Ctrl-R` | Remotes |
| `Ctrl-G Ctrl-H` | Commit hashes |
| `Ctrl-G Ctrl-S` | Stashes |
| `Ctrl-G Ctrl-L` | Reflog entries |
| `Ctrl-G Ctrl-W` | Worktrees |
| `Ctrl-G Ctrl-E` | Every ref |

## Behaviour

- Type a folder name without `cd` to go there (`auto_cd`).
- Type a file name to open it: `README.md`, `*.json`, `*.toml`, `*.yaml` open in VS Code. Paste a URL ending in `.git` to clone it.
- File name patterns ignore case: `*.jpg` also matches `IMG_001.JPG` (careful with `rm`).
- `>` won't overwrite an existing file ("file exists"); `>|` does. `>>` still creates new files.
- A new shell opens in the last folder you used (oh-my-zsh `last-working-dir`).
- No beep.

### History

- 100,000 entries in `~/.config/zsh/.zsh_history`, shared between open terminals, with timestamps.
- A command starting with a space is not saved.
- Typos aren't saved: a line whose command doesn't exist is dropped (Up still brings it back once, to fix it).
- Repeats in a row are saved once; searches skip duplicates.
- Plain `ls`, `l`, `ll`, `la`, `lt`, `cd`, `cd ..`, `..`, `...`, `pwd`, `exit`, `clear`, `history` are not saved.

### oh-my-zsh plugins

`git`, `gitfast`, `last-working-dir`, `common-aliases`, `zsh-autosuggestions` (grey suggestion: `Right` accepts it), `zsh-syntax-highlighting`, `history-substring-search`, `web-search` (`google foo`, `ddg foo`, ...), `extract` (`x <archive>`), `colored-man-pages`.
The `git` and `common-aliases` plugins add many aliases of their own (`gst`, `gco`, `L`, `G`, ...): see `alias`.
