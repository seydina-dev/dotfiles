#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Path Variables
source ~/.path_variablerc

source ~/.aliasrc
source ~/.functionrc

# GREEN=$(tput setaf 41)
# ORANGE=$(tput setaf 166)
# BLUE=$(tput setaf 43)
# RESET=$(tput sgr0)
# 
# user="${GREEN}\u${RESET}"
# hostname="${ORANGE}\h${RESET}"
# working_dir="${BLUE}\W${RESET}"

# PS1="[${user}@${hostname} ${working_dir}]\$ "
PS1="[\u@\h \W]\$ "


