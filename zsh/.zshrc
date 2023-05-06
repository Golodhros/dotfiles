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

#   Set Paths
#   ------------------------------------------------------------

#   NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm


#   Set Default Editor
#   ------------------------------------------------------------
export EDITOR="code -w"

#   -------------------------------
#   2.  CLI HELPERS
#   -------------------------------

#   Bashmarks
#   Reference on https://github.com/huyng/bashmarks
source $HOME/.local/bin/bashmarks.sh

#   Set the title of a terminal window or tab to match the folder
precmd() {
  print -Pn "\e]0;@ %~/\a"
#   print -Pn "\e]0;%n@%m: %~/\a"
}

# Reference https://gist.github.com/natelandau/10654137
