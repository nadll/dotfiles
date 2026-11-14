# Docs

A snapshot of what these dotfiles give you: key bindings, aliases, functions and tools.
Written from the config files on 2026-11-14; if something here and a config file disagree, the config file wins.

| Page | What's in it |
|---|---|
| [zsh.md](zsh.md) | Key bindings on the command line, completion menu, fzf and fzf-git keys, shell behaviour |
| [shell.md](shell.md) | Aliases, functions and `~/bin` scripts |
| [git.md](git.md) | git aliases, shell `g*` aliases and functions, notable git settings, lazygit, tig |
| [tmux.md](tmux.md) | Prefix keys, copy mode, plugins, status bar |
| [iterm2.md](iterm2.md) | iTerm2 profiles and their Cmd shortcuts (including the tmux profile) |
| [editors.md](editors.md) | VS Code and Vim |
| [macos.md](macos.md) | Text-field key bindings, Finder helpers, macOS scripts |
| [tools.md](tools.md) | What the Brewfile installs, grouped |
| [claude-code.md](claude-code.md) | Claude Code settings, status line, hooks |

## Most used

| Keys / command | What it does |
|---|---|
| `Ctrl-R` | fzf history search (`Ctrl-Y` copies the command) |
| `Ctrl-T` | fzf file picker, pastes the path |
| `Alt-C` / `cd` with no argument | fzf folder picker, then cd into it |
| `Up` / `Down` | history entries that contain what you typed |
| `Tab` | completion menu |
| `Ctrl-O` | copy the current command line to the clipboard |
| `z <name>` / `zi` | jump to a frequent folder (zoxide) |
| `frg <text>` / `frgi` | ripgrep + fzf, opens the match in your editor |
| `Ctrl-a` | tmux prefix |
| `tat` | tmux session named after the current folder |
| `lazygit` / `tig` | git in the terminal |
| `dotfiles-update` | pull this repo, re-link, install new packages |

## Seeing the live list

| Tool | Command |
|---|---|
| zsh aliases | `alias`, or `alias \| rg <word>` |
| zsh functions | `print -l ${(ok)functions} \| rg -v '^_'` |
| zsh key bindings | `bindkey` (main), `bindkey -M menuselect` (completion menu) |
| git aliases | `git aliases` |
| tmux keys | `Ctrl-a ?` |
| lazygit keys | `?` inside lazygit |
