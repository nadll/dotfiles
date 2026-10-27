#!/usr/bin/env bash
echo "Type in your first and last name (no accent or special characters - e.g. 'ç'): "
read -r full_name

echo "Type in your email address (the one used for your GitHub account): "
read -r email

# ~/.gitconfig.local is included at the end of git/.gitconfig, so these
# override the defaults in the repo without changing tracked files
git config --file "$HOME/.gitconfig.local" user.email "$email"
git config --file "$HOME/.gitconfig.local" user.name "$full_name"

echo "👌 Awesome, all set."
