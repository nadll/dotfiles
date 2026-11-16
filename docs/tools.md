# Tools

What `brew/Brewfile` installs (`brew/Brewfile.pro` adds `jfrog-cli` and `hugo` on machines set up with `--pro`).
Not from Homebrew: oh-my-zsh, powerlevel10k, the zsh plugins, tpm, and `vendor/` (git-fuzzy, fzf-git.sh), all installed by `install.sh`.

## Command line

| Tool | Use it for |
|---|---|
| `eza` | `ls` with icons and git status (`ls`, `l`, `ll`, `lt`) |
| `bat` | `cat` with syntax colors (`cat`, `catn`), fzf previews; Catppuccin Mocha theme from `bat/` |
| `fd` | Finding files (`fd <name>`), feeds fzf |
| `ripgrep` (`rg`) | Searching file contents (`frg`, `rgu`, ...) |
| `fzf` | Fuzzy picker behind `Ctrl-T`, `Ctrl-R`, `Alt-C`, `cd` and many functions |
| `zoxide` | `z <name>` / `zi`: jump to frequent folders |
| `tree` | Tree listings, fzf folder previews |
| `vivid` | Generates `LS_COLORS` (catppuccin-mocha) |
| `tlrc` | `tldr <cmd>`: short examples |
| `thefuck` | `fuck` / `fk`: fix the last command |
| `fx`, `jq` | JSON viewer / processor |
| `httpie` | `http` / `https` requests |
| `htop`, `btop`, `mactop` | Process / resource / Apple Silicon monitors (btop: Catppuccin Mocha theme from `btop/`, pick it in Esc -> Options) |
| `fastfetch` | System information summary next to a logo |
| `ncdu`, `dust` | Disk usage, interactive / as a tree |
| `bandwhich` | Bandwidth per process |
| `nnn` | Terminal file manager |
| `tmux` | Terminal multiplexer ([tmux.md](tmux.md)) |
| `shellcheck` | Lint shell scripts |
| `sevenzip` | 7z archives |
| `croc` | Send files to another computer: `croc send file.zip` |
| `repomix` | Pack a repo into one file for an AI |
| `mole` | Clean up and optimize the Mac |
| `zsh`, `bash` | Current shells |
| GNU tools | `coreutils`, `findutils`, `diffutils`, `gnu-sed`, `gnu-tar`, `grep`, `gawk`, `gnu-which`, `gzip`, `watch`, `wget`, `ed`, `gnu-indent`, `gnutls`: ahead of the macOS versions on PATH |
| Newer versions | `less`, `nano`, `curl`, `make` |

## curl settings (`~/.curlrc`)

- Downloads show a simple progress bar.
- `curl -s` still prints the reason when it fails.
- A downloaded file keeps the date the server gives it.
- HTTPS needs TLS 1.2 or newer.

## git

`git`, `git-delta` (pager), `difftastic` (`difft`, structural diff), `lazygit`, `tig`, `onefetch` (repo summary), `git-filter-repo` (rewrite history), `git-extras` (~80 extra commands), `gnupg` + `pinentry-mac` (signing). See [git.md](git.md).

## Python

`python`, `uv`. `python/uv.toml` and `python/pip.conf` only install package versions that are at least 7 days old. `breakpoint()` opens ipdb.

## Node

Not in the Brewfile.

## Apps

| App | Notes |
|---|---|
| Visual Studio Code | Plus extensions: Claude Code, Material Icon Theme, Python, Ruff, Shopify Theme Check |
| iTerm2 | Profiles from `iterm2/` ([iterm2.md](iterm2.md)) |
| Sourcetree | git GUI |
| LocalSend | AirDrop-like sharing with Windows, Linux, Android |
| Vorssaint | Menu bar utilities |
| sbx | Docker Sandboxes for coding agents |
| Fonts | MesloLGS Nerd Font, Droid Sans Mono (Powerline and Nerd Font) |

Off (commented out): `claude-code` cask (native installer used instead), `rtk`.
