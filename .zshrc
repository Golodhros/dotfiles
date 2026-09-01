# ~/.zshrc — tracked in ~/.dotfiles, symlinked by install.sh
# Oh My Zsh bootstrap. Personal aliases/prompt/env live in $ZSH_CUSTOM (zsh/*.zsh).

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# No OMZ theme — the prompt is provided by Powerline Shell (see zsh/prompt.zsh).
ZSH_THEME=""

# We set the terminal title ourselves (see zsh/shell.zsh).
DISABLE_AUTO_TITLE="true"

# Load custom config from the dotfiles repo instead of ~/.oh-my-zsh/custom.
# Oh My Zsh sources every $ZSH_CUSTOM/*.zsh file (aliases.zsh, profile.zsh,
# prompt.zsh, shell.zsh). No patching of oh-my-zsh.sh required.
ZSH_CUSTOM="$HOME/.dotfiles/zsh"

# Plugins (keep lean — too many slow down startup).
# plugins=(git)

# Make user-local binaries (bashmarks, pipx, etc.) available.
export PATH="$HOME/.local/bin:$PATH"

source $ZSH/oh-my-zsh.sh

# pnpm
export PNPM_HOME="/Users/miglesias/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end
