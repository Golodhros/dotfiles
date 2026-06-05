# Brewfile — personal Mac tooling. Install with: brew bundle --file=~/.dotfiles/Brewfile
# Run `brew bundle dump --file=~/.dotfiles/Brewfile --force` to refresh from the current machine.
#
# Keep this PERSONAL. Puzzle (work) tooling lives in the commented section at the
# bottom — uncomment only on a work machine (or keep it in ~/.extra setup).

# --- Taps ---
tap "peonping/tap"

# --- CLI tools ---
brew "git"          # newer git than the system one
brew "gh"           # GitHub CLI
brew "node"         # baseline Node (per-project versions handled by nvm)
brew "yt-dlp"       # used by bin/get_song.sh
brew "graphviz"     # diagrams / dot
brew "peon-ping"    # peon trainer

# --- Apps (casks) ---
cask "cursor"       # primary editor
cask "iterm2"       # terminal (macOS)
cask "hiddenbar"    # menu-bar declutter
cask "font-meslo-lg-nerd-font"  # Powerline/Nerd font for the prompt

# Note: Powerline Shell, NVM and Bashmarks are NOT installed via brew —
# install.sh sets them up (pipx / official installer / git clone).

# ----------------------------------------------------------------------------
# Puzzle (work) — uncomment on a work machine only.
# ----------------------------------------------------------------------------
# tap "amplitude/ampli"
# tap "withgraphite/tap"
# brew "amplitude/ampli/ampli"
# brew "withgraphite/tap/graphite"   # `gt`
# brew "postgresql@14"               # for sql_proxy:*:connect aliases
# brew "virtualenv"
# cask "meetingbar"
# cask "repobar"
