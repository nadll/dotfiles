# Search for TODO|FIXME|BUG markers in a directory and open results in a Vim quickfix window
function todos() {
  vim -q <(rg --vimgrep -w -e 'TODO' -e 'FIXME' -e 'BUG' $* .)
}

# Trim trailing and leading whitespaces from a given string
function trim() {
  local var="$*"
  # remove leading whitespace characters
  var="${var#"${var%%[![:space:]]*}"}"
  # remove trailing whitespace characters
  var="${var%"${var##*[![:space:]]}"}"
  printf '%s' "$var"
}

# calculate size of any input from STDIN
function filesize() {
  if [ "$1" == "-h" ]; then
    wc -c | awk '{ printf("%.0fK", $1/1024)}'
  else
    wc -c
  fi
}

# prints macOS system report info
function system_info(){
  system_profiler -json -detailLevel mini SPHardwareDataType SPDisplaysDataType SPMemoryDataType SPNetworkDataType SPPowerDataType SPSoftwareDataType SPStartupItemDataType SPStorageDataType
}

# Open a file at line:column in $EDITOR (used by the rg/fzf search functions below)
_open_at() {
  case "$EDITOR" in
    code*) code -g "$1:$2:$3" ;;
    *vim*) "$EDITOR" "+call cursor($2, $3)" "$1" ;;
    *)     "$EDITOR" "$1" ;;
  esac
}

# Open rg search results in a Vim quickfix list
rgq() {
  vim -q <(rg --vimgrep $*)
}

# Search with ripgrep and open results in fzf
# Usage frg <query>
frg() {
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi

  local rg_command="rg --column --line-number --no-heading --color=always --smart-case $*"
  selection=$(($rg_command || true) | fzf +m --ansi \
    --delimiter : --preview-window="right:wrap:+{2}-/2" \
    --preview "bat --style=numbers --color=always --highlight-line {2} {1}")

  if [[ -n "$selection" ]]; then
    local file=$(echo $selection | awk -F: '{ print $1 }')
    local line=$(echo $selection | awk -F: '{ print $2 }')
    local column=$(echo $selection | awk -F: '{ print $3 }')
    _open_at "$file" "$line" "$column"
  fi
}

# Search with ripgrep and live query reload enabled, open results in fzf
# Query can be changed on a fly and will spawn rg command once again instantly
# fzf disables its fuzzy find features, and acts as a dumb selector
# Usage: frgi <query>
frgi() {
  local rg_command="rg --column --line-number --no-heading --color=always --smart-case "
  local query="$1"
  selection=$(($rg_command '$query' || true ) | \
    fzf +m --bind "change:reload:$rg_command {q} || true" --ansi --disabled --query "$query" \
    --delimiter : --preview-window="right:wrap:+{2}-/2" \
    --preview "bat --style=numbers --color=always --highlight-line {2} {1}")

  if [[ -n "$selection" ]]; then
    local file=$(echo $selection | awk -F: '{ print $1 }')
    local line=$(echo $selection | awk -F: '{ print $2 }')
    local column=$(echo $selection | awk -F: '{ print $3 }')
    _open_at "$file" "$line" "$column"
  fi
}

# Search with ripgrep, open results in fzf
# Show only matching files instead of individual matches
# Preview shows individual matches
# Usage: frgl <query>
frgl() {
  local file
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
  file=$(rg --files-with-matches --no-messages "$1" | fzf +m --preview-window="right:wrap" --preview "bat --style=numbers --color=always {} 2> /dev/null | rg --color always --colors 'match:bg:yellow' --context 10 '$1' || rg --color always --context 10 '$1' {}")
  if [[ -n "$file" ]]; then
    $EDITOR "$file"
  fi
}

# function ewrap(){
#   if ! { [ "$TERM" = "screen" ] && [ -n "$TMUX" ]; } then
#     # Remove option --tab for new window
#     xfce4-terminal --tab -e "$EDITOR \"$*\""
#   else
#     # tmux session running
#     tmux split-window -h "$EDITOR \"$*\""
#   fi
# }

# Update the dotfiles repo, re-link its files and install new Brewfile packages
# (plus brew/Brewfile.pro on machines set up with install.sh --pro)
function dotfiles-update() {
  git -C "$DOTFILES" pull --ff-only &&
    "$DOTFILES/install.sh" --skip-brew &&
    brew bundle --file="$DOTFILES/brew/Brewfile" &&
    { [ ! -f ~/.dotfiles-pro ] || brew bundle --file="$DOTFILES/brew/Brewfile.pro"; }
}

# Create a new directory and enter it
# off: same as mkcd below
# function mkd() {
#     mkdir -p "$@" && cd "$_";
# }

# Create directory (with parents) and cd into it immediately
function mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Retrieve saved Wi-Fi passwords by SSID
function showwifipwd() {
    security find-generic-password -wa "$1"
}

# Finds dir and jump into using interactive fuzzy search
function fcd() {
    local dir
    dir=$(find ${1:-.} -type d -not -path '*/\.*' 2> /dev/null | fzf +m) && cd "$dir"
}

