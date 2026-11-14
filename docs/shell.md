# Aliases, functions and scripts

From `shell/alias.sh`, `shell/functions.sh`, `coreutils/coreutils.rc.sh`, `fd/`, `fzf/`, `brew/brew.rc.sh`, `macos/macos.rc.sh` and `shell/bin/`.
git ones are in [git.md](git.md).

## Listing files

| Command | What it does |
|---|---|
| `ls` | eza: long list with icons and git status, no size/time/owner/permissions |
| `l` | One per line, hidden files included, folders first |
| `ll` | Long list with hidden files, ISO dates, folders first |
| `la` | `ls -lAF` (GNU ls): long list with hidden files |
| `lsd` | Folders only |
| `lt` / `llt` | Tree, 2 levels (`llt` with details) |
| `tre` | `tree` with hidden files, no `.git`/`node_modules`, paged |
| `cat` | bat with syntax colors only (works like plain cat) |
| `catn` | bat with line numbers and git change marks, paged |

## Moving around

| Command | What it does |
|---|---|
| `cd` | No argument: pick a subfolder in fzf; otherwise normal cd |
| `z <name>` / `zi` | Jump to a frequent folder / pick one in fzf (zoxide) |
| `fcd [dir]` | Pick any folder below (`find`, no hidden ones) |
| `..` `...` `....` `.....` `..5` | Up 1 to 5 levels |
| `-` | Previous folder |
| `~` | Home |
| `mkcd <dir>` | Create a folder (with parents) and enter it |
| `cdf` / `pfd` / `ofd` | cd to / print the front Finder window's folder; open this folder in Finder |
| `o [path]` | `open` (this folder without argument) |

## Searching

| Command | What it does |
|---|---|
| `frg <text>` | ripgrep, pick a match in fzf with preview, open it at that line in `$EDITOR` |
| `frgi [text]` | Same, but the search re-runs as you type |
| `frgl <text>` | Files containing the text, preview shows matches, opens the file |
| `rgq <args>` | ripgrep results in a Vim quickfix list |
| `todos` | TODO/FIXME/BUG markers in a Vim quickfix list |
| `rgu` | ripgrep including ignored and hidden files |
| `fd` | fd with hidden files, follows links, ignores `fd/.ignore` patterns |
| `ff <part>` | Files whose name contains `<part>` |
| `hist <text>` | History lines containing text |
| `mans <cmd> <word>` | Lines around `<word>` in a man page |
| `grep` / `egrep` / `fgrep` | Colored |

## Files and disk

| Command | What it does |
|---|---|
| `trash <files>` | Move to the Finder Trash (macOS `trash`; "Put Back" works) |
| `x <archive>` / `extract` | Unpack any archive |
| `targz <dir>` | `.tar.gz` with the best compressor available (zopfli, pigz, gzip) |
| `gz <file>` | Original vs gzipped size |
| `fs [path]` | Size of a file or folder |
| `filesize [-h]` | Size of what's piped in |
| `top-size` | 10 biggest items in this folder |
| `diskspace_report` | Free/used space, like Finder counts it |
| `cleanup` | Delete `.DS_Store` files below here |
| `as-tree` | Show a list of paths as a tree: `fd foo \| as-tree` |
| `e <file>` / `E <file>` | Open in `$EDITOR` / in a split pane (tmux) |

## Text and pipes

| Command | What it does |
|---|---|
| `c` | Copy piped text without newlines: `git rev-parse HEAD \| c` |
| `map <cmd>` | Run a command per input line: `fd .git \| map dirname` |
| `sorteduniq` / `sorteduniq-asc` | Count identical lines, most / least frequent first |
| `trim <text>` | Strip leading and trailing whitespace |
| `extract-ip <file>` | IP addresses found in a file |
| `path` | `$PATH`, one per line |
| `colors` | 256-color test palette |

## Network

| Command | What it does |
|---|---|
| `ip` | Public IP |
| `localip` | IP of `en0` |
| `ips` | All IPs of all interfaces |
| `ifactive` | Active network interfaces |
| `speedtest` | macOS `networkQuality` (download then upload) |
| `serve [port]` | Serve this folder over HTTP (default 8000), prints the LAN address |
| `ports` | What's listening on TCP |
| `whats-in-port <port>` | What uses a TCP port |
| `clear-port <port>` | Stop whatever listens on a port |
| `getcertnames <domain>` | Names in a site's TLS certificate |
| `https <url>` / `httpless` | HTTPie with https by default / output in less |
| `showwifipwd <ssid>` | Saved Wi-Fi password (asks for Keychain access) |
| `hosts` | Edit `/etc/hosts` in VS Code (`sudo -e`) |

## macOS

| Command | What it does |
|---|---|
| `afk` | Display off now (locks, if a password is required after sleep) |
| `stayawake` | Keep the Mac awake for 4 hours (`Ctrl-C` stops) |
| `hidedesktop` / `showdesktop` | Hide / show desktop icons |
| `spotoff` / `spoton` | Spotlight indexing off / on (sudo) |
| `system_info` | Hardware/software report as JSON |
| `chrome` / `chrome-canary` | Chrome binaries, for flags |
| `week` | Week number |
| `md5sum` / `sha1sum` | Fallbacks to `md5` / `shasum` if missing |
| `psf` | `ps` with a useful column set |

## Homebrew

| Command | What it does |
|---|---|
| `bupdate` | `brew update && brew upgrade && brew cleanup` |
| `bip` | Pick a package in fzf and install it (`Ctrl-H`: open its homepage) |
| `bup` | Pick installed packages to upgrade |
| `brp` | Pick installed packages to uninstall |
| `blp` | Pick from installed formulae and casks (`Ctrl-H`: homepage) |
| `dotfiles-update` | `git pull` this repo, `install.sh --skip-brew`, then `brew bundle` (pro too) |

## Other

| Command | What it does |
|---|---|
| `fuck` / `fk` | Correct the last command (thefuck, loads on first use) |
| `tldr <cmd>` | Short examples (tlrc) |
| `diff <a> <b>` | git's colored word diff for any two files |

## Scripts in `~/bin`

| Script | What it does |
|---|---|
| `tat [name]` | Attach to (or switch to) the tmux session named after this folder, creating it here |
| `open_in_split_pane <cmd>` | Run a command in a new tmux split (picks horizontal/vertical from the window shape) |
| `editor_in_split_pane <file>` | `$EDITOR` in a split; used by `E` and by `nnn` |

## Machine-local additions

Not in the repo: `~/.aliases`, `~/.functions` and `~/.zshrc.local` (loaded last).
