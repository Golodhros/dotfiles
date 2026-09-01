#  ---------------------------------------------------------------------------
#
#  Description:  This file holds all my ZSH configurations and aliases
#
#  Sections:
#  1.   ENVIRONMENT CONFIGURATION
#  2.   CLI HELPERS
#
#  ---------------------------------------------------------------------------

#   -------------------------------
#   1.  ENVIRONMENT CONFIGURATION
#   -------------------------------

#   Node
#   ------------------------------------------------------------
#   No Node version manager is configured here — it's machine-specific.
#   Work machines load fnm (with --use-on-cd auto-switching) from ~/.extra.

#   Set Default Editor
#   ------------------------------------------------------------
export EDITOR="cursor -w"

#   -------------------------------
#   2.  CLI HELPERS
#   -------------------------------

#   Bashmarks
#   Reference on https://github.com/huyng/bashmarks
source $HOME/.local/bin/bashmarks.sh

#   Set the title of a terminal window or tab to match the folder
autoload -U add-zsh-hook
set_terminal_title() {
  print -Pn "\e]0;@ %~/\a"
#   print -Pn "\e]0;%n@%m: %~/\a"
}
add-zsh-hook precmd set_terminal_title

# Reference https://gist.github.com/natelandau/10654137