# Create a .tar.gz archive, using `zopfli`, `pigz` or `gzip` for compression
function targz() {
    local tmpFile="${@%/}.tar";
    tar -cvf "${tmpFile}" --exclude=".DS_Store" "${@}" || return 1;

    size=$(
        stat -f"%z" "${tmpFile}" 2> /dev/null; # macOS `stat`
        stat -c"%s" "${tmpFile}" 2> /dev/null;  # GNU `stat`
    );

    local cmd="";
    if (( size < 52428800 )) && hash zopfli 2> /dev/null; then
        # the .tar file is smaller than 50 MB and Zopfli is available; use it
        cmd="zopfli";
    else
        if hash pigz 2> /dev/null; then
        cmd="pigz";
        else
        cmd="gzip";
        fi;
    fi;

    echo "Compressing .tar ($((size / 1000)) kB) using \`${cmd}\`…";
    "${cmd}" -v "${tmpFile}" || return 1;
    [ -f "${tmpFile}" ] && rm "${tmpFile}";

    zippedSize=$(
        stat -f"%z" "${tmpFile}.gz" 2> /dev/null; # macOS `stat`
        stat -c"%s" "${tmpFile}.gz" 2> /dev/null; # GNU `stat`
    );

    echo "${tmpFile}.gz ($((zippedSize / 1000)) kB) created successfully.";
}

# Determine size of a file or total size of a directory
function fs() {
    if du -b /dev/null > /dev/null 2>&1; then
        local arg=-sbh;
    else
        local arg=-sh;
    fi
    if [[ -n "$@" ]]; then
        du $arg -- "$@";
    else
        du $arg .[^.]* ./*;
    fi;
}

# Compare original and gzipped file size
function gz() {
    local origsize=$(wc -c < "$1");
    local gzipsize=$(gzip -c "$1" | wc -c);
    local ratio=$(echo "$gzipsize * 100 / $origsize" | bc -l);
    printf "orig: %d bytes\n" "$origsize";
    printf "gzip: %d bytes (%2.2f%%)\n" "$gzipsize" "$ratio";
}

# Show all the names (CNs and SANs) listed in the SSL certificate
# for a given domain
function getcertnames() {
    if [ -z "${1}" ]; then
        echo "ERROR: No domain specified.";
        return 1;
    fi;

    local domain="${1}";
    echo "Testing ${domain}…";
    echo ""; # newline

    local tmp=$(echo -e "GET / HTTP/1.0\nEOT" \
        | openssl s_client -connect "${domain}:443" -servername "${domain}" 2>&1);

    if [[ "${tmp}" = *"-----BEGIN CERTIFICATE-----"* ]]; then
        local certText=$(echo "${tmp}" \
        | openssl x509 -text -certopt "no_aux, no_header, no_issuer, no_pubkey, \
        no_serial, no_sigdump, no_signame, no_validity, no_version");
        echo "Common Name:";
        echo ""; # newline
        echo "${certText}" | grep "Subject:" | sed -e "s/^.*CN=//" | sed -e "s/\/emailAddress=.*//";
        echo ""; # newline
        echo "Subject Alternative Name(s):";
        echo ""; # newline
        echo "${certText}" | grep -A 1 "Subject Alternative Name:" \
        | sed -e "2s/DNS://g" -e "s/ //g" | tr "," "\n" | tail -n +2;
        return 0;
    else
            echo "ERROR: Certificate not found.";
        return 1;
    fi;
}

