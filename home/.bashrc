# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Path Variables
[[ -f "$HOME/.path_variablerc" ]] && source "$HOME/.path_variablerc"

[[ -f "$HOME/.aliasrc" ]] && source "$HOME/.aliasrc"
[[ -f "$HOME/.functionrc" ]] && source "$HOME/.functionrc"

PS1="[\u@\h \W]\$ "

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

eval "$(starship init bash)"
