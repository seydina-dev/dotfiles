# Path Variables
# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
[[ -f "$HOME/.path_variablerc" ]] && source "$HOME/.path_variablerc"

# Aliases
[[ -f "$HOME/.aliasrc" ]] && source "$HOME/.aliasrc"

# Functions
[[ -f "$HOME/.functionrc" ]] && source "$HOME/.functionrc"

#plugins=( git zsh-syntax-highlighting zsh-autosuggestions fzf postgres tmux zsh-interactive-cd z)
plugins=(git)

[[ -f "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

eval "$(starship init zsh)"

# Added by dotfiles setup
export PATH="$HOME/.local/bin:$PATH"