# `o` with no arguments opens the current directory, otherwise opens the given
# location
function o() {
    if [ $# -eq 0 ]; then
        open .;
    else
        open "$@";
    fi;
}

# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
function tre() {
    tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX;
}

# Search your Command History
function hist() {
    history | grep -i "$1"
}

# Your most used commands (first word of each history line), with share: top-history [count]
function top-history() {
    fc -ln 1 | awk '{ n[$1]++; total++ }
        END { for (c in n) printf "%6d %5.1f%%  %s\n", n[c], n[c] * 100 / total, c }' |
        sort -rn | head -n "${1:-25}"
}

# Fast recursive file finder (name search)
function ff() {
    find . -type f -iname "*$1*" 2>/dev/null
}
# ff .pdf    → finds all PDFs anywhere below current dir


# Quick Python HTTP server (Python 3)
function serve() {
    local port=${1:-8000}
    # the network address is what other devices (phone, other computers) open
    local lan_ip=$(ipconfig getifaddr en0 2>/dev/null)
    echo "Serving $PWD (whole folder, no password, Ctrl-C to stop)"
    echo "  this Mac:      http://localhost:$port"
    [ -n "$lan_ip" ] && echo "  other devices: http://$lan_ip:$port"
    python3 -m http.server "$port"
}

# Display 256-color terminal test palette
function colors() {
    for i in {0..255}; do
        printf '\e[48;5;%dm%3d ' "$i" "$i"
        (((i+3) % 18)) || printf '\e[0m\n'
    done
    printf '\e[0m\n'
}

# Pretty-print your $PATH
function path() {
    echo "$PATH" | tr ":" "\n"
}

# Unix timestamp to local date and time; without argument, prints the current timestamp
#   epoch 1763130000   (13 digits = milliseconds, also fine)
function epoch() {
    [ -n "$1" ] || { date +%s; return; }
    local ts=$1
    [ ${#ts} -ge 13 ] && ts=$((ts / 1000))
    # GNU date (coreutils, first on PATH) takes -d @ts; macOS's /bin/date takes -r ts
    date -d "@$ts" '+%Y-%m-%d %H:%M:%S %Z' 2>/dev/null || /bin/date -r "$ts" '+%Y-%m-%d %H:%M:%S %Z'
}

# Seconds as hours, minutes and seconds: hms 5000 -> 1h 23m 20s
function hms() {
    [ -n "$1" ] || { echo "Usage: hms <seconds>" >&2; return 1; }
    printf '%dh %02dm %02ds\n' $(($1 / 3600)) $(($1 % 3600 / 60)) $(($1 % 60))
}

# Search within a Man page
function mans() {
    man "$1" | grep -iC 5 "$2"
}
# Usage: mans tar extract  -> Shows 'tar' man page entries near 'extract'

# A "Safe" Delete
# Uses macOS's own `trash` command (macOS 15+): files go to the Finder Trash, so "Put Back" works.
# Without it, falls back to the old behaviour: a folder that Finder doesn't show.
function trash() {
    if [ -x /usr/bin/trash ]; then
        /usr/bin/trash "$@"
        return
    fi
    mkdir -p ~/.local/share/Trash/files
    mv "$@" ~/.local/share/Trash/files/
    echo "Moved to ~/.local/share/Trash/files/"
}

# Copy files or folders to <name>.<date-time> next to them, e.g. before editing:
#   backup nginx.conf   -> nginx.conf.20261114-153012
function backup() {
    [ $# -gt 0 ] || { echo "Usage: backup <file or folder>..." >&2; return 1; }
    local stamp f
    stamp=$(date +%Y%m%d-%H%M%S)
    for f in "$@"; do
        cp -pRv "${f%/}" "${f%/}.$stamp" || return 1
    done
}

# Encrypt a file with a passphrase (gpg, AES-256), no key needed:
#   secret notes.txt   -> notes.txt.gpg
# The original stays; delete it yourself (trash notes.txt) once reveal works.
function secret() {
    [ -f "$1" ] || { echo "Usage: secret <file>" >&2; return 1; }
    gpg --symmetric --cipher-algo AES256 --output "$1.gpg" "$1" && echo "$1 -> $1.gpg"
}

# Decrypt a file made by secret (gpg asks before overwriting):
#   reveal notes.txt.gpg   -> notes.txt
function reveal() {
    [ -f "$1" ] && [ "${1%.gpg}" != "$1" ] || { echo "Usage: reveal <file>.gpg" >&2; return 1; }
    gpg --output "${1%.gpg}" --decrypt "$1" && echo "$1 -> ${1%.gpg}"
}

# Copy with rsync: keeps dates and permissions, shows progress and a summary, compresses (helps over ssh)
#   rs ~/Photos/ nas:/backup/photos/   (a / at the end of the source copies its contents, not the folder)
# Run again to copy only what changed. macOS ships openrsync: if it rejects an option, brew install rsync
function rs() {
    rsync --archive --verbose --human-readable --progress --stats --compress "$@"
}

# What's listening?
function ports() {
    lsof -iTCP -sTCP:LISTEN -P -n
}

# What uses a given TCP port (listening or connected): whats-in-port 3000
function whats-in-port() {
    [ -n "$1" ] || { echo "Usage: whats-in-port <port>" >&2; return 1; }
    lsof -nP -iTCP:"$1"
}

# Stop whatever is listening on a TCP port (all processes, e.g. a server and its workers): clear-port 3000
function clear-port() {
    [ -n "$1" ] || { echo "Usage: clear-port <port>" >&2; return 1; }
    local pids
    pids=$(lsof -t -nP -iTCP:"$1" -sTCP:LISTEN)
    [ -n "$pids" ] || { echo "Nothing is listening on port $1"; return 1; }
    echo "Stopping:"
    echo "$pids" | xargs -n1 ps -o pid=,command= -p
    echo "$pids" | xargs kill
}

# Pull IPs from any text
function extract-ip() {
    grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" "$1" | sort -u
}
# Usage: extract-ip access.log

# Pull URLs (http, https, ftp, file) out of any text, once each; reads stdin without a file
#   extract-url page.html    or    pbpaste | extract-url
function extract-url() {
    grep -Eoh "(https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]*[-A-Za-z0-9+&@#/%=~_|]" "$@" | sort -u
}

# Find the space hogs
function top-size() {
    du -hs * | sort -rh | head -10
}
