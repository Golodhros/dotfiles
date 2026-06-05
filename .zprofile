# ~/.zprofile — tracked in ~/.dotfiles, symlinked by install.sh.
# Login-shell setup. Keep this minimal.

# Homebrew — pick the right prefix for Apple Silicon or Intel Macs.
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi
