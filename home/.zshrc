if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path Variables
# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
source ~/.path_variablerc

# Aliases
source ~/.aliasrc

# Functions
source ~/.functionrc

plugins=( git zsh-syntax-highlighting zsh-autosuggestions fzf postgres tmux zsh-interactive-cd z)

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

source /usr/share/nvm/init-nvm.sh
