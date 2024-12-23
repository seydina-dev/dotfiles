# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Path Variables
source ~/.path_variablerc

source ~/.aliasrc
source ~/.functionrc

PS1="[\u@\h \W]\$ "
