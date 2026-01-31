if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#
#source /usr/share/nvm/init-nvm.sh

eval "$(starship init zsh)"
