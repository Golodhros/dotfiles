#  ---------------------------------------------------------------------------
#
#  Description:  This file holds all my BASH configurations and aliases
#
#  Sections:
#  1.   LOAD BASH FILES
#  2.   ENVIRONMENT CONFIGURATION
#  3.   CLI HELPERS
#
#  ---------------------------------------------------------------------------

#   -------------------------------
#   1.  LOAD BASH FILES
#   -------------------------------

#   Load .bash_aliases too
if [ -f $DOTFILES/bash/.bash_aliases ]; then
   source $DOTFILES/bash/.bash_aliases
fi

#   Load .bash_prompt too
if [ -f $DOTFILES/bash/.bash_prompt ]; then
   source $DOTFILES/bash/.bash_prompt
fi

#   -------------------------------
#   2.  ENVIRONMENT CONFIGURATION
#   -------------------------------

#   Set Paths
#   ------------------------------------------------------------

#   NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

#   Silence Catalina zsh warning
export BASH_SILENCE_DEPRECATION_WARNING=1

#   Set Default Editor
#   ------------------------------------------------------------
export EDITOR="code -w"

#   -------------------------------
#   3.  CLI HELPERS
#   -------------------------------

#   Bashmarks
#   Reference on https://github.com/huyng/bashmarks
source $HOME/.local/bin/bashmarks.sh

#   Allow us to set the title of a terminal window or tab. I found the
#   PROMPT_COMMAND line on stackoverflow, don't understand how this works, but it
#   does. Call it from the command line, first argument is used as the title.
title-term() {
    PROMPT_COMMAND="echo -ne '\033]0;${1}\007'"
}



# Reference https://gist.github.com/natelandau/10654137
