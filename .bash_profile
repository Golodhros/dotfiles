#   Uses my dotfiles to load stuff

#   Load environment variables too
if [ -f ~/.dotfiles_env ]; then
   source ~/.dotfiles_env
fi

#   Load bash
if [ -f $DOTFILES/bash/.bashrc ]; then
   source $DOTFILES/bash/.bashrc
fi

#   Load Git stuff
if [ -f $DOTFILES/git/.aliases ]; then
   source $DOTFILES/git/.aliases
fi

if [ -f $DOTFILES/git/.completion ]; then
   source $DOTFILES/git/.completion
fi
