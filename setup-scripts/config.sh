# """""""""""""""""""""""""""""
# " ./setup-scripts/config.sh "
# """""""""""""""""""""""""""""
#  ____________________
# /\                   \
# \_| SHARED VARIABLES |
#   |                  |
#   |   _______________|_
#    \_/_________________/

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

DOTFILES_DIR="$HOME/.dotfiles"

HOME_DOTFILES_SRC_DIR="$DOTFILES_DIR/home"
HOME_DOTFILES_DEST_DIR="$HOME"

REPOS_DIR="$HOME/repos"
[ ! -d "$REPOS_DIR" ] && mkdir -p "$REPOS_DIR"

DOTCONFIG_SRC_DIR="$DOTFILES_DIR/config"

DOTCONFIG_DEST_DIR="$HOME/.config"
[ ! -d "$DOTCONFIG_DEST_DIR" ] && mkdir -p "$DOTCONFIG_DIR"

DOTLOCAL_BIN_DIR="$HOME/.local/bin"
[ ! -d "$DOTLOCAL_BIN_DIR" ] && mkdir -p "$DOTLOCAL_BIN_DIR"
