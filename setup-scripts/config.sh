#!/usr/bin/sh

# Shared variables
# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Get the directory where the dotfiles is located
#DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$(dirname "../setup.sh")" && pwd)"

HOME_DOTFILES_SRC_DIR="$DOTFILES_DIR/home"
HOME_DOTFILES_DEST_DIR="$HOME"

REPOS_DIR="$HOME/repos"
[ ! -d "$REPOS_DIR" ] && mkdir -p "$REPOS_DIR"

DOTCONFIG_SRC_DIR="$DOTFILES_DIR/config"

DOTCONFIG_DEST_DIR="$HOME/.config"
[ ! -d "$DOTCONFIG_DEST_DIR" ] && mkdir -p "$DOTCONFIG_DIR"

DOTLOCAL_DIR="$HOME/.local"
[ ! -d "$DOTLOCAL_DIR" ] && mkdir -p "$DOTLOCAL_DIR"