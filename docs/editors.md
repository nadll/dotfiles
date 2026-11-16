# Editors

`$EDITOR` and `$VISUAL` are VS Code (`code`). git commits (`core.editor = code --wait`), `hosts` and lazygit use it too.

## VS Code

Config: `code/settings.json`, `code/keybindings.json` (linked into `~/Library/Application Support/Code/User/`).

| Keys | Action |
|---|---|
| `Shift-Enter` (terminal) | New line in Claude Code instead of sending |

The extensions the Brewfile installs: Claude Code, Material Icon Theme, Python (Pylance), Ruff (Python formatter), Shopify Theme Check.
Settings highlights: Ruff formats Python on save, indentation detected per file, trailing whitespace shown, git auto-fetch, AI co-author trailer off, no extension recommendation pop-ups, repo found from a subfolder, inline blame, telemetry and experiments off.
`code` from the shell; `git difftool` / `git mergetool` open VS Code.

## Vim

Config: `vim/.vimrc`. Solarized Dark, relative line numbers, mouse, OS clipboard, invisible characters shown, search highlighted as you type (ignores case unless you type a capital).

| Keys | Action |
|---|---|
| `,` | Leader key |
| `,ss` | Strip trailing whitespace |
| `,W` | Save as root (`sudo tee`) |
| `Space` `Enter` | Clear the search highlight |

- Modelines are off (a file can't run commands); per-folder `.vimrc` files are read in safe mode.
- No `.swp` swap files (and so no recovery after a crash).
- Typing `)`, `]` or `}` briefly shows the matching opening bracket.
- `todos`, `rgq` (see [shell.md](shell.md)) open search results in Vim's quickfix list: `:cn` / `:cp` next / previous.
