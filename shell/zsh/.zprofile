# /usr/libexec/path_helper builds $PATH from PATHS specified in /etc/paths
# however, it is flawed and PREPENDs paths defined in /etc/paths instead of appending them (while still appending paths defined in /etc/paths.d)
# Since OSX El Capitan it happens in /etc/zprofile
# and given the order of execution of zsh configuration files
# /etc/zshenv, ~/.zshenv, /etc/zprofile, ~/.zshrc
# any PATH modifications made in zshenv will be shifted to the end
# by "/usr/libexec/path_helper" running in /etc/zprofile
# see https://stackoverflow.com/a/14101578
#
# Instead of patching /etc/zshenv (needs sudo), re-run our .zshenv here, after /etc/zprofile:
# `typeset -U path` in .zshenv drops duplicates, so Homebrew and GNU utils move back in front of /usr/bin
source "$ZDOTDIR/.zshenv"
