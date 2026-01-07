#!/usr/bin/env bash
# colors.sh — robust color palette with auto-disable for non-TTY

# Detect whether to enable colors
if [[ -t 1 && -z "${NO_COLOR:-}" && "${TERM:-}" != "dumb" ]]; then
    USE_COLOR=true
else
    USE_COLOR=false
fi

if [[ "$USE_COLOR" == true ]]; then
    # Reset / Styles
    readonly RESET=$'\e[0m'
    readonly BOLD=$'\e[1m'
    readonly DIM=$'\e[2m'
    readonly UNDERLINE=$'\e[4m'

    # Regular colors
    readonly BLACK=$'\e[0;30m'
    readonly RED=$'\e[0;31m'
    readonly GREEN=$'\e[0;32m'
    readonly YELLOW=$'\e[0;33m'
    readonly BLUE=$'\e[0;34m'
    readonly PURPLE=$'\e[0;35m'
    readonly CYAN=$'\e[0;36m'
    readonly WHITE=$'\e[0;37m'
    readonly GRAY=$'\e[0;90m'

    # Bold colors
    readonly BOLD_RED=$'\e[1;31m'
    readonly BOLD_GREEN=$'\e[1;32m'
    readonly BOLD_YELLOW=$'\e[1;33m'
    readonly BOLD_BLUE=$'\e[1;34m'
    readonly BOLD_CYAN=$'\e[1;36m'

    # Background
    readonly BG_RED=$'\e[41m'
    readonly BG_GREEN=$'\e[42m'
    readonly BG_YELLOW=$'\e[43m'
else
    # Disable — set variables to empty strings so no escape codes are emitted
    readonly RESET=''
    readonly BOLD=''
    readonly DIM=''
    readonly UNDERLINE=''
    readonly BLACK=''
    readonly RED=''
    readonly GREEN=''
    readonly YELLOW=''
    readonly BLUE=''
    readonly PURPLE=''
    readonly CYAN=''
    readonly WHITE=''
    readonly GRAY=''
    readonly BOLD_RED=''
    readonly BOLD_GREEN=''
    readonly BOLD_YELLOW=''
    readonly BOLD_BLUE=''
    readonly BOLD_CYAN=''
    readonly BG_RED=''
    readonly BG_GREEN=''
    readonly BG_YELLOW=''
fi

# Handy printing helpers that are safe (use printf '%b' so any \e or \033 would still work)
print_red()    { printf '%b\n' "${RED}$*${RESET}"; }
print_green()  { printf '%b\n' "${GREEN}$*${RESET}"; }
print_yellow() { printf '%b\n' "${YELLOW}$*${RESET}"; }
print_blue()   { printf '%b\n' "${BLUE}$*${RESET}"; }
print_cyan()   { printf '%b\n' "${CYAN}$*${RESET}"; }
