

# Terminal stuff
alias ls="ls -lnh"
alias sl="ls -lnh"
alias sudo='sudo '

# Git Aliases
alias gs="git status -s"
alias gb="git branch"
alias go="git checkout "
alias gcb="git checkout -b" # + branch name
alias gd="git diff"
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cg  reen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
alias ga="git commit --amend --no-edit"

alias gac="git add . && git commit -m"

alias gri="git rebase -i HEAD~10" #10 is an arbitrary number, by tastes
alias gpr="git pull --rebase origin master"
alias gpu="git pull --rebase upstream master"
alias garc="git add . && git rebase --continue"

alias got="git "
alias get="git "

# From https://githowto.com/aliases
# alias gk='gitk --all&'
# alias gx='gitx --all'


# Util
alias gimmeServer="python -m SimpleHTTPServer"
alias vg="vagrant"


# EB specific
alias mt-edsUpdate="bay attach eventbrite_design_system 'npm run build' && bay attach core-frontend 'npm run build:eds'"
alias mt-edsCSSUpdate="bay attach eventbrite_design_system 'npm run build:css' && bay attach core-frontend 'npm run build:eds'"
alias mt-edsJSUpdate="bay attach eventbrite_design_system 'npm run build:js' && bay attach core-frontend 'npm run build:eds'"