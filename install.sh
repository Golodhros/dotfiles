#!/bin/sh

echo "Setting up your Mac..."

# Load env variables before we continue
source ~/.dotfiles/.dotfiles_env

# Install dotfiles on a fresh system
source $DOTFILES/bin/install.sh
# source $DOTFILES/homebrew/install.sh
# source $DOTFILES/osx/install.sh
# source $DOTFILES/fonts/install.sh
# source $DOTFILES/apps/install.sh

exec $DOTFILES/osx/set-defaults.sh