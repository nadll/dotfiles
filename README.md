# dotfiles

My macOS setup: zsh with oh-my-zsh and powerlevel10k, Homebrew, git, fzf, tmux and VS Code.

## Requirements

- macOS
- Homebrew and oh-my-zsh (`install.sh` installs both)

## What's in there?

- [Homebrew packages](brew/Brewfile)
- [zsh config](shell/zsh/), [aliases](shell/alias.sh), [functions](shell/functions.sh) and [scripts](shell/bin/)
- [git config](git/.gitconfig) with aliases, delta and GPG signing
- [tmux](tmux/), [fzf](fzf/), [lazygit](lazygit/), [vim](vim/)
- [VS Code settings](code/) and [iTerm2 profiles](iterm2/)
- [Claude Code settings](claude/)
- [macOS preferences](macos/) and a read-only security check

Key bindings, aliases and tools are listed in [docs/](docs/README.md).

## Installation

```sh
xcode-select --install
git clone https://github.com/nadll/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

Files in `~` become symlinks into the repo, so keep the clone. Existing files are backed up first.

Options: `--dry-run` (show changes only), `--skip-brew`, `--macos` (apply macOS preferences), `--pro` (work packages), `--help`.

After installing:

1. Open a new terminal.
2. Run `./git_setup.sh` to set your git name and email.
3. In iTerm2, make the **Default** profile from these dotfiles the default.
4. In tmux, install the plugins: `Ctrl-a` then `I`.

## Local customizations

Machine-specific settings go in files that stay out of the repo:

- `~/.zshrc.local`: zsh, loaded last
- `~/.gitconfig.local`: git name, email, signing key
- `~/.ssh/config.local`: SSH hosts
- `~/.tmux.conf.local`: tmux

## Updating

```sh
dotfiles-update
```

Runs `git pull`, `./install.sh --skip-brew` and `brew bundle`.

## More

[How it works](docs/internals.md): installer steps, layout, zsh startup, adding a tool.

## License

[MIT](LICENSE)
