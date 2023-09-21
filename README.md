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
1. Search for `for config_file ("$ZSH_CUSTOM"/*.zsh(N)); do` in '/Users/marcosiglesias/.oh-my-zsh/oh-my-zsh.sh' and swap it with `for config_file ("$ZSH_CUSTOM"/.*); do`
1. Run `install.sh` to start the installation

## For a Fresh Bash Install

1. (For Mac) Install Xcode from the App Store, open it and accept the license agreement
1. Install [Bashmarks](https://github.com/huyng/bashmarks)
1. Install [Powerline Shell](https://github.com/b-ryan/powerline-shell)
1. Copy public and private SSH keys to `~/.ssh`. Make sure they're set to `600`
1. Clone this repo by doing `git clone https://github.com/Golodhros/dotfiles.git ~/.dotfiles`
1. Copy and paste `.dotfiles_env` and `.bash_profile` (`.zsh_profile`) or into your home folder (lookout with rewriting yours)
1. Run `install.sh` to start the installation

## VSCode installation
1. Install VSCode from [this link](https://code.visualstudio.com/docs?dv=osx).
1. Set it up to launch from the command line: Open the Command Palette (Cmd+Shift+P) and type 'shell command' to find the Shell Command: Install 'code' command in PATH command.
1. Add the following extensions as needed:
- EditorConfig
- EsLint
- Prettier
- Go
- SASS
- SCSS IntelliSense
- Seti-icons
- Stylelint
- Sublime Text Keymap
- Trailing Spaces
- YAML Sort
- MDX
- GraphQL
- Import Cost
- Open in GitHub
- Duplicate action
- Remote - Containers
- Remote - Development
- VSCode React Refactor?
- Monokai Seti
- Github Copilot
1. Follow the configuration instruction on .dotfiles/vscode/instructions.txt


## Thanks To:

- [Github does dotfiles](https://dotfiles.github.io/)
- [Zach Holman](https://github.com/holman/dotfiles)
- [Mathias Bynens](https://github.com/mathiasbynens/dotfiles)
- [Dries Vints](https://driesvints.com/blog/getting-started-with-dotfiles/)
