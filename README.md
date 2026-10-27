# dotfiles

My macOS setup: zsh with oh-my-zsh and powerlevel10k, Homebrew packages, git, fzf, tmux and VS Code.
It started from [lewagon/dotfiles](https://github.com/lewagon/dotfiles) and takes its per-tool layout from [samoshkin/dotfiles](https://github.com/samoshkin/dotfiles).

## New Mac

```sh
xcode-select --install          # git and compilers, if macOS asks for them
git clone https://github.com/nadll/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh --dry-run          # optional: show what would change, change nothing
./install.sh
```

The repo can live anywhere: `install.sh` records its location in `~/.config/zsh/.env/00-dotfiles.env.sh`.
Keep the clone after installing, the files in `~` are symlinks into it.

Then:

1. Open a new terminal (or run `exec zsh`).
2. Set your git identity for this machine: `./git_setup.sh`. It writes your name and email to `~/.gitconfig.local`, which `git/.gitconfig` includes and which stays out of the repo; put signing keys or work-only settings there too. Until you run it, git refuses to commit.
3. In iTerm2, open Settings → Profiles and make the dotfiles **Default** (or **tmux**) profile the default. Both come from `iterm2/settings/profiles.json` and already use the Droid Sans Mono Nerd Font, so prompt icons render.
4. Set up the prompt: `p10k configure`.
5. In tmux, install the plugins with `Ctrl-a` then `I` (the prefix is `Ctrl-a`).
6. Optional, by hand in iTerm2 Settings: import a color preset from `iterm2/colors/` (Profiles → Colors → Color Presets → Import) and the key map `iterm2/settings/keys.itermkeymap` (Profiles → Keys → Key Mappings → Presets → Import).

### Options

| Option | What it does |
|---|---|
| `--dry-run`, `-n` | Print every change instead of making it |
| `--skip-brew` | Skip Homebrew and `brew bundle`, for a quick re-run after editing config |
| `--macos` | Also apply `macos/preferences.sh` (asks first; read the script before using it) |
| `--pro` | Also install `brew/Brewfile.pro`, and remember it (`~/.dotfiles-pro`) so later runs and `dotfiles-update` do too; `rm ~/.dotfiles-pro` to stop |
| `--help`, `-h` | Show usage |

`install.sh` is safe to run again. Existing files that aren't symlinks are moved to `<name>.backup.<timestamp>` before being replaced, and links that are already correct are left alone.

## What `install.sh` does

1. Installs Homebrew if it's missing, then the packages in `brew/Brewfile` with `brew bundle`, plus `brew/Brewfile.pro` on pro machines.
2. Installs oh-my-zsh, the powerlevel10k theme and the `zsh-autosuggestions` and `zsh-syntax-highlighting` plugins.
3. Clones tools that aren't in Homebrew, git-fuzzy and fzf-git.sh, into `vendor/` (ignored by git).
4. Runs every `<tool>/configure.sh`, `shell` first. These link the config files into place; `tmux/configure.sh` also clones tpm into `~/.tmux/plugins/tpm`.
5. Makes zsh the login shell if it isn't already.

## Layout

```
brew/        Brewfile, Homebrew env and helper functions
code/        VS Code settings.json and keybindings.json
coreutils/   GNU tools ahead of the macOS ones, eza/bat/less settings, LS_COLORS
fd/ fzf/     file finder and fuzzy finder settings
git/         .gitconfig, global gitignore, git aliases and functions
macos/       Finder helpers, Terminal.app theme; preferences.sh (applied with --macos; read it first)
python/ thefuck/ zoxide/   one setting each
shell/       zsh startup files, aliases, functions, scripts for ~/bin
ssh/ tmux/ vim/
tig/         colors for tig (readable selected line)
iterm2/      profiles (linked as an iTerm2 Dynamic Profile), color presets, key map
vendor/      clones made by install.sh, not tracked
```

### How zsh is wired

- `~/.zshenv` only sets `ZDOTDIR=~/.config/zsh`, so everything else lives in `~/.config/zsh/`. No `sudo` and no changes to `/etc`.
- `.zshenv` loads every file in `~/.config/zsh/.env/` (for all shells: PATH, Homebrew, environment variables).
- `.zprofile` loads `.zshenv` again after macOS's `path_helper`, so Homebrew and the GNU tools stay ahead of `/usr/bin`.
- `.zshrc` loads oh-my-zsh, then every file in `~/.config/zsh/.rc/` (interactive shells: aliases, functions, key bindings).
- History is in `~/.config/zsh/.zsh_history`, the powerlevel10k config in `~/.config/zsh/.p10k.zsh`.
- `~/.aliases` and `~/.functions` are sourced if they exist, for machine-local additions you don't want in the repo.

## Adding a tool

1. Create a folder, e.g. `foo/`.
2. Put settings in `foo/foo.rc.sh` (interactive shells) or `foo/foo.env.sh` (all shells, e.g. PATH).
3. Add `foo/configure.sh`, which links them into place:

   ```sh
   # Sourced by install.sh (uses its link/run helpers and $DOTFILES, $SHELLRCDIR, $SHELLENVDIR)

   link "$DOTFILES/foo/foo.rc.sh" "$SHELLRCDIR/"
   ```

   A target ending in `/` means "link into this folder". `link` backs up existing files and respects `--dry-run`. Wrap any other command that changes something in `run`, so `--dry-run` only prints it.
4. If it needs a package, add it to `brew/Brewfile`. A package only pro machines need (like `jfrog-cli`) goes in `brew/Brewfile.pro` instead; see `--pro`.
5. Run `./install.sh --skip-brew`.

Files in `.env/` and `.rc/` load in alphabetical order, so a later file wins when two set the same alias or variable.

### Startup time

```sh
time zsh -i -c exit      # total time for a new interactive shell
ZPROF=1 zsh -i -c exit   # per-function breakdown from zsh/zprof
```

Slow tools are loaded lazily: `fuck`/`fk` start thefuck (Python) only on first use, and `brew shellenv` runs once per shell.

## Checks

`.github/workflows/ci.yml` runs on every push: shellcheck, `zsh -n` and `.github/scripts/check-duplicates.sh` (an alias or function defined twice) on Ubuntu, then on a macOS runner it parses the Brewfile, does a dry run, installs into a throwaway home, checks that a second run changes nothing, and starts zsh.

## Day to day

Edit the files in the repo, not in `~`: they are the same files through the symlinks. Commit and push as usual.
Re-run `./install.sh --skip-brew` after adding a new file, so it gets linked.
`dotfiles-update` does all of it on any machine: `git pull`, `./install.sh --skip-brew`, then `brew bundle` for new packages.

Some settings are kept but switched off, to enable later:

- `git/.gitconfig`: the second half has commented settings from the previous config (`pull.rebase = true`, colors, `merge.tool`, …). `[commit] template` needs a `~/.stCommitMsg` file before you enable it.
- `fzf/fzf.rc.sh`: settings from the old `zshrc`, marked `(old zshrc, overridden above)`.

## Moving from the old setup

On a Mac that ran an earlier version of these dotfiles:

- `/etc/zshenv` may still contain `export ZDOTDIR=...` and a `path_helper` block. Both are harmless; remove them with `sudo` if you like.
- `~/.rspec` and `~/.pryrc` point to files that were removed: `rm ~/.rspec ~/.pryrc`.
- `~/.ssh/config` is copied only when missing. If yours has a bare `IdentityFile ~/.ssh/` line, change it to `IdentityFile ~/.ssh/id_ed25519`.
- `~/.zshrc` and `~/.fzf.zsh` are no longer read and can be deleted.
