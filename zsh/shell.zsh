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
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"             # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

#   Automatically switch Node version when entering a dir with an .nvmrc
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")
    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
# Skip if something else (e.g. a work ~/.extra) already registered this hook,
# so we don't switch Node versions — or print — twice on shell startup.
if command -v nvm >/dev/null 2>&1 && [[ -z ${chpwd_functions[(r)load-nvmrc]} ]]; then
  add-zsh-hook chpwd load-nvmrc
  load-nvmrc
fi


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
