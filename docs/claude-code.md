# Claude Code

Config: `claude/`, linked into `~/.claude/` (`settings.json`, `CLAUDE.md`, `statusline.sh`, `hooks/`).
Claude Code writes `settings.json` itself (`/config`, theme), so those changes show up in `git status`.

## `CLAUDE.md`

Working agreements for every project: small agreed steps, minimal changes, keep existing content, commit only when asked (explicit paths, `area: what changed` messages), never push unless asked, test before saying it's done.

## Settings

| Setting | Value |
|---|---|
| Telemetry, error reporting, feedback surveys | Off |
| Terminal title | Not changed by Claude Code |
| Old sessions | Deleted after 14 days |
| Commit / PR attribution | None (no `Co-Authored-By`) |
| Extended thinking | Always on |
| Bypass-permissions mode | Disabled |

## Permissions

| | Rules |
|---|---|
| Never read | `.env*`, `secrets/`, `config/credentials.json`, `~/.ssh`, `~/.gitconfig.local`, `~/.config/gh`, `*.pem`, `*.key`, `id_rsa`, `id_ed25519` |
| Never edit | `.env*` |
| Never run | `dd`, `diskutil`, `mkfs`, `rm -rf` on `/`, `/*`, `~` or `$HOME` (also with `sudo`) |
| Ask first | `git push`, `git commit --amend`, `git reset`, `git checkout --`, `git stash drop/clear`, `git clean`, `rm -rf`, `chmod` |
| Allowed | `git add/commit/fetch`, `git stash list/show`, `git rev-parse`, `git remote -v`, `rg`, `jq`, `tree`, `sort`, `uniq`, `mkdir`, `touch`, `pip list` |

## Sandbox

Commands run sandboxed. `~/.ssh` and `~/.config/gh` are blocked; `gh` runs outside the sandbox.
Network: github.com, api.github.com, `*.githubusercontent.com`, pypi.org, files.pythonhosted.org.
The repo's remotes use SSH, so `git fetch/pull/push` fail inside the sandbox and Claude retries them outside (push asks first).

## Hooks

| When | What happens |
|---|---|
| After Claude edits a file | `hooks/format-python.sh`: Ruff formats it, if it's Python |
| Claude finishes | `hooks/stop-notify.sh`: macOS notification with the Hero sound |
| Claude needs you | Glass sound |

## Status line

`statusline.sh` (needs `jq`): folder, git branch (`*` when there are uncommitted changes), model and session time on the first row; context use as a 10-block bar (yellow from 70 %, red from 90 %) and the cost at API prices (only an estimate on a Pro/Max plan) on the second.

## Elsewhere

- VS Code: `Shift-Enter` in the terminal is a new line ([editors.md](editors.md)); iTerm2 sends its own code for it too.
- tmux passes Claude Code's notifications through and tells `Shift-Enter` from `Enter`.
- Global git ignore: `.claude/settings.local.json`, `.claude/.cc-writes/`.
