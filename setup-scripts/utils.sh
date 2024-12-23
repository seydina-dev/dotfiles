# """"""""""""""""""""""""""""
# " ./setup-scripts/utils.sh "
# """"""""""""""""""""""""""""
#  _____________________
# /\                    \
# \_| UTILITY FUNCTIONS |
#   |                   |
#   |   ________________|_
#    \_/__________________/

# Function to print status messages
print_status() {
    echo -e "${GREEN}[*]${NC} $1"
}

# Function to print error messages
print_error() {
    echo -e "${RED}[!]${NC} $1"
}

# Function to print ln command
print_ln_command() {
    print_status "-> ln -sf $1 => $2"
}

install_aur_helper() {
    local base_url="https://aur.archlinux.org"
    let attempt_num=0
	while true; do
		if [[ "${attempt_num}" -ge "3" ]]; then
			print_error "Too many attempts"
			exit 1
		fi
        aur_helper=$(echo -e "yay\nparu\npikaur\ntrizen" | fzf --prompt="Select  your favorite AUR Package Manager: ")
		
        if [ -z "$aur_helper" ]; then
			print_error "No AUR Package Manager selected."
			((attempt_num++))
			continue
        else
            # Check if the selected AUR helper is already installed
            [ -e "$(command -v "$aur_helper")" ] && print_status "$aur_helper is already installed." && break
		fi

        local repo="${aur_helper}-bin"
        if [[ "${aur_helper}" == "trizen" || "${aur_helper}" == "pikaur" ]]; then
            local repo="$aur_helper"
        fi
        print_status "Installing $aur_helper from AUR"
        # TODO: handle directory already exist case
        repo_dir="${CACHE_DIR}/${repo}"
        # echo "$repo_dir"
        [ ! -d $repo_dir ] && mkdir -p $repo_dir
        cd $REPOS_DIR
        git clone "$base_url/${repo}.git" || { print_error "Failed to clone $aur_helper from AUR" ; exit 1; }
        # cd "$CACHE_DIR/${aur_helper}-bin" || { print_error "Failed to enter ${aur_helper}-bin directory" ; exit 1; }
        # cd "${repo_dir}" || { print_error "Failed to enter $repo directory" ; exit 1; }
        cd "$repo" || { print_error "Failed to enter $repo directory" ; exit 1; }
        # makepkg -si --noconfirm 2>&1 | tee -a "$LOG" || { printf "%s - Failed to install yay from AUR\n" "${ERROR}"; exit 1; }
        makepkg -si --noconfirm 2>&1 || { print_error "Failed to install $aur_helper from AUR"; exit 1; }
        cd .. && rm -rf "$repo" && cd "$DOTFILES_DIR"
        break
	done
}

install_pkg() {
    if command -v "${1}" &>/dev/null || pacman -Q "${1}" &>/dev/null; then
        print_status "${1} is already installed."
	else
		print_status "Now Installing ${1}..."
		$aur_helper --noconfirm -S "${1}"
		if $aur_helper -Q "${1}" &>/dev/null; then
			print_status "${1} was installed."
		else
			print_error "${1} installation has failed, skipping this package."
		fi
	fi
}
