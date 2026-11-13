# Tell gpg which terminal to use when it has to ask something there.
# $TTY rather than $(tty): with the powerlevel10k instant prompt, $(tty) says "not a tty".
export GPG_TTY=$TTY
