# Marcos's Dotfiles

My personal dotfiles.

## What Is This?

Dotfiles to help setup a Mac machine with my personal setup.
Feel free to explore, learn and copy parts for your own dotfiles.

## For a Fresh Zsh Install

1. (For Mac) Install Xcode from the App Store, open it and accept the license agreement
1. Copy public and private SSH keys to `~/.ssh`. Make sure they're set to `600`
1. Install [Bashmarks](https://github.com/huyng/bashmarks)
1. Install [NVM](https://github.com/nvm-sh/nvm)
1. Install [Powerline Shell](https://github.com/b-ryan/powerline-shell) and the [powerline fonts](https://github.com/powerline/fonts)
1. Clone this repo by doing `git clone https://github.com/Golodhros/dotfiles.git ~/.dotfiles`
1. Install [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh)
1. Copy and paste `zsh/.zshenv` into your home folder
1. Search in your Oh My Zsh generated `.zshrc` for the `ZSH_CUSTOM` variable and set it to `~/.dotfiles/zsh`
1. Run `install.sh` to start the installation

## For a Fresh Bash Install

1. (For Mac) Install Xcode from the App Store, open it and accept the license agreement
1. Install [Bashmarks](https://github.com/huyng/bashmarks)
1. Install [Powerline Shell](https://github.com/b-ryan/powerline-shell)
1. Copy public and private SSH keys to `~/.ssh`. Make sure they're set to `600`
1. Clone this repo by doing `git clone https://github.com/Golodhros/dotfiles.git ~/.dotfiles`
1. Copy and paste `.dotfiles_env` and `.bash_profile` (`.zsh_profile`) or into your home folder (lookout with rewriting yours)
1. Run `install.sh` to start the installation

Install Oh My Zsh

## Thanks To:

- [Github does dotfiles](https://dotfiles.github.io/)
- [Zach Holman](https://github.com/holman/dotfiles)
- [Mathias Bynens](https://github.com/mathiasbynens/dotfiles)
- [Dries Vints](https://driesvints.com/blog/getting-started-with-dotfiles/)
