# Edit files using whatever $EDITOR
alias e="$EDITOR"
alias E="editor_in_split_pane"

# HTTPie
alias https='http --default-scheme=https'

function httpless {
    http --pretty=all --print=hb "$@" | less -R;
}

# Aliases to Chrome browser executables
alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
alias chrome-canary="/Applications/Google\ Chrome\ Canary.app/Contents/MacOS/Google\ Chrome\ Canary"

# eg. fd <search> | tree --fromfile
# same as fd <search> | as-tree
alias as-tree='tree --fromfile'

# Get External IP / Internet Speed
# off: `ip` below also prints the public IP; for location/ISP details: curl https://ipinfo.io/json
# alias myip="curl https://ipinfo.io/json" # or /ip for plain-text ip
# macOS built-in test (Apple's servers); -s measures download and upload one after the other
# was: curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -
alias speedtest="networkQuality -s"

# Easier navigation: .., ..., ...., ....., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
# Same thing by number of levels: ..2 to ..4 duplicate ... to ..... above, so they are off
# alias ..2="cd ../.."
# alias ..3="cd ../../.."
# alias ..4="cd ../../../.."
# 5 levels up has no dot form, so ..5 stays
alias ..5="cd ../../../../.."
alias ~="cd ~" # `cd` is probably faster to type though
alias -- -="cd -"

# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
    colorflag="--color"
    # LS_COLORS comes from vivid, see coreutils/coreutils.rc.sh
else # macOS `ls`
    colorflag="-G"
    export LSCOLORS='BxBxhxDxfxhxhxhxhxcxcx'
fi

# List all files colorized in long format, excluding . and ..
alias la="ls -lAF ${colorflag}"

# List only directories
alias lsd="eza -lD"

# Always enable colored `grep` output
# Note: `GREP_OPTIONS="--color=auto"` is deprecated, hence the alias usage.
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Get week number
alias week='date +%V'

# IP addresses
# was DNS only, which fails on networks that block outside DNS servers (company networks):
# alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
# Public IP: over HTTPS first, then a second service, then DNS as a last resort
# -f: an HTTP error (proxy or captive-portal page) counts as a failure, so the next one is tried
# --max-time 5: a service that hangs doesn't block the fallback
function ip {
  curl -sf --max-time 5 "https://icanhazip.com/" || \
    curl -sf --max-time 5 "https://am.i.mullvad.net/ip" || \
      dig @resolver1.opendns.com ANY myip.opendns.com +short }
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# Show active network interfaces (rg -U: multiline match over each interface's block)
alias ifactive="ifconfig | rg -U -o '^[^\t:]+:([^\n]|\n\t)*status: active'"

# macOS has no `md5sum`, so use `md5` as a fallback
command -v md5sum > /dev/null || alias md5sum="md5"

# macOS has no `sha1sum`, so use `shasum` as a fallback
command -v sha1sum > /dev/null || alias sha1sum="shasum"

# Recursively delete `.DS_Store` files
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

# brew update
alias bupdate="brew update && brew upgrade && brew cleanup"  # brew upgrade includes casks

# Hide/show all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

# Keep the Mac awake for 4 hours (display, idle and system sleep; Ctrl-C to stop early)
alias stayawake="caffeinate -disu -t 14400"

# Away from keyboard: turn the display off now (locks the Mac when a password is required after sleep)
alias afk="pmset displaysleepnow"

# Disable Spotlight
alias spotoff="sudo mdutil -a -i off"
# Enable Spotlight
alias spoton="sudo mdutil -a -i on"

# sets the default output format for ps
alias psf='ps -eo pid,ppid,user,pri,ni,vsz,rss,pcpu,pmem,tty,stat,args'

# Edit /etc/hosts in VS Code: sudo -e edits a copy as you (VS Code not run as root), then writes it back
alias hosts='SUDO_EDITOR="code --wait" sudo -e /etc/hosts'

# Count identical lines, most frequent first (or least frequent first with -asc)
#   e.g. git log --format=%an | sorteduniq
alias sorteduniq="sort | uniq -c | sort --reverse --ignore-leading-blanks --numeric-sort"
alias sorteduniq-asc="sort | uniq -c | sort --ignore-leading-blanks --numeric-sort"

# Copy piped output to the clipboard without newlines, e.g. git rev-parse HEAD | c
alias c="tr -d '\n' | pbcopy"

# Run a command once per input line, e.g. fd .gitattributes | map dirname
alias map="xargs -n1"

# Free/used space of the main disk, in powers of 1000 like Finder
alias diskspace_report="df --si /"

# ripgrep including .gitignore'd and hidden files (-uu = --no-ignore --hidden)
alias rgu='rg -uu'

# ---- Eza (better ls) -----

alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
#alias ls="eza"

# ---- Zoxide (better cd) ----
# off: `cd` is the fzf folder picker from fzf/fzf.rc.sh (no argument = pick a subfolder);
# jump to frequent folders with `z <name>` (or `zi` to pick in fzf)
# alias cd="z"

# ---- Suffix aliases (zsh): type a file name to open it ----
# e.g. `README.md` opens it in VS Code. oh-my-zsh's common-aliases plugin defines more (txt, c, ...)
alias -s {md,json,toml,yaml,yml}=code
# Paste a repository URL ending in .git to clone it: https://github.com/user/repo.git
alias -s git='git clone'
