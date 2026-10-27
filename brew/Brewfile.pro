# Packages for pro machines only.
# Installed by ./install.sh --pro, which marks the machine with ~/.dotfiles-pro
# so later ./install.sh and dotfiles-update runs install them too.
# To stop: rm ~/.dotfiles-pro (installed packages stay until you uninstall them)

# JFrog CLI for Artifactory https://jfrog.com/getcli/
brew "jfrog-cli"
