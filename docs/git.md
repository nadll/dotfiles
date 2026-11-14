# git

Config: `git/.gitconfig` (aliases and settings), `git/funcs.sh` (shell aliases and functions), `lazygit/config.yml`, `tig/config`.
Your name, email and signing key go in `~/.gitconfig.local` (`./git_setup.sh`).

## git aliases (`git <alias>`)

### Everyday

| Alias | Runs |
|---|---|
| `st` | `status -sb` |
| `s` | `status -s` |
| `co` / `br` / `ci` | `checkout` / `branch` / `commit` |
| `go <branch>` | Switch to a branch, creating it if needed |
| `m` | Check out the default branch |
| `ap` | `add --patch`: stage chunk by chunk |
| `ca` | Add everything and commit |
| `amend` | Add staged changes to the last commit, keep its message |
| `ua` | Add everything to the last commit, no edit |
| `empty "msg"` | Empty commit (e.g. to re-run CI) |
| `unstage <file>` | Remove from the index |
| `ulc [n]` | Undo the last n commits, keep the changes (`reset --soft`) |
| `rlc [n]` | Remove the last n commits **and their changes** (`reset --hard`) |
| `p` | Pull, including submodules |
| `fo` | `fetch origin` |
| `puf` | `push --force-with-lease` |
| `c <url>` | Clone with submodules |

### Diff

| Alias | Runs |
|---|---|
| `d` | Diff with stat, no pager (clears the screen first if there are changes) |
| `di <n>` | Diff against n commits ago |
| `stat` | `diff --stat`, no pager |
| `dt` | `difftool` (VS Code) |
| `diffbranch` | Everything this branch changes vs `origin/<default>`, working tree included |
| `diffcommitsfrommain` | Commits on this branch that aren't on `origin/<default>` |
| `wtf` | Files that still have merge conflicts |
| `ignored` | Files git is ignoring in this repo |

### Log and search

| Alias | Runs |
|---|---|
| `l` | Log, one line per commit (`pretty=custom`) |
| `g` | Same, as a graph |
| `lg` | Graph of all branches |
| `today` | Your commits since midnight with line counts |
| `recent` / `rrecent` | 10 most recently committed local branches / all remote branches |
| `fc <code>` | Commits that added or removed `<code>` |
| `fm <text>` | Commits whose message contains `<text>` |
| `fb <commit>` / `ft <commit>` | Branches / tags that contain a commit |
| `contributors` | Commit count per author |
| `authors` | Every author with email, once each |
| `whoami` | `user.email` for this repo |

### Branches, tags, worktrees

| Alias | Runs |
|---|---|
| `branches` / `tags` / `remotes` | List them |
| `sweep` | Delete branches merged into the default branch, prune origin |
| `dm` | Delete branches merged into the current one |
| `defaultBranch` | Print the default branch (`remoteSetHead` refreshes it) |
| `reb <n>` | Interactive rebase of the last n commits |
| `retag <tag>` | Move a tag to HEAD, locally and on origin |
| `credit "Name" email` | Change the author of the last commit |
| `wta <path> <branch>` / `wtl` / `wtr` | Worktree add / list / remove |
| `serve` | Serve this repo read-only with `git daemon` |
| `aliases` | List all aliases |

`git-extras` adds about 80 more commands (`git summary`, `git effort`, `git changelog`, ...).

## Shell aliases and functions

### Staging and committing

| Command | Runs |
|---|---|
| `gia` / `giA` | `git add` / `git add -A` |
| `gir` | `git restore --staged` |
| `gwu` | `git restore --worktree` (discard changes) |
| `gwc` | `git clean -id` (asks) |
| `gcm` | `git commit` |
| `gce` / `gcE` | Amend keeping / editing the message |
| `gcap "msg"` | Add all, commit, push |
| `git-undo` | Undo the last commit, keep changes |

### Status and diff

| Command | Runs |
|---|---|
| `gws` | `git status --short` |
| `gwsi` | `git fuzzy status` (interactive) |
| `gdd` | Diff with stat and patch |
| `gds` | Diff stat only |
| `gdt` / `gdtui` | `git difftool` / GUI difftool |
| `gdi [refs]` | Pick changed files in git-fuzzy, open them in difftool |

### Branches and history

| Command | Runs |
|---|---|
| `gbl` | `git branch -v` |
| `gbc` | `git checkout` |
| `gbci` | Pick a branch in fzf with a log preview (with arguments: plain checkout) |
| `gbcii` | `git fuzzy branch` |
| `gbback` | Back to where HEAD was before the last checkout |
| `gbhas <ref>` | Branches containing a ref |
| `gbg` | `git show-branch` graph |
| `prec` / `nextc [branch]` | Check out the previous / next commit |
| `griii <n>` | Interactive rebase of the last n commits |
| `glo` / `glg` / `gla` | Log one-line / as a graph / graph of all branches |
| `gllr A...B` | Log with left/right markers |
| `gcs` / `gcS` | Show a commit: one line / with stat |
| `gcsi [rev]` | Browse one commit's files in git-fuzzy |
| `glistauthors` | Authors by number of commits |
| `glistb` | Remote branches by date with author |
| `listbyauthor <name>` / `gitlistcommits <name>` | An author's commits, one line each / with diffs |
| `gmm` / `gmt` | `merge --no-ff` / `mergetool` |
| `gmb` / `gmc` | Merge base / commits behind a conflict |

### Remotes and stash

| Command | Runs |
|---|---|
| `gp` / `gpl` | Push / pull |
| `gP` | Push the current branch and set upstream |
| `gss` / `gsS` | Stash / stash including untracked files |
| `gsp` | Stash pop |
| `gsi` | Pick a stash in fzf (preview), apply it |

## Notable settings

- Commits and tags are signed (`commit.gpgsign`, `tag.gpgsign`); turn it off per machine in `~/.gitconfig.local`.
- `git commit` opens VS Code, shows the diff (`commit.verbose`) and starts from `~/.gitmessage` (50/72 rulers).
- Pager: delta with line numbers (`diff`, `show`, `log`); `difft` on demand: `git -c diff.external=difft diff`.
- Diff: histogram algorithm, moved lines colored, renames and copies detected.
- Merge conflicts in `zdiff3` style; `rerere` remembers how you resolved a conflict.
- `push.autoSetupRemote`, `push.followTags`, `push.useForceIfIncludes`; `fetch.prune`.
- `pull.rebase = false`, default branch `master`.
- `git branch` sorts by last commit, `git tag` by version.
- `help.autocorrect = immediate`: a mistyped command runs the right one at once.
- `git stash show` shows the patch.

## lazygit

`lazygit` in a repo. Changes from the defaults: Nerd Font icons, no startup tip, `e`/`o` open files in VS Code, and `|` cycles diffs between delta and difftastic. `?` lists all keys.

## tig

`tig` in a repo (`tig status`, `tig blame <file>`). Readable selected line with the coolnight colors, compact author/date columns, commits in topological order, manual refresh (`R`).
